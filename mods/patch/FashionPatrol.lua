--[[
	author: Aussiemon
 
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Stormvermin patrol fashion week up in here.
--]]

local mod_name = "FashionPatrol"

-- ##########################################################
-- ################## Variables #############################
	
FashionPatrol = {
	SETTINGS = {
		ACTIVE = {
			["save"] = "cb_fashion_patrol_enabled",
			["widget_type"] = "stepper",
			["text"] = "Fashion Patrol - Enabled",
			["tooltip"] = "Fashion Patrol\n" ..
				"Patrol stormvermin have white armor in hosted games (client-side).",
			["value_type"] = "boolean",
			["options"] = {
				{text = "Off", value = false},
				{text = "On", value = true}
			},
			["default"] = 1, -- Default second option is enabled. In this case Off
		}
	}
}

local mod = FashionPatrol

mod.white_storm_variation = {
	material_variations = {
		cloth_tint = {
			min = 31,
			max = 31,
			variable = "gradient_variation",
			materials = {
				"mtr_outfit"
			},
			meshes = {
				"g_stormvermin_armor_lod0",
				"g_stormvermin_armor_lod1",
				"g_stormvermin_armor_lod2"
			}
		}
	}
}

-- ##########################################################
-- ################## Functions #############################

mod.create_options = function()
	Mods.option_menu:add_group("fashion_patrol", "Fashion Patrol")
	Mods.option_menu:add_item("fashion_patrol", mod.SETTINGS.ACTIVE, true)
end

mod.trigger_stormvermin_variation = function(unit)
	local variation_settings = mod.white_storm_variation
	local variation = variation_settings.material_variations["cloth_tint"]

	local variable_value = math.random(variation.min, variation.max)
	local variable_name = variation.variable
	local materials = variation.materials
	local meshes = variation.meshes
	local num_materials = #materials
	
	local Mesh_material = Mesh.material
	local Material_set_scalar = Material.set_scalar

	if not meshes then
		local Unit_set_scalar_for_material_table = Unit.set_scalar_for_material_table
		Unit_set_scalar_for_material_table(unit, materials, variable_name, variable_value)
	else 
		for i=1, #meshes do
			local mesh = meshes[i]
			local Unit_mesh = Unit.mesh
			local current_mesh = Unit_mesh(unit, mesh)

			for material_i=1, num_materials do
				local material = materials[material_i]
				local current_material = Mesh_material(current_mesh, material)
				Material_set_scalar(current_material,variable_name,variable_value)
			end
		end
	end
	
	local Unit_set_visibility = Unit.set_visibility
	Unit_set_visibility(unit, "all", false)
	
	return
end

local get = function(data)
	return Application.user_setting(data.save)
end
local set = Application.set_user_setting
local save = Application.save_user_settings

-- ##########################################################
-- #################### Hooks ###############################

Mods.hook.set(mod_name, "UnitSpawner.spawn_local_unit_with_extensions", function (func, self, unit_name, unit_template_name, extension_init_data, ...)
	local unit, unit_template_name = func(self, unit_name, unit_template_name, extension_init_data, ...)
	
	-- Changes here: --------------------------------
	if get(mod.SETTINGS.ACTIVE) then
		
		if extension_init_data and extension_init_data.ai_group_system and extension_init_data.ai_group_system.template == "storm_vermin_formation_patrol" then
			mod.trigger_stormvermin_variation(unit)
		end
	end
	-- Changes end. ---------------------------------
	
	return unit, unit_template_name
end)

-- ##########################################################
-- ################### Script ###############################

mod.create_options()

-- ##########################################################
