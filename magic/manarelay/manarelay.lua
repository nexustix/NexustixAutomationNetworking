function init()
  world.logInfo("manarelay init")
  mananetwork.init()
  storage.mana = storage.mana or {}
  entity.setInteractive(true)

end

function onInteraction(args)
  local awesomeString = ""
  for k,v in pairs(mananetwork.relays) do
    awesomeString = awesomeString .. tostring(v)..","
  end

  return{ "ShowPopup",{ message =
    "ID: "..tostring(entity.id())
    .."\nMana: "..mananetwork.stored.."<"
    .."\nNeeds: "..mananetwork.needsAmount.."<"
    .."\nConnections: "..awesomeString.."<"
  }}
end

function update(dt)
    --findOthers()
    mananetwork.findRelays()

    mananetwork.update()

    storage.mana = mananetwork.stored
    updateDisplay()
end

function updateDisplay()
  if mananetwork.stored < 10 then
    --world.logInfo("0")
    entity.setAnimationState("switchState", "zero")
  elseif mananetwork.stored == 100 then
    --world.logInfo("10")
    entity.setAnimationState("switchState", "ten")
  elseif mananetwork.stored >= 90 then
    --world.logInfo("9")
    entity.setAnimationState("switchState", "nine")
  elseif mananetwork.stored >= 80 then
    --world.logInfo("8")
    entity.setAnimationState("switchState", "eight")
  elseif mananetwork.stored >= 70 then
    --world.logInfo("7")
    entity.setAnimationState("switchState", "seven")
  elseif mananetwork.stored >= 60 then
    --world.logInfo("6")
    entity.setAnimationState("switchState", "six")
  elseif mananetwork.stored >= 50 then
    --world.logInfo("5")
    entity.setAnimationState("switchState", "five")
  elseif mananetwork.stored >= 40 then
    --world.logInfo("4")
    entity.setAnimationState("switchState", "four")
  elseif mananetwork.stored >= 30 then
    --world.logInfo("3")
    entity.setAnimationState("switchState", "three")
  elseif mananetwork.stored >= 20 then
    --world.logInfo("2")
    entity.setAnimationState("switchState", "two")
  elseif mananetwork.stored >= 10 then
    --world.logInfo("1")
    entity.setAnimationState("switchState", "one")
  end
end
