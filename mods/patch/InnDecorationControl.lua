--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Allows control over decorations displayed in the Red Moon Inn.
--]]

local mod_name = "InnDecorationControl"

-- ##########################################################
-- ################## Variables #############################

local last_game_act = #GameActsOrder - 1

InnDecorationControl = {
	SETTINGS = {
		ACTIVE = {
			["save"] = "cb_inn_decoration_control_enabled",
			["widget_type"] = "stepper",
			["text"] = "Inn Decoration Control - Enabled",
			["tooltip"] = "Inn Decoration Control - Enabled\n" ..
				"Toggle control over Red Moon Inn decorations on / off.\n\n" ..
				"Will not show decorations that have not yet been unlocked.",
			["value_type"] = "boolean",
			["options"] = {
				{text = "Off", value = false},
				{text = "On", value = true}
			},
			["default"] = 1, -- Default second option is enabled. In this case Off
		},
		MAIN = {
			["save"] = "cb_inn_decor_control_main",
			["widget_type"] = "slider",
			["text"] = "Main Game Decorations",
			["tooltip"] =  "Main Game Decorations\n" ..
				"Maximum general state of the Red Moon Inn by main game act:\n\n" ..
				"PROLOGUE = 0\n\n" ..
				"ACT 1: CONSOLIDATION = 1\n\n" ..
				"ACT 2: RETALIATION = 2\n\n" ..
				"ACT 3: ANNIHILATION = 3\n\n" ..
				"ACT 4: REORGANIZATION = 4 [Default]",
			["range"] = {0, last_game_act},
			["default"] = last_game_act,
		},
		BANNER = {
			["save"] = "cb_inn_decor_control_banner",
			["widget_type"] = "slider",
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
			["default"] = 5,
		},
		DRACHENFELS = {
			["save"] = "cb_inn_decor_control_drachenfels",
			["widget_type"] = "slider",
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
			["default"] = 5,
		},
		DWARF = {
			["save"] = "cb_inn_decor_control_dwarf",
			["widget_type"] = "slider",
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
			["default"] = 5,
		},
		STROMDORF = {
			["save"] = "cb_inn_decor_control_stromdorf",
			["widget_type"] = "slider",
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
			["default"] = 5,
		},
		REIK = {
			["save"] = "cb_inn_decor_control_reik",
			["widget_type"] = "slider",
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
			["default"] = 5,
		},
		TOWN_MEETING = {
			["save"] = "cb_inn_decor_control_town_meeting",
			["widget_type"] = "slider",
			["text"] = "Town Meeting Decorations",
			["tooltip"] =  "Town Meeting (Last Stand) Decorations\n" ..
				"Maximum state of the Town Meeting (Last Stand) decorations:\n\n" ..
				"UNCOMPLETED = 0\n\n" ..
				"BRONZE = 1\n\n" ..
				"SILVER = 2\n\n" ..
				"GOLD = 3 [Default]",
			["range"] = {0, 3},
			["default"] = 3,
		},
		FALL = {
			["save"] = "cb_inn_decor_control_fall",
			["widget_type"] = "slider",
			["text"] = "The Fall Decorations",
			["tooltip"] =  "The Fall (Last Stand) Decorations\n" ..
				"Maximum state of the The Fall DLC (Last Stand) decorations:\n\n" ..
				"UNCOMPLETED = 0\n\n" ..
				"BRONZE = 1\n\n" ..
				"SILVER = 2\n\n" ..
				"GOLD = 3 [Default]",
			["range"] = {0, 3},
			["default"] = 3,
		},
	},
}

local mod = InnDecorationControl

mod.dlc_lookup_table = {
	drachenfels = mod.SETTINGS.DRACHENFELS,
	dwarfs = mod.SETTINGS.DWARF,
	stromdorf = mod.SETTINGS.STROMDORF,
	reikwald =  mod.SETTINGS.REIK,
	challenge_wizard = false
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

mod.create_options = function()
	Mods.option_menu:add_group("InnDecorationControl", "Inn Decoration Control")
	Mods.option_menu:add_item("InnDecorationControl", mod.SETTINGS.ACTIVE, true)
	Mods.option_menu:add_item("InnDecorationControl", mod.SETTINGS.MAIN, true)
	Mods.option_menu:add_item("InnDecorationControl", mod.SETTINGS.BANNER, true)
	Mods.option_menu:add_item("InnDecorationControl", mod.SETTINGS.DRACHENFELS, true)
	Mods.option_menu:add_item("InnDecorationControl", mod.SETTINGS.DWARF, true)
	Mods.option_menu:add_item("InnDecorationControl", mod.SETTINGS.STROMDORF, true)
	Mods.option_menu:add_item("InnDecorationControl", mod.SETTINGS.REIK, true)
	Mods.option_menu:add_item("InnDecorationControl", mod.SETTINGS.TOWN_MEETING, true)
	Mods.option_menu:add_item("InnDecorationControl", mod.SETTINGS.FALL, true)
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

-- Control over general state of Red Moon Inn by main game act
Mods.hook.set(mod_name, "flow_callback_get_current_inn_level_progression", function (func, ...)
	
	local return_table = func(...)
	if get(mod.SETTINGS.ACTIVE) and mod.check_for_inn_level() then
		return_table.progression_step = math.min(return_table.progression_step, (get(mod.SETTINGS.MAIN) or 99))
	end
	
	return return_table
end)

-- Control over banner decorations by difficulty
Mods.hook.set(mod_name, "flow_callback_get_completed_game_difficulty", function (func, ...)
	
	local return_table = func(...)
	if get(mod.SETTINGS.ACTIVE) and mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (get(mod.SETTINGS.BANNER) or 99))
	end
	
	return return_table
end)

-- Control over Drachenfels decorations by difficulty
Mods.hook.set(mod_name, "flow_callback_get_completed_drachenfels_difficulty", function (func, ...)
	
	local return_table = func(...)
	if get(mod.SETTINGS.ACTIVE) and mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (get(mod.SETTINGS.DRACHENFELS) or 99))
	end
	
	return return_table
end)

-- Control over Karak Azgaraz decorations by difficulty
Mods.hook.set(mod_name, "flow_callback_get_completed_dwarf_levels_difficulty", function (func, ...)
	
	local return_table = func(...)
	if get(mod.SETTINGS.ACTIVE) and mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (get(mod.SETTINGS.DWARF) or 99))
	end
	
	return return_table
end)

-- Control over Stromdorf, Reik decorations by difficulty
Mods.hook.set(mod_name, "flow_callback_get_completed_dlc_levels_difficulty", function (func, params, ...)
	
	local return_table = func(params, ...)
	if get(mod.SETTINGS.ACTIVE) and params and params.dlc and mod.dlc_lookup_table[params.dlc] and mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (get(mod.dlc_lookup_table[params.dlc]) or 99))
	end
	
	return return_table
end)

-- Control over Last Stand decorations by waves surpassed
Mods.hook.set(mod_name, "flow_callback_get_completed_survival_waves", function (func, ...)
	
	local return_table = func(...)
	if get(mod.SETTINGS.ACTIVE) and mod.check_for_inn_level() then
		local town_meeting_setting = (get(mod.SETTINGS.TOWN_MEETING) or 99) * 13
		if return_table.dlc_survival_magnus and town_meeting_setting < 39 then
			return_table.dlc_survival_magnus = math.min(return_table.dlc_survival_magnus, town_meeting_setting)
		end
		
		local fall_setting = (get(mod.SETTINGS.FALL) or 99) * 13
		if return_table.dlc_survival_ruins and fall_setting < 39 then
			return_table.dlc_survival_ruins = math.min(return_table.dlc_survival_ruins, fall_setting)
		end
	end
	
	return return_table
end)

-- ##########################################################
-- ################### Script ###############################

mod.create_options()

-- ##########################################################
