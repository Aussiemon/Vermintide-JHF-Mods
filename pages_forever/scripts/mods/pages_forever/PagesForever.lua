--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Allows the pickup of lorebook pages (that do nothing) after they've all been unlocked. Allows prevention of sackrat lorebook drops.
--]]

local mod = get_mod("PagesForever")

-- ##########################################################
-- ################## Variables #############################

-- ##########################################################
-- ################## Functions #############################

mod.redo_sackrat_weights = function()
	local loot_rat_pickups = LootRatPickups
	local total_loot_rat_spawn_weighting = 0
	
	for pickup_name, spawn_weighting in pairs(loot_rat_pickups) do
		total_loot_rat_spawn_weighting = total_loot_rat_spawn_weighting + spawn_weighting
	end

	for pickup_name, spawn_weighting in pairs(loot_rat_pickups) do
		LootRatPickups[pickup_name] = spawn_weighting/total_loot_rat_spawn_weighting
	end
end

mod.set_sackrat_pages = function(enabled)
	-- Enable sackrat pages
	if enabled then
		LootRatPickups = {
			first_aid_kit = 3,
			healing_draught = 2,
			damage_boost_potion = 1,
			speed_boost_potion = 1,
			frag_grenade_t2 = 1,
			fire_grenade_t2 = 1,
			loot_die = 4,
			lorebook_page = 4
		}
		mod.redo_sackrat_weights()
	
	-- Disable sackrat pages
	else
		LootRatPickups = {
			first_aid_kit = 3,
			healing_draught = 2,
			damage_boost_potion = 1,
			speed_boost_potion = 1,
			frag_grenade_t2 = 1,
			fire_grenade_t2 = 1,
			loot_die = 4,
		}
		mod.redo_sackrat_weights()
	end
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook("Pickups.lorebook_pages.lorebook_page.hide_func", function (func, ...)
	
	if mod:get("show_lorebook_pages") then
		-- Do not hide lorebook pages
		return false
	end
	
	-- Return original result
	local result = func(...)
	return result
end)

-- ##########################################################
-- ################### Callback #############################

-- Call when game state changes (e.g. StateLoading -> StateIngame)
mod.on_game_state_changed = function(status, state)
	if mod:is_enabled() then
		-- Put loot rat pages setting into effect
		mod.set_sackrat_pages(not mod:get("sackrat_pages_disabled"))
	end
end

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_name)
	if mod:is_enabled() and setting_name == "sackrat_pages_disabled" then
	
		-- Put loot rat pages setting into effect
		mod.set_sackrat_pages(not mod:get("sackrat_pages_disabled"))
	end
end

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(initial_call)
	if not initial_call then
		mod.set_sackrat_pages(true)
	end
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(initial_call)
	mod:enable_all_hooks()
	mod.set_sackrat_pages(not mod:get("sackrat_pages_disabled"))
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
