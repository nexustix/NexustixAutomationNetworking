mananetwork = {}

function mananetwork.init()
  mananetwork.connections = {}
  mananetwork.relays = {}

  mananetwork.givesMana = false
  mananetwork.needsAmount = 0

  -- could be done with an int or booleans but may not be as intuitive
  mananetwork.type = "default"

  mananetwork.max = 100
  mananetwork.stored = 0

  mananetwork.reserve = 50
  mananetwork.pulseSize = 25
end

function mananetwork.update()
  --mananetwork.updateNeeds()
  for k,v in pairs(mananetwork.connections) do
    local has = world.callScriptedEntity(v, "mananetwork.getManaStorage")
    world.logInfo("[AppliedMagistics]("..tostring(entity.id())..")<"..world.entityName(entity.id())..">: "..tostring(has))
    if has < mananetwork.stored then
      local wantToGive = 1
      world.logInfo("want to give")
      local overflow = world.callScriptedEntity(v, "mananetwork.addMana", wantToGive) or 0
      mananetwork.stored = mananetwork.stored - (wantToGive - overflow)
    end
  end
  --mananetwork.updateNeeds()
end

function mananetwork.findRelays()
  local foundIDs = world.objectQuery(entity.position(),10,{
    name = "ammanarelay",
    order = "nearest"
  })
  mananetwork.relays = {}
  mananetwork.connections = {}
  for k,v in pairs(foundIDs) do

    if v ~= entity.id() then
      world.logInfo("[AppliedMagistics]("..tostring(entity.id())..")<"..world.entityName(entity.id())..">: found "..tostring(v).." at "..tostring(k).." , goes to "..tostring(#mananetwork.relays))
      --world.logInfo("taking it to "..tostring(#mananetwork.relays))
      mananetwork.relays[#mananetwork.relays+1] = v
      mananetwork.connections [#mananetwork.connections +1] = v
    end
  end
end

function mananetwork.getManaStorage()
  -- if needs amount <= 0 object should know what to do ... saves one boolean
  return mananetwork.stored
end

function mananetwork.givesMana(destinationID)
end

function mananetwork.addMana(amount)
  mananetwork.stored = mananetwork.stored + amount
  local overflow = 0
  if mananetwork.stored > mananetwork.max then
    overflow = mananetwork.stored - mananetwork.max
    mananetwork.stored = mananetwork.max
  end
  return overflow
end

function mananetwork.removeMana(amount)
  -- TODO try incorporating 0
  mananetwork.stored = mananetwork.stored - amount
  local underflow -- is underflow even a word ??
  if mananetwork.stored < 0 then
    underflow = mananetwork.stored
    mananetwork.stored = 0
  end
  return underflow
end

--[[
function mananetwork.updateNeeds()
  -- TODO use percent
  mananetwork.needsAmount = 0

  if mananetwork.stored < 100 then
    mananetwork.needsAmount = mananetwork.max - mananetwork.stored
  else
    mananetwork.needsAmount = 0
  end
  -- TODO use percent
  if mananetwork.stored >= 25 then
    mananetwork.givesMana = true
  else
    mananetwork.givesMana = false
  end
end
]]
