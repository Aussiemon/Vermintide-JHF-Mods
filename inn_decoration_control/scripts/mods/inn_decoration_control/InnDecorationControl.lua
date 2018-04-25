--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Allows client-side control over decorations displayed in the Red Moon Inn.
--]]

local mod = get_mod("InnDecorationControl")

-- ##########################################################
-- ################## Variables #############################

local GameActsOrder = GameActsOrder
mod.last_game_act = #GameActsOrder - 1

local mod_data = {}
mod_data.name = "Inn Decoration Control" -- Readable mod name
mod_data.description = "Allows client-side control over decorations displayed in the Red Moon Inn." -- Readable mod description
mod_data.is_togglable = true -- If the mod can be enabled/disabled
mod_data.is_mutator = false -- If the mod is mutator
mod_data.options_widgets = {
	{
		["setting_name"] = "main_game",
		["widget_type"] = "numeric",
		["text"] = "Main Game Decorations",
		["tooltip"] =  "Main Game Decorations\n" ..
			"Maximum general state of the Red Moon Inn by main game act:\n\n" ..
			"PROLOGUE = 0\n\n" ..
			"ACT 1: CONSOLIDATION = 1\n\n" ..
			"ACT 2: RETALIATION = 2\n\n" ..
			"ACT 3: ANNIHILATION = 3\n\n" ..
			"ACT 4: EPILOGUE = 4 [Default]",
		["range"] = {0, mod.last_game_act},
		["default_value"] = mod.last_game_act,
	},
	{
		["setting_name"] = "difficulty_banner",
		["widget_type"] = "numeric",
		["text"] = "Banner Decorations",
		["tooltip"] =  "Banner Decorations\n" ..
			"Maximum state of the main game banner decorations by difficulty:\n\n" ..
			"UNCOMPLETED = 0\n\n" ..
			"EASY = 1\n\n" ..
			"NORMAL = 2\n\n" ..
			"HARD = 3\n\n" ..
			"NIGHTMARE = 4\n\n" ..
			"CATACLYSM = 5 [Default]",
		["range"] = {0, 5},
		["default_value"] = 5,
	},
	{
		["setting_name"] = "drachenfels",
		["widget_type"] = "numeric",
		["text"] = "Castle Drachenfels Decorations",
		["tooltip"] =  "Castle Drachenfels DLC Decorations\n" ..
			"Maximum state of the Castle Drachenfels DLC decorations by difficulty:\n\n" ..
			"UNCOMPLETED = 0\n\n" ..
			"EASY = 1\n\n" ..
			"NORMAL = 2\n\n" ..
			"HARD = 3\n\n" ..
			"NIGHTMARE = 4\n\n" ..
			"CATACLYSM = 5 [Default]",
		["range"] = {0, 5},
		["default_value"] = 5,
	},
	{
		["setting_name"] = "dwarfs",
		["widget_type"] = "numeric",
		["text"] = "Karak Azgaraz Decorations",
		["tooltip"] =  "Karak Azgaraz DLC Decorations\n" ..
			"Maximum state of the Karak Azgaraz DLC decorations by difficulty:\n\n" ..
			"UNCOMPLETED = 0\n\n" ..
			"EASY = 1\n\n" ..
			"NORMAL = 2\n\n" ..
			"HARD = 3\n\n" ..
			"NIGHTMARE = 4\n\n" ..
			"CATACLYSM = 5 [Default]",
		["range"] = {0, 5},
		["default_value"] = 5,
	},
	{
		["setting_name"] = "stromdorf",
		["widget_type"] = "numeric",
		["text"] = "Stromdorf Decorations",
		["tooltip"] =  "Stromdorf DLC Decorations\n" ..
			"Maximum state of the Stromdorf DLC decorations by difficulty:\n\n" ..
			"UNCOMPLETED = 0\n\n" ..
			"EASY = 1\n\n" ..
			"NORMAL = 2\n\n" ..
			"HARD = 3\n\n" ..
			"NIGHTMARE = 4\n\n" ..
			"CATACLYSM = 5 [Default]",
		["range"] = {0, 5},
		["default_value"] = 5,
	},
	{
		["setting_name"] = "reikwald",
		["widget_type"] = "numeric",
		["text"] = "Reik Decorations",
		["tooltip"] =  "Reik DLC Decorations\n" ..
			"Maximum state of the Reik DLC decorations by difficulty:\n\n" ..
			"UNCOMPLETED = 0\n\n" ..
			"EASY = 1\n\n" ..
			"NORMAL = 2\n\n" ..
			"HARD = 3\n\n" ..
			"NIGHTMARE = 4\n\n" ..
			"CATACLYSM = 5 [Default]",
		["range"] = {0, 5},
		["default_value"] = 5,
	},
	{
		["setting_name"] = "chamber",
		["widget_type"] = "numeric",
		["text"] = "Waylaid Decorations",
		["tooltip"] =  "Waylaid DLC Decorations\n" ..
			"Maximum state of the Waylaid DLC decorations by difficulty:\n\n" ..
			"UNCOMPLETED = 0\n\n" ..
			"EASY = 1\n\n" ..
			"NORMAL = 2\n\n" ..
			"HARD = 3\n\n" ..
			"NIGHTMARE = 4\n\n" ..
			"CATACLYSM = 5 [Default]",
		["range"] = {0, 5},
		["default_value"] = 5,
	},
	{
		["setting_name"] = "town_meeting",
		["widget_type"] = "numeric",
		["text"] = "Town Meeting Decorations",
		["tooltip"] =  "Town Meeting (Last Stand) Decorations\n" ..
			"Maximum state of the Town Meeting (Last Stand) decorations:\n\n" ..
			"UNCOMPLETED = 0\n\n" ..
			"BRONZE = 1\n\n" ..
			"SILVER = 2\n\n" ..
			"GOLD = 3 [Default]",
		["range"] = {0, 3},
		["default_value"] = 3,
	},
	{
		["setting_name"] = "fall",
		["widget_type"] = "numeric",
		["text"] = "The Fall Decorations",
		["tooltip"] =  "The Fall (Last Stand) Decorations\n" ..
			"Maximum state of the The Fall DLC (Last Stand) decorations:\n\n" ..
			"UNCOMPLETED = 0\n\n" ..
			"BRONZE = 1\n\n" ..
			"SILVER = 2\n\n" ..
			"GOLD = 3 [Default]",
		["range"] = {0, 3},
		["default_value"] = 3,
	},
}

-- ##########################################################
-- ################## Functions #############################

mod.check_for_inn_level = function()
	local state_manager = Managers.state
	local level_key = state_manager.game_mode and state_manager.game_mode:level_key()
	if level_key and level_key == "inn_level" then
		return true
	end
	return false
end

-- ##########################################################
-- #################### Hooks ###############################

-- Control over general state of Red Moon Inn by main game act
mod:hook("flow_callback_get_current_inn_level_progression", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		return_table.progression_step = math.min(return_table.progression_step, (mod:get("main_game") or 99))
	end
	
	return return_table
end)

-- Control over banner decorations by difficulty
mod:hook("flow_callback_get_completed_game_difficulty", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (mod:get("difficulty_banner") or 99))
	end
	
	return return_table
end)

-- Control over Drachenfels decorations by difficulty
mod:hook("flow_callback_get_completed_drachenfels_difficulty", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (mod:get("drachenfels") or 99))
	end
	
	return return_table
end)

-- Control over Karak Azgaraz decorations by difficulty
mod:hook("flow_callback_get_completed_dwarf_levels_difficulty", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (mod:get("dwarfs") or 99))
	end
	
	return return_table
end)

-- Control over Stromdorf, Reik decorations by difficulty
mod:hook("flow_callback_get_completed_dlc_levels_difficulty", function (func, params, ...)
	
	local return_table = func(params, ...)
	if params and params.dlc and mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (mod:get(params.dlc) or 99))
	end
	
	return return_table
end)

-- Control over Last Stand decorations by waves surpassed
mod:hook("flow_callback_get_completed_survival_waves", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		local town_meeting_setting = (mod:get("town_meeting") or 99) * 13
		if return_table.dlc_survival_magnus and town_meeting_setting < 39 then
			return_table.dlc_survival_magnus = math.min(return_table.dlc_survival_magnus, town_meeting_setting)
		end
		
		local fall_setting = (mod:get("fall") or 99) * 13
		if return_table.dlc_survival_ruins and fall_setting < 39 then
			return_table.dlc_survival_ruins = math.min(return_table.dlc_survival_ruins, fall_setting)
		end
	end
	
	return return_table
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

mod:initialize_data(mod_data)

-- ##########################################################
