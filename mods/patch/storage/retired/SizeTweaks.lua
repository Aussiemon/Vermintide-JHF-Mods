--[[
	author: Aussiemon
 
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Adjustment of size variation for various units.
--]]

local mod_name = "SizeTweaks"

-- ====== Parameters: DO NOT SET ANY VALUE TO 0 OR EXCESSIVELY HIGH VALUES

local scale_creatures = true -- Set to false to disable creature scaling
local scale_players = true -- Set to false to disable player scaling

local creature_scale_factor = 1.000 -- Change to globablly scale creatures
local creature_radius_scale_factor = 1.000 -- Change to globally change creature radius
local player_scale_factor = 1.000 -- Change to globally scale players


-- These settings provide specific scaling values on a per-creature basis.

local pig_scale_override = nil -- Change to set specific scale for pig
local literalrat_scale_override = nil -- Change to set specific scale for literal rat-sized rat
local slave_scale_override = nil -- Change to set specific scale for slave rat
local clan_scale_override = nil -- Change to set specific scale for clan rat
local gunner_scale_override = nil -- Change to set specific scale for ratling gunner
local globadier_scale_override = nil -- Change to set specific scale for globadier
local packmaster_scale_override = nil -- Change to set specific scale for pack master
local gutter_scale_override = nil -- Change to set specific scale for gutter runner
local lootrat_scale_override = nil -- Change to set specific scale for loot rat
local storm_scale_override = nil -- Change to set specific scale for storm vermin
local stormcommander_scale_override = nil -- Change to set specific scale for storm vermin commander
local stormchampion_scale_override = 1.5 -- Change to set specific scale for storm vermin champion
local ogre_scale_override = 1.5 -- Change to set specific scale for rat ogre
local seer_scale_override = nil -- Change to set specific scale for grey seers (will not likely affect White Rat grey seer object)
local stormfiend_scale_override = nil -- Change to set specific scale for stormfiends (probably unimplemented, but just in case)


-- These settings, if I understand correctly, let rats group closer together.

local pig_radius_scale_override = nil -- Change to set specific radius scale for pig
local literalrat_radius_scale_override = nil -- Change to set specific radius scale for literal rat-sized rat
local slave_radius_scale_override = nil -- Change to set specific radius scale for slave rat
local clan_radius_scale_override = nil -- Change to set specific radius scale for clan rat
local gunner_radius_scale_override = nil -- Change to set specific radius scale for ratling gunner
local globadier_radius_scale_override = nil -- Change to set specific radius scale for globadier
local packmaster_radius_scale_override = nil -- Change to set specific radius scale for pack master
local gutter_radius_scale_override = nil -- Change to set specific radius scale for gutter runner
local lootrat_radius_scale_override = nil -- Change to set specific radius scale for loot rat
local storm_radius_scale_override = nil -- Change to set specific radius scale for storm vermin
local stormcommander_radius_scale_override = nil -- Change to set specific radius scale for storm vermin commander
local stormchampion_radius_scale_override = nil -- Change to set specific radius scale for storm vermin champion
local ogre_radius_scale_override = nil -- Change to set specific radius scale for rat ogre
local seer_radius_scale_override = nil -- Change to set specific radius scale for grey seers (will not likely affect White Rat grey seer object)
local stormfiend_radius_scale_override = nil -- Change to set specific radius scale for stormfiends (probably unimplemented, but just in case)


-- ====== Do not modify code below unless you know what you're doing. ======


-- Creature scaling is done with size variation ranges. These mostly reset upon death.
if scale_creatures then


if Breeds.critter_pig then
	Breeds.critter_pig.size_variation_range = {
			0.9*(pig_scale_override or creature_scale_factor), --Normal: .9, 1.1
			1.1*(pig_scale_override or creature_scale_factor)
		}
	Breeds.critter_pig.radius = 1*(pig_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.critter_rat then
	Breeds.critter_rat.size_variation_range = {
			0.9*(literalrat_scale_override or creature_scale_factor), --Normal: .9, 1.1
			1.1*(literalrat_scale_override or creature_scale_factor)
		}
	Breeds.critter_rat.radius = 1*(literalrat_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_slave then
	Breeds.skaven_slave.size_variation_range = {
			0.85*(slave_scale_override or creature_scale_factor), --Normal: .85, .95
			0.95*(slave_scale_override or creature_scale_factor)
		}
	Breeds.skaven_slave.radius = 1.75*(slave_radius_scale_override or creature_radius_scale_factor) --Normal: 1.75
end

if Breeds.skaven_clan_rat then
	Breeds.skaven_clan_rat.size_variation_range = {
			0.95*(clan_scale_override or creature_scale_factor), --Normal: .95, 1.05
			1.05*(clan_scale_override or creature_scale_factor)
		}
	Breeds.skaven_clan_rat.radius = 2*(clan_radius_scale_override or creature_radius_scale_factor) --Normal: 2
end

if Breeds.skaven_ratling_gunner then
	Breeds.skaven_ratling_gunner.size_variation_range = {
			1.0*(gunner_scale_override or creature_scale_factor), --Normal: 1.0, 1.0
			1.0*(gunner_scale_override or creature_scale_factor)
		}
	Breeds.skaven_ratling_gunner.radius = 1*(gunner_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_poison_wind_globadier then
	Breeds.skaven_poison_wind_globadier.size_variation_range = {
			1.0*(globadier_scale_override or creature_scale_factor), --Normal: 1.0, 1.0
			1.0*(globadier_scale_override or creature_scale_factor)
		}
	Breeds.skaven_poison_wind_globadier.radius = 1*(globadier_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_pack_master then
	Breeds.skaven_pack_master.size_variation_range = {
			1.0*(packmaster_scale_override or creature_scale_factor), --Normal: 1.0, 1.0
			1.0*(packmaster_scale_override or creature_scale_factor)
		}
	Breeds.skaven_pack_master.radius = 1*(packmaster_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_gutter_runner then
	Breeds.skaven_gutter_runner.size_variation_range = {
			1.0*(gutter_scale_override or creature_scale_factor), --Normal: 1.0, 1.0
			1.0*(gutter_scale_override or creature_scale_factor)
		}
	Breeds.skaven_gutter_runner.radius = 1*(gutter_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_loot_rat then
	Breeds.skaven_loot_rat.size_variation_range = {
			1.0*(lootrat_scale_override or creature_scale_factor), --Normal: 1.0, 1.0
			1.0*(lootrat_scale_override or creature_scale_factor)
		}
	Breeds.skaven_loot_rat.radius = 1*(lootrat_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_storm_vermin then
	Breeds.skaven_storm_vermin.size_variation_range = {
			1.05*(storm_scale_override or creature_scale_factor), --Normal: 1.05, 1.15
			1.15*(storm_scale_override or creature_scale_factor)
		}
	Breeds.skaven_storm_vermin.radius = 1*(storm_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_storm_vermin_commander then
	Breeds.skaven_storm_vermin_commander.size_variation_range = {
			1.05*(stormcommander_scale_override or creature_scale_factor), --Normal: 1.05, 1.15
			1.15*(stormcommander_scale_override or creature_scale_factor)
		}
	Breeds.skaven_storm_vermin_commander.radius = 1*(stormcommander_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_storm_vermin_champion then
	Breeds.skaven_storm_vermin_champion.size_variation_range = {
			1.4*(stormchampion_scale_override or creature_scale_factor), --Normal: 1.4, 1.4
			1.4*(stormchampion_scale_override or creature_scale_factor)
		}
	Breeds.skaven_storm_vermin_champion.radius = 1*(stormchampion_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_rat_ogre then
	Breeds.skaven_rat_ogre.size_variation_range = {
			1.4*(ogre_scale_override or creature_scale_factor), --Normal: No variation given
			1.4*(ogre_scale_override or creature_scale_factor)
		}
	Breeds.skaven_rat_ogre.radius = 2*(ogre_radius_scale_override or creature_radius_scale_factor) --Normal: 2
end

if Breeds.skaven_grey_seer then
	Breeds.skaven_grey_seer.size_variation_range = {
		1*(seer_scale_override or creature_scale_factor), --Normal: 1, 1
		1*(seer_scale_override or creature_scale_factor)
	}
Breeds.skaven_grey_seer.radius = 1*(seer_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

if Breeds.skaven_stormfiend then
	Breeds.skaven_stormfiend.size_variation_range = {
		1*(stormfiend_scale_override or creature_scale_factor), --Normal: No variation given
		1*(stormfiend_scale_override or creature_scale_factor)
	}
Breeds.skaven_stormfiend.radius = 1*(stormfiend_radius_scale_override or creature_radius_scale_factor) --Normal: 1
end

end

-- Player scaling can be done using Stingray commands, but I have not yet managed to find a good way to do this for creatures.
if scale_players then


if not player_height_from_name_hooked then
	player_height_from_name_hooked = false
end

if not spawn_local_unit_hooked then
	spawn_local_unit_hooked = false
end

-- Set first person view to scaled height
if not player_height_from_name_hooked then
	Mods.hook.set(command_name, "PlayerUnitFirstPerson._player_height_from_name", function (func, self, name)
		local profile = self.profile
		return ((profile.first_person_heights[name])*(player_scale_factor))
	end)
	player_height_from_name_hooked = true
end

-- Set unit scale to scaled value
if not spawn_local_unit_hooked then
	Mods.hook.set(command_name, "UnitSpawner.spawn_local_unit", function (func, self, unit_name, position, rotation, material)
			local unit = func(self, unit_name, position, rotation, material)
			
			if scale_players and string.find(unit_name, "beings/player") then
				local current_scale = stingray.Unit.local_scale(unit, 0)
				stingray.Unit.set_local_scale(unit, 0, 
					Vector3(current_scale.x * player_scale_factor,
					current_scale.y * player_scale_factor,
					current_scale.z * player_scale_factor))
			end
			--EchoConsole(unit_name)
			
			return unit
	end)
	spawn_local_unit_hooked = true
end


end