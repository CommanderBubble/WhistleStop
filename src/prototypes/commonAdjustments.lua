local function commonAdjustments(factory)
    factory.collision_mask = factory.collision_mask or {"item-layer", "object-layer", "player-layer", "water-tile"}
    factory.corpse = factory.name .. "-remnants"
    factory.create_ghost_on_death = true
    factory.dying_explosion = factory.name .. "-explosion"
    factory.fast_replaceable_group = nil
    factory.flags = {
        "placeable-neutral",
        "placeable-player",
        "player-creation"
    }
    factory.has_backer_name = nil
    factory.max_health = 10000
    factory.minable.result = factory.name
    factory.next_upgrade = nil
    factory.resistances = {
        {
            type="poison",
            percent=90
        },
        {
            type="acid",
            percent=80
        },
        {
            type="physical",
            percent=70
        },
        {
            type="fire",
            percent=70
        },
        {
            type="explosion",
            percent=-100
        }
    }
    factory.scale_entity_info_icon = true
end

return commonAdjustments
