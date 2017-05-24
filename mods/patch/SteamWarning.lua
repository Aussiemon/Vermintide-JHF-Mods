--[[
	author: Aussiemon
	
	-----
 
	Copyright 2017 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Displays a warning on the day that Steam usually schedules routine maintenance.
--]]
local mod_name = "SteamWarning"

local day_of_usual_steam_maintenance = nil -- Change this to manually set scheduled maintenance day

-- With help from user gwell at https://stackoverflow.com/questions/22518443/lua-get-current-day
local days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday"}
local day = days[os.date("*t").wday]

-- With help from http://lua-users.org/wiki/TimeZone
local currentTime = os.time()
local diffTime = os.difftime(currentTime, os.time(os.date("!*t", currentTime)))
local h, m = math.modf(diffTime / 3600)

-- I think it's pretty assured that Steam's scheduled maintenance would be Wednesday in timezones past UTC+4.00
if (h > 4) and not day_of_usual_steam_maintenance then
	day_of_usual_steam_maintenance = "Wednesday"

-- Otherwise maintenance day is on Tuesday as usual
elseif not day_of_usual_steam_maintenance then
	day_of_usual_steam_maintenance = "Tuesday"
	
end

-- Display warning once per startup on maintenance day
if GameSettingsDevelopment.network_mode == "steam" and day == day_of_usual_steam_maintenance then
	EchoConsole("-------------------------------------------------------------------------------")
	EchoConsole("WARNING: Steam may go down for maintenance today.")
	EchoConsole("-------------------------------------------------------------------------------")
end