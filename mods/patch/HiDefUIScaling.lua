--[[
	author: Aussiemon
	
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Provides better UI scaling for higher-resolution displays.
--]]

local mod_name = "HiDefUIScaling"

-- ##########################################################
-- ################## Variables #############################

HiDefUIScaling = {
	SETTINGS = {
		ACTIVE = {
			["save"] = "cb_scale_high_definition_UI",
			["widget_type"] = "stepper",
			["text"] = "Scale UI for HD Displays - Enabled",
			["tooltip"] = "Scale UI for HD Displays\n" ..
				"Toggle UI-scaling for HD displays on / off.\n\n" ..
				"Automatically resizes UI for resolutions greater than 1080p.\n\n" ..
				"Use /reload command, then open and close a window to enact changes.",
			["value_type"] = "boolean",
			["options"] = {
				{text = "Off", value = false},
				{text = "On", value = true}
			},
			["default"] = 1, -- Default first option is enabled. In this case Off
		},
		SCALE = {
			["save"] = "cb_scale_high_definition_UI_scale_factor",
			["widget_type"] = "dropdown",
			["text"] = "Max UI Scaling Factor",
			["tooltip"] = "Max UI Scaling Factor\n" ..
				"Choose the max possible scaling percentage past 1080p. Only takes effect if the increased scaling factor is necessary.\n\n" ..
				"Use /reload command, then open and close a window to enact changes.",
			["value_type"] = "number",
			["options"] = {
				{text = "133%", value = 133}, -- 1440p
				{text = "166%", value = 166},
				{text = "200%", value = 200}, -- 4k
				{text = "233%", value = 233},
				{text = "266%", value = 266}, -- 5k
				{text = "300%", value = 300},
				{text = "333%", value = 333},
				{text = "366%", value = 366},
				{text = "400%", value = 400}, -- 8k
			},
			["default"] = 9, -- Default ninth option is enabled. In this case 400%
		},
	},
}

mod.hd_ui_scaling_enabled = false

-- ##########################################################
-- ################## Functions #############################

HiDefUIScaling.create_options = function()
	Mods.option_menu:add_group("HDUserInterface", "HD User Interface")
	Mods.option_menu:add_item("HDUserInterface", HiDefUIScaling.SETTINGS.ACTIVE, true)
	Mods.option_menu:add_item("HDUserInterface", HiDefUIScaling.SETTINGS.SCALE, true)
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

Mods.hook.set(mod_name, "UIResolutionScale", function (func, ...)
	local w, h = UIResolution()
	if get(HiDefUIScaling.SETTINGS.ACTIVE) and (w > UIResolutionWidthFragments() and h > UIResolutionHeightFragments()) then
		local max_scaling_factor = math.max((((get(HiDefUIScaling.SETTINGS.SCALE) or 4) + 1) / 100), 1)
		
		local width_scale = math.min(w/UIResolutionWidthFragments(), max_scaling_factor) -- Changed to allow scaling up to quadruple the original max scale (1 -> 4)
		local height_scale = math.min(h/UIResolutionHeightFragments(), max_scaling_factor) -- Changed to allow scaling up to quadruple the original max scale (1 -> 4)

		mod.hd_ui_scaling_enabled = true
		return math.min(width_scale, height_scale)
	else
		mod.hd_ui_scaling_enabled = false
		return func(...)
	end
end)

-- ##########################################################
-- ################### Script ###############################

HiDefUIScaling.create_options()
UPDATE_RESOLUTION_LOOKUP(true)

-- ##########################################################
