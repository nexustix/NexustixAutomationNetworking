function init()
  sb.logInfo("[NAN] Grinder init")
  powernode.init()

  powernode.relative_x = 1
  powernode.relative_y = 3.5
  powernode.buffersize = 100
  powernode.receives = true

  storage.outputitems = {}
  storage.processinglength = 3
  storage.processingcost = 25

  storage.processingtimer = storage.processinglength

  storage.inv_items = {}

  --object.setInteractive(true)
end


function update(dt)
    powernode.update()
    storage.inv_items = world.containerItems(entity.id())
    if powernode.stored >= storage.processingcost then
        getRecipe()
        if (#storage.outputitems) > 0 then
            doWork()
        end
    end
end


function getRecipe()


    storage.outputitems = {}

    if not (storage.inv_items[10]) then
        return
    elseif storage.inv_items[10].name == "nan_teledynamium" then
        addOutput("nan_teledynamiumdust")

    elseif storage.inv_items[10].name == "goldbar" then
        addOutput("nan_golddust")
    elseif storage.inv_items[10].name == "silverbar" then
        addOutput("nan_silverdust")

    elseif storage.inv_items[10].name == "liquidwater" then
        addOutput("nan_hydrogen")
        addOutput("nan_hydrogen")
        addOutput("nan_oxygen")
    end
end

function addOutput(item_name)
    storage.outputitems[#storage.outputitems+1] = item_name
end

--function addNOutput(item_name, n)
    --storage.outputitems[#storage.outputitems+1] = item_name
--end

function doWork()
    if storage.processingtimer <= 0 then
        if powernode.removePower(storage.processingcost) then
            world.containerConsume(entity.id(), storage.inv_items[10].name)
            generateOutput(storage.outputitems)
        end
        storage.processingtimer = storage.processinglength
    else
        storage.processingtimer = storage.processingtimer - 1
    end
end

function generateOutput(items)
    for k, v in pairs(items) do
        world.containerAddItems(entity.id(), {name = v, count = 1, data = {}})
    end
end
