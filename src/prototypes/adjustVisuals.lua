-- Scales up visuals by a factor and scales back animations by a factor (to adjust for increased crafting speed)

local function scalePosition(position, factor)
    local x = position.x or position[1]
    local y = position.y or position[2]
    if x and y then
        return {x = x * factor, y = y * factor}
    else
        return position
    end
end

-- Scale graphics by a factor and correct animation speed
local function bumpUp(animation, scaleFactor, animationFactor)
    if type(animation) ~= "table" then
        return
    end

    if type(animation.shift) == "table" then
        animation.shift = scalePosition(animation.shift, scaleFactor)
    end
    if type(animation.scale) ~= "nil" then
        animation.scale = (animation.scale or 1) * scaleFactor
    end
    if type(animation.frame_count) == "number" and animation.frame_count > 1 then
        animation.animation_speed = (animation.animation_speed or 1) * animationFactor
    end
end

local function bumpFullAnimation(animation, scaleFactor, animationFactor)
    if type(animation) == "table" then
        bumpUp(animation, scaleFactor, animationFactor)
        bumpUp(animation.hr_version, scaleFactor, animationFactor)
    end
end

local function bumpAnimationSet(animation_set, scaleFactor, animationFactor)
    for _, direction in pairs({"north", "east", "south", "west"}) do
        if type(animation_set[direction]) == "table" and type(animation_set[direction].layers) == "table" then
            for _, layer in pairs(animation_set[direction].layers) do
                bumpFullAnimation(layer, scaleFactor, animationFactor)
            end
        end
    end
    if type(animation_set.layers) == "table" then
        for _, layer in pairs(animation_set.layers) do
            bumpFullAnimation(layer, scaleFactor, animationFactor)
        end
    end

    for _, value in pairs(animation_set) do
        bumpFullAnimation(value, scaleFactor, animationFactor)
    end
end

function adjustVisuals(machine, scaleFactor, animationFactor)
    if type(machine) ~= "table" then
        return
    end

    -- Animation Adjustments
    if type(machine.animation) == "table" then
        bumpAnimationSet(machine.animation, scaleFactor, animationFactor)
    end

    if type(machine.animations) == "table" then
        bumpAnimationSet(machine.animations, scaleFactor, animationFactor)
    end

    -- Idle Animation Adjustments
    if type(machine.idle_animation) == "table" then
        bumpAnimationSet(machine.idle_animation, scaleFactor, animationFactor)
    end

    -- Tile Adjustments
    if type(machine.tile_height) ~= "nil" then
        machine.tile_height = machine.tile_height * scaleFactor
    end
    if type(machine.tile_width) ~= "nil" then
        machine.tile_width = machine.tile_width * scaleFactor
    end

    -- Working Visualisations Adjustments
    if type(machine.working_visualisations) == "table" then
        for _, visualisation in pairs(machine.working_visualisations) do
            if type(visualisation) == "table" then
                bumpFullAnimation(visualisation.animation, scaleFactor, animationFactor)
                for _, direction in pairs({"north", "east", "south", "west"}) do
                    bumpFullAnimation(visualisation[direction .. "_animation"], scaleFactor, animationFactor)
                    if type(visualisation[direction .. "_position"]) == "table" then
                        visualisation[direction .. "_position"] = scalePosition(visualisation[direction .. "_position"], scaleFactor)
                    end
                end
                if type(visualisation.animation) == "table" and type(visualisation.animation.layers) == "table" then
                    for _, layer in pairs(visualisation.animation.layers) do
                        bumpFullAnimation(layer, scaleFactor, animationFactor)
                    end
                end
            end
        end
    end
end