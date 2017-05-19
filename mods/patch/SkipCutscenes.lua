--[[
	author: Aussiemon
 
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Makes all cutscenes skippable, and handles fade out/in.
	
	KNOWN ISSUE: Cursor appears on screen until game is restarted if equipment chest is open when cutscene would've ended. Use /fixcursor to hide.
--]]
local mod_name = "SkipCutscenes"

local skip_next_fade = false

local display_warning = true
local warning_displayed = false

Mods.hook.set(mod_name, "CutsceneSystem.skip_pressed", function (func, self)
	
	if self.active_camera then
		self.flow_cb_deactivate_cutscene_cameras(self)
		self.flow_cb_deactivate_cutscene_logic(self)
		skip_next_fade = true
		
		if display_warning and not warning_displayed and Managers.state.game_mode ~= nil then
			EchoConsole("Skipped cutscene: Do not open equipment chest until the point where cutscene would've ended naturally.")
			EchoConsole(" ")
			EchoConsole("Use /fixcursor command to hide lingering cursor.")
			warning_displayed = true
		end
	end
	
	return
end)

Mods.hook.set(mod_name, "CutsceneSystem.flow_cb_cutscene_effect", function (func, self, name, flow_params)
	
	if name == "fx_fade" and skip_next_fade then
		skip_next_fade = false
		return
	end
	
	local result = func(self, name, flow_params)
	
	return result
end)