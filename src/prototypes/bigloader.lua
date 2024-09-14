-- Big loader prototype and item definition
require("util")

local function create_bigloader(name)
    local bigloader = util.table.deepcopy(data.raw["loader"]["express-loader"])

    bigloader.name = name
    bigloader.localised_name = {"entity-name.express-loader"}
    bigloader.minable = {hardness = 0, minable = false, mining_time = 0}
    bigloader.next_upgrade = nil
    bigloader.fast_replaceable_group = nil
    bigloader.destructible = false

    bigloader.create_ghost_on_death = false
    bigloader.flags = {"placeable-player", "player-creation", "not-deconstructable", "not-blueprintable", "not-rotatable", "hidden", "hide-alt-info", "not-upgradable", "not-selectable-in-game", "no-copy-paste", "not-repairable"}

    bigloader.collision_mask = {"transport-belt-layer"}
    bigloader.structure_render_layer = "lower-object"

    data.raw["loader"][name] = bigloader

    local bigloader_item = util.table.deepcopy(data.raw.item["express-loader"])

    bigloader_item.name = name
    -- bigloader_item.icon = icon
    bigloader_item.order = "d[loader]-c[" .. name .."]"
    bigloader_item.place_result = name

    data.raw.item[name] = bigloader_item
end

return create_bigloader