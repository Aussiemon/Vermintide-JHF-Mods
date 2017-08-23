--[[
	author: Aussiemon
	
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Modifies the base loot die chance to account for number of chests in a map.
--]]

local mod_name = "FairLootDice"

-- ##########################################################
-- ################### Variables ############################

local LENGTH_METHOD = 1
local FLATRATE_METHOD = 2

FairLootDice = {
	SETTINGS = {
		ACTIVE = {
			["save"] = "cb_fair_loot_dice_enabled",
			["widget_type"] = "stepper",
			["text"] = "Fair Loot Dice - Enabled",
			["tooltip"] = "Fair Loot Dice\n" ..
				"Toggle fair loot dice percentage on / off.\n\n" ..
				"Modifies the base loot die chance to account for number of chests in a map.",
			["value_type"] = "boolean",
			["options"] = {
				{text = "Off", value = false},
				{text = "On", value = true}
			},
			["default"] = 1, -- Default second option is enabled. In this case Off
		},
		METHOD = {
			["save"] = "cb_fair_loot_dice_method",
			["widget_type"] = "dropdown",
			["text"] = "Dice Chance Method",
			["tooltip"] = "Dice Chance Method\n" ..
				"Allows choosing how odds are determined.\n\n" ..
				"-- LENGTH --\nTwo-grimoire maps normalized to at least 17 chests, otherwise 14.\n\n" ..
				"-- FLAT-RATE --\nAll maps normalized to exactly 17 chests.",
			["value_type"] = "number",
			["options"] = {
				{text = "Length", value = LENGTH_METHOD},
				{text = "Flat-Rate", value = FLATRATE_METHOD},
			},
			["default"] = 1, -- Default first option is enabled. In this case Length
		},
	},
	LevelChestNumbers = {
		magnus = 26,
		merchant = 23,
		sewers_short = 5,
		wizard = 21,
		bridge = 15,
		forest_ambush = 5,
		city_wall = 5,
		cemetery = 6,
		farm = 7,
		tunnels = 8,
		courtyard_level = 3,
		docks_short_level = 16,
		end_boss = 9,
		dlc_castle = 8,
		dlc_castle_dungeon = 17,
		dlc_portals = 7,
		dlc_dwarf_interior = 5,
		dlc_dwarf_exterior = 8,
		dlc_dwarf_beacons = 2,
		dlc_stromdorf_hills = 10,
		dlc_stromdorf_town = 17,
	},
	TargetProbabilitiesTwoDice = {
		0,
		0.0025,
		0.0073,
		0.014,
		0.0226,
		0.0328,
		0.0444,
		0.0572,
		0.0712,
		0.0861,
		0.1019,
		0.1184,
		0.1354,
		0.1530,
		0.1710,
		0.1892,
		0.2078,
		0.2265,
		0.2453,
		0.2642,
		0.2830,
		0.3018,
		0.3206,
		0.3392,
		0.3576,
		0.3759,
	},
	LongLevels = {
		magnus = "Horn of Magnus",
		merchant = "Supply and Demand",
		wizard = "Wizard's Tower",
		forest_ambush = "Engines of War",
		cemetery = "Garden of Morr",
		tunnels = "Enemy Below",
		dlc_castle = "Castle Drachenfels",
		dlc_castle_dungeon = "The Dungeons",
		dlc_dwarf_interior = "Khazid Kro",
		dlc_dwarf_exterior = "Cursed Rune",
	},
}

-- ##########################################################
-- ################## Functions #############################

-- Uses linear proportions to calculate loot-die chance
FairLootDice.calculate_chance = function (num_chests, target_num_chests, reduce_excess)
	local normal_chance = 0.05
	if not reduce_excess and num_chests >= target_num_chests then
		return normal_chance
	end
	
	local min_chance = normal_chance
	if reduce_excess then
		min_chance = 0.00
	end
	
	local chest_fraction = target_num_chests / num_chests
	local return_chance = math.max((chest_fraction * normal_chance), min_chance)
	
	--EchoConsole(tostring(math.floor(return_chance*1000)/10).."% base loot die chance")
	return math.min(return_chance, .5)
end

-- Recreates binomial probabilites to calculate most-accurate loot-die chance
FairLootDice.complex_calculate_chance = function (num_chests, target_num_chests)
	
	local normal_chance = 0.05
	if num_chests >= target_num_chests then
		return normal_chance
	end

	local return_chance = normal_chance
	local target_probability = FairLootDice.TargetProbabilitiesTwoDice[target_num_chests]
	local best_probability = 0
	for i = 50, 999 do
		local probability = FairLootDice.calculate_probability(num_chests, (i/1000))
		if probability < target_probability then
			best_probability = probability
		else
			-- If this attempt is closer than the previous attempt
			if 0 < (math.abs(best_probability - target_probability) - math.abs(probability - target_probability)) then
				return_chance = (i/1000)
			else
				return_chance = ((i-1)/1000)
			end
			return_chance = math.max(return_chance, normal_chance)
			return_chance = math.min(return_chance, 0.5)
			return return_chance
		end
	end
	
	return_chance = FairLootDice.calculate_chance(num_chests, target_num_chests, false) or normal_chance
	return return_chance
end

-- Finds binomial probability of at least two dice with given odds and number of chests
FairLootDice.calculate_probability = function (num_chests, odds)
	local total_probability = 0
	for i = 0, 1 do
		if i == 0 then
			total_probability = total_probability + (math.pow(odds, i) * (math.pow((1 - odds), (num_chests - i))))
		else
			total_probability = total_probability + ((FairLootDice.factorial(num_chests) / (FairLootDice.factorial(i) * FairLootDice.factorial(num_chests - i))) * math.pow(odds, i) * (math.pow((1 - odds), (num_chests - i))))
		end
	end
	if 1 < total_probability then
		total_probability = 1
	end
	return (1 - total_probability)
end

FairLootDice.factorial = function (input)
	if input == 0 then
		return 0
	end
	local output = input
	for i = 1, input - 1 do
		output = output * i
	end
	return output
end

FairLootDice.create_options = function()
	Mods.option_menu:add_group("FairLootDice", "Fair Loot Dice")
	Mods.option_menu:add_item("FairLootDice", FairLootDice.SETTINGS.ACTIVE, true)
	Mods.option_menu:add_item("FairLootDice", FairLootDice.SETTINGS.METHOD, true)
end

local get = function(data)
	if data then
		return Application.user_setting(data.save)
	end
end
local set = Application.set_user_setting
local save = Application.save_user_settings

-- ##########################################################
-- #################### Hooks ###############################

Mods.hook.set(mod_name, "DiceKeeper.chest_loot_dice_chance", function (func, ...)
	
	-- Change odds according to settings
	if get(FairLootDice.SETTINGS.ACTIVE) then
		if Managers and Managers.state and Managers.state.game_mode then
		
			-- Take level key and lookup chest information
			local level_key = Managers.state.game_mode:level_key()
			if FairLootDice.LevelChestNumbers[level_key] then
				local num_chests = FairLootDice.LevelChestNumbers[level_key]
				
				-- Normalize odds according to setting
				local calc_method = get(FairLootDice.SETTINGS.METHOD) or 1
				if calc_method == LENGTH_METHOD then
				
					-- Check mission length
					if FairLootDice.LongLevels[level_key] then
						local chance = FairLootDice.calculate_chance(num_chests, 17, false)
						return chance
					else
						local chance = FairLootDice.calculate_chance(num_chests, 14, false)
						return chance
					end
					
				-- Flat-rate normalization
				elseif calc_method == FLATRATE_METHOD then
					local chance = FairLootDice.calculate_chance(num_chests, 17, true)
					return chance
				end
			end
		end
	end
	
	-- Original function
	local result = func(...)
	return result
end)

-- ##########################################################
-- ################### Script ###############################

FairLootDice.create_options()

-- ##########################################################
