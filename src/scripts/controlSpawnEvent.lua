-- Placing/Destroying events and loader placement

local function placeLoader(entity, position, type, direction)
	local ce = entity.surface.create_entity 
	local fN = entity.force

	local loader = ce{name="express-loader", position=position, force=fN, type=type, direction=direction}
	loader.destructible = false
	loader.minable = {hardness = 0, minable = false, mining_time = 0}
	table.insert(global.whistlestops[entity].loaders, loader)
end

function on_built_event(event)
	local entity = event.created_entity
	local center = entity.position

	if entity.name == "big-furnace" then
		for i=2,5 do
			-- Left side loaders
			placeLoader(entity, {center.x - 7.5, center.y + i}, "input", 2)
			placeLoader(entity, {center.x - 7.5, center.y - i}, "input", 2)
			-- Right side loaders
			placeLoader(entity, {center.x + 7, center.y + i}, "output", 2)
			placeLoader(entity, {center.x + 7, center.y - i}, "output", 2)
		end
	elseif entity.name == "big-assembly" then
		-- Left side loaders
		for i=-6,6 do
			if i ~= -1 then
				placeLoader(entity, {center.x - 7.5, center.y + i}, "input", 2)
			end
		end
		
		-- Right side loaders
		for i=2,5 do
			placeLoader(entity, {center.x + 7, center.y + i}, "output", 2)
			placeLoader(entity, {center.x + 7, center.y - i}, "output", 2)
		end

		for i=-6,-2 do
			-- Bottom loaders
			placeLoader(entity, {center.x + i, center.y + 7.5}, "input", 1)
			-- Top loaders
			placeLoader(entity, {center.x + i, center.y -8}, "input", 4)
		end
	end
end

script.on_event(defines.events.on_built_entity, on_built_event)
script.on_event(defines.events.on_robot_built_entity, on_built_event)
script.on_event(defines.events.script_raised_built, on_built_event)

-- Removed the loaders
function clean_up(surface, center)
	debugWrite("Cleaning up big factory loaders at " .. center.x .. "," .. center.y)
	local area = {{center.x-8.8, center.y-8.8}, {center.x+8.8, center.y+8.8}}
	for _, entity in pairs(surface.find_entities_filtered{area=area, name="express-loader"}) do
		if not entity.destructible and not entity.minable then
			entity.destroy()
		end
	end
end

-- Destroying a big assembly machine
local function on_destroy_event(event)
	if event.entity.name == "big-furnace" or event.entity.name == "big-assembly" then
		clean_up(event.entity.surface, event.entity.position)
	end	
end

script.on_event(defines.events.on_player_mined_entity, on_destroy_event)
script.on_event(defines.events.on_robot_mined_entity, on_destroy_event)
script.on_event(defines.events.on_entity_died, on_destroy_event)
script.on_event(defines.events.script_raised_destroy, on_destroy_event)