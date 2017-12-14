--[[
	author: Aussiemon
	
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Adds pub brawl access back to inn.
--]]

local mod_name = "PubBrawl"

-- ##########################################################
-- ################## Variables #############################

PubBrawl = {
	SETTINGS = {
		ACTIVE = {
			["save"] = "cb_pub_brawl_enabled",
			["widget_type"] = "stepper",
			["text"] = "Pub Brawl - Enabled",
			["tooltip"] = "Pub Brawl\n" ..
				"Toggle pub brawl on / off.\n\n" ..
				"Re-enables Fatshark's pub brawl in the inn.",
			["value_type"] = "boolean",
			["options"] = {
				{text = "Off", value = false},
				{text = "On", value = true}
			},
			["default"] = 1, -- Default first option is enabled. In this case Off
		},
		ADDITIONAL_ITEMS = {
			["save"] = "cb_pub_brawl_additional_items",
			["widget_type"] = "stepper",
			["text"] = "Additional Items",
			["tooltip"] = "Additional Items\n" ..
				"Toggle additional item spawning on / off.\n\n" ..
				"Adds wooden swords, a bomb, and potions to the inn.",
			["value_type"] = "boolean",
			["options"] = {
				{text = "Off", value = false},
				{text = "On", value = true}
			},
			["default"] = 1, -- Default first option is enabled. In this case Off
		},
	},
}

local mod = PubBrawl

-- ##########################################################
-- ################## Functions #############################

mod.create_options = function()
	Mods.option_menu:add_group("pub_brawl", "Pub Brawl")
	Mods.option_menu:add_item("pub_brawl", mod.SETTINGS.ACTIVE, true)
	Mods.option_menu:add_item("pub_brawl", mod.SETTINGS.ADDITIONAL_ITEMS, true)
end

mod.update_title_properties = function()
	if Managers.backend and Managers.backend._interfaces and Managers.backend._interfaces.title_properties then
		local title_properties = Managers.backend._interfaces.title_properties
		if not title_properties._data then
			title_properties._data = {
				brawl_enabled = true,
			}
		else
			title_properties._data.brawl_enabled = true
		end
	end
end

mod.spawn_brawl_swords_and_other_items = function()
	safe_pcall(function()
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

local get = function(data)
	if data then
		return Application.user_setting(data.save)
	end
end
local set = Application.set_user_setting
local save = Application.save_user_settings

-- ##########################################################
-- #################### Hooks ###############################

-- Re-enables the flow event that causes Lohner to pour a drink when approached
Mods.hook.set(mod_name, "GameModeManager.pvp_enabled", function (func, self)
	
	-- Changes here:
	if get(mod.SETTINGS.ACTIVE) and Managers.state.game_mode and Managers.state.game_mode._game_mode_key == "inn" then
		return true
	end
	-- Changes end.
	
	local result = func(self)
	return result
end)

-- Handles initial spawning of pub items
Mods.hook.set(mod_name, "StateInGameRunning.event_game_started", function(func, self)
	func(self)
	
	if get(mod.SETTINGS.ACTIVE) and get(mod.SETTINGS.ADDITIONAL_ITEMS) and Managers.player.is_server then
		if Managers.state.game_mode and Managers.state.game_mode._game_mode_key == "inn" then
			
			-- Spawn items
			local pickup_system = Managers.state.entity:system("pickup_system")
			if #pickup_system._spawned_pickups < 4 then
				mod.spawn_brawl_swords_and_other_items()
			end
		end
	end
end)

-- ##########################################################
-- ################### Script ###############################

mod.create_options()
if get(mod.SETTINGS.ACTIVE) then
	mod.update_title_properties()
end

-- ##########################################################
