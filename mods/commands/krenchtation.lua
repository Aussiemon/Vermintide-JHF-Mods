--[[
	author: Aussiemon (contains modifications to code orginally written by Grimalackt)
 
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Replaces ogres with Krench the Stormvermin Champion
--]]

local command_name = "krenchtation"
local display_name = "Krench"
local announce_in_chat = false

local local_player = Managers.player
if not local_player.is_server and not krenchMutationToken then
	EchoConsole("You must be the host to activate the "..display_name.." Mutation!")
	return
end

if Managers.state.game_mode == nil or (Managers.state.game_mode._game_mode_key ~= "inn" and local_player.is_server) then
	EchoConsole("You must be in the inn to activate the "..display_name.." Mutation!")
	return
end

if not krenchMutationToken then
	krenchMutationToken = true

	-- ##########################################################
	-- #################### Backup Variables ####################
	
	if not Backup_Breeds_skaven_storm_vermin_champion then
		Backup_Breeds_skaven_storm_vermin_champion = Breeds.skaven_storm_vermin_champion
	end
	
	if not Backup_Breeds_skaven_rat_ogre then
		Backup_Breeds_skaven_rat_ogre = Breeds.skaven_rat_ogre
	end
	
	-- ##########################################################
	-- #################### Modify Variables ####################
	
	-- Check for lack of spawn_group in this level
	Mods.hook.set(command_name, "BTSpawnAllies.enter", function (func, self, unit, blackboard, t)
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
					local result = func(self, unit, blackboard, t)
					return result
				else
					--EchoConsole("Problem finding spawn group to adopt.")
					self._activate_ward(self, unit, blackboard)
					return
				
				end
			else
				local result = func(self, unit, blackboard, t)
				return result
			end
	end)
	
	-- Catch nil spawning allies flag
	Mods.hook.set(command_name, "BTSpawnAllies.run", function (func, self, unit, blackboard, t, dt)
			if blackboard.spawning_allies == nil then
				return "done"
			else
				local result = func(self, unit, blackboard, t, dt)
				return result
			end
	end)
	
	-- Catch rare husk error
	Mods.hook.set(command_name, "AiBreedSnippets.on_storm_vermin_champion_husk_spawn", function (func, unit)
			if unit ~= nil then
				local actor = Unit.actor(unit, "c_trophy_rack_ward")
				if actor ~= nil then
					local result = func(unit)
					return result
				end
			end
			
			--EchoConsole("Nil champion husk unit or actor!")
			return
	end)
	
	if not Breeds.skaven_storm_vermin_champion.combat_spawn_stinger then
		Breeds.skaven_storm_vermin_champion.combat_spawn_stinger = "Play_enemy_stormvermin_champion_electric_floor"
	end
	Breeds.skaven_rat_ogre = Breeds.skaven_storm_vermin_champion
	
	-- ##########################################################
	
	if announce_in_chat then
		Managers.chat:send_system_chat_message(1, display_name.." Mutation ENABLED.", 0, true)
	else
		EchoConsole(display_name.." Mutation ENABLED.")
	end
	
else
	krenchMutationToken = false

	-- ##########################################################
	-- #################### Restore Variables ###################
	
	if Backup_Breeds_skaven_storm_vermin_champion then
		 Breeds.skaven_storm_vermin_champion = Backup_Breeds_skaven_storm_vermin_champion
	end
	
	if Backup_Breeds_skaven_rat_ogre then
		Breeds.skaven_rat_ogre = Backup_Breeds_skaven_rat_ogre
	end
	
	Mods.hook.enable(false, command_name, "BTSpawnAllies.enter")
	Mods.hook.enable(false, command_name, "BTSpawnAllies.run")
	Mods.hook.enable(false, command_name, "AiBreedSnippets.on_storm_vermin_champion_husk_spawn")
	
	-- ##########################################################
	
	if local_player.is_server then
		if announce_in_chat then
			Managers.chat:send_system_chat_message(1, display_name.." Mutation DISABLED.", 0, true)
		else
			EchoConsole(display_name.." Mutation DISABLED.")
		end
	end

end

Mods.hook.set(command_name, "MatchmakingManager.update", function(func, self, dt, t)
	-- Call original function
	func(self, dt, t)
	
	if not local_player.is_server and krenchMutationToken and Managers.state.game_mode ~= nil then
		Mods.exec("commands", command_name)
		EchoConsole("The "..display_name.." Mutation was disabled because you are no longer the server.")
	end
end)