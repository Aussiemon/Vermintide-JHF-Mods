--[[
	author: Aussiemon and bi

	-----

	Copyright 2021 Aussiemon and bi

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	-----

	Provides better UI scaling for higher-resolution displays.
--]]

local mod = get_mod("HiDefUIScaling")

-- ##########################################################
-- ################## Variables #############################

local cached_slider_value = mod:get("scale_slider")

local UIResolutionWidthFragments = UIResolutionWidthFragments
local UIResolutionHeightFragments = UIResolutionHeightFragments
local UISceneGraph = UISceneGraph
local UPDATE_RESOLUTION_LOOKUP = UPDATE_RESOLUTION_LOOKUP

local _G = _G
local math = math

local NilCursor = {
	0,
	0,
	0
}
local tooltip_size = {
	0,
	0
}
local temp_cursor_pos = {
	0,
	0
}
local tooltip_background_color = {
	220,
	3,
	3,
	3
}
local temp_text_lines = {}
local platform_offset = Vector3Box(0, 0, 0)

-- ##########################################################
-- ################## Functions #############################

mod.get_adjusted_scale = function (self, width, height)
	local width_scale, height_scale
	local max_scaling_factor = cached_slider_value or 4.00

	-- Changed to allow scaling up to quadruple the original max scale (0.5 -> 4)
	width_scale = math.min(width / UIResolutionWidthFragments(), max_scaling_factor)
	height_scale = math.min(height / UIResolutionHeightFragments(), max_scaling_factor)
	
	return math.min(width_scale, height_scale)
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook("UIResolutionScale", function (func, ...)
	local width, height = UIResolution()
	if width > UIResolutionWidthFragments() and height > UIResolutionHeightFragments() then
		return mod:get_adjusted_scale(width, height)
	else
		return func(...)
	end
end)

mod:hook_origin(UIPasses.tooltip_text, "draw", function (ui_renderer, pass_data, ui_scenegraph, pass_definition, ui_style, ui_content, position, size, input_service, dt, ...)
	ui_style.font_size = 18
	local font_material, font_size, font_name = nil

	if ui_style.font_type then
		local font, size_of_font = UIFontByResolution(ui_style)
		font_name = font[3]
		font_size = font[2]
		font_material = font[1]
		font_size = size_of_font
	else
		local font = ui_style.font
		font_name = font[3]
		font_size = font[2]
		font_material = font[1]
		font_size = ui_style.font_size or font_size
	end

	local text = ui_content[pass_data.text_id]

	if ui_style.localize then
		text = Localize(text)
	end

	local max_width = ui_style.max_width or size[1]
	local font_height, font_min, font_max = UIGetFontHeight(ui_renderer.gui, font_name, font_size)
	local texts = UIRenderer.word_wrap(ui_renderer, text, font_material, font_size, max_width)
	local text_start_index = ui_content.text_start_index or 1
	local max_texts = ui_content.max_texts or #texts
	local num_texts = math.min(#texts - (text_start_index - 1), max_texts)
	local full_font_height = (font_max + math.abs(font_min)) * RESOLUTION_LOOKUP.inv_scale
	local text_offset = Vector3(0, (ui_style.grow_downward and full_font_height) or -full_font_height, 0)
	local fixed_position = ui_style.fixed_position

	if fixed_position and ui_style.use_fixed_position then
		temp_cursor_pos[1] = position[1] + fixed_position[1]
		temp_cursor_pos[2] = position[2] + fixed_position[2]
	else
		local cursor = input_service:get("cursor") or NilCursor
		temp_cursor_pos[1] = cursor[1]
		temp_cursor_pos[2] = cursor[2]
	end

	local cursor_offset = ui_style.cursor_offset
	temp_cursor_pos[1] = temp_cursor_pos[1] + ((cursor_offset and cursor_offset[1]) or 25)
	temp_cursor_pos[2] = temp_cursor_pos[2] - ((cursor_offset and cursor_offset[2]) or 15)
	local cursor_position = UIInverseScaleVectorToResolution(temp_cursor_pos)
	tooltip_size[2] = full_font_height * num_texts
	tooltip_size[1] = 0

	for i = 1, num_texts, 1 do
		local text_line = texts[i - 1 + text_start_index]
		local width, height, min = UIRenderer.text_size(ui_renderer, text_line, font_material, font_size, tooltip_size[2])

		if tooltip_size[1] < width then
			tooltip_size[1] = width
		end
	end

	local cursor_side = ui_style.cursor_side
	local draw_downwards = ui_style.draw_downwards

	if cursor_side and cursor_side == "left" then
		position[1] = cursor_position[1] - tooltip_size[1]

		if draw_downwards then
			position[2] = cursor_position[2] - full_font_height
		else
			position[2] = cursor_position[2] + tooltip_size[2] - full_font_height
		end
	else
		position[1] = cursor_position[1]
		position[2] = cursor_position[2] - full_font_height
	end

	position[3] = UILayer.tooltip + 1

	for i = 1, num_texts, 1 do
		local text_line = texts[i - 1 + text_start_index]
		local color = (ui_style.last_line_color and i == num_texts and ui_style.last_line_color) or (ui_style.line_colors and ui_style.line_colors[i]) or ui_style.text_color

		UIRenderer.draw_text(ui_renderer, text_line, font_material, font_size, font_name, position, color)

		position = position + text_offset
	end

	local padding_x = 4
	local padding_y = 2
	position[3] = position[3] - 1
	position[2] = (position[2] + full_font_height + font_min) - padding_y
	position[1] = position[1] - 2 - padding_x
	tooltip_size[1] = tooltip_size[1] + padding_x * 2
	tooltip_size[2] = tooltip_size[2] + padding_y * 2

	UIRenderer.draw_rounded_rect(ui_renderer, position, tooltip_size, 5, tooltip_background_color)
end)

-- ##########################################################
-- ################### Callback #############################

mod.on_setting_changed = function ()
	-- There's only one setting for this mod, so don't check for changed setting_id
	cached_slider_value = mod:get("scale_slider")
	UPDATE_RESOLUTION_LOOKUP(true)
end

mod.on_enabled = function ()
	UPDATE_RESOLUTION_LOOKUP(true)
end

mod.on_disabled = function ()
	UPDATE_RESOLUTION_LOOKUP(true)
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
