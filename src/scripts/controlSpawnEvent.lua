inspect = require("inspect")

require("luaMacros")

-- Placing/Destroying events and loader placement

local offset1 = {[0]=1, [2]=0, [4]=-1, [6]=0}
local offset2 = {[0]=0, [2]=1, [4]=0, [6]=-1}

local function placeLoader(entity, xoffset, yoffset, type, direction)
	local ce = entity.surface.create_entity 
	local fN = entity.force

	local xposition = entity.position.x + offset1[entity.direction] * xoffset - offset2[entity.direction] * yoffset
	local yposition = entity.position.y + offset1[entity.direction] * yoffset + offset2[entity.direction] * xoffset
	direction_final = (direction + entity.direction)%8

	local loader = ce{name="express-loader-big", position={xposition, yposition}, force=fN, type=type, direction=direction_final}
end

script.on_event(defines.events.on_player_rotated_entity,
	function (event)
		if event.entity.name == "big-furnace" or event.entity.name == "big-assembly" then
			local position = event.entity.position
			local area = {{position.x-8.8, position.y-8.8}, {position.x+8.8, position.y+8.8}}
			for _, entity in pairs(event.entity.surface.find_entities_filtered{area=area, name="express-loader-big"}) do
				entity.destroy()
			end
			on_built_event({created_entity=event.entity})
		end
	end
)

function on_built_event(event)
	local entity = event.created_entity

	if entity.name == "big-furnace" then
		for i=2,5 do
			-- Left side loaders
			placeLoader(entity, -7.5, i, "input", 2)
			placeLoader(entity, -7.5, -i, "input", 2)
			-- Right side loaders
			placeLoader(entity, 7.5, i, "output", 2)
			placeLoader(entity, 7.5, -i, "output", 2)
		end
	elseif entity.name == "big-assembly" then
		-- Left side loaders
		for i=-6,6 do
			if i ~= -1 then
				placeLoader(entity, -7.5, i, "input", 2)
			end
		end
		
		-- Right side loaders
		for i=2,5 do
			placeLoader(entity, 7.5, i, "output", 2)
			placeLoader(entity, 7.5, -i, "output", 2)
		end

		for i=-6,-2 do
			-- Bottom loaders
			placeLoader(entity, i, 7.5, "input", 0)
			-- Top loaders
			placeLoader(entity, i, -7.5, "input", 4)
		end
	end
end

script.on_event(defines.events.on_built_entity, on_built_event)
script.on_event(defines.events.on_robot_built_entity, on_built_event)
script.on_event(defines.events.script_raised_built, on_built_event)

-- Removed the loaders
function clean_up(surface, center)
	debugWrite("Cleaning up big factory loaders and beacons at " .. center.x .. "," .. center.y)
	local area = {{center.x-8.8, center.y-8.8}, {center.x+8.8, center.y+8.8}}
	for _, entity in pairs(surface.find_entities_filtered{area=area, name={"express-loader-big", "big-beacon-1", "big-beacon-2"}}) do
		entity.destroy()
	end
end

-- Destroying leftover loaders and beacons
local function on_destroy_event(event)
	if inlist(event.entity.name, {"big-furnace", "big-assembly", "big-refinery", "big-chemplant"}) then
		clean_up(event.entity.surface, event.entity.position)
	end	
end

script.on_event(defines.events.on_player_mined_entity, on_destroy_event)
script.on_event(defines.events.on_robot_mined_entity, on_destroy_event)
script.on_event(defines.events.on_entity_died, on_destroy_event)
script.on_event(defines.events.script_raised_destroy, on_destroy_event)