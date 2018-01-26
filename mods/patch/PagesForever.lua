--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Allows the pickup of lorebook pages (that don't do anything) after they've all been unlocked. Also allows restriction of lorebook sackrat drops after they've all been unlocked.
--]]

local mod_name = "PagesForever"

-- ##########################################################
-- ################## Variables #############################

PagesForever = {
	SETTINGS = {
		ACTIVE = {
		["save"] = "cb_lorebook_pages_forever",
		["widget_type"] = "stepper",
		["text"] = "Lorebook Pages Forever - Enabled",
		["tooltip"] =  "Lorebook Pages Forever\n" ..
			"Toggle lorebook pages appearing post-unlock on / off.\n\n" ..
			"Allows you to see and interact with lorebook pages after they've been unlocked, if only for the joy of picking them up.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
		SACKRAT = {
		["save"] = "cb_lorebook_pages_forever_sackrat_drops",
		["widget_type"] = "stepper",
		["text"] = "Prevent Sackrat Pages",
		["tooltip"] =  "Disable Sackrat Pages Post-Unlock\n" ..
			"Toggle the drop of sackrat lorebook pages on / off.\n\n" ..
			"Sackrat lorebook page drops will be disabled when all pages are unlocked.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
	}
}

local mod = PagesForever

-- ##########################################################
-- ################## Functions #############################

local get = function(data)
	return Application.user_setting(data.save)
end
local set = Application.set_user_setting
local save = Application.save_user_settings

mod.create_options = function()
	Mods.option_menu:add_group("pages_forever", "Lorebook Pages Forever")
	Mods.option_menu:add_item("pages_forever", mod.SETTINGS.ACTIVE, true)
	Mods.option_menu:add_item("pages_forever", mod.SETTINGS.SACKRAT, true)
end

mod.redo_sackrat_weights = function()
	local total_loot_rat_spawn_weighting = 0
	for pickup_name, spawn_weighting in pairs(LootRatPickups) do
		total_loot_rat_spawn_weighting = total_loot_rat_spawn_weighting + spawn_weighting
	end

	for pickup_name, spawn_weighting in pairs(LootRatPickups) do
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

Mods.hook.set(mod_name, "Pickups.lorebook_pages.lorebook_page.hide_func", function (func, ...)
	
	-- Change sackrat drops if necessary
	local result = func(...)
	if get(mod.SETTINGS.SACKRAT) and LootRatPickups["lorebook_page"] then
		mod.set_sackrat_pages(false)
		
	-- Restore sackrat drops to default if necessary
	elseif not (LootRatPickups["lorebook_page"] or get(mod.SETTINGS.SACKRAT)) then
		mod.set_sackrat_pages(true)
	end
	
	if get(mod.SETTINGS.ACTIVE) then
		-- Show lorebook pages
		return false
	end
	
	-- Return original result
	return result
end)

-- ##########################################################
-- #################### Script ##############################

mod.create_options()

-- ##########################################################
