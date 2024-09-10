-- Lists points used to determine if a new factory is far enough away from previous factories
require("__WhistleStopFactories__.scripts.controlSpawnEvent")
require("util")

Updates = {}
local current_version = 8

Updates.init = function()
	global.update_version = current_version
end

Updates.run = function()
    global.update_version = global.update_version or 0
	if global.update_version <= 1 then
        -- Location tracking
        global.whistlestops = global.whistlestops or {} -- New
    end

    if global.update_version <= 7 then
        for _, force in pairs(game.forces) do
            for _, recipe in pairs(force.recipes) do
                if string.sub(recipe.name, -4)=="-big" and inlist(recipe.category, {"big-assembly", "big-uranium", "big-chem", "big-smelting", "big-refinery"}) and force.recipes[string.sub(recipe.name,1,-5)] and force.recipes[string.sub(recipe.name,1,-5)].enabled and not force.recipes[string.sub(recipe.name,1,-5)].hidden then 
                    recipe.enabled=true
                end 
            end
        end
    end
	global.update_version = current_version
end

return Updates