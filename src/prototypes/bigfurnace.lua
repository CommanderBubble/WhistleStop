-- Big furnace prototype and item definition
require("__WhistleStopFactories__.prototypes.adjustVisuals")
require("util")

commonAdjustments = require("__WhistleStopFactories__.prototypes.commonAdjustments")

local function create_bigfurnace(name, energy, speed)
    local bigfurnaceremnants = util.table.deepcopy(data.raw.corpse["electric-furnace-remnants"])

    bigfurnaceremnants.name = name .. "-remnants"

    adjustVisuals(bigfurnaceremnants, 5.4, 1/60)

    data.raw.corpse[name .. "-remnants"] = bigfurnaceremnants

    local bigfurnace = util.table.deepcopy(data.raw.furnace["electric-furnace"])
    local icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png"

    bigfurnace.name = name
    bigfurnace.icon = icon
    bigfurnace.icon_size = 32
    bigfurnace.localised_name = {"entity-name.wsf-big-furnace"}

    bigfurnace.collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
    bigfurnace.selection_box = {{-8.8, -9}, {8.8, 9}}
    bigfurnace.drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}
    bigfurnaceremnants.collision_box = bigfurnace.collision_box
    bigfurnaceremnants.selection_box = bigfurnace.selection_box
    bigfurnaceremnants.drawing_box = bigfurnace.drawing_box

    if bigfurnace.energy_source and bigfurnace.energy_source.emissions_per_minute then
        local prepollution = bigfurnace.energy_source.emissions_per_minute
        bigfurnace.energy_source.emissions_per_minute = bigfurnace.energy_source.emissions_per_minute * (speed / bigfurnace.crafting_speed) * 5
        log("adjusted pollution of bigfurnace from "..prepollution.." to "..bigfurnace.energy_source.emissions_per_minute)
    end

    bigfurnace.crafting_categories = {"big-smelting"}
    bigfurnace.crafting_speed = speed

    bigfurnace.energy_usage = energy
    bigfurnace.module_specification.module_slots = 6
    bigfurnace.map_color = {r=199, g=103, b=247}

    -- Set this to an assembling machine type
    bigfurnace.type = "assembling-machine"
    bigfurnace.result_inventory_size = nil
    bigfurnace.source_inventory_size = nil
    bigfurnace.ingredient_count = 4

    commonAdjustments(bigfurnace)

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

    bigfurnace.fluid_boxes = {
        fluidBox("input", {-9, 0})
    }

    adjustVisuals(bigfurnace, 5.4, 1/60)

    data.raw["assembling-machine"][name] = bigfurnace

    local bigfurnace_item = util.table.deepcopy(data.raw.item["electric-furnace"])

    bigfurnace_item.name = name
    bigfurnace_item.icon = icon
    bigfurnace_item.icon_size = 32
    bigfurnace_item.order = bigfurnace_item.order .. "-big"
    bigfurnace_item.place_result = name

    data.raw.item[name] = bigfurnace_item
    -- log(serpent.line(bigfurnace))
    -- log(serpent.line(bigfurnace_item))
end

return create_bigfurnace