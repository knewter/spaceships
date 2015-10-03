defmodule Spaceships.TCPServer do
  def listen(port, state_pid) do
    IO.puts "listening on port #{port}"
    tcp_options = [:binary, {:packet, 0}, {:active, false}]
    {:ok, listening_socket} = :gen_tcp.listen(port, tcp_options)
    do_accept(listening_socket, state_pid)
  end

  def do_accept(listening_socket, state_pid) do
    {:ok, socket} = :gen_tcp.accept(listening_socket)
    start(socket, state_pid)
  end

  def start(socket, state_pid) do
    loop(socket, state_pid)
  end

  def loop(socket, state_pid) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, "quit\r\n"} -> :ok
      {:ok, data} ->
        IO.puts inspect data
        Spaceships.State.get_ships(state_pid)
        |> render_ships
        |> tcp_send(socket)
        :timer.sleep(10)
        loop(socket, state_pid)
    end
  end

  def tcp_send(data, socket) do
    :gen_tcp.send(socket, data)
  end

  def render_ships(ships) do
    ships
    |> Enum.map(&render_ship/1)
    |> Enum.join "|"
  end

  def render_ship(ship) do
    vector_x = :math.cos ship.angle
    vector_y = :math.sin ship.angle
    Enum.join([ship.id, ship.x, ship.y, vector_x, vector_y], "=")
  end
end
