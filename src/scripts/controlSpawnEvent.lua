require("__WhistleStopFactories__.scripts.luaMacros")

-- Placing/Destroying events and loader placement

local offset1 = {[0]=1, [2]=0, [4]=-1, [6]=0}
local offset2 = {[0]=0, [2]=1, [4]=0, [6]=-1}

local function placeLoader(entity, xoffset, yoffset, type, direction)
    local xposition = entity.position.x + offset1[entity.direction] * xoffset - offset2[entity.direction] * yoffset
    local yposition = entity.position.y + offset1[entity.direction] * yoffset + offset2[entity.direction] * xoffset
    direction_final = (direction + entity.direction) % 8

    local loader = entity.surface.create_entity{name="wsf-factory-loader", position={xposition, yposition}, force=entity.force, type=type, direction=direction_final}
    if loader then
        loader.destructible = false
        loader.minable = false
        loader.operable = false
        loader.rotatable = false
    else
        debugWrite("Loader Spawn failed at " .. xposition .. "," .. yposition)
    end
    return loader
end

local function loadersForBigAssembly(entity)
    local loaderlist = global.whistlestops[entity.unit_number].loaderlist

    -- Left side loaders
    for i=2,6 do
        table.insert(loaderlist, placeLoader(entity, -7.5, i, "input", 2))
        table.insert(loaderlist, placeLoader(entity, -7.5, -i, "input", 2))
    end

    -- Right side loaders
    for i=2,6 do
        table.insert(loaderlist, placeLoader(entity, 7.5, i, "output", 2))
        table.insert(loaderlist, placeLoader(entity, 7.5, -i, "output", 2))
    end

    for i=2,6 do
        -- Bottom loaders
        table.insert(loaderlist, placeLoader(entity, -i, 7.5, "input", 0))
        table.insert(loaderlist, placeLoader(entity, i, 7.5, "input", 0))
        -- Top loaders
        table.insert(loaderlist, placeLoader(entity, -i, -7.5, "input", 4))
        table.insert(loaderlist, placeLoader(entity, i, -7.5, "input", 4))
    end
end

local function loadersForBigCentrifuge(entity)
    local loaderlist = global.whistlestops[entity.unit_number].loaderlist
    
    for i=2,6 do
        -- Left side loaders
        table.insert(loaderlist, placeLoader(entity, -7.5, i, "input", 2))
        table.insert(loaderlist, placeLoader(entity, -7.5, -i, "input", 2))
        -- Right side loaders
        table.insert(loaderlist, placeLoader(entity, 7.5, i, "output", 2))
        table.insert(loaderlist, placeLoader(entity, 7.5, -i, "output", 2))
    end
end

local function loadersForBigChemPlant(entity)
    local loaderlist = global.whistlestops[entity.unit_number].loaderlist
    
    for i=2,6 do
        -- Left side loaders
        table.insert(loaderlist, placeLoader(entity, -7.5, i, "input", 2))
        table.insert(loaderlist, placeLoader(entity, -7.5, -i, "input", 2))
        -- Right side loaders
        table.insert(loaderlist, placeLoader(entity, 7.5, i, "output", 2))
        table.insert(loaderlist, placeLoader(entity, 7.5, -i, "output", 2))
    end
end

local function loadersForBigFurnace(entity)
    local loaderlist = global.whistlestops[entity.unit_number].loaderlist
    
    for i=2,7 do
        -- Left side loaders
        table.insert(loaderlist, placeLoader(entity, -7.5, i, "input", 2))
        table.insert(loaderlist, placeLoader(entity, -7.5, -i, "input", 2))
        -- Right side loaders
        table.insert(loaderlist, placeLoader(entity, 7.5, i, "output", 2))
        table.insert(loaderlist, placeLoader(entity, 7.5, -i, "output", 2))
    end
end

local function loadersForBigRefinery(entity)
    local loaderlist = global.whistlestops[entity.unit_number].loaderlist
    
    for i=3,10 do
        -- Left side loaders
        table.insert(loaderlist, placeLoader(entity, -13.5, i, "input", 2))
        table.insert(loaderlist, placeLoader(entity, -13.5, -i, "input", 2))
    end
end

local function placeAllLoaders(entity)
    if entity.name == "wsf-big-assembly" then
        loadersForBigAssembly(entity)
    elseif entity.name == "wsf-big-centrifuge" then
        loadersForBigCentrifuge(entity)
    elseif entity.name == "wsf-big-chemplant" then
        loadersForBigChemPlant(entity)
    elseif entity.name == "wsf-big-furnace" then
        loadersForBigFurnace(entity)
    elseif entity.name == "wsf-big-refinery" then
        loadersForBigRefinery(entity)
    end
end

local function destroyLoaders(unit_number)
    if type(global.whistlestops[unit_number]) ~= "nil" then
        for k,v in pairs(global.whistlestops[unit_number].loaderlist) do
            v.destroy()
        end
        global.whistlestops[unit_number].loaderlist = {}
    end
end

script.on_event(defines.events.on_player_rotated_entity,
    function (event)
        if inlist(event.entity.name, {"wsf-big-assembly", "wsf-big-centrifuge", "wsf-big-chemplant", "wsf-big-furnace", "wsf-big-refinery"}) then
            destroyLoaders(event.entity.unit_number)
            placeAllLoaders(event.entity)
        end
    end
)

function on_built_event(entity)
    if type(entity) ~= "table" or not inlist(entity.name, {"wsf-big-assembly", "wsf-big-centrifuge", "wsf-big-chemplant", "wsf-big-furnace", "wsf-big-refinery"}) then
        return
    end

    global.whistlestops[entity.unit_number] = {position=entity.position, type=entity.name, entity=entity, surface=entity.surface, direction=entity.direction, recipe=nil, tag=nil, loaderlist={}}

    placeAllLoaders(entity)
end

script.on_event(
    {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity
    },
    function (event)
        if type(event) == "table" then
            on_built_event(event.created_entity)
        end
    end
)

script.on_event(
    {
        defines.events.script_raised_built,
        defines.events.script_raised_revive,
        defines.events.on_cancelled_deconstruction
    },
    function (event)
        if type(event) == "table" then
            on_built_event(event.entity)
        end
    end
)

-- Destroying leftover loaders
function on_destroy_event(entity)
    if type(entity) == "table" and inlist(entity.name, {"wsf-big-assembly", "wsf-big-centrifuge", "wsf-big-chemplant", "wsf-big-furnace", "wsf-big-refinery"}) then
        destroyLoaders(entity.unit_number)
        global.whistlestops[entity.unit_number] = nil
    end    
end

script.on_event(
    {
        defines.events.on_entity_died,
        defines.events.on_player_mined_entity,
        defines.events.on_robot_mined_entity,
        defines.events.script_raised_destroy,
        defines.events.on_marked_for_deconstruction
    },
    function (event)
        if type(event) == "table" then
            on_destroy_event(event.entity)
        end
    end
)