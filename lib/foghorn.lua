Foghorn = {}

Foghorn.f = 50

function Foghorn.update(f)
  if f >= Foghorn.f then
    Foghorn.setF()
    if Params.foghornsEnabled then Foghorn.trigger() end
  end
end

function Foghorn.setF()
  local f = Counters.getFrame()
  Foghorn.f = math.random(f + util.round(3500 / params:get("foghornProbability")), f + util.round(10000 / params:get("foghornProbability")))
end

function Foghorn.trigger()
  if params:get("foghornAmp") > 0 then
    engine.triggerFoghorn(0.01 * math.random(1, params:get("foghornAmp")))
    if math.random(0, 100) < 10 then Gfx.doDrawShip() end
  end
end

return Foghorn
