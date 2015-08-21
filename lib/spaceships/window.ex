defmodule Spaceships.Window do
  @moduledoc """
  A window to draw our spaceships within.
  """

  @title 'Spaceships'

  require Record
  Record.defrecordp :wx, Record.extract(:wx, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxClose, Record.extract(:wxClose, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxCommand, Record.extract(:wxCommand, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxKey, Record.extract(:wxKey, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxPaint, Record.extract(:wxPaint, from_lib: "wx/include/wx.hrl")

  def start(state_pid) do
    do_init(state_pid)
  end

  def init(state_pid) do
    :wx.batch(fn() -> do_init(state_pid) end)
  end

  def do_init(state_pid) do
    wx = :wx.new
    frame = :wxFrame.new(wx, -1, @title, size: {1000, 1000})
    panel = :wxPanel.new(frame, [])

    main_sizer = :wxBoxSizer.new(:wx_const.wx_vertical)
    sizer = :wxStaticBoxSizer.new(:wx_const.wx_vertical, panel)
    win = :wxPanel.new(panel, [style: :wx_const.wx_full_repaint_on_resize])

    :wxPanel.connect(win, :paint, [:callback])
    :wxPanel.connect(win, :size)

    :wxSizer.add(sizer, win, [flag: :wx_const.wx_expand, proportion: 1])
    :wxSizer.add(main_sizer, sizer, [flag: :wx_const.wx_expand, proportion: 1])
    :wxPanel.setSizer(panel, main_sizer)
    :wxFrame.show(frame)
    receive do
      :ok -> :ok
      after 100 -> # Have to wait for a little for the window to exist
                   # before creating the drawing context
        dc = :wxPaintDC.new(win)
        draw(state_pid, dc)
    end
    receive do
      :ok -> :ok
    end
    :wxPaintDC.destroy(dc)
  end

  def draw(state_pid, dc) do
    do_draw(state_pid, dc)
  end

  def do_draw(state_pid, dc) do
    Spaceships.Renderer.render(dc, Spaceships.State.get_ships(state_pid))
    :timer.sleep(10)
    do_draw(state_pid, dc)
  end
end
