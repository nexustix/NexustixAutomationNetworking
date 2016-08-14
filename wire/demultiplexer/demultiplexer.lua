function init()
  --entity.setInteractive(true)
  smartcable.init()

  if storage.smartvalues == nil then
    storage.smartvalues = {}
    for i = 0, entity.outboundNodeCount()-1 do
      storage.smartvalues[i] = false
    end
  end

  if storage.active == nil then
    storage.active = entity.configParameter("defaultSwitchState", true)
  end
  --setActive(storage.active)
  entity.setAnimationState("switchState", "on")

end


function onInteraction(args)
  --flip output
  --setActive(not storage.active)
  --return{ "ShowPopup",{ message = "output=".. }}
end

function onNpcPlay(npcId)
  onInteraction()
end


function onReceivedSmartvalues(smartvalues)
  for i = 0, entity.outboundNodeCount()-1 do
    entity.setOutboundNodeLevel (i, smartvalues[i] or false)
  end
end
