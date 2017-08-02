--[[
	author: Aussiemon
 
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Reports lorebook unlock stats to the user.
--]]

local command_name = "lorebook"

if not mod.LevelKeyLookups then
	mod.LevelKeyLookups = {
		magnus = "Horn of Magnus",
		merchant = "Supply and Demand",
		wizard = "Wizard's Tower",
		sewers_short = "Smuggler's Run",
		farm = "Wheat and Chaff",
		bridge = "Black Powder",
		forest_ambush = "Engines of War",
		cemetery = "Garden of Morr",
		courtyard_level = "Well Watch",
		end_boss = "White Rat",
		tunnels = "Enemy Below",
		city_wall = "Man the Ramparts",
		docks_short_level = "Waterfront",
		dlc_survival_ruins = "The Fall",
		dlc_survival_magnus = "Town Meeting",
		dlc_portals = "Summoner's Peak",
		dlc_castle = "Castle Drachenfels",
		dlc_castle_dungeon = "The Dungeons",
		dlc_dwarf_beacons = "Chain of Fire",
		dlc_dwarf_exterior = "Cursed Rune",
		dlc_dwarf_interior = "Khazid Kro",
		dlc_stromdorf_hills = "The Courier",
		dlc_stromdorf_town = "Reaching Out",
		dlc_challenge_wizard = "Trials of the Foolhardy",
	}
end

safe_pcall(function()
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

	EchoConsole("------------------------------")
	EchoConsole("Lorebook Unlocks")
	EchoConsole("------------------------------")
	
	local total_count = 0
	local total_unlock_count = 0

	for level_key, _ in pairs(mod.LevelKeyLookups) do
		local pages = table.clone(LorebookCollectablePages[level_key])
		local num_pages = #pages
		total_count = total_count + num_pages
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
		EchoConsole(mod.LevelKeyLookups[level_key]..": "..unlocked_count.."/"..num_pages)
	end

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
	
	total_count = total_count + num_any_pages

	total_unlock_count = total_unlock_count + unlocked_any_count
	EchoConsole("Any Level: "..unlocked_any_count.."/"..num_any_pages)
	EchoConsole("Total Unlocked: "..total_unlock_count.."/"..total_count)
	EchoConsole("------------------------------")
end)