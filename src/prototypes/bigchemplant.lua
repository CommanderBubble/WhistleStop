-- Big Assembly prototype and item definition
require("__WhistleStopFactories__.prototypes.adjustVisuals")
require("util")

commonAdjustments = require("__WhistleStopFactories__.prototypes.commonAdjustments")

local function create_bigchemplant(name, energy, speed)
    local collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
    local selection_box = {{-8.8, -9}, {8.8, 9}}
    local drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

    -- Base objects
    local bigchemplant = util.table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
    local bigchemplant_corpse = util.table.deepcopy(data.raw.corpse["chemical-plant-remnants"])
    local bigchemplant_explosion = util.table.deepcopy(data.raw.explosion["chemical-plant-explosion"])
    local bigchemplant_item = util.table.deepcopy(data.raw.item["chemical-plant"])

    -- Corpse
    bigchemplant_corpse.name = name .. "-remnants"
    bigchemplant_corpse.order = bigchemplant_corpse.order .. "-wsf"

    adjustVisuals(bigchemplant_corpse, 5, 1)

    bigchemplant_corpse.collision_box = collision_box
    bigchemplant_corpse.selection_box = selection_box
    bigchemplant_corpse.drawing_box = drawing_box

    data.raw.corpse[name .. "-remnants"] = bigchemplant_corpse

    -- Explosion
    bigchemplant_explosion.name = name .. "-explosion"
    bigchemplant_explosion.order = bigchemplant_explosion.order .. "-wsf"

    adjustVisuals(bigchemplant_explosion, 5, 1)

    bigchemplant_explosion.collision_box = collision_box
    bigchemplant_explosion.selection_box = selection_box
    bigchemplant_explosion.drawing_box = drawing_box
    
    data.raw.explosion[name .. "-explosion"] = bigchemplant_explosion

    -- Entity
    -- local icon = "__WhistleStopFactories__/graphics/icons/big-chemplant.png"

    bigchemplant.name = name
    -- bigchemplant.icon = icon
    bigchemplant.localised_name = {"entity-name.wsf-big-chemplant"}

    bigchemplant.collision_box = collision_box
    bigchemplant.selection_box = selection_box
    bigchemplant.drawing_box = drawing_box

    if bigchemplant.energy_source and bigchemplant.energy_source.emissions_per_minute then
        local prepollution = bigchemplant.energy_source.emissions_per_minute
        bigchemplant.energy_source.emissions_per_minute = prepollution * (speed / bigchemplant.crafting_speed) * 5
        log("adjusted pollution of bigchemplant from "..prepollution.." to "..bigchemplant.energy_source.emissions_per_minute)
    end

    bigchemplant.crafting_categories = {"big-chem"}
    bigchemplant.crafting_speed = speed

    bigchemplant.energy_usage = energy
    bigchemplant.ingredient_count = 10
    bigchemplant.module_specification.module_slots = 5
    bigchemplant.map_color = {r=103, g=247, b=103}

    commonAdjustments(bigchemplant)

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

    bigchemplant.fluid_boxes = {
        fluidBox("input", {-5, -9}),
        fluidBox("input", {5, -9}),
        fluidBox("output", {-5, 9}),
        fluidBox("output", {5, 9}),
        -- off_when_no_fluid_recipe = true -- Allows for rotation
    }

    adjustVisuals(bigchemplant, 5, 1/20)

    data.raw["assembling-machine"][name] = bigchemplant

    -- Item
    bigchemplant_item.name = name
    -- bigchemplant_item.icon = icon
    bigchemplant_item.order = bigchemplant_item.order .. "-big"
    bigchemplant_item.place_result = name
    bigchemplant_item.stack_size = 5

    data.raw.item[name] = bigchemplant_item
end

return create_bigchemplant