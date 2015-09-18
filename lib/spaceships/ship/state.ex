defmodule Spaceships.Ship.State do
  @time_units_per_second 1000000000

  defstruct x: 0.0,
            y: 200.0,
            v: 0.0,
            angle: 0.0,
            last_update: nil

  def tick(state, new_time) do
    delta_t = new_time - state.last_update
    delta_t_in_seconds = delta_t / @time_units_per_second
    # FIXME: assume we're traveling along the x axis for now...
    delta_x = delta_t_in_seconds * (state.v * (:math.cos state.angle))
    delta_y = delta_t_in_seconds * (state.v * (:math.sin state.angle))
    %__MODULE__{state|x: state.x + delta_x, y: state.y + delta_y, last_update: new_time}
  end
end
