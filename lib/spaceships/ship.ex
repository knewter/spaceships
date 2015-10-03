defmodule Spaceships.Ship do
  use GenServer
  # Tick every 10 ms.  Maybe too frequent?
  @tick_interval 10

  ## Client API

  @doc """
  Starts the ship.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Returns the ship's state
  """
  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  @doc """
  Increase the ship's v by amount
  """
  def accelerate(pid, amount) do
    GenServer.cast(pid, {:accelerate, amount})
  end

  @doc """
  Increase the ship's rotation by amount
  """
  def rotate(pid, amount) do
    GenServer.cast(pid, {:rotate, amount})
  end

  ## Server API

  def init(:ok) do
    :random.seed
    :timer.send_after(@tick_interval, :tick)
    id = :rand.uniform
    {:ok, %Spaceships.Ship.State{last_update: :erlang.system_time, id: id}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:accelerate, amount}, state) do
    {:noreply, update_in(state.v, &(&1 + amount))}
  end

  def handle_cast({:rotate, amount}, state) do
    {:noreply, update_in(state.angle, &(&1 + amount))}
  end

  def handle_info(:tick, state) do
    new_state = Spaceships.Ship.State.tick(state, :erlang.system_time)
    :timer.send_after(@tick_interval, :tick)
    {:noreply, new_state}
  end
end
