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

local this_completion = 0
local total_completed = 0
local translated_name = ""
local user_name = ""

local send_all = false -- Change to false to never publicly display level completion stats
if Managers.chat then
	if local_player._cached_name ~= nil then
		user_name = local_player._cached_name
	end
else
	send_all = false
end

if send_all then
	Managers.chat:send_system_chat_message(1, "------------------------------", 0, true)
	if user_name ~= "" then
		Managers.chat:send_system_chat_message(1, (user_name .. "'s Mission Completions"), 0, true)
	else
		Managers.chat:send_system_chat_message(1, ("Mission Completions"), 0, true)
	end
	Managers.chat:send_system_chat_message(1, "------------------------------", 0, true)
else
	EchoConsole("------------------------------")
	EchoConsole("Mission Completions")
	EchoConsole("------------------------------")
end

for _, level_name in ipairs(UnlockableLevels) do

	if level_name == "magnus" then
		translated_name = "Horn of Magnus"
		
	elseif level_name == "merchant" then
		translated_name = "Supply and Demand"
		
	elseif level_name == "wizard" then
		translated_name = "Wizard's Tower"
		
	elseif level_name == "sewers_short" then
		translated_name = "Smuggler's Run"
		
	elseif level_name == "farm" then
		translated_name = "Wheat and Chaff"
		
	elseif level_name == "bridge" then
		translated_name = "Black Powder"
		
	elseif level_name == "forest_ambush" then
		translated_name = "Engines of War"
		
	elseif level_name == "cemetery" then
		translated_name = "Garden of Morr"
		
	elseif level_name == "courtyard_level" then
		translated_name = "Well Watch"
		
	elseif level_name == "end_boss" then
		translated_name = "White Rat"
		
	elseif level_name == "tunnels" then
		translated_name = "Enemy Below"
		
	elseif level_name == "city_wall" then
		translated_name = "Man the Ramparts"
		
	elseif level_name == "docks_short_level" then
		translated_name = "Waterfront"
		
	elseif level_name == "dlc_survival_ruins" then
		translated_name = "The Fall"
		
	elseif level_name == "dlc_survival_magnus" then
		translated_name = "Town Meeting"
		
	elseif level_name == "dlc_portals" then
		translated_name = "Summoner's Peak"
		
	elseif level_name == "dlc_castle" then
		translated_name = "Castle Drachenfels"
		
	elseif level_name == "dlc_castle_dungeon" then
		translated_name = "The Dungeons"
		
	elseif level_name == "dlc_dwarf_beacons" then
		translated_name = "Chain of Fire"
		
	elseif level_name == "dlc_dwarf_exterior" then
		translated_name = "Cursed Rune"
		
	elseif level_name == "dlc_dwarf_interior" then
		translated_name = "Khazid Kro"
		
	elseif level_name == "dlc_stromdorf_hills" then
		translated_name = "The Courier"
		
	elseif level_name == "dlc_stromdorf_town" then
		translated_name = "Reaching Out"
		
	else
		translated_name = level_name
	end
	
	this_completion = stat_db.get_persistent_stat(stat_db, stats_id, "completed_levels", level_name)
	total_completed = total_completed + this_completion
	
	local survival_level_name = nil
	local this_total_kills = nil
	local this_veteran_waves = nil
	local this_champion_waves = nil
	local this_heroic_waves = nil
	
	if level_name == "dlc_survival_ruins" then
		survival_level_name = "ruins"
	elseif level_name == "dlc_survival_magnus" then
		survival_level_name = "magnus"
	end
	
	if survival_level_name then
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
	end
	
	if send_all then
		if not survival_level_name then
			Managers.chat:send_system_chat_message(1, (translated_name .. ": " .. this_completion), 0, true)
		else
			Managers.chat:send_system_chat_message(1, (translated_name .. ": " .. this_total_kills .. " kills, (" .. this_veteran_waves .. ", " .. this_champion_waves .. ", " .. this_heroic_waves .. ") best waves"), 0, true)
		end
	else
		if not survival_level_name then
			EchoConsole(translated_name .. ": " .. this_completion)
		else
			EchoConsole(translated_name .. ": " .. this_total_kills .. " kills, (" .. this_veteran_waves .. ", " .. this_champion_waves .. ", " .. this_heroic_waves .. ") best waves")
		end
	end
end

local total_badges = stat_db.get_persistent_stat(stat_db, stats_id, "endurance_badges")

if send_all then
	Managers.chat:send_system_chat_message(1, ("Total Completions: " .. total_completed), 0, true)
	Managers.chat:send_system_chat_message(1, ("Total Endurance Badges: " .. total_badges), 0, true)
	Managers.chat:send_system_chat_message(1, ("------------------------------"), 0, true)
else
	EchoConsole("Total Completions: " .. total_completed)
	EchoConsole("Total Endurance Badges: " .. total_badges)
	EchoConsole("------------------------------")
end