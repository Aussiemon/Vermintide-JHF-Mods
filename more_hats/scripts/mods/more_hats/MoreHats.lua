--[[
	author: Aussiemon and IAmLupo
	
	-----
 
	Copyright 2018 Aussiemon and IAmLupo

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Makes selected hats equippable by other heroes, and allows total unequipping of hats.
--]]

local mod = get_mod("MoreHats")

-- ##########################################################
-- ################## Variables #############################

mod.players_nodes = {
	bright_wizard = {
		j_neck = true,
		j_spine2 = true,
		j_head = true,
		a_hat = false,
		j_leftshoulder = true,
		j_shoulder_level = true,
		j_rightshoulder = true,
	},
	wood_elf = {
		j_neck = true,
		j_spine2 = true,
		j_head = true,
		a_hat = false,
		j_leftshoulder = true,
		j_shoulder_level = false,
		j_rightshoulder = true,
	},
	dwarf_ranger = {
		j_neck = true,
		j_spine2 = true,
		j_head = true,
		a_hat = true,
		j_leftshoulder = true,
		j_shoulder_level = false,
		j_rightshoulder = true,
	},
	empire_soldier = {
		j_neck = true,
		j_spine2 = false,
		j_head = true,
		a_hat = true,
		j_leftshoulder = true,
		j_shoulder_level = false,
		j_rightshoulder = true,
	},
	witch_hunter = {
		j_neck = true,
		j_spine2 = true,
		j_head = true,
		a_hat = true,
		j_leftshoulder = true,
		j_shoulder_level = false,
		j_rightshoulder = true,
	},
}

-- ##########################################################
-- ################## Functions #############################

-- Build a list of hat attachment nodes
mod.get_all_hats_nodes = function()
	local list = {}
	
	local item_master_list = ItemMasterList
	local get_item_template = BackendUtils.get_item_template
	local table_clone = table.clone
	
	for item_name, item in pairs(item_master_list) do
		if item.item_type == "hat" then
			local hat_template = get_item_template(item)
			local attachment_node_linking = hat_template.attachment_node_linking
		
			if attachment_node_linking and attachment_node_linking.slot_hat then
				local slot_hat = attachment_node_linking.slot_hat
				
				list[item_name] = table_clone(slot_hat)
			end
		end
	end
	
	return list
end

-- Validate hats against nodes of players
mod.validate_hats = function(player_nodes, hat_nodes)
	for hat_name, node in pairs(hat_nodes) do
		if player_nodes[node.source] == false then
			return false
		end
	end
	
	return true
end

-- Patch ItemMasterList with updated 'can_wield' lists
mod.patch_hats = function(player_nodes)
	mod:pcall(function()
		local hats_nodes = mod.get_all_hats_nodes()
		
		for hat_name, hat_nodes in pairs(hats_nodes) do
			local new_list = {}
			
			-- Find valid characters that can wear the hat
			for player_name, player_nodes in pairs(mod.players_nodes) do
				if mod.validate_hats(player_nodes, hat_nodes) then
					table.insert(new_list, player_name)
				end
			end
			
			-- Patch the master item list with new list
			ItemMasterList[hat_name].can_wield = new_list
		end
	end)
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook("InventoryEquipmentUI.remove_inventory_item", function (func, self, item_data, specific_slot_index, ...)
	
	-- Original function
	local result = func(self, item_data, specific_slot_index, ...)
	
	-- Check for item data before search
	local selected_equipment_index = specific_slot_index
	local slots = InventorySettings.slots_by_inventory_button_index
	if not item_data then
		local equipment = self.current_equipment

		for i = 1, #slots, 1 do
			if i == selected_equipment_index then
				local equipped_item_backend_id = equipment[i]

				if not equipped_item_backend_id then
					return 
				end

				local item = ScriptBackendItem.get_item_from_id(equipped_item_backend_id)
				local item_key = item.key
				item_data = ItemMasterList[item_key]

				break
			end
		end
	end
	
	-- Check for item data after search
	if not item_data then
		return result
	end
	
	-- Check for equipment slot before search
	if not selected_equipment_index then
		local equipment = self.current_equipment
		local item_backend_id = item_data.backend_id

		for i = 1, #slots, 1 do
			local equipped_item_backend_id = equipment[i]

			if equipped_item_backend_id and equipped_item_backend_id == item_backend_id then
				selected_equipment_index = i

				break
			end
		end
	end
	
	-- Check for equipment slot after search
	if not selected_equipment_index then
		return result
	end
	
	-- Identify if this is an attempt to remove a hat
	local player_manager = self.player_manager
	local player = player_manager.player_from_peer_id(player_manager, self.peer_id)
	local player_profile_index = player.profile_index
	local unit = player.player_unit
	
	local profile_name = self.selected_profile_name(self)
	local selected_profile_index = FindProfileIndex(profile_name)
	local slot_type = item_data.slot_type
	local slot = slots[selected_equipment_index]
	local slot_name = slot.name

	-- Remove the hat
	if slot_type == "hat" then -- Do NOT change this line to unequip of weapons. You will crash loop on startup.
		if not mod:get("allow_unequip_wood_elf") and profile_name == "wood_elf" then
			mod:echo("Kerillian cannot remove her headgear.")
			return result
		end
	
		if player_profile_index == selected_profile_index then
			local attachment_extension = ScriptUnit.extension(unit, "attachment_system")

			attachment_extension.remove_attachment(attachment_extension, slot_name)
		end

		self.unequip_item(self, item_data, selected_equipment_index)
		BackendUtils.set_loadout_item(nil, profile_name, slot_name)

		self.current_equipment[selected_equipment_index] = nil

		self.play_sound(self, "Play_hud_inventory_drop_item")

		result = true
	end
	
	return result
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
	mod.patch_hats()
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
