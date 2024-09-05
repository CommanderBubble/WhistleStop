-- Big Furnace prototype and item definition
local create_bigfurnace = require("__WhistleStopFactories__.prototypes.bigfurnace")
-- name, energy_consumption, crafting_speed
create_bigfurnace("wsf-big-furnace", "40000kW", 100)

-- Big Assembly prototype and item definition
local create_bigassembly = require("__WhistleStopFactories__.prototypes.bigassembly")
-- name, energy_consumption, crafting_speed
create_bigassembly("wsf-big-assembly", "30000kW", 40)

-- Big Refinery prototype and item definition
local create_bigrefinery = require("__WhistleStopFactories__.prototypes.bigrefinery")
-- name, energy_consumption, crafting_speed
create_bigrefinery("wsf-big-refinery", "36000kW", 18)

-- Big Chemical Plant prototype and item definition
local create_bigchemplant = require("__WhistleStopFactories__.prototypes.bigchemplant")
create_bigchemplant("wsf-big-chemplant", "36000kW", 18)

 -- Big Centrifuge prototype and item definition
local create_bigcentrifuge = require("__WhistleStopFactories__.prototypes.bigcentrifuge")
create_bigcentrifuge("wsf-big-centrifuge", "36000kW", 18)