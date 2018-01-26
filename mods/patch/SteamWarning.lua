--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Displays a warning on the day that Steam usually schedules routine maintenance.
--]]

local mod_name = "SteamWarning"

-- ##########################################################
-- ################## Variables #############################

local day_of_usual_steam_maintenance = "Tuesday" -- Change this to set the day upon which the warning will be displayed.

local steam_time_zone = -8 -- Change this to set the timezone relative to the chosen day

-- ##########################################################
-- ################### Script ###############################

if GameSettingsDevelopment.network_mode == "steam" then

	-- Calculate the day of the week at the PDT timezone
	local days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
	local current_steam_date = os.date("!*t", (os.time() + (steam_time_zone * 60 * 60)))
	local current_steam_day = days[current_steam_date.wday]

	-- EchoConsole("Time at Steam: "..current_steam_day..", "..tostring(current_steam_date.hour)..":"..tostring(current_steam_date.min))

	-- Display warning once per startup on maintenance day
	if current_steam_day == day_of_usual_steam_maintenance then
		EchoConsole("------------------------------------------------------------------------------")
		EchoConsole("WARNING: Steam may go down for maintenance today.")
		EchoConsole("------------------------------------------------------------------------------")
	end
end

-- ##########################################################
