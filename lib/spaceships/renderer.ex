defmodule Spaceships.Renderer do
  @center_y 500
  @center_x 500
  @ship_radius 3

  def render(dc, ships) do
    canvas = :wxGraphicsContext.create(dc)
    draw_background(canvas, dc)
    draw_ships(canvas, dc, ships)
  end

  def draw_background(canvas, dc) do
    :wxPaintDC.clear(dc)
    black_brush = :wxBrush.new({0, 0, 0, 255})
    :wxDC.setBackground(dc, black_brush)
  end

  def draw_ships(canvas, dc, ships) do
    brush = :wxBrush.new({255, 255, 255, 255})
    :wxGraphicsContext.setBrush(canvas, brush)
    for ship <- ships do
      int_x = ship.x |> Float.ceil |> trunc
      int_y = ship.y |> Float.ceil |> trunc
      :wxDC.drawCircle(dc, {int_x, int_y}, @ship_radius)
    end
  end
end
