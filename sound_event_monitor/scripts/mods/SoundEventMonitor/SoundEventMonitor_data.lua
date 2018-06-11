--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local mod_data = {
	name = "Sound Event Monitor",
	description = "Allows you to record the names of sound events as they happen in Vermintide.",
	is_togglable = true,
	is_mutator = false,
	mutator_settings = {}
}

mod_data.options_widgets = { -- Widget settings for the mod options menu
	{
		["setting_name"] = "max_repeat",
		["widget_type"] = "numeric",
		["text"] = "Max Repeated Events",
		["tooltip"] = "Max number of times to report an already-recorded event.",
		["range"] = {1, 100},
		["default_value"] = 30,
	}
}

return mod_data
