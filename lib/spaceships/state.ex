defmodule Spaceships.State do
  use GenServer

  ## Client API

  @doc """
  Starts the state server.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Queries all of the ships for their state and returns a list of it.
  """
  def get_ships(pid) do
    GenServer.call(pid, :get_ships)
  end

  @doc """
  Adds a ship to the state
  """
  def add_ship(pid, ship_pid) do
    GenServer.cast(pid, {:add_ship, ship_pid})
  end

  ## Server API

  def init(:ok) do
    {:ok, []}
  end

  def handle_call(:get_ships, _from, state) do
    {:reply, gather_ships(state), state}
  end

  def handle_cast({:add_ship, ship_pid}, state) do
    {:noreply, [ship_pid|state]}
  end

  ## Implementation functions
  defp gather_ships(state) do
    for ship_pid <- state do
      Spaceships.Ship.get_state(ship_pid)
    end
  end
end
