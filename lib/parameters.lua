Params = {}

function Params.init()
  local speedCtrl = controlspec.new(0.01, 4.0, "exp", 0, 0.16)

  params:add_separator("~ ~ ~ ONG ~ ~ ~")
  params:add_number("masterAmp", "master volume", 0, 100, 80)
  params:set_action("masterAmp", function(x) engine.amp(x*0.01) end)

  params:add_separator("near waves")
  params:add_number("nearWavesAmp", "amplitude", 0, 100, 70)
  params:set_action("nearWavesAmp", function(x) engine.nearWavesAmp(x*0.01) end)
  params:add_control("nearWavesSpeed", "speed", speedCtrl)
  params:set_action("nearWavesSpeed", function(x) engine.nearWavesSpeed(x) end)
  params:add_control("nearWavesFilterCutoff", "filter cutoff", controlspec.new(20, 5000, "exp", 0, 3000, "hz"))
  params:set_action("nearWavesFilterCutoff", function(x) engine.nearWavesFilterCutoff(x) end)

  params:add_separator("far waves")
  params:add_number("farWavesAmp", "amplitude", 0, 100, 50)
  params:set_action("farWavesAmp", function(x) engine.farWavesAmp(x*0.01) end)
  params:add_control("farWavesSpeed", "speed", speedCtrl)
  params:set_action("farWavesSpeed", function(x) engine.farWavesSpeed(x) end)
  params:add_control("farWavesFilterCutoff", "filter cutoff", controlspec.new(20, 5000, "exp", 0, 840, "hz"))
  params:set_action("farWavesFilterCutoff", function(x) engine.farWavesFilterCutoff(x) end)

  params:add_separator("ambience")
  params:add_number("foamAmp", "foam volume", 1, 10000, 20)
  params:set_action("foamAmp", function(x) engine.foam(x*0.0001) end)
  params:add_number("ambienceAmp", "ambience volume", 0, 10000, 30)
  params:set_action("ambienceAmp", function(x) engine.ambience(x*0.0001) end)
end

return Params
