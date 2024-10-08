-- Creates 50x versions of each recipe from selected categories
require("__WhistleStopFactories__.scripts.luaMacros")
require("util")

-- List of factors to try in case of ingredient limitations or stacksize limitations, in order of what is tried
local factor_list = {50, 40, 30, 20, 10, 5, 2, 1}

-- Game crashes if ingredient amount is higher than this
local maxIngredientCount = 65535

-- Output size maximum for fluid, 100 x (base_area=10)
local maxFluidBox = 1000

-- Lookup table for finding subgroup and stack_size which can be in various locations in data.raw
local dataRawLookup = {}
for _, class in pairs(data.raw) do
    for className, classData in pairs(class) do
        dataRawLookup[className] = dataRawLookup[className] or {}
        if classData.subgroup then
            dataRawLookup[className].subgroup = classData.subgroup
        end
        if classData.stack_size then
            dataRawLookup[className].stack_size = classData.stack_size
        end
    end
end

-- Provides the lowest value from factor_list that works
local function findfactor(min_value)
    for _, factor in pairs(factor_list) do
        if factor <= min_value then
            return factor
        end
    end
    -- Edge case for some recipes that ALREADY exceed max stack size, such as creative mode mod
    return 1
end

local function getStackSize(item)
    if dataRawLookup[item].stack_size then
        return math.min(maxIngredientCount, dataRawLookup[item].stack_size)
    end
    log("No stacksize found for " .. item)
    return 100
end

-- Figures out max ingredient amount to ensure nothing goes over the max allowable of 65535
local function maxRecipeAmount(ingredients)
    local maxAmount = 0
    for _, ingredient in pairs(ingredients) do
        local amount = ingredient.amount or ingredient.amount_max or ingredient[2]

        if amount then
            maxAmount = math.max(maxAmount, amount)
        else
            log("Recipe with no amount registered " .. serpent.line(ingredient))
        end
    end
    return maxAmount
end

-- Figures out max result amount to ensure the machine doesn't try to output more than the stacksize
local function maxRecipeOutputFactor(recipeOutputs)
    local minAmount = factor_list[1]
    for _, recipeOutput in pairs(recipeOutputs) do
        if recipeOutput.amount then
            if recipeOutput.type == "fluid" then
                minAmount = math.min(maxFluidBox / recipeOutput.amount, minAmount)
            else
                minAmount = math.min(getStackSize(recipeOutput.name) / recipeOutput.amount, minAmount)
            end
        else
            if recipeOutput[2] then
                minAmount = math.min(getStackSize(recipeOutput[1]) / recipeOutput[2], minAmount)
            end
        end
    end
    return minAmount
end

-- Multiplies the ingredient counts by a set factor
local function setFactorIngredients(ary, factor)
    for k,v in pairs(ary) do
        if v.amount then
            v.amount = v.amount * factor
        elseif v.amount_max then
            v.amount_max = v.amount_max * factor
            if v.amount_min then
                v.amount_min = v.amount_min * factor
            end
        elseif v[2] then
            v[2] = v[2] * factor
        else
            log("Recipe with no amount registered " .. serpent.line(v))
        end
        if v.catalyst_amount then
            v.catalyst_amount = v.catalyst_amount * factor
        end
    end
    return ary
end

-- Checks all locations for potential main product results
local function checkForProduct(recipe)
    if type(recipe) ~= "table" then
        return
    elseif recipe.result then
        return recipe.result
    elseif type(recipe.results) == "table" and #recipe.results == 1 and type(recipe.results[1]) == "table" and recipe.results[1].name then
        return recipe.results[1].name
    elseif type(recipe.results) == "table" and #recipe.results == 1 and type(recipe.results[1]) == "table" and recipe.results[1][1] then
        return recipe.results[1][1]
    end
end

-- Find the subgroup for a given item
local function findSubgroup(recipe)
    if type(recipe) ~= "table" then return end
    if recipe.subgroup then
        return recipe.subgroup
    end

    -- Search all possible locations where the "main product" where recipes inherit their subgroup can be found
    local product = checkForProduct(recipe)
    product = product or checkForProduct(recipe.normal)
    product = product or checkForProduct(recipe.expensive)
    product = product or recipe.main_product

    if product == nil then
        log("No main product found " .. recipe.name .. serpent.dump(recipe))
        return
    end

    if dataRawLookup[product] and dataRawLookup[product].subgroup then
        return dataRawLookup[product].subgroup
    end
    log("No subgroup found for " .. product)
end

-- Adjusts counts on all variables by factor.  Does nothing if factor would go over max ingredient amount.
local function setValues(recipe)
    if type(recipe) ~= "table" then return end
    -- Highest factor that would excede the maximum ingredient limit
    local min_factor1 = maxIngredientCount / maxRecipeAmount(recipe.ingredients)

    -- Highest factor that would excede the item stacksize for the output
    local min_factor2
    if recipe.result then
        min_factor2 = getStackSize(recipe.result) / (recipe.result_count or 1)
    else
        min_factor2 = maxRecipeOutputFactor(recipe.results)
    end

    -- Final factor used to scale all values of the recipe
    local factor = findfactor(math.min(min_factor1, min_factor2))

    -- Recipe ingredient adjustment
    recipe.ingredients = setFactorIngredients(recipe.ingredients, factor)

    -- Recipe time adjustment, defaulting to .5 if nil
    recipe.energy_required = (recipe.energy_required or 0.5) * factor

    -- Recipe output adjustment, defaulting to 1 if nil
    if recipe.result then
        recipe.result_count = (recipe.result_count or 1) * factor
    end
    if recipe.results then
        recipe.results = setFactorIngredients(recipe.results, factor)
    end

    recipe.hide_from_player_crafting = true
end

local function recipeSetup()
    -- Cycles through recipes adding big version to recipe list

    local cat_list1 = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"]["crafting_categories"])
    local cat_list2 = util.table.deepcopy(data.raw["assembling-machine"]["centrifuge"]["crafting_categories"])
    local cat_list3 = util.table.deepcopy(data.raw["assembling-machine"]["chemical-plant"]["crafting_categories"])
    table.insert(cat_list3, "electrolysis") -- Support for Bobs electrolysis
    local cat_list4 = {}
    if type(data.raw.furnace["electric-furnace"]) == "table" then
        for k,v in pairs(data.raw.furnace["electric-furnace"]["crafting_categories"]) do
            table.insert(cat_list4, v)
        end
    else
        table.insert(cat_list4, "smelting")
    end
    table.insert(cat_list4, "chemical-furnace")  -- Support for Bobs chemical furnaces
    table.insert(cat_list4, "mixing-furnace") -- Support for Bobs mixing furnaces
    local cat_list5 = util.table.deepcopy(data.raw["assembling-machine"]["oil-refinery"]["crafting_categories"])

    for _, recipeBase in pairs(util.table.deepcopy(data.raw.recipe)) do
        if type(recipeBase) == "table" then
            
            local cat = recipeBase.category or "crafting" -- Blank recipes categories are considered "crafting"
            if inlist(cat, cat_list1) or inlist(cat, cat_list2) or inlist(cat, cat_list3) or inlist(cat, cat_list4) or inlist(cat, cat_list5) then
                recipe = util.table.deepcopy(recipeBase)
                
                -- Recipe is split into normal/expensive, one allowed to be blank
                if recipe.normal or recipe.expensive then
                    if recipe.normal then
                        recipe.normal = util.table.deepcopy(recipe.normal)
                        setValues(recipe.normal)
                        if not recipe.normal.main_product and type(recipe.normal.results) == "table" and #recipe.normal.results > 1 then
                            recipe.localised_name = recipe.localised_name or {"recipe-name." .. recipe.name}
                        end
                    end
                    if recipe.expensive then
                        recipe.expensive = util.table.deepcopy(recipe.expensive)
                        setValues(recipe.expensive)
                        if not recipe.expensive.main_product and type(recipe.expensive.results) == "table" and #recipe.expensive.results > 1 then
                            recipe.localised_name = recipe.localised_name or {"recipe-name." .. recipe.name}
                        end
                    end
                elseif (recipe.result or recipe.results) and recipe.ingredients then
                    setValues(recipe)
                    if not recipe.main_product and type(recipe.results) == "table" and #recipe.results > 1 then
                        recipe.localised_name = recipe.localised_name or {"recipe-name." .. recipe.name}
                    end
                end
                
                local subgroup = findSubgroup(recipe)
                if subgroup then
                    recipe.subgroup = subgroup .. "-big"
                end
                recipe.name = recipe.name .. "-big"
                
                -- Big assembly recipes
                if inlist(cat, cat_list1) then
                    recipe.category = "big-assembly"

                -- Big centrifuge recipes
                elseif inlist(cat, cat_list2) then
                    recipe.category = "big-uranium"
                    
                -- Chemical furnace recipes
                elseif inlist(cat, cat_list3) then
                    recipe.category = "big-chem"

                -- Big furnace recipes
                elseif inlist(cat, cat_list4) then
                    recipe.category = "big-smelting"

                -- Oil refinery recipes
                elseif inlist(cat, cat_list5) then
                    recipe.category = "big-refinery"
                end

                data.raw.recipe[recipe.name] = recipe
            end
        end
    end
end

recipeSetup()
