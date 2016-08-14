smartcable = {}
-- Red Power inspired "Bundled cable" for Starbound
-- P.S. not really since it is no loger limited to 8 (16 in redpower) values


-- initialize variables
function smartcable.init()
  -- { 1 = { 1=x, 2=x }, 2 = { 1=x, 2=x } }
  smartcable.inbound = {}
  smartcable.outbound = {}

  smartcable.populated = false
end

-- populate tables and mark as populated
function smartcable.load()
  smartcable.refreshConnections()
  smartcable.populated = true
end

-- update tables
function smartcable.update()
  if smartcable.populated then
    smartcable.refreshConnections()
  else
      smartcable.load()
      if onSmartcableUpdate then
        onSmartcableUpdate()
      end
  end
end

-- populate tables to be awate of incomming/outgoing nodes
function smartcable.refreshConnections()

  -- handle inbound nodes
  smartcable.inbound = {}
  for i = 0, entity.inboundNodeCount()-1 do

    for k,v in pairs(entity.getInboundNodeIds(i)) do
      world.logInfo(k.." "..tostring(v));
    end
    smartcable.inbound[i] = entity.getInboundNodeIds(i)
  end

  -- handle outbound nodes
  smartcable.outbound = {}
  for j = 0, entity.outboundNodeCount()-1 do
    smartcable.outbound[j] = {}
    local foundNodes = entity.getOutboundNodeIds(j)
    for k, v in pairs(foundNodes) do
      world.logInfo(k.." at "..tostring(j).. "<");
      smartcable.outbound[j][k] = k
    end
  end

end


function smartcable.outboundConnected(nodeID)
  -- check if list exists in non-empty state <and> the connection itself is not nil
  return (smartcable.outbound ~= nil)  and (smartcable.outbound[nodeID] ~= nil)
end


function smartcable.sendSmartvalues(nodeID, smartvalues)
  if not smartcable.populated then
    smartcable.load()
  end
  local success = false

  -- only send if the desired output node is connected
  if smartcable.outboundConnected(nodeID) then
    -- a node can habe multiple connections

    for k,v in pairs(smartcable.outbound[nodeID]) do
      -- transmit not via wire itself but call remote funtion
      success = world.callScriptedEntity(v, "smartcable.receiveSmartvalues", smartvalues) or false
    end
  end
  return success
end

-- receives incomming message if receiving object also "includes" smartcable in .object
function smartcable.receiveSmartvalues(smartvalues)
  if onReceivedSmartvalues then
    -- use custom handler if object has one
    onReceivedSmartvalues(smartvalues)
  else
    -- or do nothing (for now)
  end
end
