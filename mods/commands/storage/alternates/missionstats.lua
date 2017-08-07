--[[
	author: Aussiemon
 
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Reports number of completed attempts for each level.
--]]

local command_name = "missionstats"

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

-- Lookup table for the prefixes under which Last Stand stats are stored
mod.SurvivalLevelPrefixes = {
	dlc_survival_ruins = "ruins",
	dlc_survival_magnus = "magnus",
	length = 2
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

	local total_completed = 0
	local user_name = ""

	local send_all = true -- Change to false to never publicly display level completion stats
	if Managers.chat then
		if local_player._cached_name ~= nil then
			user_name = local_player._cached_name
		end
	else
		send_all = false
	end
	
	-- ############## Begin String Format ########################

	if send_all then
		Managers.chat:send_system_chat_message(1, "------------------------------", 0, true)
		if user_name ~= "" then
			Managers.chat:send_system_chat_message(1, (user_name .. "'s Mission Completions"), 0, true)
		else
			Managers.chat:send_system_chat_message(1, ("Mission Completions"), 0, true)
		end
		Managers.chat:send_system_chat_message(1, "------------------------------", 0, true)
	end
	
	output_string = output_string .. "\n"
	
	local line_count = 0
	local total_count = 0
	local stored_survival_lines = ""

	-- Get listing for each level
	for _, level_name in pairs(mod.LevelKeyArray) do
	
		line_count = line_count + 1
		total_count = total_count + 1

		local translated_name = mod.LevelKeyLookups[level_name] or level_name
		
		-- If this is a Last Stand map, retrieve the prefix used in the stats database
		local survival_level_name = nil
		if mod.SurvivalLevelPrefixes[level_name] then
			survival_level_name = mod.SurvivalLevelPrefixes[level_name]
		end
		
		-- Format statistics into a line to append to the total output
		if survival_level_name then
		
			-- Last Stand mission
			local this_total_kills = nil
			local this_veteran_waves = nil
			local this_champion_waves = nil
			local this_heroic_waves = nil
			
			this_total_kills = 
				stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_hard_kills")) 
				+ stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_harder_kills")) 
				+ stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_hardest_kills"))
			this_veteran_waves = 
				stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_hard_waves")) 
			this_champion_waves =
				stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_harder_waves")) 
			this_heroic_waves =
				stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_hardest_waves"))
				
			line_count = line_count - 1
		
			-- Line is stored for printing after regular mission stats
			stored_survival_lines = stored_survival_lines .. "\n" .. translated_name .. ": " .. this_total_kills .. " kills, (" .. this_veteran_waves .. ", " .. this_champion_waves .. ", " .. this_heroic_waves .. ") best waves"
			
			if send_all then
				Managers.chat:send_system_chat_message(1, (translated_name .. ": " .. this_total_kills .. " kills, (" .. this_veteran_waves .. ", " .. this_champion_waves .. ", " .. this_heroic_waves .. ") best waves"), 0, true)
			end
		else
		
			-- Regular mission
			local this_completion = stat_db.get_persistent_stat(stat_db, stats_id, "completed_levels", level_name) or 0
			total_completed = total_completed + this_completion
			
			if line_count > 3 then
				line_count = 1
				output_string = output_string .. "\n"
			end
			
			-- Line is appended immediately
			output_string = output_string .. translated_name .. ": " .. this_completion
			
			if line_count < 3 and total_count ~= (#mod.LevelKeyArray - mod.SurvivalLevelPrefixes.length) then
				output_string = output_string .. ",  "
			end
			
			if send_all then
				Managers.chat:send_system_chat_message(1, (translated_name .. ": " .. this_completion), 0, true)
			end
		end
	end

	local total_badges = stat_db.get_persistent_stat(stat_db, stats_id, "endurance_badges")

	if send_all then
		Managers.chat:send_system_chat_message(1, ("Total Completions: " .. total_completed), 0, true)
		Managers.chat:send_system_chat_message(1, ("Total Endurance Badges: " .. total_badges), 0, true)
		Managers.chat:send_system_chat_message(1, ("------------------------------"), 0, true)
	end
	
	-- Re-add Last Stand lines
	output_string = output_string .. stored_survival_lines
	
	-- Finalize
	output_string = output_string .. "\n" .. "Total Completions: " .. total_completed
	output_string = output_string .. "\n" .. "Total Endurance Badges: " .. total_badges
	
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
	simple_popup.queue_popup(simple_popup, output_string, "Mission Stats", "accept", "Close")
	
	-- Resize popup font to fit small display window
	local popup_manger = Managers.popup
	local popup_handler = popup_manger._handler
	local n_popups = popup_handler.n_popups
	local popup = popup_handler.popups[n_popups]
	popup.text_font_size = 17
	
end)

-- ##########################################################
-- ##########################################################
