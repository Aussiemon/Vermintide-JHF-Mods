--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local GameActsOrder = GameActsOrder
local last_game_act = #GameActsOrder - 1

local mod_data = {
	name = "Inn Decoration Control",               -- Readable mod name
	description = "Allows client-side control over decorations displayed in the Red Moon Inn.",  -- Mod description
	is_togglable = true,            -- If the mod can be enabled/disabled
	is_mutator = false,             -- If the mod is mutator
	mutator_settings = {}          -- Extra settings, if it's mutator
}

mod_data.options_widgets = {
	{
		["setting_name"] = "main_game",
		["widget_type"] = "numeric",
		["text"] = "Main Game Decorations",
		["tooltip"] =  "Maximum general state of the Red Moon Inn by main game act:\n\n" ..
			"PROLOGUE = 0\n\n" ..
			"ACT 1: CONSOLIDATION = 1\n\n" ..
			"ACT 2: RETALIATION = 2\n\n" ..
			"ACT 3: ANNIHILATION = 3\n\n" ..
			"ACT 4: EPILOGUE = 4 [Default]",
		["range"] = {0, last_game_act},
		["default_value"] = last_game_act,
	},
	{
		["setting_name"] = "difficulty_banner",
		["widget_type"] = "numeric",
		["text"] = "Banner Decorations",
		["tooltip"] =  "Maximum state of the main game banner decorations by difficulty:\n\n" ..
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
		["tooltip"] =  "Maximum state of the Castle Drachenfels DLC decorations by difficulty:\n\n" ..
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
		["tooltip"] =  "Maximum state of the Karak Azgaraz DLC decorations by difficulty:\n\n" ..
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
		["tooltip"] =  "Maximum state of the Stromdorf DLC decorations by difficulty:\n\n" ..
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
		["tooltip"] =  "Maximum state of the Reik DLC decorations by difficulty:\n\n" ..
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
		["tooltip"] =  "Maximum state of the Waylaid DLC decorations by difficulty:\n\n" ..
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
		["tooltip"] =  "Maximum state of the Town Meeting (Last Stand) decorations:\n\n" ..
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
		["tooltip"] =  "Maximum state of the The Fall DLC (Last Stand) decorations:\n\n" ..
			"UNCOMPLETED = 0\n\n" ..
			"BRONZE = 1\n\n" ..
			"SILVER = 2\n\n" ..
			"GOLD = 3 [Default]",
		["range"] = {0, 3},
		["default_value"] = 3,
	},
}

return mod_data
