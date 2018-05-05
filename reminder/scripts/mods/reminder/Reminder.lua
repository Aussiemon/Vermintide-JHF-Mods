--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Allows users to write messages that will be played back at the end of missions.
--]]

local mod = get_mod("Reminder")

-- ##########################################################
-- ################## Variables #############################

local mod_data = {}
mod_data.name = "Reminder" -- Readable mod name
mod_data.description = "Allows users to write messages that will be played back at the end of missions." -- Readable mod description
mod_data.is_togglable = true -- If the mod can be enabled/disabled
mod_data.is_mutator = false -- If the mod is mutator
mod_data.options_widgets = {
	{
		["setting_name"] = "auto_clear_reminders",
		["widget_type"] = "checkbox",
		["text"] = "Auto-Clear Reminders",
		["tooltip"] = "Auto-Clear Reminders After Playback\n" ..
					"Enable to automatically clear reminders after they've been displayed.",
		["default_value"] = true -- Default first option is enabled. In this case true
	}
}

mod:command("reminder", "adds a reminder for playback at mission-end", function(...) mod.record_reminder(...) end)
mod:command("clear_reminders", "clears mission-end reminders", function() mod.clear_reminders() end)

mod.reminder_string = mod.reminder_string or ""

local Managers = Managers
local pairs = pairs
local type = type

-- ##########################################################
-- ################## Functions #############################

mod.record_reminder = function(...)
	-- Process reminders with respect to existing reminders, use "clear" to reset.
	local args = {...}
	if args and #args > 0 then

		local this_reminder = ""
	   
		-- Start new line if existing reminders
		if mod.reminder_string ~= "" then
			mod.reminder_string = mod.reminder_string .. "\n"
		end
	   
		-- Process/format arguments into a new reminder
		for key, value in pairs(args) do
		
			if type(value) == "string" then
				if mod.reminder_string ~= "" then
					mod.reminder_string = mod.reminder_string .. " " .. value
				else
					mod.reminder_string = value
				end
				if this_reminder ~= "" then
					this_reminder = this_reminder .. " " .. value
				else
					this_reminder = value
				end
				
			elseif type(value) == "table" then
				for value_key, value_value in pairs(value) do
					if type(value_value) == "string" then
						if mod.reminder_string ~= "" then
							mod.reminder_string = mod.reminder_string .. " " .. value_value
						else
							mod.reminder_string = value_value
						end
						if this_reminder ~= "" then
							this_reminder = this_reminder .. " " .. value_value
						else
							this_reminder = value_value
						end
					end
				end
			end
		end
	   
		-- Make sure this isn't a clearing command before confirming saved reminder
		if this_reminder ~= " clear" and this_reminder ~= "clear" then
			mod:echo("Reminder saved: " .. this_reminder)
		else
			mod.clear_reminders()
		end
		
	else
		if mod.reminder_string == "" then
			mod:echo("No reminder given!")
		end
	end
end

mod.clear_reminders = function()
	mod.reminder_string = ""
	mod:echo("Reminders cleared!")
end

-- ##########################################################
-- #################### Hooks ###############################

-- Hook the scoreboard function to play back reminders upon entry
mod:hook("ScoreboardUI.on_enter", function (func, ...)
   
	-- Playback reminders and show chat window
	if mod.reminder_string ~= "" then
		mod:echo("============ REMINDER: ============\n" .. mod.reminder_string .. "\n===================================")
		if not Managers.chat:chat_is_focused() then
			local chat_gui = Managers.chat.chat_gui
			chat_gui:show_chat()
		end
		if mod:get("auto_clear_reminders") then
			mod.reminder_string = ""
		end
	end
   
	-- Original function continues
	local result = func(...)
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

mod:initialize_data(mod_data)

-- ##########################################################
