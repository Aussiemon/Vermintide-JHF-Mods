--[[
	author: Aussiemon (contains modifications to code orginally written by Grimalackt)
 
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Replaces ogres with Krench the Stormvermin Champion/Chieftain
--]]

local command_name = "krenchtation"

local local_player = Managers.player

if not local_player.is_server and not krenchtationToken then
	EchoConsole("You must be the host to activate the Krench Mutation.")
	return
end

if Managers.state.game_mode == nil or (Managers.state.game_mode._game_mode_key ~= "inn" and local_player.is_server) then
	EchoConsole("You must be in the inn to run the Krench Mutation!")
	return
end

if not krenchtationToken then
	krenchtationToken = true

-- Backup variables

if not Backup_Breeds_skaven_storm_vermin_champion then
	Backup_Breeds_skaven_storm_vermin_champion = Breeds.skaven_storm_vermin_champion
end

if not Backup_Breeds_skaven_rat_ogre then
	Backup_Breeds_skaven_rat_ogre = Breeds.skaven_rat_ogre
end

if not Backup_BTSpawnAllies_enter then
	Backup_BTSpawnAllies_enter = BTSpawnAllies.enter
end

if not Backup_BTSpawnAllies_run then
	Backup_BTSpawnAllies_run = BTSpawnAllies.run
end

-- Modify variables

--[[
"Spawn allies" action causes the game to crash if there are no spawn points.
These hooks prevent the action from firing if necessary, while still allowing the ward to activate.
--]]

if not BTSpawnAllies_enter_hooked then
	Mods.hook.set(command_name, "BTSpawnAllies.enter", function (func, self, unit, blackboard, t)
				local action = self._tree_node.action_data
				local spawn_group = action.spawn_group
				local spawner_system = Managers.state.entity:system("spawner_system")
				if spawner_system._id_lookup[spawn_group] == nil then
					self._activate_ward(self, unit, blackboard)
					return
				else
					local result = func(self, unit, blackboard, t)
					return result
				end
		end)
	BTSpawnAllies_enter_hooked = true
end

if not BTSpawnAllies_run_hooked then
	Mods.hook.set(command_name, "BTSpawnAllies.run", function (func, self, unit, blackboard, t, dt)
				if blackboard.spawning_allies == nil then
					return "done"
				else
					local result = func(self, unit, blackboard, t, dt)
					return result
				end
		end)
	BTSpawnAllies_run_hooked = true
end

Breeds.skaven_rat_ogre = Breeds.skaven_storm_vermin_champion
Breeds.skaven_rat_ogre.combat_spawn_stinger = "Play_enemy_stormvermin_champion_electric_floor"

EchoConsole("Krench Mutation ENABLED.")


else
	krenchtationToken = false

-- Restore variables if backup exists

if Backup_Breeds_skaven_storm_vermin_champion then
	 Breeds.skaven_storm_vermin_champion = Backup_Breeds_skaven_storm_vermin_champion
end

if Backup_Breeds_skaven_rat_ogre then
	Breeds.skaven_rat_ogre = Backup_Breeds_skaven_rat_ogre
end

if Backup_BTSpawnAllies_enter then
	BTSpawnAllies.enter = Backup_BTSpawnAllies_enter
	BTSpawnAllies_enter_hooked = false
end

if Backup_BTSpawnAllies_run then
	BTSpawnAllies.run = Backup_BTSpawnAllies_run
	BTSpawnAllies_run_hooked = false
end

EchoConsole("Krench Mutation DISABLED.")

end

-- Make sure player is still the host

if not Backup_MatchmakingManager_update then
	Backup_MatchmakingManager_update = MatchmakingManager.update
end

MatchmakingManager.update = function (self, dt, t)
	-- Call original function
	Backup_MatchmakingManager_update(self, dt, t)
	
	if not local_player.is_server and krenchtationToken and Managers.state.game_mode ~= nil then
		Mods.exec("commands", "krenchtation")
		EchoConsole("The Krench Mutation was disabled because you are no longer the host.")
	end
end