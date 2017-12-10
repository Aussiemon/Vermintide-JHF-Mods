--[[
	author: Aussiemon
	
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Restores variety to the Red Moon Inn loading screens.
--]]

local mod_name = "RedMoonVariety"

-- ##########################################################
-- ################## Variables #############################

local current_act_progression_raw_hook_enabled = false

-- ##########################################################
-- ################## Functions #############################

-- ##########################################################
-- #################### Hooks ###############################

Mods.hook.set(mod_name, "LevelUnlockUtils.current_act_progression_raw", function (func, self, level_key, ...)
	
	-- Randomize how the game sees act progression, when enabled
	if current_act_progression_raw_hook_enabled then
		return math.random(0, (#GameActsOrder - 1))
	end
	
	return func(self, level_key, ...)
end)

Mods.hook.set(mod_name, "StateLoading.setup_loading_view", function (func, self, level_key, ...)
	current_act_progression_raw_hook_enabled = true
	func(self, level_key, ...)
	current_act_progression_raw_hook_enabled = false
	return
end)

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
