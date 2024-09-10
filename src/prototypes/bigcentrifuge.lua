-- Big Centrifuge prototype and item definition
require("__WhistleStopFactories__.prototypes.adjustVisuals")
require("util")

commonAdjustments = require("__WhistleStopFactories__.prototypes.commonAdjustments")

local function create_bigcentrifuge(name, energy, speed)
    local collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
    local selection_box = {{-8.8, -9}, {8.8, 9}}
    local drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

    -- Base objects
    local bigcentrifuge = util.table.deepcopy(data.raw["assembling-machine"]["centrifuge"])
    local bigcentrifuge_corpse = util.table.deepcopy(data.raw.corpse["centrifuge-remnants"])
    local bigcentrifuge_explosion = util.table.deepcopy(data.raw.explosion["centrifuge-explosion"])
    local bigcentrifuge_item = util.table.deepcopy(data.raw.item["centrifuge"])

    -- Corpse
    bigcentrifuge_corpse.name = name .. "-remnants"
    bigcentrifuge_corpse.order = bigcentrifuge_corpse.order .. "-wsf"

    adjustVisuals(bigcentrifuge_corpse, 5, 1)

    bigcentrifuge_corpse.collision_box = collision_box
    bigcentrifuge_corpse.selection_box = selection_box
    bigcentrifuge_corpse.drawing_box = drawing_box

    data.raw.corpse[name .. "-remnants"] = bigcentrifuge_corpse

    -- Explosion
    bigcentrifuge_explosion.name = name .. "-explosion"
    bigcentrifuge_explosion.order = bigcentrifuge_explosion.order .. "-wsf"

    adjustVisuals(bigcentrifuge_explosion, 5, 1)

    bigcentrifuge_explosion.collision_box = collision_box
    bigcentrifuge_explosion.selection_box = selection_box
    bigcentrifuge_explosion.drawing_box = drawing_box
    
    data.raw.explosion[name .. "-explosion"] = bigcentrifuge_explosion

    -- Entity
    -- local icon = "__WhistleStopFactories__/graphics/icons/big-centrifuge.png"

    bigcentrifuge.name = name
    -- bigcentrifuge.icon = icon
    bigcentrifuge.localised_name = {"entity-name.wsf-big-centrifuge"}

    bigcentrifuge.collision_box = collision_box
    bigcentrifuge.selection_box = selection_box
    bigcentrifuge.drawing_box = drawing_box

    if bigcentrifuge.energy_source and bigcentrifuge.energy_source.emissions_per_minute then
        local prepollution = bigcentrifuge.energy_source.emissions_per_minute
        bigcentrifuge.energy_source.emissions_per_minute = prepollution * (speed / bigcentrifuge.crafting_speed) * 5
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

    bigcentrifuge_item.name = name
    -- bigcentrifuge_item.icon = icon
    bigcentrifuge_item.order = bigcentrifuge_item.order .. "-big"
    bigcentrifuge_item.place_result = name
    bigcentrifuge_item.stack_size = 5

    data.raw.item[name] = bigcentrifuge_item
end

return create_bigcentrifuge