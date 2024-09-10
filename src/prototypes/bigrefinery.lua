-- Big refinery prototype and item definition
require("__WhistleStopFactories__.prototypes.adjustVisuals")
require("util")

commonAdjustments = require("__WhistleStopFactories__.prototypes.commonAdjustments")

local function create_bigrefinery(name, energy, speed)
    local collision_box = {{-14.5, -14.5}, {14.5, 14.5}}
    local selection_box = {{-15, -15}, {15, 15}}
    local drawing_box = {{-15, -15.3}, {15, 15}}

    -- Base objects
    local bigrefinery = util.table.deepcopy(data.raw["assembling-machine"]["oil-refinery"])
    local bigrefinery_corpse = util.table.deepcopy(data.raw.corpse["oil-refinery-remnants"])
    local bigrefinery_explosion = util.table.deepcopy(data.raw.explosion["oil-refinery-explosion"])
    local bigrefinery_item = util.table.deepcopy(data.raw.item["oil-refinery"])

    -- Corpse
    bigrefinery_corpse.name = name .. "-remnants"
    bigrefinery_corpse.order = bigrefinery_corpse.order .. "-wsf"

    adjustVisuals(bigrefinery_corpse, 5.8, 1)

    bigrefinery_corpse.collision_box = collision_box
    bigrefinery_corpse.selection_box = selection_box
    bigrefinery_corpse.drawing_box = drawing_box

    data.raw.corpse[name .. "-remnants"] = bigrefinery_corpse

    -- Explosion
    bigrefinery_explosion.name = name .. "-explosion"
    bigrefinery_explosion.order = bigrefinery_explosion.order .. "-wsf"

    adjustVisuals(bigrefinery_explosion, 5.8, 1)

    bigrefinery_explosion.collision_box = collision_box
    bigrefinery_explosion.selection_box = selection_box
    bigrefinery_explosion.drawing_box = drawing_box
    
    data.raw.explosion[name .. "-explosion"] = bigrefinery_explosion

    -- Entity
    bigrefinery.name = name
    -- bigrefinery.icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png"

    bigrefinery.localised_name = {"entity-name.wsf-big-refinery"}

    bigrefinery.collision_box = collision_box
    bigrefinery.selection_box = selection_box
    bigrefinery.drawing_box = drawing_box

    if bigrefinery.energy_source and bigrefinery.energy_source.emissions_per_minute then
        local prepollution = bigrefinery.energy_source.emissions_per_minute
        bigrefinery.energy_source.emissions_per_minute = prepollution * (speed / bigrefinery.crafting_speed) * 5
    end

    bigrefinery.crafting_categories = {"big-refinery"}
    bigrefinery.crafting_speed = speed

    bigrefinery.energy_usage = energy
    bigrefinery.module_specification.module_slots = 6
    bigrefinery.map_color = {r=199, g=199, b=247}

    commonAdjustments(bigrefinery)

    local function fluidBox(type, position)
        retvalue = {
                production_type = type,
                pipe_covers = pipecoverspictures(),
                base_area = 50,
                pipe_connections = {{ type=type, position=position }},
            }
        if type == "input" then
            retvalue.base_level = -1
        else
            retvalue.base_level = 1
        end
        return retvalue
    end

    bigrefinery.fluid_boxes = {
        fluidBox("input", {-6, 15}),
        fluidBox("input", {6, 15}),
        fluidBox("output", {-12, -15}),
        fluidBox("output", {0, -15}),
        fluidBox("output", {12, -15})
    }

    adjustVisuals(bigrefinery, 5.8, 1/20)

    data.raw["assembling-machine"][name] = bigrefinery

    -- Item
    bigrefinery_item.name = name
    -- bigrefinery_item.icon = icon
    bigrefinery_item.order = bigrefinery_item.order .. "-big"
    bigrefinery_item.place_result = name
    bigrefinery_item.stack_size = 5

    data.raw.item[name] = bigrefinery_item
end

return create_bigrefinery