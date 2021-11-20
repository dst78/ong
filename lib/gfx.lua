Gfx = {}
Gfx.waves = {}
Gfx.baseY = 30
Gfx.waveWidth = 20
Gfx.waveHeight = 30
Gfx.wavesSpeed = 0.17
Gfx.wavesAmp = 23
Gfx.waveMatrix1 = {{0, 0, 0, 0, 2, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 1, 1, 1, 0, 0, 0}, {0, 0, 0, 0, 1, 1, 1, 1, 0, 0}, {0, 0, 0, 0, 1, 1, 1, 1, 0, 0}, {0, 0, 0, 1, 1, 1, 1, 0, 0, 0}, {1, 1, 0, 0, 2, 0, 0, 0, 0, 0}, {1, 2, 2, 2, 2, 2, 2, 2, 2, 2}, {1, 1, 0, 1, 0, 1, 0, 1, 0, 0}, {0, 1, 1, 1, 1, 1, 1, 0, 0, 0}}
Gfx.waveMatrix1F = 100;
Gfx.waveMatrix2 = {{0, 0, 0, 1, 1, 1, 4, 4, 0, 0, 0, 0}, {0, 0, 1, 1, 1, 1, 1, 1, 4, 0, 0, 0}, {0, 1, 1, 2, 2, 2, 2, 2, 2, 4, 0, 0}, {1, 1, 2, 2, 2, 2, 2, 2, 2, 4, 0, 0}, {1, 1, 2, 2, 5, 9, 1, 2, 9, 2, 0, 0}, {1, 1, 2, 2, 5, 1, 2, 1, 5, 1, 0, 0}, {1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 4, 0}, {0, 1, 1, 2, 2, 2, 2, 2, 2, 2, 4, 0}, {0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 0, 0}, {0, 1, 2, 1, 2, 2, 2, 1, 2, 2, 4, 0}, {0, 1, 2, 2, 2, 2, 3, 2, 1, 2, 4, 0}, {1, 2, 2, 1, 1, 1, 2, 4, 1, 1, 2, 4}, {1, 1, 1, 0, 0, 1, 1, 4, 0, 1, 1, 2}, {0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0}}
Gfx.matrix2OffsetX = 0
Gfx.matrix2OffsetY = 0
Gfx.matrix2Draw = false

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
  local fL = 4 * math.log(params:get("foamAmp") + 0.1)
  for n = 0,fL*math.sin(f / (2.4 / Gfx.wavesSpeed) - 1.8) do
    y = math.random(60, 63)
    Gfx.setLevel(y)
    screen.pixel(math.random(0, 127), y)
  end
  screen.fill()
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

--[[
    Gfx.sprite(-20 + (f - Counters.horn), Gfx.baseY - 9, Counters.horn)
    if (Counters.horn + 150) < f then
    elseif Counters.horn + 74 == f then

    end
--]]

function Gfx.kraken()
  local f = Counters.getFrame()
  local o2 = math.sin(f/20) * 12

  if o2 > 0 and o2 < 0.3 and math.random(0, 100) > 95 then
    Gfx.matrix2OffsetX = math.random(5, 110)
    Gfx.matrix2OffsetY = math.random(0, 15)
    Gfx.matrix2Draw = true
  elseif o2 < 0 then
    Gfx.matrix2Draw = false
  end

  if Gfx.matrix2Draw == true then
    Gfx.sprite(Gfx.matrix2OffsetX, Gfx.baseY + Gfx.matrix2OffsetY - o2, Gfx.waveMatrix2, o2)
  end
end

function Gfx.sprite(x, y, s, stopy)
  local lx = tab.count(s[1])
  local ly = tab.count(s)
  stopy = stopy or ly
  ly = math.min(ly, stopy)

  if x + lx >= 0 and x < 128 and y+ly >= 0 and y+ly < 64 then
    for sy=1,ly do
      for sx=1,lx do
        if s[sy][sx] > 0 then
          screen.level(s[sy][sx])
          screen.pixel(x + sx, y + sy)
          screen.fill()
        end
      end
    end
  end
end


return Gfx
