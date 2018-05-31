--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local PER_MISSION = 1
local ONCE = 2

local mod_data = {
	name = "Steam Warning",               -- Readable mod name
	description = "Displays a warning on the day that Steam usually schedules routine maintenance.",  -- Mod description
	is_togglable = true,            -- If the mod can be enabled/disabled
	is_mutator = false,             -- If the mod is mutator
	mutator_settings = {}          -- Extra settings, if it's mutator
}

mod_data.options_widgets = {
	{
		["setting_name"] = "frequency",
		["widget_type"] = "dropdown",
		["text"] = "Frequency of Display",
		["tooltip"] = "Frequency of Display\n" ..
			"Choose how often the Steam disconnect warning will be displayed.\n\n" ..
			"-- Per-Mission --\nDisplay warning once per entered lobby / mission.\n\n" ..
			"-- Once --\nDisplay warning once on usual disconnect day.",
		["options"] = {
			{text = "Per-Mission", value = PER_MISSION},
			{text = "Once", value = ONCE},
		},
		["default_value"] = ONCE, -- Default first option is enabled. In this case Once
	}
}

return mod_data
