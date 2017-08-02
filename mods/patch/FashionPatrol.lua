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

mod.original_storm_variation = {
		max = UnitVariationSettings.skaven_storm_vermin.material_variations.cloth_tint.max,
		min = UnitVariationSettings.skaven_storm_vermin.material_variations.cloth_tint.min
	}

mod.new_storm_variation = { -- Variation gradient values above 30 are treated as pure white
		max = 31,
		min = 31
	}
	
Mods.hook.set(mod_name, "UnitSpawner.spawn_network_unit", function(func, self, unit_name, unit_template_name, extension_init_data, position, rotation, material)
	
	-- Identify Stormvermin patrol unit and change colors
	local changed_color = false
	if extension_init_data and extension_init_data.ai_group_system and extension_init_data.ai_group_system.template == "storm_vermin_formation_patrol" then
		UnitVariationSettings.skaven_storm_vermin.material_variations.cloth_tint.max = mod.new_storm_variation.max
		UnitVariationSettings.skaven_storm_vermin.material_variations.cloth_tint.min = mod.new_storm_variation.min
		changed_color = true
	end
	
	-- Original function
	local unit, go_id = func(self, unit_name, unit_template_name, extension_init_data, position, rotation, material)
	
	-- Restore color settings
	if changed_color then
		UnitVariationSettings.skaven_storm_vermin.material_variations.cloth_tint.max = mod.original_storm_variation.max
		UnitVariationSettings.skaven_storm_vermin.material_variations.cloth_tint.min = mod.original_storm_variation.min
	end
	
	-- Return result
	return unit, go_id
end)