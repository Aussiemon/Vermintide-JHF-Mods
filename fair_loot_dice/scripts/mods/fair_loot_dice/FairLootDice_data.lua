--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local LENGTH_METHOD = 1
local FLATRATE_METHOD = 2

local mod_data = {
	name = "Fair Loot Dice",               -- Readable mod name
	description = "Modifies the base loot die chance to account for number of chests in a map.",  -- Mod description
	is_togglable = true,            -- If the mod can be enabled/disabled
	is_mutator = false,             -- If the mod is mutator
	mutator_settings = {}          -- Extra settings, if it's mutator
}

mod_data.options_widgets = {
	{
		["setting_name"] = "method",
		["widget_type"] = "dropdown",
		["text"] = "Dice Chance Method",
		["tooltip"] = "Allows choosing how odds are determined.\n\n" ..
			"-- LENGTH --\nTwo-grimoire maps normalized to at least 17 chests, otherwise 14.\n\n" ..
			"-- FLAT-RATE --\nAll maps normalized to exactly 17 chests.",
		["options"] = {
			{text = "Length", value = LENGTH_METHOD},
			{text = "Flat-Rate", value = FLATRATE_METHOD},
		},
		["default_value"] = LENGTH_METHOD, -- Default first option is enabled. In this case Length
	}
}

return mod_data
