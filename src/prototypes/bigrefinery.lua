-- Big refinery prototype and item definition
require("__WhistleStopFactories__.prototypes.adjustVisuals")
require("util")

commonAdjustments = require("__WhistleStopFactories__.prototypes.commonAdjustments")

local function create_bigrefinery(name, energy, speed)
    local bigrefineryremnants = util.table.deepcopy(data.raw.corpse["oil-refinery-remnants"])

    bigrefineryremnants.name = name .. "-remnants"

    adjustVisuals(bigrefineryremnants, 5.8, 1/20)

    data.raw.corpse[name .. "-remnants"] = bigrefineryremnants

    local bigrefinery = util.table.deepcopy(data.raw["assembling-machine"]["oil-refinery"])

    bigrefinery.name = name
    -- bigrefinery.icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png"
    bigrefinery.localised_name = {"entity-name.wsf-big-refinery"}

    bigrefinery.collision_box = {{-14.5, -14.5}, {14.5, 14.5}}
    bigrefinery.selection_box = {{-15, -15}, {15, 15}}
    bigrefinery.drawing_box = {{-15, -15.3}, {15, 15}}
    bigrefineryremnants.collision_box = bigrefinery.collision_box
    bigrefineryremnants.selection_box = bigrefinery.selection_box
    bigrefineryremnants.drawing_box = bigrefinery.drawing_box

    if bigrefinery.energy_source and bigrefinery.energy_source.emissions_per_minute then
        local prepollution = bigrefinery.energy_source.emissions_per_minute
        bigrefinery.energy_source.emissions_per_minute = bigrefinery.energy_source.emissions_per_minute * (speed / bigrefinery.crafting_speed) * 5
        log("adjusted pollution of bigrefinery from "..prepollution.." to "..bigrefinery.energy_source.emissions_per_minute)
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

    local bigrefinery_item = util.table.deepcopy(data.raw.item["oil-refinery"])

    bigrefinery_item.name = name
    -- bigrefinery_item.icon = icon
    bigrefinery_item.order = bigrefinery_item.order .. "-big"
    bigrefinery_item.place_result = name

    data.raw.item[name] = bigrefinery_item
end

return create_bigrefinery