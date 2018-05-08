--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Replaces ogres with Krench the Stormvermin Champion.
--]]

local mod = get_mod("KrenchMutation")

-- ##########################################################
-- ################## Variables #############################

Backup_Breeds_skaven_storm_vermin_champion = Backup_Breeds_skaven_storm_vermin_champion or nil
Backup_Breeds_skaven_rat_ogre = Backup_Breeds_skaven_rat_ogre or nil

local mod_data = {}
mod_data.name = "Krench Mutation" -- Readable mod name
mod_data.description = "Replaces ogres with Krench the Stormvermin Champion." -- Readable mod description
mod_data.is_togglable = false -- If the mod can be enabled/disabled
mod_data.is_mutator = true -- If the mod is mutator
mod_data.mutator_settings = { -- Extra settings for mutator
}
mod_data.options_widgets = nil

local Managers = Managers
local Breeds = Breeds
local Unit = Unit
local pairs = pairs
local type = type
local rawget = rawget
local rawset = rawset

-- ##########################################################
-- ################## Functions #############################

mod.activate_mutation = function()
	local local_player = Managers.player
	if not local_player.is_server then
		mod:echo("You must be the host to activate the Krench Mutation!")
		return
	end

	if Managers.state.game_mode == nil or (Managers.state.game_mode._game_mode_key ~= "inn" and local_player.is_server) then
		mod:echo("You must be in the inn to activate the Krench Mutation!")
		return
	end
	
	if not rawget(_G, "Backup_Breeds_skaven_storm_vermin_champion") then
		rawset(_G, "Backup_Breeds_skaven_storm_vermin_champion", Breeds.skaven_storm_vermin_champion)
	end
	
	if not rawget(_G, "Backup_Breeds_skaven_rat_ogre") then
		rawset(_G, "Backup_Breeds_skaven_rat_ogre", Breeds.skaven_rat_ogre)
	end
	
	if not Breeds.skaven_storm_vermin_champion.combat_spawn_stinger then
		Breeds.skaven_storm_vermin_champion.combat_spawn_stinger = "Play_enemy_stormvermin_champion_electric_floor"
	end
	Breeds.skaven_rat_ogre = Breeds.skaven_storm_vermin_champion
	
	--mod:chat_broadcast("Krench Mutation ENABLED")
end

mod.deactivate_mutation = function()
	if Backup_Breeds_skaven_storm_vermin_champion then
		 Breeds.skaven_storm_vermin_champion = Backup_Breeds_skaven_storm_vermin_champion
	end
	
	if Backup_Breeds_skaven_rat_ogre then
		Breeds.skaven_rat_ogre = Backup_Breeds_skaven_rat_ogre
	end
	
	--mod:chat_broadcast("Krench Mutation DISABLED")
end

-- ##########################################################
-- #################### Hooks ###############################

-- Check for lack of spawn_group in this level
mod:hook("BTSpawnAllies.enter", function (func, self, unit, blackboard, t, ...)
	local action = self._tree_node.action_data
	local spawn_group = action.spawn_group
	local spawner_system = Managers.state.entity:system("spawner_system")
	
	if spawner_system._id_lookup[spawn_group] == nil then
		local new_spawn_group = nil
		local largest_entry_size = 0
		for key,value in pairs(spawner_system._id_lookup) do
			if type(value) == "table" then
				if largest_entry_size < #value then
					largest_entry_size = #value
					new_spawn_group = key
				end
			end
		end
		if new_spawn_group then
			self._tree_node.action_data.spawn_group = new_spawn_group
			local result = func(self, unit, blackboard, t, ...)
			return result
		else
			mod:echo("Problem finding spawn group to adopt.")
			self._activate_ward(self, unit, blackboard)
			return
		
		end
	else
		local result = func(self, unit, blackboard, t, ...)
		return result
	end
end)

-- Catch nil spawning allies flag
mod:hook("BTSpawnAllies.run", function (func, self, unit, blackboard, t, dt, ...)
	if blackboard.spawning_allies == nil then
		return "done"
	else
		local result = func(self, unit, blackboard, t, dt, ...)
		return result
	end
end)

-- Catch rare husk error
mod:hook("AiBreedSnippets.on_storm_vermin_champion_husk_spawn", function (func, unit, ...)
	if unit ~= nil then
		local actor = Unit.actor(unit, "c_trophy_rack_ward")
		if actor ~= nil then
			local result = func(unit)
			return result
		end
	end
	
	mod:echo("Nil champion husk unit or actor!")
end)

-- ##########################################################
-- ################### Callback #############################

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(initial_call)
	if not initial_call then
		mod.deactivate_mutation()
	end
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(initial_call)
	mod:enable_all_hooks()
	mod.activate_mutation()
end

-- ##########################################################
-- ################### Script ###############################

mod:initialize_data(mod_data)

-- ##########################################################