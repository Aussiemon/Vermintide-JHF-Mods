--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	
--]]

local mod = get_mod("Template")

-- ##########################################################
-- ################## Variables #############################

local mod_data = {}
mod_data.name = "Template" -- Readable mod name
mod_data.description = "TemplateDescription" -- Readable mod description
mod_data.is_togglable = true -- If the mod can be enabled/disabled
mod_data.is_mutator = false -- If the mod is mutator
mod_data.mutator_settings = { -- Extra settings for mutator
    ...
}
mod_data.options_widgets = {
	{
		["setting_name"] = "dropdown",
		["widget_type"] = "dropdown",
		["text"] = "Dropdown",
		["tooltip"] = "Dropdown\n" ..
			"Line_1\n\n" ..
			"Line_2\n\n" ..
			"Line_3",
		["options"] = {
			{--[[1]] text = "Value_1",       value = "Value_1"},
			{--[[2]] text = "Value_2",     value = "Value_2"},
			{--[[3]] text = "Value_3", value = "Value_3"},
			{--[[4]] text = "Value_4",    value = "Value_4"},
			{--[[5]] text = "Value_5",     value = "Value_5"},
		},
		["default_value"] = "Value_1", -- Default first option In this case "Value_1"
		["sub_widgets"] = {
			{
				["show_widget_condition"] = {3, 4, 5},

				["setting_name"] = "checkbox",
				["widget_type"] = "checkbox",
				["text"] = "Checkbox",
				["tooltip"] = "Checkbox\n" ..
					"Line_1\n\n" ..
					"Line_2\n\n" ..
					"Line_3",
				["default_value"] = false
			}
		}
	},
	{
		["setting_name"] = "checkbox",
		["widget_type"] = "checkbox",
		["text"] = "Checkbox",
		["tooltip"] = "Checkbox\n" ..
					"Line_1\n\n" ..
					"Line_2\n\n" ..
					"Line_3",
		["default_value"] = true -- Default first option is enabled. In this case true
	}
}

-- ##########################################################
-- ################## Functions #############################

-- ##########################################################
-- #################### Hooks ###############################

mod:hook("", function (func, ...)
	
	-- Original function
	local result = func(...)
	return result
end)

-- ##########################################################
-- ################### Callback #############################

-- Call on every update to mods
mod.update = function(dt)
	return
end

-- Call when all mods are being unloaded
mod.on_unload = function()
	return
end

-- Call when game state changes (e.g. StateLoading -> StateIngame)
mod.on_game_state_changed = function(status, state)
	return
end

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_name)
	return
end

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(initial_call)
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(initial_call)
	mod:enable_all_hooks()
end

-- Call when a user joins
mod.on_user_joined = function(player)
	return
end

-- Call when a user leaves
mod.on_user_left = function(player)
	return
end

-- Call when all mods are loaded
mod.on_all_mods_loaded = function()
	return
end

-- ##########################################################
-- ################### Script ###############################

mod:initialize_data(mod_data)

-- ##########################################################
