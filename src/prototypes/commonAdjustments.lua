local function commonAdjustments(factory)

    factory.next_upgrade = nil
    factory.fast_replaceable_group = nil
    factory.dying_explosion = "big-explosion"
    factory.max_health = 10000

    factory.scale_entity_info_icon = true

    factory.create_ghost_on_death = true
    factory.flags = {
        "placeable-neutral",
        "placeable-player",
        "player-creation"
    }

    factory.corpse = factory.name .. "-remnants"

    factory.minable.result = factory.name

    factory.collision_mask = factory.collision_mask or {"item-layer", "object-layer", "player-layer", "water-tile"}
    factory.resistances = {
        {
            type="poison",
            percent=90
        },
        {
            type="acid",
            percent=80},
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

    factory.has_backer_name = nil
end

return commonAdjustments
