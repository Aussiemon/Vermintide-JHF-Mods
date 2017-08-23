--[[
	author: Aussiemon
	
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Adjustment of size for specific BW first-person weapon models.
--]]

local mod_name = "SmallerBWStaffs"

-- ##########################################################
-- ################## Variables #############################

SmallerBWStaffs = {
	SETTINGS = {
		ACTIVE = {
		["save"] = "cb_smaller_bw_staffs_enabled",
		["widget_type"] = "stepper",
		["text"] = "Smaller Wizard Staffs - Enabled",
		["tooltip"] =  "Smaller Wizard Staffs\n" ..
			"Toggle smaller wizard staffs on / off.\n\n" ..
			"Allows reducing the size of all first-person bright wizard staff models.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
		RED_ACTIVE = {
		["save"] = "cb_smaller_bw_staffs_shrink_red",
		["widget_type"] = "stepper",
		["text"] = "Shrink Red Staffs",
		["tooltip"] =  "Shrink Red Staffs\n" ..
			"Toggle the reduced size of red staffs on / off.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
		RED_SCALE = {
			["save"] = "cb_smaller_bw_staffs_scale_red",
			["widget_type"] = "slider",
			["text"] = "Red Staff Scale",
			["tooltip"] =  "Red Staff Scale\n" ..
				"Scale of red bright wizard staffs.",
			["range"] = {20, 100},
			["default"] = 42, -- Optimum size for red staffs after testing
		},
		BOLT_ACTIVE = {
		["save"] = "cb_smaller_bw_staffs_shrink_bolt",
		["widget_type"] = "stepper",
		["text"] = "Shrink Bolt Staffs",
		["tooltip"] =  "Shrink Bolt Staffs\n" ..
			"Toggle the reduced size of bolt staffs on / off.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
		BOLT_SCALE = {
			["save"] = "cb_smaller_bw_staffs_scale_bolt",
			["widget_type"] = "slider",
			["text"] = "Bolt Staff Scale",
			["tooltip"] =  "Bolt Staff Scale\n" ..
				"Scale of bolt bright wizard staffs.",
			["range"] = {20, 100},
			["default"] = 100,
		},
		BEAM_ACTIVE = {
		["save"] = "cb_smaller_bw_staffs_shrink_beam",
		["widget_type"] = "stepper",
		["text"] = "Shrink Beam Staffs",
		["tooltip"] =  "Shrink Beam Staffs\n" ..
			"Toggle the reduced size of beam staffs on / off.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
		BEAM_SCALE = {
			["save"] = "cb_smaller_bw_staffs_scale_beam",
			["widget_type"] = "slider",
			["text"] = "Beam Staff Scale",
			["tooltip"] =  "Beam Staff Scale\n" ..
				"Scale of beam bright wizard staffs.",
			["range"] = {20, 100},
			["default"] = 100,
		},
		CONFLAG_ACTIVE = {
		["save"] = "cb_smaller_bw_staffs_shrink_conflag",
		["widget_type"] = "stepper",
		["text"] = "Shrink Conflag Staffs",
		["tooltip"] =  "Shrink Conflag Staffs\n" ..
			"Toggle the reduced size of conflag staffs on / off.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
		CONFLAG_SCALE = {
			["save"] = "cb_smaller_bw_staffs_scale_conflag",
			["widget_type"] = "slider",
			["text"] = "Conflag Staff Scale",
			["tooltip"] =  "Conflag Staff Scale\n" ..
				"Scale of conflag bright wizard staffs.",
			["range"] = {20, 100},
			["default"] = 100,
		},
		FIREBALL_ACTIVE = {
		["save"] = "cb_smaller_bw_staffs_shrink_fireball",
		["widget_type"] = "stepper",
		["text"] = "Shrink Fireball Staffs",
		["tooltip"] =  "Shrink Fireball Staffs\n" ..
			"Toggle the reduced size of fireball staffs on / off.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
		FIREBALL_SCALE = {
			["save"] = "cb_smaller_bw_staffs_scale_fireball",
			["widget_type"] = "slider",
			["text"] = "Fireball Staff Scale",
			["tooltip"] =  "Fireball Staff Scale\n" ..
				"Scale of fireball bright wizard staffs.",
			["range"] = {20, 100},
			["default"] = 100,
		},
	},
	scaled_unit = nil,
	counter = 1,
	LookupTable = {},
	LookupScaleTable = {},
}

-- Lookup table for active settings
SmallerBWStaffs.LookupTable["units/weapons/player/wpn_brw_staff_06/wpn_brw_staff_06"] = SmallerBWStaffs.SETTINGS.RED_ACTIVE -- Red
SmallerBWStaffs.LookupTable["units/weapons/player/wpn_brw_staff_05/wpn_brw_staff_05"] = SmallerBWStaffs.SETTINGS.BOLT_ACTIVE -- Bolt
SmallerBWStaffs.LookupTable["units/weapons/player/wpn_brw_staff_04/wpn_brw_staff_04"] = SmallerBWStaffs.SETTINGS.BEAM_ACTIVE -- Beam
SmallerBWStaffs.LookupTable["units/weapons/player/wpn_brw_staff_03/wpn_brw_staff_03"] = SmallerBWStaffs.SETTINGS.CONFLAG_ACTIVE -- Conflag
SmallerBWStaffs.LookupTable["units/weapons/player/wpn_brw_staff_02/wpn_brw_staff_02"] = SmallerBWStaffs.SETTINGS.FIREBALL_ACTIVE -- Fireball

-- Lookup table for scale settings
SmallerBWStaffs.LookupScaleTable["units/weapons/player/wpn_brw_staff_06/wpn_brw_staff_06"] = SmallerBWStaffs.SETTINGS.RED_SCALE -- Red
SmallerBWStaffs.LookupScaleTable["units/weapons/player/wpn_brw_staff_05/wpn_brw_staff_05"] = SmallerBWStaffs.SETTINGS.BOLT_SCALE -- Bolt
SmallerBWStaffs.LookupScaleTable["units/weapons/player/wpn_brw_staff_04/wpn_brw_staff_04"] = SmallerBWStaffs.SETTINGS.BEAM_SCALE -- Beam
SmallerBWStaffs.LookupScaleTable["units/weapons/player/wpn_brw_staff_03/wpn_brw_staff_03"] = SmallerBWStaffs.SETTINGS.CONFLAG_SCALE -- Conflag
SmallerBWStaffs.LookupScaleTable["units/weapons/player/wpn_brw_staff_02/wpn_brw_staff_02"] = SmallerBWStaffs.SETTINGS.FIREBALL_SCALE -- Fireball

-- ##########################################################
-- ################## Functions #############################

SmallerBWStaffs.create_options = function()
	Mods.option_menu:add_group("smaller_bw_staffs", "Smaller Bright Wizard Staffs")
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.ACTIVE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.RED_ACTIVE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.RED_SCALE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.BOLT_ACTIVE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.BOLT_SCALE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.BEAM_ACTIVE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.BEAM_SCALE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.CONFLAG_ACTIVE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.CONFLAG_SCALE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.FIREBALL_ACTIVE, true)
	Mods.option_menu:add_item("smaller_bw_staffs", SmallerBWStaffs.SETTINGS.FIREBALL_SCALE, true)
end

-- Updates bright wizard staff size with scaling factor
mod.bw_staff_apply_scale = function(scaling_factor, remove_unit, calling_function)
	if SmallerBWStaffs.scaled_unit and Unit.alive(SmallerBWStaffs.scaled_unit) then
	
		safe_pcall(function()
		
			local root_node = Unit.has_node(SmallerBWStaffs.scaled_unit, "root_point") and Unit.node(SmallerBWStaffs.scaled_unit, "root_point") or 0
			local current_scale = Unit.local_scale(SmallerBWStaffs.scaled_unit, root_node)
			
			Unit.set_local_scale(SmallerBWStaffs.scaled_unit, root_node, 
				Vector3(current_scale.x * (scaling_factor or 1),
					current_scale.y * (scaling_factor or 1),
					current_scale.z * (scaling_factor or 1)))
			if remove_unit then
				SmallerBWStaffs.scaled_unit = nil
			end
		end)
		
		if calling_function then
			EchoConsole(calling_function)
		end
	end
	
	return
end

local get = function(data)
	if not data then return 1 end
	return Application.user_setting(data.save)
end
local set = Application.set_user_setting
local save = Application.save_user_settings

-- ##########################################################
-- #################### Hooks ###############################

Mods.hook.set(mod_name, "UnitSpawner.spawn_local_unit", function (func, self, unit_name, position, rotation, material)
	local unit = func(self, unit_name, position, rotation, material)
	
	if get(SmallerBWStaffs.LookupTable[unit_name]) then
		-- Save oversized staff unit
		if SmallerBWStaffs.LookupTable[unit_name] then
			SmallerBWStaffs.scaled_unit = unit
			SmallerBWStaffs.scaled_unit_name = unit_name
			SmallerBWStaffs.counter = 1
		end
	end
	
	return unit
end)

Mods.hook.set(mod_name, "UnitSpawner.spawn_local_unit_with_extensions", function (func, self, unit_name, ...)
	local unit, unit_template_name = func(self, unit_name, ...)
	
	if get(SmallerBWStaffs.LookupTable[unit_name]) then
		-- Apply scaling factor
		local scale_setting = SmallerBWStaffs.LookupScaleTable[SmallerBWStaffs.scaled_unit_name]
		local scale_factor = math.pow(((get(scale_setting)/100) or 1), (1/3))
		
		if SmallerBWStaffs.counter < 3 then
			mod.bw_staff_apply_scale(scale_factor, false, nil)
			SmallerBWStaffs.counter = SmallerBWStaffs.counter + 1
		else
			mod.bw_staff_apply_scale(scale_factor, true, nil)
		end
	end
	
	return unit, unit_template_name
end)

-- ##########################################################
-- ################### Script ###############################

SmallerBWStaffs.create_options()

-- ##########################################################