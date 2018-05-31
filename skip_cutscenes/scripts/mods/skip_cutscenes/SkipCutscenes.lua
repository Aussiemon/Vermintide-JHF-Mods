--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Makes all cutscenes skippable, and handles fade out/in.
--]]

local mod = get_mod("SkipCutscenes")

-- ##########################################################
-- ################## Variables #############################

-- Variable to track the need to skip the fade effect
mod.skip_next_fade = false

-- ##########################################################
-- ################## Functions #############################

-- ##########################################################
-- #################### Hooks ###############################

-- Automatically skip cutscenes if necessary
mod:hook("CutsceneSystem.flow_cb_activate_cutscene_camera", function (func, self, ...)

	-- Skip cutscene if set to 'automatic'
	if mod:get("automatic") then
		mod.skip_next_fade = true
		return
	end
	
	return func(self, ...)
end)

-- Automatically skip cutscenes if necessary
mod:hook("CutsceneSystem.flow_cb_activate_cutscene_logic", function (func, self, player_input_enabled, event_on_activate, event_on_skip, ...)

	-- Skip cutscene if set to 'automatic'
	if mod:get("automatic") then
		if event_on_activate then
			local level = LevelHelper:current_level(self.world)
			Level.trigger_event(level, event_on_activate)
		end
		
		mod.skip_next_fade = true
		return
	end
		
	-- Original function
	return func(self, player_input_enabled, event_on_activate, event_on_skip, ...)
end)

-- Set up skip for fade effect
mod:hook("CutsceneSystem.skip_pressed", function (func, ...)
	
	mod.skip_next_fade = script_data.skippable_cutscenes and true
	
	-- Original function
	local result = func(...)
	return result
end)

-- Skip fade when applicable
mod:hook("CutsceneSystem.flow_cb_cutscene_effect", function (func, self, name, ...)
	
	if name == "fx_fade" and (mod.skip_next_fade) then
		mod.skip_next_fade = false
		return
	end
	
	-- Original function
	local result = func(self, name, ...)
	return result
end)

-- Don't restore player input if player already has active input
mod:hook("CutsceneSystem.flow_cb_deactivate_cutscene_logic", function (func, self, event_on_deactivate, ...)
	
	-- If a popup is open or cursor present, skip the input restore
	if ShowCursorStack.stack_depth > 0 or Managers.popup:has_popup() then
		if event_on_deactivate then
			local level = LevelHelper:current_level(self.world)
			Level.trigger_event(level, event_on_deactivate)
		end

		self.event_on_skip = nil
		return
	end
	
	-- Original function
	local result = func(self, event_on_deactivate, ...)
	return result
end)

-- Prevent invalid cursor pop crash if another mod interferes
mod:hook("ShowCursorStack.pop", function (func, ...)
	
	-- Catch a starting depth of 0 or negative cursors before pop
	if ShowCursorStack.stack_depth <= 0 then
		mod:echo("[Warning]: Attempt to remove non-existent cursor.")
		return
	end
	
	-- Original function
	local result = func(...)
	return result
end)

-- ##########################################################
-- ################### Callback #############################

-- Call when game state changes (e.g. StateLoading -> StateIngame)
mod.on_game_state_changed = function(status, state)
	mod.skip_next_fade = false
end

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(initial_call)
	if not initial_call then
		script_data.skippable_cutscenes = false
	end
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(initial_call)
	script_data.skippable_cutscenes = true
	mod:enable_all_hooks()
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
