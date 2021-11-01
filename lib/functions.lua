fn = {}

fn.screenIsDirty = true

function fn.screenDirty(state)
  if state == nil then return fn.screenIsDirty end
  fn.screenIsDirty = state
  return fn.screenIsDirty
end

-- maps a value to range [0,1]
function fn.mapToUnity(val, min, max)
  return util.clamp((val - min) / (max - min), 0, 1)
end

-- exponential function for values in [0,1]
function fn.unityExp(val, min, max)
  local v = fn.mapToUnity(val, min, max)
  return v*v
end

return fn
