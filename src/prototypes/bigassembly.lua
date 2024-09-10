-- Big Assembly prototype and item definition
require("__WhistleStopFactories__.prototypes.adjustVisuals")
require("util")

commonAdjustments = require("__WhistleStopFactories__.prototypes.commonAdjustments")

local function create_bigassembly(name, energy, speed)
    local collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
    local selection_box = {{-8.8, -9}, {8.8, 9}}
    local drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

    -- Base objects
    local bigassembly = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
    local bigassembly_corpse = util.table.deepcopy(data.raw.corpse["assembling-machine-3-remnants"])
    local bigassembly_explosion = util.table.deepcopy(data.raw.explosion["assembling-machine-3-explosion"])
    local bigassembly_item = util.table.deepcopy(data.raw.item["assembling-machine-3"])

    -- Corpse
    bigassembly_corpse.name = name .. "-remnants"
    bigassembly_corpse.order = bigassembly_corpse.order .. "-wsf"

    adjustVisuals(bigassembly_corpse, 6, 1)

    bigassembly_corpse.collision_box = collision_box
    bigassembly_corpse.selection_box = selection_box
    bigassembly_corpse.drawing_box = drawing_box

    data.raw.corpse[name .. "-remnants"] = bigassembly_corpse

    -- Explosion
    bigassembly_explosion.name = name .. "-explosion"
    bigassembly_explosion.order = bigassembly_explosion.order .. "-wsf"

    adjustVisuals(bigassembly_explosion, 6, 1)

    bigassembly_explosion.collision_box = collision_box
    bigassembly_explosion.selection_box = selection_box
    bigassembly_explosion.drawing_box = drawing_box
    
    data.raw.explosion[name .. "-explosion"] = bigassembly_explosion

    -- Entity
    local icon = "__WhistleStopFactories__/graphics/icons/big-assembly.png"

    bigassembly.name = name
    bigassembly.icon = icon
    bigassembly.icon_size = 32
    bigassembly.localised_name = {"entity-name.wsf-big-assembly"}

    bigassembly.collision_box = collision_box
    bigassembly.selection_box = selection_box
    bigassembly.drawing_box = drawing_box

    if bigassembly.energy_source and bigassembly.energy_source.emissions_per_minute then
        local prepollution = bigassembly.energy_source.emissions_per_minute
        bigassembly.energy_source.emissions_per_minute = prepollution * (speed / bigassembly.crafting_speed) * 5
    end

    bigassembly.crafting_categories = {"big-assembly"}
    bigassembly.crafting_speed = speed

    bigassembly.energy_usage = energy
    bigassembly.ingredient_count = 10
    bigassembly.module_specification.module_slots = 5
    bigassembly.map_color = {r=103, g=247, b=247}

    commonAdjustments(bigassembly)

    local function fluidBox(type, position)
        retvalue = {
                production_type = type,
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                pipe_connections = {{ type=type, position=position }},
                secondary_draw_orders = { north = -1 }
            }
        if type == "input" then
            retvalue.base_level = -1
        else
            retvalue.base_level = 1
        end
        return retvalue
    end

    bigassembly.fluid_boxes = {
        fluidBox("input", {0, -9}),
        fluidBox("input", {-9, 0}),
        fluidBox("output", {9, 0}),
        fluidBox("output", {0, 9}),
    }

    adjustVisuals(bigassembly, 6, 1/32)

    data.raw["assembling-machine"][name] = bigassembly

    -- Item
    bigassembly_item.name = name
    bigassembly_item.icon = icon
    bigassembly_item.icon_size = 32
    bigassembly_item.order = bigassembly_item.order .. "-big"
    bigassembly_item.place_result = name
    bigassembly_item.stack_size = 5

    data.raw.item[name] = bigassembly_item
end

return create_bigassembly