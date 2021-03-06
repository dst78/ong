-- ocean noise generator
--   v1.1.0 @AnoikisNomads
--
-- _,/'2_,/'2_,/'2_,/'2_,/'2_,/'2_
-- '2_,/'2_,/'2_,/'2_,/'2_,/'2_,/2
--
-- ▼ instructions below ▼
--
-- K1 display help
-- E1 overall amplitude
-- E2 near waves amplitude
-- K2+E2 near waves speed
-- K3+E2 foam amplitude
-- E3 far waves amplitude
-- K2+E3 far waves speed
-- K3+E3 ambience amplitude

Help = include("ong/lib/help")
fn = include("ong/lib/functions")
Counters = include("ong/lib/counters")
Gfx = include("ong/lib/gfx")
Params = include("ong/lib/parameters")
Foghorn = include("ong/lib/foghorn")

engine.name = 'Ong'

local keydown={false, false, false}
local displayMode = 0
local compressorWasOn = false

function init()
  compressorOff()
  Params.init()
  Counters.init()
  Counters.ui:start()
  Gfx.init()

  redraw()
end

function key(n,z)
  keydown[n] = (z == 1)

  if keydown[1] == true then
    displayMode = 1 -- help
  elseif keydown[1] == false then
    displayMode = 0 -- normal screen
  end

  fn.screenDirty(true)
end

function enc(n, d)
  if n == 1 then
    params:delta("masterAmp",d)
    Help.line("E1", params:get("masterAmp"))

  elseif n == 2 then
    if keydown[2] == false and keydown[3] == false then
      params:delta("nearWavesAmp",d)
      Help.line("E2", params:get("nearWavesAmp"))

    elseif keydown[2] == true and keydown[3] == false then
      params:delta("nearWavesSpeed",d)
      Help.line("K2+E2", util.round(params:get("nearWavesSpeed"), 0.01))

    elseif keydown[2] == false and keydown[3] == true then
      params:delta("foamAmp",d)
      Help.line("K3+E2", params:get("foamAmp"))
    end

  elseif n == 3 then
    if keydown[2] == false and keydown[3] == false then
      params:delta("farWavesAmp",d)
      Help.line("E3", params:get("farWavesAmp"))

    elseif keydown[2] == true and keydown[3] == false then
      params:delta("farWavesSpeed",d)
      Help.line("K2+E3", util.round(params:get("farWavesSpeed"), 0.01))

    elseif keydown[2] == false and keydown[3] == true then
      params:delta("ambienceAmp",d)
      Help.line("K3+E3", util.round(params:get("ambienceAmp"), 0.0001))
    end
  else
    print("logic broke. HALP")
  end

  fn.screenDirty(true)
end

function redraw()
  if not fn.screenDirty() then return end
  screen.clear()

  if displayMode == 0 then    -- standard screen
    Gfx.display()
    Help.displayLine()
  elseif displayMode == 1 then    -- help screen
    Help.display()
  end

  screen.update()
  fn.screenDirty(false)
end

function cleanup()
  compressorRestore()
  Counters.cleanup()
end

function rerun()
  norns.script.load(norns.state.script)
end

function compressorOff()
  if params:string("compressor") == 'ON' then
    compressorWasOn = true
    params:set("compressor", 1)
  end
end

function compressorRestore()
  if compressorWasOn then
    params:set("compressor", 2)
  end
end
