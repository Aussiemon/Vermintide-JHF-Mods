--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local LevelSettings = LevelSettings

local pairs = pairs
local table = table

local multiple_loading_screen_list = {
	inn_level = 5,
	magnus = 2,
	merchant = 2,
	sewers_short = 2,
	wizard = 2,
	bridge = 2,
	forest_ambush = 2,
	city_wall = 2,
	cemetery = 2,
	farm = 2,
	tunnels = 2,
	courtyard_level = 2,
	docks_short_level = 2,
	end_boss = 2,
	dlc_castle = 2
}

local mod_data = {
	name = "Old School Loading Screens",               -- Readable mod name
	description = "Adds early Vermintide 'old school' loading screen variants, adds unused mission briefs.",  -- Mod description
	is_togglable = true,            -- If the mod can be enabled/disabled
	is_mutator = false,             -- If the mod is mutator
	mutator_settings = {}          -- Extra settings, if it's mutator
}

mod_data.custom_gui_textures = {
	textures = {}
}
local material_prefix = "loading_screen_"
for key, value in pairs(multiple_loading_screen_list) do
	if LevelSettings[key] and key ~= "inn_level" then
		table.insert(mod_data.custom_gui_textures.textures, material_prefix .. key .. "_1")
	end
end

mod_data.options_widgets = {
	{
		["setting_name"] = "randomize_screens",
		["widget_type"] = "checkbox",
		["text"] = "Randomize Loading Screens",
		["tooltip"] = "Randomly select loading screens for enabled maps.\n\n" ..
			"If disabled, only 'old school' variants will be used.",
		["default_value"] = true, -- Default first option In this case true
	},
	{
		["setting_name"] = "randomize_tips",
		["widget_type"] = "checkbox",
		["text"] = "Randomize Loading Screen Tips",
		["tooltip"] = "Randomly select loading screen tips for enabled maps.",
		["default_value"] = false, -- Default first option In this case false
	},
	{
		["setting_name"] = "toggle_maps",
		["widget_type"] = "dropdown",
		["text"] = "Toggle Maps",
		["tooltip"] = "Allows maps with loading screens to be toggled On / Off",
		["options"] = {
			{--[[1]] text = "Enabled",       value = true},
			{--[[2]] text = "Disabled",     value = false}
		},
		["default_value"] = 2, -- Default first option In this case Disabled
		["sub_widgets"] = {
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "inn_level_ls",
				["widget_type"] = "checkbox",
				["text"] = "Red Moon Inn",
				["tooltip"] = "Toggle loading screen changes for Red Moon Inn.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "magnus_ls",
				["widget_type"] = "checkbox",
				["text"] = "Horn of Magnus",
				["tooltip"] = "Toggle loading screen changes for Horn of Magnus.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "merchant_ls",
				["widget_type"] = "checkbox",
				["text"] = "Supply and Demand",
				["tooltip"] = "Toggle loading screen changes for Supply and Demand.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "sewers_short_ls",
				["widget_type"] = "checkbox",
				["text"] = "Smuggler's Run",
				["tooltip"] = "Toggle loading screen changes for Smuggler's Run.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "wizard_ls",
				["widget_type"] = "checkbox",
				["text"] = "Wizard's Tower",
				["tooltip"] = "Toggle loading screen changes for Wizard's Tower.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "bridge_ls",
				["widget_type"] = "checkbox",
				["text"] = "Black Powder",
				["tooltip"] = "Toggle loading screen changes for Black Powder.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "forest_ambush_ls",
				["widget_type"] = "checkbox",
				["text"] = "Engines of War",
				["tooltip"] = "Toggle loading screen changes for Engines of War.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "city_wall_ls",
				["widget_type"] = "checkbox",
				["text"] = "Man the Ramparts",
				["tooltip"] = "Toggle loading screen changes for Man the Ramparts.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "cemetery_ls",
				["widget_type"] = "checkbox",
				["text"] = "Garden of Morr",
				["tooltip"] = "Toggle loading screen changes for Garden of Morr.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "farm_ls",
				["widget_type"] = "checkbox",
				["text"] = "Wheat and Chaff",
				["tooltip"] = "Toggle loading screen changes for Farm.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "tunnels_ls",
				["widget_type"] = "checkbox",
				["text"] = "Enemy Below",
				["tooltip"] = "Toggle loading screen changes for Enemy Below.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "courtyard_level_ls",
				["widget_type"] = "checkbox",
				["text"] = "Well Watch",
				["tooltip"] = "Toggle loading screen changes for Well Watch.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "docks_short_level_ls",
				["widget_type"] = "checkbox",
				["text"] = "Waterfront",
				["tooltip"] = "Toggle loading screen changes for Waterfront.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "end_boss_ls",
				["widget_type"] = "checkbox",
				["text"] = "White Rat",
				["tooltip"] = "Toggle loading screen changes for White Rat.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "dlc_castle_ls",
				["widget_type"] = "checkbox",
				["text"] = "Castle Drachenfels",
				["tooltip"] = "Toggle loading screen changes for Castle Drachenfels.",
				["default_value"] = true -- Default first option is enabled. In this case true
			}
		}
	}
}

return mod_data
