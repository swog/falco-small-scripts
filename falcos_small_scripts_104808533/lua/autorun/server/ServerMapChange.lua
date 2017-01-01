--put the next thing to true if you want this script to be active!
local ISTURNEDON = false

if not ISTURNEDON then return end
local Changes = {"20:09", "18:00"}--When will it change map?
local MinutesBeforeWarning = 30 -- Warn 30 minutes before level change
local AfterThat_WarnEvery = 60 -- after the first warning, warn every x seconds
local Map = {"rp_evocity_v2d", "rp_downtown_v2"} -- Circulation of maps

local function Warn(hour, minute)
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint("THE MAP WILL CHANGE ON "..tostring(hour)..":"..tostring(minute))
	end
end

local IsWarning = false
local function Checkmapchange()
	for k,v in pairs(Changes) do
		local hours = tonumber(string.Explode(":", v)[1])
		local minutes = tonumber(string.Explode(":", v)[2])

		local WarningHour = hours
		local WarningMinutes
		if MinutesBeforeWarning > minutes then
			WarningHour = hours - 1
			WarningMinutes = 60 - (MinutesBeforeWarning - minutes)
		else
			WarningMinutes = minutes - MinutesBeforeWarning
		end

		if tonumber(os.date("%H")) == WarningHour and tonumber(os.date("%M")) == WarningMinutes and not IsWarning then
			IsWarning = true
			Warn(string.Explode(":", v)[1], string.Explode(":", v)[2])
			timer.Create("MapChangewarning", function()
				AfterThat_WarnEvery(0, Warn, string.Explode(":", v)[1], string.Explode(":", v)[2])
			end)
		end

		if tonumber(os.date("%H")) == hours and tonumber(os.date("%M")) == minutes and IsWarning then
			local ToMap
			for a,b in pairs(Map) do
				if string.lower(b) == string.lower(game.GetMap()) then
					if Map[a+1] then ToMap = Map[a+1]
					else ToMap = Map[1]
					end
				end
			end
			if not ToMap then ToMap = Map[1] end
			game.ConsoleCommand("changelevel ".. ToMap.."\n")
		end
	end
end
timer.Create("Changelevelontime", 1, 0, Checkmapchange)