--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Plays unused character-specific dialogue when a potion is consumed.
--]]

local mod_name = "PotionDialogue"

-- ##########################################################
-- ################## Variables #############################

PotionDialogue = {
	SETTINGS = {
		ACTIVE = {
			["save"] = "cb_potion_dialogue_enabled",
			["widget_type"] = "stepper",
			["text"] = "Potion Dialogue - Enabled",
			["tooltip"] = "Potion Dialogue\n" ..
				"Plays unused character-specific dialogue when a potion is consumed.",
			["value_type"] = "boolean",
			["options"] = {
				{text = "Off", value = false},
				{text = "On", value = true}
			},
			["default"] = 1, -- Default second option is enabled. In this case Off
		}
	}
}

local mod = PotionDialogue

mod.stance_equivalents_all = {
	damage_boost_potion_weak = "offensive",
	speed_boost_potion_weak = "defensive",
	damage_boost_potion_medium = "offensive",
	speed_boost_potion_medium = "defensive",
	speed_boost_potion = "defensive",
	damage_boost_potion = "offensive"
}

mod.stance_equivalents_limited = {
	speed_boost_potion = "defensive",
	damage_boost_potion = "offensive"
}

-- Optimization locals
local Unit_alive = Unit.alive
local ScriptUnit_extension_input = ScriptUnit.extension_input
local FrameTable_alloc_table = FrameTable.alloc_table
local Application_user_setting = Application.user_setting

-- ##########################################################
-- ################## Functions #############################

mod.create_options = function ()
	Mods.option_menu:add_group("potion_dialogue", "Potion Dialogue")
	Mods.option_menu:add_item("potion_dialogue", mod.SETTINGS.ACTIVE, true)
end

mod.trigger_potion_dialogue_event = function (action_extension)
	local current_action = action_extension.current_action
	local owner_unit = action_extension.owner_unit
	local buff_template = current_action.buff_template

	if buff_template and mod.stance_equivalents_all[buff_template] and Unit_alive(owner_unit) then
		local dialogue_input = ScriptUnit_extension_input(owner_unit, "dialogue_system")
		local event_data = FrameTable_alloc_table()
		event_data.stance_type = mod.stance_equivalents_all[buff_template]

		dialogue_input:trigger_networked_dialogue_event("stance_triggered", event_data)
	end
end

local get = function (data)
	return Application_user_setting(data.save)
end
local set = Application.set_user_setting
local save = Application.save_user_settings

-- ##########################################################
-- #################### Hooks ###############################

Mods.hook.set(mod_name, "ActionPotion.finish", function (func, self, reason, ...)
	
	-- Play dialogue events
	if get(mod.SETTINGS.ACTIVE) and reason == "action_complete" then
		mod.trigger_potion_dialogue_event(self)
	end
	
	local result = func(self, reason, ...)
	return result
end)

-- ##########################################################
-- ################### Script ###############################

mod.create_options()

-- ##########################################################
