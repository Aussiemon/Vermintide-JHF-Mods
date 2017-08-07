--[[
	author: Aussiemon
 
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Reports number of unlocked Lorebook pages for each level. Levels without pages are included in case of future additions.
--]]

local command_name = "lorebook"

-- ##########################################################
-- #################### Tables ##############################

-- Level Key to Level Name Lookup Table
mod.LevelKeyLookups = {
	magnus = "Horn of Magnus",
	merchant = "Supply and Demand",
	sewers_short = "Smuggler's Run",
	wizard = "Wizard's Tower",
	bridge = "Black Powder",
	forest_ambush = "Engines of War",
	city_wall = "Man the Ramparts",
	cemetery = "Garden of Morr",
	farm = "Wheat and Chaff",
	tunnels = "Enemy Below",
	courtyard_level = "Well Watch",
	docks_short_level = "Waterfront",
	end_boss = "White Rat",
	dlc_castle = "Castle Drachenfels",
	dlc_castle_dungeon = "The Dungeons",
	dlc_portals = "Summoner's Peak",
	dlc_dwarf_interior = "Khazid Kro",
	dlc_dwarf_exterior = "Cursed Rune",
	dlc_dwarf_beacons = "Chain of Fire",
	dlc_stromdorf_hills = "The Courier",
	dlc_stromdorf_town = "Reaching Out",
	dlc_challenge_wizard = "Trial of the Foolhardy",
	dlc_survival_magnus = "Town Meeting",
	dlc_survival_ruins = "The Fall"
}

-- Array of ordered keys for proper printing order
mod.LevelKeyArray = {
	"magnus",
	"merchant",
	"sewers_short",
	"wizard",
	"bridge",
	"forest_ambush",
	"city_wall",
	"cemetery",
	"farm",
	"tunnels",
	"courtyard_level",
	"docks_short_level",
	"end_boss",
	"dlc_castle",
	"dlc_castle_dungeon",
	"dlc_portals",
	"dlc_dwarf_interior",
	"dlc_dwarf_exterior",
	"dlc_dwarf_beacons",
	"dlc_stromdorf_hills",
	"dlc_stromdorf_town",
	"dlc_challenge_wizard",
	"dlc_survival_magnus",
	"dlc_survival_ruins"
}

-- ##########################################################
-- #################### Script ##############################

safe_pcall(function()

	local output_string = ""
	if not Managers.player then
		EchoConsole("Please wait: stats not yet loaded!")
		return
	end

	local local_player = Managers.player:local_player()
	if not local_player then
		EchoConsole("Please wait: stats not yet loaded!")
		return
	end

	local stat_db = Managers.player:statistics_db()
	if not stat_db then
		EchoConsole("Please wait: stats not yet loaded!")
		return
	end

	local stats_id = local_player.stats_id(local_player)
	if not stats_id then
		EchoConsole("Please wait: stats not yet loaded!")
		return
	end
	
	-- ############## Begin String Format ########################

	output_string = output_string .. "\n"
	
	local total_page_count = 0
	local total_unlock_count = 0
	
	local line_count = 0
	local total_count = 0

	-- Get listing for each level
	for _, level_key in pairs(mod.LevelKeyArray) do
	
		line_count = line_count + 1
		total_count = total_count + 1
	
		local pages = table.clone(LorebookCollectablePages[level_key])
		local num_pages = #pages
		total_page_count = total_page_count + num_pages
		local unlocked_count = 0
		
		for i = 1, num_pages, 1 do
			local category_name = pages[i]
			local page_id = LorebookCategoryLookup[category_name]
			local persistent_unlocked = stat_db.get_persistent_array_stat(stat_db, stats_id, "lorebook_unlocks", page_id)

			if persistent_unlocked then
				unlocked_count = unlocked_count + 1
			end
		end
		
		total_unlock_count = total_unlock_count + unlocked_count
		
		if line_count > 3 then
			line_count = 1
			output_string = output_string .. "\n"
		end
		
		-- Create line and append
		output_string = output_string .. mod.LevelKeyLookups[level_key]..": "..unlocked_count.."/"..num_pages
		
		if line_count < 3 and total_count ~= (#mod.LevelKeyArray) then
			output_string = output_string .. ",  "
		end
	end

	-- Include the pages that may be found on any level
	local any_level_pages = table.clone(LorebookCollectablePages.any)
	local num_any_pages = #any_level_pages
	local unlocked_any_count = 0

	for i = 1, num_any_pages, 1 do
		local category_name = any_level_pages[i]
		local page_id = LorebookCategoryLookup[category_name]
		local persistent_unlocked = stat_db.get_persistent_array_stat(stat_db, stats_id, "lorebook_unlocks", page_id)

		if persistent_unlocked then
			unlocked_any_count = unlocked_any_count + 1
		end
	end
	
	total_page_count = total_page_count + num_any_pages
	total_unlock_count = total_unlock_count + unlocked_any_count
	
	-- Finalize
	output_string = output_string .. "\n" .. "Any Level: "..unlocked_any_count.."/"..num_any_pages
	output_string = output_string .. "\n" .. "Total Unlocked: "..total_unlock_count.."/"..total_page_count
	
	-- ############## End String Format ########################
	
	-- Initialize simple popup manager if necessary
	if not Managers.simple_popup then
		Managers.simple_popup = SimplePopup:new()
	end
	
	-- Start closing chat window and transfer input
	local chat_manager = Managers.chat
	local chat_gui = chat_manager.chat_gui
	chat_gui:unblock_input(false)
	chat_gui.chat_closed = true
	chat_gui.chat_focused = false
	chat_gui.chat_close_time = 0
	chat_gui:clear_current_transition()
	chat_gui:set_menu_transition_fraction(0)
	chat_gui:_set_chat_window_alpha(1)
	chat_gui.tab_widget.style.button_notification.color[1] = UISettings.chat.tab_notification_alpha_1

	-- Display popup
	local simple_popup = Managers.simple_popup
	simple_popup.queue_popup(simple_popup, output_string, "Lorebook Unlocks", "accept", "Close")
	
	-- Resize popup font to fit small display window
	local popup_manger = Managers.popup
	local popup_handler = popup_manger._handler
	local n_popups = popup_handler.n_popups
	local popup = popup_handler.popups[n_popups]
	popup.text_font_size = 16
	
end)

-- ##########################################################
-- ##########################################################
