--[[
	author: Aussiemon

	-----

	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	-----

	Provides better UI scaling for higher-resolution displays.
--]]

local mod = get_mod("HiDefUIScaling")

-- ##########################################################
-- ################## Variables #############################

local scale = mod:get("scale")

-- ##########################################################
-- #################### Hooks ###############################

mod:hook("UIResolutionScale", function (func, ...)
  local width, height = UIResolution()
  if width > UIResolutionWidthFragments() and height > UIResolutionHeightFragments() then
    local max_scaling_factor = math.max((((scale or 4) + 1) / 100), 1)

    -- Changed to allow scaling up to quadruple the original max scale (1 -> 4)
    local width_scale = math.min(width / UIResolutionWidthFragments(), max_scaling_factor)
    local height_scale = math.min(height / UIResolutionHeightFragments(), max_scaling_factor)

    return math.min(width_scale, height_scale)
  else
    return func(...)
  end
end)

-- ##########################################################
-- ################### Callback #############################

mod.on_setting_changed = function ()
	-- There's only one setting for this mod, so don't check for changed setting_id
	scale = mod:get("scale")
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
