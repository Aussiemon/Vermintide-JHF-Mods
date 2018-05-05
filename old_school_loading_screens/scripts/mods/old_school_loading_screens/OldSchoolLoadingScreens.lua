--[[
	author: Aussiemon

	-----

	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	-----

	Adds early Vermintide 'old school' loading screen variants, adds unused mission briefs.
--]]

local mod = get_mod("OldSchoolLoadingScreens")

-- ##########################################################
-- ################## Variables #############################

mod.multiple_loading_screen_list = {
	inn_level = 5,
	magnus = 2,
	merchant = 2,
	sewers_short = 2,
	wizard = 2,
	bridge = 2,
	forest_ambush = 2,
	city_wall = 2,
	cemetery = 2,
	farm = 2,
	tunnels = 2,
	courtyard_level = 2,
	docks_short_level = 2,
	end_boss = 2,
	dlc_castle = 2
}

mod.current_act_progression_raw_hook_enabled = false
mod.last_shown_screen_index = mod.last_shown_screen_index or -1

local mod_data = {}
mod_data.name = "Old School Loading Screens" -- Readable mod name
mod_data.description = "Adds early Vermintide 'old school' loading screen variants, adds unused mission briefs." -- Readable mod description
mod_data.is_togglable = true -- If the mod can be enabled/disabled
mod_data.is_mutator = false -- If the mod is mutator
mod_data.options_widgets = {
	{
		["setting_name"] = "randomize_screens",
		["widget_type"] = "checkbox",
		["text"] = "Randomize Loading Screens",
		["tooltip"] = "Randomize Loading Screens\n" ..
			"Randomly select loading screens for enabled maps.\n\n" ..
			"If disabled, only 'old school' variants will be used.",
		["default_value"] = true, -- Default first option In this case true
	},
	{
		["setting_name"] = "randomize_tips",
		["widget_type"] = "checkbox",
		["text"] = "Randomize Loading Screen Tips",
		["tooltip"] = "Randomize Loading Screen Tips\n" ..
			"Randomly select loading screen tips for enabled maps.",
		["default_value"] = false, -- Default first option In this case false
	},
	{
		["setting_name"] = "toggle_maps",
		["widget_type"] = "dropdown",
		["text"] = "Toggle Maps",
		["tooltip"] = "Toggle Maps\n" ..
			"Allows maps with loading screens to be toggled On / Off",
		["options"] = {
			{--[[1]] text = "Enabled",       value = true},
			{--[[2]] text = "Disabled",     value = false}
		},
		["default_value"] = 2, -- Default first option In this case Disabled
		["sub_widgets"] = {
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "inn_level_ls",
				["widget_type"] = "checkbox",
				["text"] = "Red Moon Inn",
				["tooltip"] = "Red Moon Inn\n" ..
							"Toggle loading screen changes for Red Moon Inn.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "magnus_ls",
				["widget_type"] = "checkbox",
				["text"] = "Horn of Magnus",
				["tooltip"] = "Horn of Magnus\n" ..
							"Toggle loading screen changes for Horn of Magnus.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "merchant_ls",
				["widget_type"] = "checkbox",
				["text"] = "Supply and Demand",
				["tooltip"] = "Supply and Demand\n" ..
							"Toggle loading screen changes for Supply and Demand.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "sewers_short_ls",
				["widget_type"] = "checkbox",
				["text"] = "Smuggler's Run",
				["tooltip"] = "Smuggler's Run\n" ..
							"Toggle loading screen changes for Smuggler's Run.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "wizard_ls",
				["widget_type"] = "checkbox",
				["text"] = "Wizard's Tower",
				["tooltip"] = "Wizard's Tower\n" ..
							"Toggle loading screen changes for Wizard's Tower.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "bridge_ls",
				["widget_type"] = "checkbox",
				["text"] = "Black Powder",
				["tooltip"] = "Black Powder\n" ..
							"Toggle loading screen changes for Black Powder.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "forest_ambush_ls",
				["widget_type"] = "checkbox",
				["text"] = "Engines of War",
				["tooltip"] = "Engines of War\n" ..
							"Toggle loading screen changes for Engines of War.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "city_wall_ls",
				["widget_type"] = "checkbox",
				["text"] = "Man the Ramparts",
				["tooltip"] = "Man the Ramparts\n" ..
							"Toggle loading screen changes for Man the Ramparts.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "cemetery_ls",
				["widget_type"] = "checkbox",
				["text"] = "Garden of Morr",
				["tooltip"] = "Garden of Morr\n" ..
							"Toggle loading screen changes for Garden of Morr.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "farm_ls",
				["widget_type"] = "checkbox",
				["text"] = "Wheat and Chaff",
				["tooltip"] = "Wheat and Chaff\n" ..
							"Toggle loading screen changes for Farm.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "tunnels_ls",
				["widget_type"] = "checkbox",
				["text"] = "Enemy Below",
				["tooltip"] = "Enemy Below\n" ..
							"Toggle loading screen changes for Enemy Below.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "courtyard_level_ls",
				["widget_type"] = "checkbox",
				["text"] = "Well Watch",
				["tooltip"] = "Well Watch\n" ..
							"Toggle loading screen changes for Well Watch.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "docks_short_level_ls",
				["widget_type"] = "checkbox",
				["text"] = "Waterfront",
				["tooltip"] = "Waterfront\n" ..
							"Toggle loading screen changes for Waterfront.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "end_boss_ls",
				["widget_type"] = "checkbox",
				["text"] = "White Rat",
				["tooltip"] = "White Rat\n" ..
							"Toggle loading screen changes for White Rat.",
				["default_value"] = true -- Default first option is enabled. In this case true
			},
			{
				["show_widget_condition"] = {1},

				["setting_name"] = "dlc_castle_ls",
				["widget_type"] = "checkbox",
				["text"] = "Castle Drachenfels",
				["tooltip"] = "Castle Drachenfels\n" ..
							"Toggle loading screen changes for Castle Drachenfels.",
				["default_value"] = true -- Default first option is enabled. In this case true
			}
		}
	}
}

local LevelSettings = LevelSettings
local UIRenderer = UIRenderer
local pairs = pairs
local math = math

-- ##########################################################
-- ################## Functions #############################

mod.setup_multiple_loading_screens = function()
	for key, value in pairs(mod.multiple_loading_screen_list) do
		if LevelSettings[key] then
			LevelSettings[key].number_loading_images = value
			LevelSettings[key].has_multiple_loading_images = true
		end
	end
end

mod.disable_multiple_loading_screens = function()
	for key, value in pairs(mod.multiple_loading_screen_list) do
		if LevelSettings[key] and key ~= "inn_level" then
			LevelSettings[key].number_loading_images = nil
			LevelSettings[key].has_multiple_loading_images = false
		end
	end
end

mod.use_all_mission_briefs = function()
	mod.merchant = mod.merchant or table.clone(LevelSettings.merchant.map_settings.wwise_events)
	LevelSettings.merchant.map_settings.wwise_events = {
		"nik_map_brief_merchant_district_01",
		"nik_map_brief_merchant_district_02",
		"nik_map_brief_merchant_district_03",
		"nik_map_brief_merchant_district_04"
	}

	mod.tunnels = mod.tunnels or table.clone(LevelSettings.tunnels.map_settings.wwise_events)
	LevelSettings.tunnels.map_settings.wwise_events = {
		"nik_map_brief_skaven_tunnels_01",
		"nik_map_brief_skaven_tunnels_02",
		"nik_map_brief_skaven_tunnels_03",
		"nik_map_brief_skaven_tunnels_04"
	}

	mod.sewers_short = mod.sewers_short or table.clone(LevelSettings.sewers_short.map_settings.wwise_events)
	LevelSettings.sewers_short.map_settings.wwise_events = {
		"nik_map_brief_sewers_01",
		"nik_map_brief_sewers_02",
		"nik_map_brief_sewers_03",
		"nik_map_brief_sewers_04"
	}

	mod.magnus = mod.magnus or table.clone(LevelSettings.magnus.map_settings.wwise_events)
	LevelSettings.magnus.map_settings.wwise_events = {
		"nik_map_brief_magnus_tower_01",
		"nik_map_brief_magnus_tower_02",
		"nik_map_brief_magnus_tower_03",
		"nik_map_brief_magnus_tower_04"
	}

	mod.bridge = mod.bridge or table.clone(LevelSettings.bridge.map_settings.wwise_events)
	LevelSettings.bridge.map_settings.wwise_events = {
		"nik_map_brief_bridge_01",
		"nik_map_brief_bridge_02",
		"nik_map_brief_bridge_03",
		"nik_map_brief_bridge_04"
	}
end

mod.use_default_mission_briefs = function()
	LevelSettings.merchant.map_settings.wwise_events = mod.merchant or LevelSettings.merchant.map_settings.wwise_events
	LevelSettings.tunnels.map_settings.wwise_events = mod.tunnels or LevelSettings.tunnels.map_settings.wwise_events
	LevelSettings.sewers_short.map_settings.wwise_events = mod.sewers_short or LevelSettings.sewers_short.map_settings.wwise_events
	LevelSettings.magnus.map_settings.wwise_events = mod.magnus or LevelSettings.magnus.map_settings.wwise_events
	LevelSettings.bridge.map_settings.wwise_events = mod.bridge or LevelSettings.bridge.map_settings.wwise_events
end

mod.setup_materials_and_textures = function()
	local custom_textures_names = {}

	local material_prefix = "loading_screen_"
	for key, value in pairs(mod.multiple_loading_screen_list) do
		if LevelSettings[key] and key ~= "inn_level" then
			table.insert(custom_textures_names, material_prefix .. key .. "_1")
		end
	end

	mod:custom_textures(unpack(custom_textures_names))
end

-- ##########################################################
-- #################### Hooks ###############################

-- Randomizes how the game sees act progression, when enabled
mod:hook("LevelUnlockUtils.current_act_progression_raw", function (func, self, level_key, ...)

	if mod.current_act_progression_raw_hook_enabled then
		local chosen_act = math.max(math.random(0, (#GameActsOrder - 1)), 0)

		-- Don't show the same loading screen twice in the inn
		while chosen_act == mod.last_shown_screen_index do
			chosen_act = math.max(math.random(0, (#GameActsOrder - 1)), 0)
		end
		mod.last_shown_screen_index = chosen_act
		return chosen_act
	end

	return func(self, level_key, ...)
end)

-- Modifies loading screen image choice behavior
mod:hook("StateLoading.setup_loading_view", function (func, self, level_key, ...)

	-- For the inn, choose a random screen
	if mod:get("inn_level_ls") then
		mod.current_act_progression_raw_hook_enabled = true
	end
	func(self, level_key, ...)
	mod.current_act_progression_raw_hook_enabled = false
end)

-- Modifies loading screen image choice behavior
mod:hook("LoadingView.texture_resource_loaded", function (func, self, level_key, act_progression_index, game_difficulty, ...)
	UIRenderer.destroy(self.ui_renderer, self.world)

	self.level_key = level_key

	local loading_screen_changes_enabled = mod:get(level_key .. "_ls")

	-- Randomize the act used for choosing tip text
	if mod:get("randomize_tips") and loading_screen_changes_enabled then
		self.act_progression_index = math.max(math.random(0, (#GameActsOrder - 1)), 0)
	else
		self.act_progression_index = act_progression_index
	end

	local level_settings = LevelSettings[level_key]
	local loading_image_material = level_settings.loading_bg_image
	local has_multiple_loading_images = level_settings.has_multiple_loading_images
	local number_loading_images = level_settings.number_loading_images or 1
	local game_mode = level_settings.game_mode or "adventure"
	local bg_material = "materials/ui/loading_screens/" .. loading_image_material

	-- Default act_progression_index to 0 if needed
	act_progression_index = act_progression_index or 0

	if has_multiple_loading_images then

		-- For maps other than the inn (which requires different randomization) choose a random screen or overwrite
		if level_key ~= "inn_level" and loading_screen_changes_enabled then
			if mod:get("randomize_screens") then
				act_progression_index = math.max(math.random(0, (number_loading_images - 1)), 0)
			else
				act_progression_index = math.max(math.random(1, (number_loading_images - 1)), 0)
			end
		end

		if 1 <= act_progression_index then
			if level_key ~= "inn_level" then
				bg_material = "materials/old_school_loading_screens/old_school_loading_screens"
			else
				bg_material = bg_material .. "_" .. act_progression_index
			end
		end
	end

	self.ui_renderer = UIRenderer.create(self.world, "material", bg_material, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_popup", "material", "materials/ui/ui_1080p_chat")

	if 1 <= act_progression_index and level_key ~= "inn_level" then
		self.bg_widget.content.bg_texture = level_settings.loading_bg_image .. "_" .. act_progression_index
	else
		self.bg_widget.content.bg_texture = level_settings.loading_bg_image
	end

	-- An 'act_progression_index' of 0 points to the original loading screens with no act text, the inn and last stand maps don't need act text either
	if (0 == act_progression_index) and level_key ~= "inn_level" and level_settings.level_type ~= "survival" then
		self.setup_act_text(self, level_key)
	end

	-- The inn and last stand maps don't need difficulty text
	if level_key ~= "inn_level" and level_settings.level_type ~= "survival" then
		self.setup_difficulty_text(self, game_difficulty)
	end

	-- An 'act_progression_index' of 0 points to the original loading screens with no level text
	if (0 == act_progression_index) or level_key == "inn_level" or level_key == "dlc_castle" then
		self.setup_level_text(self, level_key)
	end
	self.setup_tip_text(self, self.act_progression_index, game_mode)
end)

-- ##########################################################
-- ################### Callback #############################

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(initial_call)
	if not initial_call then
		mod.use_default_mission_briefs()
		mod.disable_multiple_loading_screens()
	end
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(initial_call)
	mod:enable_all_hooks()
	mod.setup_multiple_loading_screens()
	mod.use_all_mission_briefs()
end

-- ##########################################################
-- ################### Script ###############################

mod:initialize_data(mod_data)
mod.setup_materials_and_textures()

-- ##########################################################
