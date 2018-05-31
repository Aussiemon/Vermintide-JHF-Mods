--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Modifies the base loot die chance to account for number of chests in a map.
--]]

local mod = get_mod("FairLootDice")

-- ##########################################################
-- ################## Variables #############################

mod.LENGTH_METHOD = 1
mod.FLATRATE_METHOD = 2

mod.LevelChestNumbers = {
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
	dlc_reikwald_forest = 12,
	dlc_reikwald_river = 4,
	chamber = 7
}

mod.LongLevels = {
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
	dlc_reikwald_forest = "Reikwald Forest",
	dlc_reikwald_river = "River Reik"
}

-- ##########################################################
-- ################## Functions #############################

-- Uses linear proportions to calculate loot-die chance
mod.calculate_chance = function (num_chests, target_num_chests, reduce_excess)
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
	
	--mod:echo(tostring(math.floor(return_chance*1000)/10).."% base loot die chance")
	return math.min(return_chance, .5)
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook("DiceKeeper.chest_loot_dice_chance", function (func, ...)
	
	-- Change odds according to settings
	if Managers and Managers.state and Managers.state.game_mode then
	
		-- Take level key and lookup chest information
		local state_manager = Managers.state
		local level_key = state_manager.game_mode:level_key()
		
		if mod.LevelChestNumbers[level_key] then
			local num_chests = mod.LevelChestNumbers[level_key]
			
			-- Normalize odds according to setting
			local calc_method = mod:get("method")
			if calc_method == mod.LENGTH_METHOD then
			
				-- Check mission length
				if mod.LongLevels[level_key] then
					local chance = mod.calculate_chance(num_chests, 17, false)
					return chance
				else
					local chance = mod.calculate_chance(num_chests, 14, false)
					return chance
				end
				
			-- Flat-rate normalization
			elseif calc_method == mod.FLATRATE_METHOD then
				local chance = mod.calculate_chance(num_chests, 17, true)
				return chance
			end
		end
	end
	
	-- Original function
	local result = func(...)
	return result
end)

-- ##########################################################
-- ################### Callback #############################

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(initial_call)
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(initial_call)
	mod:enable_all_hooks()
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
