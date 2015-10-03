defmodule TCPExample do
  @new_ship_spawn_timing 1000
  @port 8400

  def run do
    {:ok, pid} = Spaceships.State.start_link
    spawn(fn() -> Spaceships.Window.start(pid) end)
    spawn(fn() -> Spaceships.TCPServer.listen(@port, pid) end)
    loop(pid)
  end

  def loop(pid) do
    add_ship(pid)
    :timer.sleep @new_ship_spawn_timing
    loop(pid)
  end

  def add_ship(pid) do
    IO.puts "adding ship"
    {:ok, ship_pid} = Spaceships.Ship.start_link
    Spaceships.Ship.accelerate(ship_pid, 10)
    :timer.apply_interval(@new_ship_spawn_timing, __MODULE__, :rotate, [ship_pid])
    :timer.apply_interval(@new_ship_spawn_timing, __MODULE__, :accelerate, [ship_pid])
    Spaceships.State.add_ship(pid, ship_pid)
  end

  # Rotate a ship by some random amount between -1 and 1
  def rotate(ship_pid) do
    amount = (:rand.uniform - 0.5) * 0.2
    Spaceships.Ship.rotate(ship_pid, amount)
  end

  # Accelerate a ship by some random amount between -10 and 10
  def accelerate(ship_pid) do
    amount = (:rand.uniform - 0.5) * 2
    Spaceships.Ship.accelerate(ship_pid, amount)
  end
end

TCPExample.run
