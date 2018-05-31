--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Adds pub brawl access back to inn, with optional extras.
--]]

local mod = get_mod("PubBrawl")

-- ##########################################################
-- ################## Variables #############################

-- ##########################################################
-- ################## Functions #############################

mod.update_title_properties = function(is_brawl_enabled)
	if Managers.backend and Managers.backend._interfaces and Managers.backend._interfaces.title_properties then
		local title_properties = Managers.backend._interfaces.title_properties
		if not title_properties._data then
			title_properties._data = {
				brawl_enabled = is_brawl_enabled,
			}
		else
			title_properties._data.brawl_enabled = is_brawl_enabled
		end
	end
end

mod.spawn_brawl_swords_and_other_items = function()
	mod:pcall(function()
		if Managers.player.is_server then
		
			-- Wooden Pub Brawl swords on tables
			mod.spawn_inn_brawl_sword_01()
			mod.spawn_inn_brawl_sword_02()
			
			-- Grenade near ammo box
			mod.spawn_inn_grenade()
			
			-- Potions near forge and exit
			mod.spawn_inn_strength()
			mod.spawn_inn_speed()
		end
	end)
end

mod.spawn_inn_brawl_sword_01 = function()
	Pickups.level_events.wooden_sword_01.hud_description = "Wooden Sword"
	Managers.state.network.network_transmit:send_rpc_server(
		'rpc_spawn_pickup',
		NetworkLookup.pickup_names["wooden_sword_01"],
		Vector3(0.3, -4.3, 2.1),
		Quaternion.axis_angle(Vector3(5, 2, 3), 0.5),
		NetworkLookup.pickup_spawn_types['dropped']
	)
end

mod.spawn_inn_brawl_sword_02 = function()
	Pickups.level_events.wooden_sword_02.hud_description = "Wooden Sword"
	Managers.state.network.network_transmit:send_rpc_server(
		'rpc_spawn_pickup',
		NetworkLookup.pickup_names["wooden_sword_02"],
		Vector3(0.0, 0.4, 2),
		Quaternion.axis_angle(Vector3(5, 3, -8), .5),
		NetworkLookup.pickup_spawn_types['dropped']
	)
end

mod.spawn_inn_grenade = function()
	Managers.state.network.network_transmit:send_rpc_server(
		'rpc_spawn_pickup',
		NetworkLookup.pickup_names["frag_grenade_t2"],
		Vector3(3.0, 3.9, 2.1),
		Quaternion.axis_angle(Vector3(0, 0, 0), 0),
		NetworkLookup.pickup_spawn_types['dropped']
	)
end

mod.spawn_inn_strength = function()
	Managers.state.network.network_transmit:send_rpc_server(
		'rpc_spawn_pickup',
		NetworkLookup.pickup_names["damage_boost_potion"],
		Vector3(6.41, -3.15, 1.3),
		Quaternion.axis_angle(Vector3(0, 0, 0), 0),
		NetworkLookup.pickup_spawn_types['dropped']
	)
end

mod.spawn_inn_speed = function()
	Managers.state.network.network_transmit:send_rpc_server(
		'rpc_spawn_pickup',
		NetworkLookup.pickup_names["speed_boost_potion"],
		Vector3(-7.8, -4.7, 1.7),
		Quaternion.axis_angle(Vector3(0, 0, 0), 0),
		NetworkLookup.pickup_spawn_types['dropped']
	)
end

-- ##########################################################
-- #################### Hooks ###############################

-- Re-enables the flow event that causes Lohner to pour a drink when approached
mod:hook("GameModeManager.pvp_enabled", function (func, self, ...)
	
	-- Changes here:
	if mod:is_enabled() and Managers.state.game_mode and Managers.state.game_mode._game_mode_key == "inn" then
		return true
	end
	-- Changes end.
	
	local result = func(self, ...)
	return result
end)

-- ##########################################################
-- ################### Callback #############################

-- Call when game state changes (e.g. StateLoading -> StateIngame)
mod.on_game_state_changed = function(status, state)
	if mod:is_enabled() and state == "StateIngame" and mod:get("additional_items") and Managers.player.is_server then
		if Managers.state.game_mode and Managers.state.game_mode._game_mode_key == "inn" then
			
			-- Spawn items
			local pickup_system = Managers.state.entity:system("pickup_system")
			if #pickup_system._spawned_pickups < 4 then
				mod.spawn_brawl_swords_and_other_items()
			end
		end
	end
end

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(initial_call)
	if not initial_call then
		mod.update_title_properties(false)
	end
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(initial_call)
	mod:enable_all_hooks()
	mod.update_title_properties(true)
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
