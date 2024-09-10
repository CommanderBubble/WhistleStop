-- Big furnace prototype and item definition
require("__WhistleStopFactories__.prototypes.adjustVisuals")
require("util")

commonAdjustments = require("__WhistleStopFactories__.prototypes.commonAdjustments")

local function create_bigfurnace(name, energy, speed)
    local collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
    local selection_box = {{-8.8, -9}, {8.8, 9}}
    local drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

    -- Base objects
    local bigfurnace = util.table.deepcopy(data.raw.furnace["electric-furnace"])
    local bigfurnace_corpse = util.table.deepcopy(data.raw.corpse["electric-furnace-remnants"])
    local bigfurnace_explosion = util.table.deepcopy(data.raw.explosion["electric-furnace-explosion"])
    local bigfurnace_item = util.table.deepcopy(data.raw.item["electric-furnace"])

    -- Corpse
    bigfurnace_corpse.name = name .. "-remnants"
    bigfurnace_corpse.order = bigfurnace_corpse.order .. "-wsf"

    adjustVisuals(bigfurnace_corpse, 5.4, 1)

    bigfurnace_corpse.collision_box = collision_box
    bigfurnace_corpse.selection_box = selection_box
    bigfurnace_corpse.drawing_box = drawing_box

    data.raw.corpse[name .. "-remnants"] = bigfurnace_corpse

    -- Explosion
    bigfurnace_explosion.name = name .. "-explosion"
    bigfurnace_explosion.order = bigfurnace_explosion.order .. "-wsf"

    adjustVisuals(bigfurnace_explosion, 5.4, 1)

    bigfurnace_explosion.collision_box = collision_box
    bigfurnace_explosion.selection_box = selection_box
    bigfurnace_explosion.drawing_box = drawing_box
    
    data.raw.explosion[name .. "-explosion"] = bigfurnace_explosion

    -- Entity
    local icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png"

    bigfurnace.name = name
    bigfurnace.icon = icon
    bigfurnace.icon_size = 32
    bigfurnace.localised_name = {"entity-name.wsf-big-furnace"}

    bigfurnace.collision_box = collision_box
    bigfurnace.selection_box = selection_box
    bigfurnace.drawing_box = drawing_box

    if bigfurnace.energy_source and bigfurnace.energy_source.emissions_per_minute then
        local prepollution = bigfurnace.energy_source.emissions_per_minute
        bigfurnace.energy_source.emissions_per_minute = prepollution * (speed / bigfurnace.crafting_speed) * 5
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

    -- Item
    bigfurnace_item.name = name
    bigfurnace_item.icon = icon
    bigfurnace_item.icon_size = 32
    bigfurnace_item.order = bigfurnace_item.order .. "-big"
    bigfurnace_item.place_result = name
    bigfurnace_item.stack_size = 5

    data.raw.item[name] = bigfurnace_item
end

return create_bigfurnace