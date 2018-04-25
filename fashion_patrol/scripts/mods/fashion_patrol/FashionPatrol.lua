--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Gives Stormvermin patrols white armor (client-side, host only)
--]]

local mod = get_mod("FashionPatrol")

-- ##########################################################
-- ################## Variables #############################

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

local mod_data = {}
mod_data.name = "Fashion Patrol" -- Readable mod name
mod_data.description = "Gives Stormvermin patrols white armor (client-side, host only)." -- Readable mod description
mod_data.is_togglable = true -- If the mod can be enabled/disabled
mod_data.is_mutator = false -- If the mod is mutator

-- ##########################################################
-- ################## Functions #############################

-- Sets Stormvermin armor material to white
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
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook("UnitSpawner.spawn_local_unit_with_extensions", function (func, self, unit_name, unit_template_name, extension_init_data, ...)
	local unit, unit_template_name = func(self, unit_name, unit_template_name, extension_init_data, ...)
	
	-- Changes here: --------------------------------
	if unit_template_name == "ai_unit_storm_vermin" and extension_init_data and extension_init_data.ai_group_system and extension_init_data.ai_group_system.template == "storm_vermin_formation_patrol" then
		mod.trigger_stormvermin_variation(unit)
	end
	-- Changes end. ---------------------------------
	
	return unit, unit_template_name
end)

-- ##########################################################
-- ################### Callback #############################

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(initial_call)
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(initial_call)
	mod:enable_all_hooks()
end

-- ##########################################################
-- ################### Script ###############################

mod:initialize_data(mod_data)

-- ##########################################################
