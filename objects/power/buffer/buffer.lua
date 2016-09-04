function init()
  sb.logInfo("[NAN] Relay init")
  powernode.init()

  powernode.relative_x = 1
  powernode.relative_y = 1
  powernode.is_relay = true
  --powernode.init()
  --sb.logInfo("[NAN] "..tostring(storage.mana))

  --if storage.mana == nil then storage.mana = 0 end

  --powernode.stored = storage.mana
  object.setInteractive(true)

end

function onInteraction(args)
  local awesomeString = ""
  for k,v in pairs(powernode.relays) do
    if k == #powernode.relays then
        awesomeString = awesomeString .. tostring(v)
    else
        awesomeString = awesomeString .. tostring(v)..","
    end
  end

  return{ "ShowPopup",{ message =
    "ID: "..tostring(entity.id())
    .."\nPower: "..powernode.stored.."<"
    .."\nPercent: "..tostring(powernode.getStoredPercent()).."<"
    .."\nConnections: "..awesomeString.."<"
  }}
end

function update(dt)
    powernode.update()
    --powernode.addPower(1) --XXX DEBUG POWER GENERATION

    updateDisplay()
end

function updateDisplay()
  if powernode.getStoredPercent() < 10 then
    --world.logInfo("0")
    animator.setAnimationState("switchState", "zero")
  elseif powernode.getStoredPercent() == 100 then
    --world.logInfo("10")
    animator.setAnimationState("switchState", "ten")
  elseif powernode.getStoredPercent() >= 90 then
    --world.logInfo("9")
    animator.setAnimationState("switchState", "nine")
  elseif powernode.getStoredPercent() >= 80 then
    --world.logInfo("8")
    animator.setAnimationState("switchState", "eight")
  elseif powernode.getStoredPercent() >= 70 then
    --world.logInfo("7")
    animator.setAnimationState("switchState", "seven")
  elseif powernode.getStoredPercent() >= 60 then
    --world.logInfo("6")
    animator.setAnimationState("switchState", "six")
  elseif powernode.getStoredPercent() >= 50 then
    --world.logInfo("5")
    animator.setAnimationState("switchState", "five")
  elseif powernode.getStoredPercent() >= 40 then
    --world.logInfo("4")
    animator.setAnimationState("switchState", "four")
  elseif powernode.getStoredPercent() >= 30 then
    --world.logInfo("3")
    animator.setAnimationState("switchState", "three")
  elseif powernode.getStoredPercent() >= 20 then
    --world.logInfo("2")
    animator.setAnimationState("switchState", "two")
  elseif powernode.getStoredPercent() >= 10 then
    --world.logInfo("1")
    animator.setAnimationState("switchState", "one")
  end
end
