defmodule Spaceships.StateTest do
  use ExUnit.Case

  test "starting the server" do
    assert {:ok, _pid} = Spaceships.State.start_link
  end

  test "adding a ship" do
    {:ok, pid} = Spaceships.State.start_link
    Spaceships.State.add_ship(pid, :mock_pid)
  end

  test "getting a ship's state" do
    {:ok, ship_pid} = Spaceships.Ship.start_link
    {:ok, state_pid} = Spaceships.State.start_link
    Spaceships.State.add_ship(state_pid, ship_pid)
    assert [%Spaceships.Ship.State{}] = Spaceships.State.get_ships(state_pid)
  end
end
