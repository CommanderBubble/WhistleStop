-- Big Centrifuge prototype and item definition
require("__WhistleStopFactories__.prototypes.adjustVisuals")
require("util")

commonAdjustments = require("__WhistleStopFactories__.prototypes.commonAdjustments")

local function create_bigcentrifuge(name, energy, speed)
    local bigcentrifugeremnants = util.table.deepcopy(data.raw.corpse["centrifuge-remnants"])

    bigcentrifugeremnants.name = name .. "-remnants"

    adjustVisuals(bigcentrifugeremnants, 5, 1/20)

    data.raw.corpse[name .. "-remnants"] = bigcentrifugeremnants

    local bigcentrifuge = util.table.deepcopy(data.raw["assembling-machine"]["centrifuge"])
    -- local icon = "__WhistleStopFactories__/graphics/icons/big-assembly.png"

    bigcentrifuge.name = name
    -- bigcentrifuge.icon = icon
    bigcentrifuge.localised_name = {"entity-name.wsf-big-centrifuge"}

    bigcentrifuge.collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
    bigcentrifuge.selection_box = {{-8.8, -9}, {8.8, 9}}
    bigcentrifuge.drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}
    bigcentrifugeremnants.collision_box = bigcentrifuge.collision_box
    bigcentrifugeremnants.selection_box = bigcentrifuge.drawiselection_boxng_box
    bigcentrifugeremnants.drawing_box = bigcentrifuge.drawing_box

    if bigcentrifuge.energy_source and bigcentrifuge.energy_source.emissions_per_minute then
        local prepollution = bigcentrifuge.energy_source.emissions_per_minute
        bigcentrifuge.energy_source.emissions_per_minute = bigcentrifuge.energy_source.emissions_per_minute * (speed / bigcentrifuge.crafting_speed) * 5
        log("adjusted pollution of bigcentrifuge from "..prepollution.." to "..bigcentrifuge.energy_source.emissions_per_minute)
    end

    bigcentrifuge.crafting_categories = {"big-uranium"}
    bigcentrifuge.crafting_speed = speed

    bigcentrifuge.energy_usage = energy
    bigcentrifuge.ingredient_count = 10
    bigcentrifuge.module_specification.module_slots = 5
    bigcentrifuge.map_color = {r=103, g=247, b=103}

    commonAdjustments(bigcentrifuge)

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

    adjustVisuals(bigcentrifuge, 5, 1/20)

    data.raw["assembling-machine"][name] = bigcentrifuge

    local bigcentrifuge_item = util.table.deepcopy(data.raw.item["centrifuge"])

    bigcentrifuge_item.name = name
    -- bigcentrifuge_item.icon = icon
    bigcentrifuge_item.order = bigcentrifuge_item.order .. "-big"
    bigcentrifuge_item.place_result = name

    data.raw.item[name] = bigcentrifuge_item
end

return create_bigcentrifuge