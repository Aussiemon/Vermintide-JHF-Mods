--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local mod_data = {
	name = "Smaller Bright Wizard Staffs",               -- Readable mod name
	description = "Adjustment of size for specific BW first-person weapon models.",  -- Mod description
	is_togglable = true,            -- If the mod can be enabled/disabled
	is_mutator = false,             -- If the mod is mutator
	mutator_settings = {}          -- Extra settings, if it's mutator
}

mod_data.options_widgets = {
	{
		["setting_name"] = "red_staff_active",
		["widget_type"] = "checkbox",
		["text"] = "Enable for Red Staffs",
		["tooltip"] = "Toggle the reduced size of red staffs on / off.",
		["default_value"] = true, -- Default first option is enabled. In this case true
		["sub_widgets"] = {
			{
				["setting_name"] = "red_staff_scale",
				["widget_type"] = "numeric",
				["text"] = "Red Staff Scale",
				["tooltip"] = "Scale of red bright wizard staffs.",
				["range"] = {20, 100},
				["default_value"] = 42, -- Best size for red staffs after testing
			}
		}
	},
	{
		["setting_name"] = "bolt_staff_active",
		["widget_type"] = "checkbox",
		["text"] = "Enable for Bolt Staffs",
		["tooltip"] = "Toggle the reduced size of bolt staffs on / off.",
		["default_value"] = false, -- Default first option is enabled. In this case false
		["sub_widgets"] = {
			{
				["setting_name"] = "bolt_staff_scale",
				["widget_type"] = "numeric",
				["text"] = "Bolt Staff Scale",
				["tooltip"] = "Scale of bolt bright wizard staffs.",
				["range"] = {20, 100},
				["default_value"] = 100,
			}
		}
	},
	{
		["setting_name"] = "beam_staff_active",
		["widget_type"] = "checkbox",
		["text"] = "Enable for Beam Staffs",
		["tooltip"] = "Toggle the reduced size of beam staffs on / off.",
		["default_value"] = false, -- Default first option is enabled. In this case false
		["sub_widgets"] = {
			{
				["setting_name"] = "beam_staff_scale",
				["widget_type"] = "numeric",
				["text"] = "Beam Staff Scale",
				["tooltip"] = "Scale of beam bright wizard staffs.",
				["range"] = {20, 100},
				["default_value"] = 100,
			}
		}
	},
	{
		["setting_name"] = "conflag_staff_active",
		["widget_type"] = "checkbox",
		["text"] = "Enable for Conflag Staffs",
		["tooltip"] = "Toggle the reduced size of conflag staffs on / off.",
		["default_value"] = false, -- Default first option is enabled. In this case false
		["sub_widgets"] = {
			{
				["setting_name"] = "conflag_staff_scale",
				["widget_type"] = "numeric",
				["text"] = "Conflag Staff Scale",
				["tooltip"] = "Scale of conflag bright wizard staffs.",
				["range"] = {20, 100},
				["default_value"] = 100,
			}
		}
	},
	{
		["setting_name"] = "fireball_staff_active",
		["widget_type"] = "checkbox",
		["text"] = "Enable for Fireball Staffs",
		["tooltip"] = "Toggle the reduced size of fireball staffs on / off.",
		["default_value"] = false, -- Default first option is enabled. In this case false
		["sub_widgets"] = {
			{
				["setting_name"] = "fireball_staff_scale",
				["widget_type"] = "numeric",
				["text"] = "Fireball Staff Scale",
				["tooltip"] = "Scale of fireball bright wizard staffs.",
				["range"] = {20, 100},
				["default_value"] = 100,
			}
		}
	}
}

return mod_data
