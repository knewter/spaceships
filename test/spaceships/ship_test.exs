defmodule Spaceships.ShipTest do
  use ExUnit.Case

  test "starting a ship" do
    assert {:ok, pid} = Spaceships.Ship.start_link
  end

  test "getting a ship's state" do
    {:ok, pid} = Spaceships.Ship.start_link
    assert %Spaceships.Ship.State{} = Spaceships.Ship.get_state(pid)
  end

  test "ships move based on their v" do
    {:ok, pid} = Spaceships.Ship.start_link
    Spaceships.Ship.accelerate(pid, 0.1)
    :timer.sleep(1000)
    state = Spaceships.Ship.get_state(pid)
    assert state.v == 0.1
    assert_in_delta state.x, 0.1, 0.005
  end
end
