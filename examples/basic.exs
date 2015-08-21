defmodule Basic do
  @new_ship_spawn_timing 1000

  def run do
    {:ok, pid} = Spaceships.State.start_link
    spawn(fn() -> Spaceships.Window.start(pid) end)
    IO.puts "about to add interval"
    {:ok, _} = :timer.apply_interval(@new_ship_spawn_timing, __MODULE__, :add_ship, [pid])
    :timer.sleep(10000000)
  end

  def add_ship(pid) do
    IO.puts "adding ship"
    {:ok, ship_pid} = Spaceships.Ship.start_link
    Spaceships.Ship.accelerate(ship_pid, 10)
    Spaceships.State.add_ship(pid, ship_pid)
  end
end

Basic.run
