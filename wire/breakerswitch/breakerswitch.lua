function init()
  entity.setInteractive(true)
  if storage.state == nil then
    output(entity.configParameter("defaultSwitchState", false))
  else
    output(storage.state)
  end
end

function state()
  return storage.state
end

function onInteraction(args)
  --flip output
  output(not storage.state)
  --return{ "ShowPopup",{ message = "storage.state="..tostring(storage.state) }}
end

function onNpcPlay(npcId)
  onInteraction()
end

function output(state)
  storage.state = state
  if state then
    entity.setAnimationState("switchState", "on")
    entity.setSoundEffectEnabled(true)
    entity.playSound("on");
    entity.setAllOutboundNodes(true)
  else
    entity.setAnimationState("switchState", "off")
    entity.setSoundEffectEnabled(false)
    entity.playSound("off");
    entity.setAllOutboundNodes(false)
  end
end
