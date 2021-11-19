Params = {}

function Params.init()
  local speedCtrl = controlspec.new(0.01, 4000.0, "exp", 0, 0.16)
  local volCtrl = controlspec.new(1, 10000, "exp", 0, 25)

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
  params:add_control("foamAmp", "foam volume", volCtrl)
  params:set_action("foamAmp", function(x) engine.foam(x*0.0001) end)
  params:add_control("ambienceAmp", "ambience volume", volCtrl)
  params:set_action("ambienceAmp", function(x) engine.ambience(x*0.0001) end)
  params:add_control("ambienceFilterCutoff", "filter cutoff", controlspec.new(20, 10000, "exp", 0, 10000, "hz"))
  params:set_action("ambienceFilterCutoff", function(x) engine.ambienceFilterCutoff(x) end)

  params:add_separator("fog horns")
  params:add_trigger("triggerFoghorn", "sound fog horn")
  params:set_action("triggerFoghorn", function() engine.triggerFoghorn(params:get("nearWavesAmp") * 0.01) end)
end

return Params
