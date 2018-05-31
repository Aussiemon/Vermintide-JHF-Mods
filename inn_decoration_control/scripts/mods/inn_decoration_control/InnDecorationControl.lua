--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Allows client-side control over decorations displayed in the Red Moon Inn.
--]]

local mod = get_mod("InnDecorationControl")

-- ##########################################################
-- ################## Variables #############################

-- ##########################################################
-- ################## Functions #############################

mod.check_for_inn_level = function()
	local state_manager = Managers.state
	local level_key = state_manager.game_mode and state_manager.game_mode:level_key()
	if level_key and level_key == "inn_level" then
		return true
	end
	return false
end

-- ##########################################################
-- #################### Hooks ###############################

-- Control over general state of Red Moon Inn by main game act
mod:hook("flow_callback_get_current_inn_level_progression", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		return_table.progression_step = math.min(return_table.progression_step, (mod:get("main_game") or 99))
	end
	
	return return_table
end)

-- Control over banner decorations by difficulty
mod:hook("flow_callback_get_completed_game_difficulty", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (mod:get("difficulty_banner") or 99))
	end
	
	return return_table
end)

-- Control over Drachenfels decorations by difficulty
mod:hook("flow_callback_get_completed_drachenfels_difficulty", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (mod:get("drachenfels") or 99))
	end
	
	return return_table
end)

-- Control over Karak Azgaraz decorations by difficulty
mod:hook("flow_callback_get_completed_dwarf_levels_difficulty", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (mod:get("dwarfs") or 99))
	end
	
	return return_table
end)

-- Control over Stromdorf, Reik decorations by difficulty
mod:hook("flow_callback_get_completed_dlc_levels_difficulty", function (func, params, ...)
	
	local return_table = func(params, ...)
	if params and params.dlc and mod.check_for_inn_level() then
		return_table.completed_difficulty = math.min(return_table.completed_difficulty, (mod:get(params.dlc) or 99))
	end
	
	return return_table
end)

-- Control over Last Stand decorations by waves surpassed
mod:hook("flow_callback_get_completed_survival_waves", function (func, ...)
	
	local return_table = func(...)
	if mod.check_for_inn_level() then
		local town_meeting_setting = (mod:get("town_meeting") or 99) * 13
		if return_table.dlc_survival_magnus and town_meeting_setting < 39 then
			return_table.dlc_survival_magnus = math.min(return_table.dlc_survival_magnus, town_meeting_setting)
		end
		
		local fall_setting = (mod:get("fall") or 99) * 13
		if return_table.dlc_survival_ruins and fall_setting < 39 then
			return_table.dlc_survival_ruins = math.min(return_table.dlc_survival_ruins, fall_setting)
		end
	end
	
	return return_table
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
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
