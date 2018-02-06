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

local mod_name = "SoundSettings"

-- ##########################################################
-- ################## Variables #############################

SoundSettings = {
	SETTINGS = {
		GLING = {
		["save"] = "cb_sound_settings_gling",
		["widget_type"] = "stepper",
		["text"] = "Disable Trait \"Gling\" SFX",
		["tooltip"] =  "Disable Trait \"Gling\" SFX\n" ..
			"Toggle disabled \"gling\" sound effect when attack is buffed by traits on / off.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 2, -- Default first option is enabled. In this case On
		},
		EXECUTIONER = {
		["save"] = "cb_sound_settings_exec_headshot",
		["widget_type"] = "stepper",
		["text"] = "Disable Executioner Headshot SFX",
		["tooltip"] =  "Disable Executioner Headshot SFX\n" ..
			"Toggle disabled guillotine sound effect on exec. sword headshot on / off.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
		KILLINGBLOW = {
		["save"] = "cb_sound_settings_killing_blow",
		["widget_type"] = "stepper",
		["text"] = "Disable Killing Blow SFX",
		["tooltip"] =  "Disable Killing Blow SFX\n" ..
			"Toggle disabled killing blow sound effect on / off.",
		["value_type"] = "boolean",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true}
		},
		["default"] = 1, -- Default first option is enabled. In this case Off
		},
	},
	LookupTable = {}
}

local mod = SoundSettings

mod.LookupTable["Play_hud_trait_active"] = mod.SETTINGS.GLING -- Trait Buff SFX
mod.LookupTable["executioner_sword_critical"] = mod.SETTINGS.EXECUTIONER -- Executioner Headshot SFX
mod.LookupTable["Play_hud_matchmaking_countdown"] = mod.SETTINGS.KILLINGBLOW -- Killing Blow SFX

-- ##########################################################
-- ################## Functions #############################

local get = function(data)
	if not (data and data.save) then
		return false
	end
	return Application.user_setting(data.save)
end
local set = Application.set_user_setting
local save = Application.save_user_settings

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

mod.create_options = function()
	Mods.option_menu:add_group("sound_setings", "Sound Settings")
	Mods.option_menu:add_item("sound_setings", mod.SETTINGS.GLING, true)
	Mods.option_menu:add_item("sound_setings", mod.SETTINGS.EXECUTIONER, true)
	Mods.option_menu:add_item("sound_setings", mod.SETTINGS.KILLINGBLOW, true)
end

-- ##########################################################
-- #################### Hooks ###############################

Mods.hook.set(mod_name, "WwiseWorld.trigger_event", function (func, self, event_name, ...)
	local event = event_name
	if mod.LookupTable[event] and get(mod.LookupTable[event]) then
		if not (event == "Play_hud_matchmaking_countdown" and mod.check_for_inn_or_loading()) then
			return
		end
	end
	
	return func(self, event_name, ...)
end)

-- ##########################################################
-- ################### Script ###############################

mod.create_options()

-- ##########################################################
