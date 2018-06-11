--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Allows the user to toggle the "gling" sound on trait hits, as well as various other effects.
--]]

local mod = get_mod("SoundSettings")

-- ##########################################################
-- ################## Variables #############################

mod.LookupTable = {}

mod.LookupTable["Play_hud_trait_active"] = "disable_gling" -- Trait Buff SFX
mod.LookupTable["executioner_sword_critical"] = "disable_guillotine" -- Executioner Headshot SFX
mod.LookupTable["Play_hud_matchmaking_countdown"] = "disable_killing_blow" -- Killing Blow SFX

local Managers = Managers

local WwiseWorld = WwiseWorld

-- ##########################################################
-- ################## Functions #############################

-- Check for presence of inn or loading screen
mod.check_for_inn_or_loading = function()
	local managers = Managers
	if managers and managers.state and managers.state.game_mode then
		local level_key = managers.state.game_mode:level_key()
		if not level_key or level_key == "inn_level" then
			return true
		end
	else
		return true
	end
	
	return false
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook(WwiseWorld, "trigger_event", function (func, self, event_name, ...)
	local event = event_name
	if mod.LookupTable[event] and mod:get(mod.LookupTable[event]) then
		if not (event == "Play_hud_matchmaking_countdown" and mod.check_for_inn_or_loading()) then
			return
		end
	end
	
	return func(self, event_name, ...)
end)

-- ##########################################################
-- ################### Callback #############################

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
