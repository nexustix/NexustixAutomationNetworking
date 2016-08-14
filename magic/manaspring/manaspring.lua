function init()
  world.logInfo("manarelay init")
  mananetwork.init()
  --storage.ents = storage.ents or {}
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
    mananetwork.addMana(1)
    mananetwork.update()
end
