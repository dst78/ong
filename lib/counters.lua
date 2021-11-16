Counters = {}

function Counters.init()
  Counters.ui = metro.init()
  Counters.ui.time = 1 / 15
  Counters.ui.count = -1
  Counters.ui.play = 1
  Counters.ui.frame = 1
  Counters.ui.quarter_frame = 1
  Counters.ui.event = Counters.optician
end

function cleanup()
  Counters.ui.free_all()
end

function Counters.optician()
  if Counters.ui ~= nil then
    Counters.ui.frame = Counters.ui.frame + 1

    if Counters.ui.frame % 4 == 0 then
      Counters.ui.quarter_frame = Counters.ui.quarter_frame + 1
    end

    Gfx.createWaves(Counters.ui.frame)
    fn.screenDirty(true)
    redraw()
  end
end

function Counters.getFrame()
  return Counters.ui.frame
end

return Counters
