--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Allows you to record the names of sound events as they happen in Vermintide.
--]]

local mod = get_mod("SoundEventMonitor")

-- ##########################################################
-- ################## Variables #############################

mod.output_path = "../Vermintide_Sound_Events.csv"
mod.event_table = {}
mod.recording = false

mod:command("start_recording", "start recording sound events", function() mod.recording = true end)
mod:command("stop_recording", "stop recording sound events", 
	function()
		mod.recording = false
		mod:echo("All recorded sound event names have been saved to your Vermintide game folder.")
	end
)
mod:command("clear_recordings", "clear recorded sound events", 
	function()
		mod.event_table = {}
		
		local file = io.open(mod.output_path, "w+")
		if file then
			io.close(file)
		else
			mod.recording = false
			mod:echo("Output file not accessible.")
		end
	end
)
mod:command("play_sound", "attempt to play a given sound event name", function(...) mod.play_sound_event(...) end)

local Managers = Managers

local io = io
local type = type
local tostring = tostring
local math = math
local pairs = pairs

-- ##########################################################
-- ################## Functions #############################

mod.write_line = function(message)
	local file = io.open(mod.output_path, "a+")
	if not file then
		mod:echo("Output file not accessible.")
		return false
	end
	
	file:write(message .. "\n")
	io.close(file)
	return true
end

mod.process_argument_string = function(...)
	local args = {...}
	if args and #args > 0 then

		local this_argument = ""
	   
		-- Process arguments into a single string
		for key, value in pairs(args) do
		
			if type(value) == "string" then
				if this_argument ~= "" then
					this_argument = this_argument .. " " .. value
				else
					this_argument = value
				end
				
			elseif type(value) == "table" then
				for value_key, value_value in pairs(value) do
					if type(value_value) == "string" then
						if this_argument ~= "" then
							this_argument = this_argument .. " " .. value_value
						else
							this_argument = value_value
						end
					end
				end
			end
		end
		
		return this_argument
	end
		
	return "nil"
end

mod.play_sound_event = function(...)
	local sound_event_name = mod.process_argument_string(...)
	local SOURCE_ID = 0

	mod:pcall(function()
		mod:echo("Attempting to play sound event: '" .. sound_event_name .. "'")
		
		local world = Managers.world:world("level_world")
		local wwise_world = Managers.world:wwise_world(world)
		wwise_world:trigger_event(sound_event_name, SOURCE_ID)
	end)
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook("WwiseWorld.trigger_event", function (func, self, event_name, ...)
	local result = func(self, event_name, ...)
	if not mod.recording then
		return result
	end
	
	if not mod.event_table[event_name] then
		
		local level_key = "loading_screen"
		if Managers and Managers.state and Managers.state.game_mode then
			level_key = Managers.state.game_mode:level_key() or "loading_screen"
		end
		
		if mod.write_line(tostring(level_key)..","..tostring(event_name)) then
			mod:echo(event_name)
			mod.event_table[event_name] = 1
		else
			mod.recording = false
			mod:echo("Output file not accessible.")
		end
	else
		mod.event_table[event_name] = mod.event_table[event_name] + 1
		if mod.event_table[event_name] < mod:get("max_repeat") then
			mod:echo(event_name)
		end
	end
	
	return result
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
