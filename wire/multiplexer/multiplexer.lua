function init()
  --entity.setInteractive(true)
  smartcable.init()

  --TODO cleanup definitions here
  if storage.smartvalues == nil then
    storage.smartvalues = {}
    for i = 0, entity.outboundNodeCount()-1 do
      storage.smartvalues[i] = false
    end
  end


  if storage.outsmart == nil then
    storage.outsmart = {}
    for i = 0, entity.outboundNodeCount()-1 do
      storage.outsmart[i] = false
    end
  end


  if storage.active == nil then
    storage.active = entity.configParameter("defaultSwitchState", false)
  end

  --onInboundNodeChange()
  broadcastUpdate()
  entity.setAnimationState("switchState", "on")
end

function onInteraction(args)
  --nothing
end


function onNpcPlay(npcId)
  onInteraction()
end

function onNodeConnectionChange(args)
  broadcastUpdate()
end

function onInboundNodeChange(args)
  broadcastUpdate()
end

function broadcastUpdate()
  --world.logInfo("change");
  smartcable.update()
  for i = 0, entity.inboundNodeCount()-1 do
    storage.smartvalues[i] = entity.getInboundNodeLevel(i)
  end
  if smartcable.outboundConnected(0) then
    smartcable.sendSmartvalues(0, storage.smartvalues)
  end
end
