Gfx = {}
Gfx.waves = {}
Gfx.baseY = 30
Gfx.waveWidth = 20
Gfx.waveHeight = 30
Gfx.wavesSpeed = 0.17
Gfx.wavesAmp = 23

function Gfx.init()
  local f = Counters.getFrame()

  for i=f-300,f do
    Gfx.createWaves(i)
  end
end

function Gfx.createWaves(f)
  local s = math.sin(f / (1/Gfx.wavesSpeed))/2 + 0.5; -- range is (0,1)

  if math.random() > s then
    Gfx.addWave(f, math.random(-30, 158))
  end
end

function Gfx.display()
  local f = Counters.getFrame()
  --[[
  screen.level(5)
  screen.move(0, 16)
  screen.text(tab.count(Gfx.waves))
  --]]

  Gfx.wavesSpeed = util.clamp(params:get("nearWavesSpeed"), 0.05, 1.0)
  Gfx.wavesAmp = params:get("nearWavesAmp")

  -- near waves
  for i,w in ipairs(Gfx.waves) do
    if w ~= nil then
      -- draw waves and remove old ones
      Gfx.removeWave(i, Gfx.drawWave(w, f, i))
    end
  end

  -- foam
  local fL = 4 * math.log(params:get("foamAmp"))
  for n = 0,fL*math.sin(f / (2.4 / Gfx.wavesSpeed) - 1.8) do
    y = math.random(60, 63)
    Gfx.setLevel(y)
    screen.pixel(math.random(0, 127), y)
    screen.fill()
  end
end

function Gfx.drawWave(wave, frame, index)
  local x = wave[1]
  local f = frame - wave[2]

  local u = fn.mapToUnity((f / (1.5/Gfx.wavesSpeed)), 0, Gfx.waveHeight)
  local dy = u*u -- distance-based vertical offset
  local ay = u * math.sin(x + (f / (2.4/Gfx.wavesSpeed))) -- distance-based wave amplitude
  local xw = u*u*u * Gfx.waveWidth * math.sin(f / 100 + x) -- distance-based wave width
  local xx = Gfx.wavesAmp * u * math.sin(dy + ay + (f / (10/Gfx.wavesSpeed))) -- distance-based horizontal slew
  local ty = dy * Gfx.waveHeight + Gfx.baseY + ay -- total y

  for xv = -50,60,50 do -- draw each wave 3 times at offsets
    screen.move(xv + xx + x - (xw/2), ty)
    screen.line_rel(xw + 1, 0)
  end
  Gfx.setLevel(ty)
  screen.stroke()

  return ty
end

function Gfx.addWave(f, x)
  local n = 1+tab.count(Gfx.waves)

  for i = 1,n do
    -- find empty spot
    if Gfx.waves[i] == nil then
      Gfx.waves[i] = {x, f}
    end
  end
end

function Gfx.removeWave(i, y)
  if y > Gfx.baseY+Gfx.waveHeight-1 then
    table.remove(Gfx.waves, i)
  end
end

function Gfx.setLevel(y)
  level = 1
  if     y > 60 then level = 13
  elseif y > 56 then level = 8
  elseif y > 50 then level = 5
  elseif y > 42 then level = 3
  elseif y > 30 then level = 2
  end
  screen.level(level)
end


return Gfx
