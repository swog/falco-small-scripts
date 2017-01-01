local cansay = true
FALCO_CHATTIME = 1.6
local OOC = CreateClientConVar("falco_ooc", 1, true, false)

local _R = debug.getregistry()
FALCO_RPRealName = _R.Player.Nick

local SteamID = debug.getregistry().Player.SteamID
debug.getregistry().Player.SteamID = function(ply, ...) if ply:IsBot() then return "BOT" end return SteamID(ply, ...) end

function Falco_DelayedSay(text)
	if cansay then
		local add = ""
		if OOC:GetInt() == 1 and GetGlobalInt("alltalk") == 0 then add = "/ooc " end
		local endresult = add.. tostring(text)
		if string.len(endresult) >= 126 then
			timer.Simple(1.62, function() Falco_DelayedSay(string.sub(endresult, 127)) end)
		end
		LocalPlayer():ConCommand("say " ..string.sub(endresult, 1, 126))
		cansay = false
		timer.Simple(FALCO_CHATTIME, function() cansay = true end)
	else
		timer.Simple(FALCO_CHATTIME, function() Falco_DelayedSay(text) end)
	end
end
concommand.Add("Falco_delayedsay", function(_,_,args) Falco_DelayedSay(table.concat(args, " ")) end)

--Example:
concommand.Add("falco_hiall", function()
	local hiall = ""
	for k,v in pairs(player.GetAll()) do
		if v ~= LocalPlayer() then
			hiall = hiall ..", hi " .. v:Nick()
		end
	end
	hiall = string.sub(hiall, 3)
	Falco_DelayedSay(hiall)
end)

-- Nice chat print solution.
function fprint(...)
	local Printage = {}
	local arg = {...}
	for k,v in pairs(arg) do
		Printage[k] = tostring(arg[k]).."\t"
	end
	chat.AddText(Color(255,0,0,255), unpack(Printage))
end
usermessage.Hook("fprint", function(um)
	fprint(um:ReadString())
end)


local FALCO_CHATCOMMANDS = {}

function falco_addchatcmd(text, func)
	FALCO_CHATCOMMANDS[text] = func
end

local function FALCO_CHAT2(ply, text, teamonly, dead)
	if ply ~= LocalPlayer() then return end
	cansay = false
	timer.Simple(2.1, function() cansay = true end)
	for k,v in pairs(FALCO_CHATCOMMANDS) do
		if string.lower(string.sub(text,1, string.len(k))) == string.lower(k) then
			v(string.sub(text, string.len(k) + 2))
			break
		elseif string.lower(string.sub(text, 7, string.len(k) + 6)) == string.lower(k) then
			v(string.sub(text, string.len(k) + 8))
		end
	end
end
hook.Add( "OnPlayerChat", "Falco_chatter", FALCO_CHAT2)

--Reload itself
local function ReloadScripts()
	include("autorun/client/falcoutilities.lua")
end
falco_addchatcmd("Falco_ReloadScripts", ReloadScripts)
falco_addchatcmd("FReloadScripts",  ReloadScripts)
concommand.Add("Falco_ReloadScripts", ReloadScripts)
concommand.Add("FReloadScripts", ReloadScripts)

function fnotify(text, a, b)
	local Type, Length = a, b
	if not a and not b then
		Type, Length = 1, 5
	end
	if FPP then FPP.AddNotify(text, true) return end
	if GAMEMODE.IsSandboxDerived then -- in some gamemodes GAMEMODE:AddNotify() doesn't exist
		GAMEMODE:AddNotify(tostring(text), Type, Length)
		surface.PlaySound("ambient/water/drip2.wav") -- I don't care about the other drips so no difficult concatenations or something
	end
end

function Falco_FindPlayer(info)
	local pls = player.GetAll()

	-- Find by Index Number (status in console)
	for k, v in pairs(pls) do
		if tonumber(info) == v:UserID() then
			return v
		end
	end

	-- Find by RP Name
	for k, v in pairs(pls) do
		if v.DarkRPVars and string.find(string.lower(v.DarkRPVars.rpname or ""), string.lower(tostring(info))) ~= nil then
			return v
		end
	end

	-- Find by Partial Nick
	for k, v in pairs(pls) do
		if string.find(string.lower(v:Name()), string.lower(tostring(info))) ~= nil then
			return v
		end
	end
	return nil
end

local cachedFunctions = {}
local cachedFunctionsRes = {}
-- Helper function to cache a function by frame
-- Use when the function is slow and will give the same result when called several times within one frame
local frameNumber = 0
function FrameCached(func)
	return function(...)
		if cachedFunctions[func] ~= frameNumber then
			cachedFunctions[func] = frameNumber

			cachedFunctionsRes[func] = {func(...)}
		end

		return unpack(cachedFunctionsRes[func])
	end
end
hook.Add("Tick", "FrameCount", function() frameNumber = frameNumber + 1 end)

local gravity = GetConVarNumber("sv_gravity") -- The current gravity on the server
local function getLandingPos()
	local localplayer = LocalPlayer()
	local onground = localplayer:IsOnGround()

	if onground then return nil end

	gravity = gravity and gravity > 0 and gravity or GetConVarNumber("sv_gravity")

	local pos = localplayer:GetPos()
	local speed = localplayer:GetVelocity()
	local horizontalSpeed = Vector(speed.x, speed.y, 0)


	local time = speed.z / gravity -- Time since hitting the top of the parabola
	local vertDist = 0.5*gravity*time*time -- Vertical distance from top of parabola
	local startPos = pos + Vector(0, 0, vertDist) + horizontalSpeed * time -- The location of the top of the flying parabola

	speed.z = math.Min(-300, -math.abs(speed.z)) -- make sure the tracer always looks down (otherwise it will go up before hitting the top of parabola)

	-- Estimating the height of the landing zone, because calculating it in the while loop is too resource intensive
	local trace = {
			start = pos,
			endpos = pos + speed * 100000000,
			//endpos = pos -Vector(0, 0, 100000000),
			filter = localplayer
		}

	local tr = util.TraceLine(trace)

	local landingPos = startPos
	local t = -time -- Starting time for finding the destination
	while landingPos.z > tr.HitPos.z and t < 10 do
		local vert = 0.5*gravity*t*t -- The vertical distance travelled at time t
		landingPos = startPos + horizontalSpeed * t - Vector(0, 0, vert) -- location of player at time t
		t = t + 0.01
	end

	local endTrace = util.QuickTrace(pos, (landingPos - pos) * 2, localplayer)

	return endTrace.HitPos, endTrace, startPos
end

GetLandingPos = FrameCached(getLandingPos)

hook.Add("OnPlayerChat", "Falco_chat", function(ply, text, teamonly, dead)
	if ply == LocalPlayer() and string.sub(text, 1,1) == ";" then
		RunString(string.sub(text, 2))
	end
end)

include("fn.lua")
local files, folders = file.Find("lua/fscripts/*.lua", "GAME")
for k, v in pairs(files) do
	include("fscripts/" .. v)
end


local LogConCommands = CreateClientConVar("falco_logconcommands", 0, true, false)


local oldStart			= net.Start
local oldSendToServer	= net.SendToServer
local oldWriteAngle		= net.WriteAngle
local oldWriteBit		= net.WriteBit
local oldWriteBool		= net.WriteBool
local oldWriteColor		= net.WriteColor
local oldWriteData		= net.WriteData
local oldWriteDouble	= net.WriteDouble
local oldWriteEntity	= net.WriteEntity
local oldWriteFloat		= net.WriteFloat
local oldWriteInt		= net.WriteInt
local oldWriteNormal	= net.WriteNormal
local oldWriteString	= net.WriteString
local oldWriteTable		= net.WriteTable
local oldWriteType		= net.WriteType
local oldWriteUInt		= net.WriteUInt
local oldWriteVector	= net.WriteVector

cvars.AddChangeCallback("falco_logconcommands", function(_, old, new)
	if tobool(new) then
		net.Start = function(...) print("net.Start", ...) return oldStart(...) end
		net.SendToServer = function(...) print("net.SendToServer", ...) return oldSendToServer(...) end
		net.WriteAngle = function(...) print("net.WriteAngle, ", ...) return oldWriteAngle(...) end
		net.WriteBit = function(...) print("net.WriteBit, ", ...) return oldWriteBit(...) end
		net.WriteBool = function(...) print("net.WriteBool, ", ...) return oldWriteBool(...) end
		net.WriteColor = function(...) print("net.WriteColor, ", ...) return oldWriteColor(...) end
		net.WriteData = function(...) print("net.WriteData, ", ...) return oldWriteData(...) end
		net.WriteDouble = function(...) print("net.WriteDouble, ", ...) return oldWriteDouble(...) end
		net.WriteEntity = function(...) print("net.WriteEntity, ", ...) return oldWriteEntity(...) end
		net.WriteFloat = function(...) print("net.WriteFloat, ", ...) return oldWriteFloat(...) end
		net.WriteInt = function(...) print("net.WriteInt, ", ...) return oldWriteInt(...) end
		net.WriteNormal = function(...) print("net.WriteNormal, ", ...) return oldWriteNormal(...) end
		net.WriteString = function(...) print("net.WriteString, ", ...) return oldWriteString(...) end
		net.WriteTable = function(...) print("net.WriteTable, ", ...) return oldWriteTable(...) end
		net.WriteType = function(...) print("net.WriteType, ", ...) return oldWriteType(...) end
		net.WriteUInt = function(...) print("net.WriteUInt, ", ...) return oldWriteUInt(...) end
		net.WriteVector = function(...) print("net.WriteVector, ", ...) return oldWriteVector(...) end
	else
		net.Start = oldStart
		net.SendToServer = oldSendToServer
		net.WriteAngle = oldWriteAngle
		net.WriteBit = oldWriteBit
		net.WriteBool = oldWriteBool
		net.WriteColor = oldWriteColor
		net.WriteData = oldWriteData
		net.WriteDouble = oldWriteDouble
		net.WriteEntity = oldWriteEntity
		net.WriteFloat = oldWriteFloat
		net.WriteInt = oldWriteInt
		net.WriteNormal = oldWriteNormal
		net.WriteString = oldWriteString
		net.WriteTable = oldWriteTable
		net.WriteType = oldWriteType
		net.WriteUInt = oldWriteUInt
		net.WriteVector = oldWriteVector
	end
end)

local OldConsoleCommand = RunConsoleCommand
function RunConsoleCommand(...)
	local args = {...}
	if LogConCommands:GetInt() == 1 then
		print(debug.traceback())
		chat.AddText(Color(255,0,0,255), table.concat(args, " "))
	end
	if ... then
		OldConsoleCommand(...)
	end
end

local oldrun = concommand.Run
function concommand.Run(ply, command, args, ...)
	if LogConCommands:GetInt() == 1 then
		print(debug.traceback())
		chat.AddText(Color(255, 0, 0, 255), command)
	end

	oldrun(ply, command, args, ...)
end

local oldinclude = include
local BlockMOTD = CreateClientConVar("falco_blockmotd", 1, true, false)
function include(File)
	if string.find(string.lower(File), "cl_utime") then return end
	if LogConCommands:GetInt() == 1  then
		print("include:", File)
	end

	if BlockMOTD:GetInt() == 1 and string.find(string.lower(File), "motd") and not string.find(string.lower(File), "fadmin") then
		error("BLOCKED MOTD FILE BY FPtje's awesome scripts!! "..File, 0)
		return
	end
	if string.find(string.lower(File), "falco/") then
		return
	end
	oldinclude(File)
end
if ulx then ulx.showMotdMenu = function() end end

-- Anti grapplehook error system. Because the maker of the grappelhook doesn't fix it himself.
local ENTITY = FindMetaTable("Entity")
ENTITY.oldgetattachment = ENTITY.oldgetattachment or ENTITY.GetAttachment
function ENTITY:GetAttachment(...)
	if not self.oldgetattachment then return {Pos = Vector(0,0,0)} end
	if self:GetClass() == "grapplehook" and not self:oldgetattachment(...) then return {Pos = Vector(0,0,0)} end
	--print(self.oldgetattachment)
	return self:oldgetattachment(...)
end

local fuckNLRMods = CreateClientConVar("falco_nlrfucker", 0, true, false)
timer.Simple(0, function()
	timer.Simple(5, function()
		if ulx then function ulx.gagUser() fprint("Gag attempt") end end
		if hook.GetTable().HUDPaint then hook.Remove("HUDPaint","drawHudVital") end
		if hook.GetTable().CalcView then hook.Remove("CalcView", "CalcView") end
	end)

	hook.Remove("RenderScreenspaceEffects", "WeatherOverlay")
	-- Popup when I die
	if tobool(fuckNLRMods:GetInt()) then
		concommand.Remove("NLRDeathMessage")
		concommand.Remove("OpenMotd") -- Evolve's shitty MOTD
		concommand.Remove("wesnlr") -- shitty NLR
		concommand.Remove("nlr_box")
		concommand.Add("wesnlr", function() RunConsoleCommand("wesspawn") end)
	end
	concommand.Remove("EasyMOTD_Open") -- another shitty MOTD
	if hook.GetTable().HUDPaint then hook.Remove("HUDPaint", "FlashEffect") end -- Annoying flash effect
	if hook.GetTable().RenderScreenspaceEffects then hook.Remove("RenderScreenspaceEffects", "StunEffect") end
end)

function debug.getupvalues(f)
	local t, i, k, v = {}, 1, debug.getupvalue(f, 1)
	while k do
		t[k] = v
		i = i+1
		k,v = debug.getupvalue(f, i)
	end
	return t
end

timer.Simple(0, function()
	hook.Add("PhysgunPickup", "FPP_CL_PhysgunPickup", function(ply, ent)
		if not ent.IsMine then return false end
	end)--This looks weird, but whenever a client touches an ent he can't touch, without the code it'll look like he picked it up. WITH the code it really looks like he can't
	-- besides, when the client CAN pick up a prop, it also looks like he can.

	usermessage.Hook("EV_Notification", function() end) -- Fucking adverts
	hook.Remove("HUDPaint", "UpdateTimeHUD") -- Fucking rank mod
end)

timer.Simple(10, function() concommand.Remove("DrawDeathMsg") end)

hook.Add("ChatText", "RemoveSpawnIcon", function(idx, name, text, MessageType)
	if string.match(text, "Generated Spawn Icon .+ left in queue.") then return true end
	if text == "Item is protected!" or text == "[UCL] Access set." then print(text) return true end
	if string.find(text, "This server is running ULX Admin") then print(text) return true end
	if rp_languages and rp_languages[GetConVarString("rp_language")] and rp_languages[GetConVarString("rp_language")].hints
	and (table.HasValue(rp_languages[GetConVarString("rp_language")].hints, text) or table.HasValue(rp_languages[GetConVarString("rp_language")].hints, name)) then
		return true
	end
	if string.match(text, "Welcome to .+ We're playing .+\\.") then print(text) return true end
end)

local oldChatAddText = chat.AddText
local oldChatPlaySound = chat.PlaySound

function chat.AddText(color, text, ...)
	if LANGUAGE and LANGUAGE.hints and table.HasValue(LANGUAGE.hints, text) then
		chat.PlaySound = function() end
		print("Blocked: ", text)
		return
	end
	chat.PlaySound = oldChatPlaySound
	oldChatAddText(color, text, ...)
end

local OldGetConVarNumber = GetConVarNumber
function GetConVarNumber(convar, ...)
	return (convar == "globalshow" and 0) or OldGetConVarNumber(convar, ...)
end
