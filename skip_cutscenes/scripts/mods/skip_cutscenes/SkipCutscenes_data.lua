--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local mod_data = {
	name = "Skip Cutscenes",               -- Readable mod name
	description = "Enable / disable the ability to skip cutscenes with ESC / Space.",  -- Mod description
	is_togglable = true,            -- If the mod can be enabled/disabled
	is_mutator = false,             -- If the mod is mutator
	mutator_settings = {}          -- Extra settings, if it's mutator
}

mod_data.options_widgets = {
	{
		["setting_name"] = "automatic",
		["widget_type"] = "dropdown",
		["text"] = "Mode",
		["tooltip"] = "Toggle method of skipping cutscenes.\n\n" ..
			"Automatic will skip cutscenes by default; Manual uses ESC / Space.",
		["options"] = {
			{text = "Automatic", value = true},
			{text = "Manual", value = false}
		},
		["default_value"] = false,
	}
}

return mod_data
