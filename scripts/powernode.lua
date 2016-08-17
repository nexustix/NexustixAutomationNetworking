powernode = {}


function powernode.init()

    sb.logInfo("[NAN] Powernode init")

    powernode.devices = {}          -- konwn connections (not relays)
    powernode.relays = {}           -- konwn relay connections

    powernode.receives = false      -- can receive power
    powernode.sends = false         -- can send power
    --powernode.only_relays = true    -- only transmit power to relays

    powernode.is_relay = false      -- is a relay

    powernode.bandwith = 1          -- maximal power transmission per object tick (send an receive calculated separately)
    powernode.buffersize = 50       -- internal power-buffer size

    powernode.stored = 0            -- amount of power in buffer

    powernode.relative_x = 0        --  where to spawn the spark relative X
    powernode.relative_y = 0        --  where to spawn the spark relative Y

    --powernode.do_spark = true


    if storage.power == nil then storage.power = 0 end

    powernode.stored = storage.power
end

function powernode.isPowernode()
    return true
end

--XXX START GETTERS / SETTERS

--connections = {}
--relays = {}

--receives = false
function powernode.isreceiving()
    return powernode.receives
end

--sends = false
function powernode.isSending()
    return powernode.sends
end
--only_relays = true

--is_relay = false
function powernode.isRelay()
    return powernode.is_relay
end
--bandwith = 1
--buffersize = 50

--stored = 0
function powernode.getStoredPercent()
    return math.floor( powernode.stored / (powernode.buffersize / 100) ) or 100
end

--relative_x = 0 --relative_y = 0
function powernode.getRelativePos()

    local curHere = entity.position()
    curHere[1] = curHere[1] + powernode.relative_x
    curHere[2] = curHere[2] + powernode.relative_y
    return curHere
end

----powernode.do_spark = true
function powernode.generateSpark(destinationID)
    local tmpDist = world.magnitude(world.entityPosition(destinationID), object.position())
    --local posHere = entity.position()
    local posHere = powernode.getRelativePos()

    local posThere = world.entityPosition(destinationID)
    posThere = world.callScriptedEntity(destinationID, "powernode.getRelativePos")

    world.spawnProjectile("powerspark", posHere, entity.id(), world.distance( posThere, posHere ) , true,
    {["timeToLive"] = 0.02*tmpDist,
    ["collision"] = false,
    })
end

--XXX END GETTERS / SETTERS

function powernode.update()
    powernode.findConnections()

    if powernode.is_relay then

        powernode.disperseToRelays()
        for k, v in pairs(powernode.devices) do
            if ( world.entityExists(v) ) and ( world.callScriptedEntity(v, "powernode.isReceiving") ) and ( world.callScriptedEntity(v, "powernode.getStoredPercent") < 100 ) then
                if powernode.sendPower(v) then
                    powernode.generateSpark(v)
                end
            end
        end

    elseif powernode.sends then
            powernode.disperseToRelays()
    end
    storage.power = powernode.stored
end


function powernode.findConnections()

    local foundIDs = world.objectQuery(entity.position(),13,{
        order = "nearest"
    })

    powernode.connections = {}
    powernode.relays = {}

    for k,v in pairs(foundIDs) do
        --sb.logInfo("[NAN] "..tostring(world.entityType(v)))
        -- i do not desire to find "myself"
        if ( v ~= entity.id() ) and ( world.callScriptedEntity(v, "powernode.isPowernode") ~= nil ) then --and root.itemHasTag(world.entityType(v), "nan_power") then

            if world.callScriptedEntity(v, "powernode.isRelay") then
                powernode.relays[#powernode.relays+1] = v
            else
                powernode.devices [#powernode.devices +1] = v
            end
        end
    end
end


function powernode.disperseToRelays()
    for k, v in pairs(powernode.relays) do
        if powernode.is_relay then
            if world.callScriptedEntity(v, "powernode.getStoredPercent") < powernode.getStoredPercent()-25 then
                if powernode.sendPower(v) then
                    powernode.generateSpark(v)
                end
            end
        else
            if powernode.sendPower(v) then
                powernode.generateSpark(v)
            end
        end
    end
end


function powernode.sendPower(destinationID)

    local add_amount = powernode.bandwith

    if powernode.removePowerUnderflow(add_amount) == 0 then
        if world.callScriptedEntity(destinationID, "powernode.addPower", add_amount) and powernode.removePower(add_amount) then
            return true
        end
    end
    return false
end


function powernode.addPowerOverflow(amount)

    local post = powernode.stored + amount
    local overflow = 0

    if post > powernode.buffersize then
        overflow = post - powernode.buffersize
    end

    return overflow
end


function powernode.removePowerUnderflow(amount)

    local post = powernode.stored - amount
    local underflow = 0

    if post < 0 then
        underflow = 0 - post
    end

    return underflow
end


function powernode.addPower(amount)

    if powernode.addPowerOverflow(amount) == 0 then
        powernode.stored = powernode.stored + amount
        return true
    end

    return false
end


function powernode.removePower(amount)

    if powernode.removePowerUnderflow(amount) == 0 then
        powernode.stored = powernode.stored - amount
        return true
    end

    return false
end
