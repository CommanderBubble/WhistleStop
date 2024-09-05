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

    animation.scale = (animation.scale or 1) * scaleFactor
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

function adjustVisuals(machine, scaleFactor, animationFactor)
    if type(machine) ~= "table" then
        return
    end
    -- Animation Adjustments
    if type(machine.animation) == "table" then
        for _, direction in pairs({"north", "east", "south", "west"}) do
            if type(machine.animation[direction]) == "table" and type(machine.animation[direction].layers) == "table" then
                for _, v in pairs(machine.animation[direction].layers) do
                    bumpFullAnimation(v, scaleFactor, animationFactor)
                end
            end
        end
        if type(machine.animation.layers) == "table" then
            for _, v in pairs(machine.animation.layers) do
                bumpFullAnimation(v, scaleFactor, animationFactor)
            end
        end
        
        if machine.type == "corpse" then
            for _, v in pairs(machine.animation) do
                bumpFullAnimation(v, scaleFactor, animationFactor)
            end
        end
    end
    -- Idle Animation Adjustments
    if type(machine.idle_animation) == "table" then
        for _, direction in pairs({"north", "east", "south", "west"}) do
            if type(machine.idle_animation[direction]) == "table" and type(machine.idle_animation[direction].layers) == "table" then
                for _, v in pairs(machine.idle_animation[direction].layers) do
                    bumpFullAnimation(v, scaleFactor, animationFactor)
                end
            end
        end
        if type(machine.idle_animation.layers) == "table" then
            for _, v in pairs(machine.idle_animation.layers) do
                bumpFullAnimation(v, scaleFactor, animationFactor)
            end
        end
    end
    -- Tile Adjustments
    if machine.type == "corpse" then
        machine.tile_width = machine.tile_width * scaleFactor
        machine.tile_height = machine.tile_height * scaleFactor
    end
    -- Working Visualisations Adjustments
    if type(machine.working_visualisations) == "table" then
        for _, v in pairs(machine.working_visualisations) do
            if type(v) == "table" then
                bumpFullAnimation(v.animation, scaleFactor, animationFactor)
                for _, direction in pairs({"north", "east", "south", "west"}) do
                    bumpFullAnimation(v[direction .. "_animation"], scaleFactor, animationFactor)
                    if type(v[direction .. "_position"]) == "table" then
                        v[direction .. "_position"] = scalePosition(v[direction .. "_position"], scaleFactor)
                    end
                end
                if type(v.animation) == "table" and type(v.animation.layers) == "table" then
                    for _, layer in pairs(v.animation.layers) do
                        bumpFullAnimation(layer, scaleFactor, animationFactor)
                    end
                end
            end
        end
    end
end