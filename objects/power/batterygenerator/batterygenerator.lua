function init()
    sb.logInfo("[NAN] BatteryGenerator init")
    object.setInteractive(true)

    powernode.init()

    powernode.relative_x = 1
    powernode.relative_y = 1.5
    --powernode.is_relay = true
    powernode.sends = true
    powernode.buffersize = 10
    --powernode.init()
    --sb.logInfo("[NAN] "..tostring(storage.mana))

    --if storage.mana == nil then storage.mana = 0 end

    --powernode.stored = storage.mana
    object.setInteractive(true)

end

--[[
function onInteraction(args)
    local awesomeString = ""
    for k,v in pairs(powernode.relays) do
        awesomeString = awesomeString .. tostring(v)..","
    end

    return{ "ShowPopup",{ message =
        "ID: "..tostring(entity.id())
        .."\nMana: "..powernode.stored.."<"
        .."\nNeeds: ".."NaN".."<"
        .."\nConnections: "..awesomeString.."<"
    }}
end
]]

function update(dt)
    powernode.update()
    local batteryCount = world.containerAvailable(entity.id(),"smallbattery")
    if  (batteryCount ~= nil) and (batteryCount > 0)then
        if powernode.stored <= 0 then
        --powernode.addPower(1) --XXX DEBUG POWER GENERATION
            world.containerTakeNumItemsAt(entity.id(), 1, 1)
            world.containerConsume(entity.id(), "smallbattery")
            powernode.stored = powernode.buffersize
        end
    end

    updateDisplay(batteryCount)
end


function updateDisplay(batteryCount)
    if batteryCount < 1 then
        animator.setAnimationState("switchState", "zero")

    elseif batteryCount >= 10 then
        animator.setAnimationState("switchState", "ten")

    elseif batteryCount >= 9 then
        animator.setAnimationState("switchState", "nine")

    elseif batteryCount >= 8 then
        animator.setAnimationState("switchState", "eight")

    elseif batteryCount >= 7 then
        animator.setAnimationState("switchState", "seven")

    elseif batteryCount >= 6 then
        animator.setAnimationState("switchState", "six")

    elseif batteryCount >= 5 then
        animator.setAnimationState("switchState", "five")

    elseif batteryCount >= 4 then
        animator.setAnimationState("switchState", "four")

    elseif batteryCount >= 3 then
        animator.setAnimationState("switchState", "three")

    elseif batteryCount >= 2 then
        animator.setAnimationState("switchState", "two")

    elseif batteryCount >= 1 then
        animator.setAnimationState("switchState", "one")

    end
end
