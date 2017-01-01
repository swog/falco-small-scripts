-- PERFORMANCE VARS
local _RBACKUP = debug.getregistry()
local FToScreen = _RBACKUP.Vector.ToScreen
local FDistance = _RBACKUP.Vector.Distance

local FEyeAngles = _RBACKUP.Entity.EyeAngles
local FEntIndex = _RBACKUP.Entity.EntIndex
local FLookupAttachment = _RBACKUP.Entity.LookupAttachment
local FGetAttachment = _RBACKUP.Entity.GetAttachment
local FGetClass = _RBACKUP.Entity.GetClass
local FGetPos = _RBACKUP.Entity.GetPos
local FGetNWInt = _RBACKUP.Entity.GetNWInt
local FGetNWString = _RBACKUP.Entity.GetNWString

local FGetPrintName = _RBACKUP.Weapon.GetPrintName

local FShootPos = _RBACKUP.Player.GetShootPos
local FTeam = _RBACKUP.Player.Team
local FGetActiveWeapon = _RBACKUP.Player.GetActiveWeapon
local FGetAimVector = _RBACKUP.Player.GetAimVector
local FNick = _RBACKUP.Player.Nick
local FIsAdmin = _RBACKUP.Player.IsAdmin
local FIsSuperAdmin = _RBACKUP.Player.IsSuperAdmin

-- General mod compatability :D
timer.Simple(10, function()
	FNick = _RBACKUP.Player.Nick
	FIsAdmin = _RBACKUP.Player.IsAdmin
	FIsSuperAdmin = _RBACKUP.Player.IsSuperAdmin
end)

local CreateClientConVar = CreateClientConVar
local string = string
local util = util
local pairs = pairs
local math = math
local draw = draw
local type = type
local render = render
local hook = hook
local LocalPlayer = LocalPlayer
local Angle = Angle
local cam = cam
local table = table
local RunConsoleCommand = RunConsoleCommand
local IsValid = IsValid
local player = player
local ents = ents
local EyePos = EyePos
local EyeAngles = EyeAngles
local tostring = tostring
local Vector = Vector
local team = team
local ScrW = ScrW
local ScrH = ScrH

local ESPOn = CreateClientConVar("FESPTOGGLE", 1, true, false)
local CrossHairOn = CreateClientConVar("falco_Crosshair", 1, true, false)

local MiddleAllign = CreateClientConVar("FESPMiddleAllign", 0, true, false)
local CHair = CreateClientConVar("FESPCHair", 1, true, false)
local CHairLimited = CreateClientConVar("FESPCHairLimited", 1, true, false)
local SuperChair = CreateClientConVar("FESPCHairSuper", 0, true, false)
local dotsize = CreateClientConVar("FESPDotSize", 10, true, false)
local bordersize = CreateClientConVar("FESPBorderSize", 1, true, false)
local FShowName = CreateClientConVar("FESPShowName", 1, true, false)
local FShowHealth = CreateClientConVar("FESPShowHealth", 1, true, false)
local FShowAdmin = CreateClientConVar("FESPShowAdmin", 1, true, false)
local FShowOwner = CreateClientConVar("FESPShowOwner", 1, true, false)
local FShowRPMoney = CreateClientConVar("FESPShowRPMoney", 1, true, false)
local FShowSpeed = CreateClientConVar("FESPShowSpeed", 0, true, false)
local FShowDistance = CreateClientConVar("FESPShowDistance", 1, true, false)
local FShowWeapon = CreateClientConVar("FESPShowWeapon", 1, true, false)
local FESPCorrection = CreateClientConVar("FESPCorrection", 1, true, false)
local FMirror = CreateClientConVar("FESPMirror", 0, true, false)
local FMirrorx = CreateClientConVar("FESPMirrorx", 0, true, false)
local FMirrory = CreateClientConVar("FESPMirrory", 0, true, false)
local FMirrorw = CreateClientConVar("FESPMirrorw", 300, true, false)
local FMirrorh = CreateClientConVar("FESPMirrorh", 300, true, false)

local CustomENTS = {}
local ESPPos = {}
local ESPLines = {}

local DingetjesLijst = CreateClientConVar("FESPAllHappyDingetjes", "", true, false)
local DrawLijst =  {}

local EntityShowTable
if DingetjesLijst:GetString() ~= "" then
	EntityShowTable = string.Explode("|", DingetjesLijst:GetString())
else
	EntityShowTable = {}
end

local vector = FindMetaTable("Vector")

--Vector:IsInSight(ignore, ply) by FPtje
--[[
Use Vectore:IsInSight(table/entity ignore this, ply visible to player)
]]
function vector:IsInSight(ignore, ply)
	ply = ply or LocalPlayer()
	local trace = {}
	trace.start = FShootPos(ply)
	trace.endpos = self
	trace.filter = ignore
	trace.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
	local TheTrace = util.TraceLine(trace)
	return TheTrace.Hit, TheTrace.HitPos, trace.Entity
end

local function FGetEyeTrace(ply)
	local HeadPos = FShootPos(ply)
	local tracedata = {}
	tracedata.start = HeadPos
	tracedata.endpos = HeadPos + FGetAimVector(ply) * 10000
	tracedata.filter = ply
	tracedata.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER

	local trace = util.TraceLine(tracedata)
	return trace
end

--[[
Material( "cable/new_cable_lit" )
Material( "cable/chain" )
Material("sprites/yellowlaser1")
Material("cable/cable_metalwinch01")
Material( "vgui/icons/icon_arrow_down" )
Material( "overlays/garagegroundmarking01b" )
]]
local LineMat = Material("sprites/lookingat")
local function NamesOnHeads()
	local ScrWidth, ScrHeight = ScrW(), ScrH()
	local aimVec = LocalPlayer():GetAimVector()
	local localPos = EyePos()

	surface.SetFont("FALCO_FONT")
	local textw, texth = surface.GetTextSize("h")
	if CrossHairOn:GetInt() == 1 then
		local Size = 9

		surface.SetDrawColor(0,0,100,160)
		surface.DrawLine(ScrWidth/2-Size, ScrHeight/2 + 1, ScrWidth/2+Size, ScrHeight/2 + 1)
		surface.DrawLine(ScrWidth/2-Size, ScrHeight/2 - 1, ScrWidth/2+Size, ScrHeight/2 - 1)

		surface.DrawLine(ScrWidth/2 + 1, ScrHeight/2 - Size, ScrWidth/2 + 1, ScrHeight/2 + Size)
		surface.DrawLine(ScrWidth/2 - 1, ScrHeight/2 - Size, ScrWidth/2 - 1, ScrHeight/2 + Size)

		surface.SetDrawColor(255,100,100,255)
		surface.DrawLine(ScrWidth/2 - Size, ScrHeight/2, ScrWidth/2 + Size, ScrHeight/2)
		surface.DrawLine(ScrWidth/2, ScrHeight/2 - Size, ScrWidth/2, ScrHeight/2 + Size)

	end
	if ESPOn:GetInt() == 1 then
		local DotSize = GetConVarNumber("FESPDotSize")

		for k,v in pairs(DrawLijst) do
			if aimVec:Dot((v.pos - localPos):GetNormalized()) < 0.5 then continue end

			local Correction = tobool(FESPCorrection:GetInt()) and (#v.data * 15) or 0
			local pos = FToScreen(v.pos)
			pos.x = math.Clamp(pos.x, 0, ScrWidth)
			pos.y = math.Clamp(pos.y, 45, ScrHeight)

			if not v.IsLooking then
				draw.RoundedBox(1, pos.x - 1.5 * DotSize, pos.y - 0.5 * DotSize - Correction, DotSize, DotSize, Color(v.teamcolor.r,v.teamcolor.g,v.teamcolor.b))
			end
			for a,b in pairs(v.data) do
				local w = -0.5 * DotSize
				if MiddleAllign:GetInt() == 1 then
					w = string.len(b) * 2.3
				end
				local BorderSize = GetConVarNumber("FESPBorderSize")
				draw.WordBox(BorderSize, pos.x - w - DotSize, (pos.y + (a-1) * (texth + BorderSize) + 0.5 * DotSize) - Correction, b , "FALCO_FONT", Color(0,0,0,50), Color(255, 255, 255, 255))
			end
		end
		for k,v in pairs(ESPPos) do
			local pos = FToScreen(v)
			draw.RoundedBox(1, pos.x - 0.5 * DotSize, pos.y - 0.5 * DotSize, DotSize, DotSize, Color(255,0,0,255))
		end
	end
	if FMirror:GetInt() == 1 then
		local CamData = {}
		local ang = FEyeAngles(LocalPlayer())
		CamData.angles = Angle(ang.p - ang.p - ang.p, ang.y - 180, ang.r)
		CamData.origin = FShootPos(LocalPlayer())
		CamData.x, CamData.y, CamData.w, CamData.h = FMirrorx:GetInt(), FMirrory:GetInt(), FMirrorw:GetInt(), FMirrorh:GetInt()
		render.RenderView( CamData )
		draw.RoundedBox(1, (ScrWidth / 2) - 1.5, (ScrHeight / 2) - 1.5, 3, 3, Color(255,255,255,255))
	end

end
hook.Add("HUDPaint", "NamesOnTEHHeads", NamesOnHeads)

local function DrawLines()
	cam.Start3D(EyePos(), EyeAngles())
	render.SetMaterial(LineMat)

	for k,v in pairs(DrawLijst) do
		if v.IsLooking then
			local distance = FDistance(v.pos, v.origin)
			render.DrawBeam(v.pos, v.origin, 4, 0.01, distance/30, Color(v.teamcolor.r,v.teamcolor.g,v.teamcolor.b))
		end
	end

	for k, v in pairs(ESPLines) do
		local distance = FDistance(v[2], v[1])
		render.DrawBeam(v[2], v[1], 4, 0.01, distance/30, Color(0, 255, 0, 255))
	end

	cam.End3D()
end
hook.Add("RenderScreenspaceEffects", "FESP_DrawLines", DrawLines)

function FESPAddEnt(ent, id)
	CustomENTS[id or (#CustomENTS + 1)] = ent
end

function FESPRemoveEnt(id)
	CustomENTS[id] = nil
end

function FESPClearEnt()
	CustomENTS = {}
end

function FESPAddPos(...)
	for k,v in pairs({...}) do
		table.insert(ESPPos, v)
	end
end
falco_addchatcmd("FESPAddPosLA", function()
	FESPAddPos(FGetEyeTrace(LocalPlayer()).HitPos)
end)

falco_addchatcmd("FESPClearPos", function()
	FESPClearPos()
end)
usermessage.Hook("FESPAddPos", function(um)
	FESPAddPos(um:ReadVector())
end)

function FESPClearPos()
	ESPPos = {}
end

function FESPAddLine(first, last)
	table.insert(ESPLines, {first, last})
	fprint("Line added, distance: ", first:Distance(last))
end
usermessage.Hook("FESPAddLine", function(um)
	FESPAddLine(um:ReadVector(), um:ReadVector())
end)

function FESPClearLines()
	ESPLines = {}
end

function FESPClear()
	FESPClearPos()
	FESPClearLines()
end

local function AddEntityToShow(ply, cmd, args)
	table.insert(EntityShowTable, tostring(args[1]))
	local newstring = table.concat(EntityShowTable, "|")
	RunConsoleCommand("FESPAllHappyDingetjes", newstring)
end
concommand.Add("FESPAddEntity", AddEntityToShow)

local function RemoveEntityToShow(ply, cmd, args)
	for k,v in pairs(EntityShowTable) do
		if string.lower(v) == string.lower(tostring(args[1])) then
			table.remove(EntityShowTable, k)
			local newstring = table.concat(EntityShowTable, "|")
			if table.Count(EntityShowTable) > 0 then
				RunConsoleCommand("FESPAllHappyDingetjes", newstring)
			else
				RunConsoleCommand("FESPAllHappyDingetjes", "")
			end
		end
	end
end
concommand.Add("FESPRemoveEntity", RemoveEntityToShow)

local function HeadPos(ent)
	if not IsValid(ent) then return Vector(0,0,0) end
	local head = FLookupAttachment(ent, "eyes")
	local Head = FGetAttachment(ent, head)
	if not Head then
		return FShootPos(ent)
	end
	return Head.Pos
end

--[[ local function gunpos(ply)
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return HeadPos(ply) end
	local att = wep:LookupAttachment("muzzle")
	if not wep:GetAttachment(1) then
		return HeadPos(ply)
	end
	return wep:GetAttachment(1).Pos
end ]]

local NoLookingAtWeapons = {
	["weapon_physgun"] = true,
	["weapon_physcannon"] = true,
	["gmod_camera"] = true,
	["keys"] = true,
	["pocket"] = true}
local tick = 0
local ticktable = {}
for i=0,1000,10 do
	ticktable[i] = true
end

local function FESPThink()
	local AllPly = player.GetAll()
	for k = 1, #AllPly do
		local v = AllPly[k] -- Lazy me.
		if v ~= LocalPlayer() then
			local entindex = FEntIndex(v)
			local a = DrawLijst[entindex] or {}

			a.data = a.data or {}

			local teamcolor = a.teamcolor or team.GetColor(FTeam(v))
			a.teamcolor = teamcolor
			local wep = FGetActiveWeapon(v)
			a.pos = HeadPos(v)
			a.dir = FGetAimVector(v)
			a.origin = EyePos()

			if CHair:GetInt() == 1 and (CHairLimited:GetInt() == 0 or (CHairLimited:GetInt() == 0 and (not IsValid(wep) or IsValid(wep) and not NoLookingAtWeapons[FGetClass(wep)]))) then
				local b = {}
				b.data = {}
				b.teamcolor = a.teamcolor
				b.IsLooking = true

				local lookat1 = FGetEyeTrace(v)
				local lookat = lookat1.HitPos

				b.pos = lookat
				b.origin = a.pos

				DrawLijst[tostring(entindex) .. "look1"] = b
				local origin = b.origin

				if SuperChair:GetInt() == 1 and (b.pos:IsInSight(v) or origin:IsInSight(v)) then
					local aimvector = FGetAimVector(v)
					local aimvecAngle = aimvector:Angle()

					local distance = FDistance((aimvector*9000000), origin)
					local upperdistance = distance / math.tan(44.91)
					local rightdistance = distance / math.tan(44.675)
					local UpperBorder = aimvecAngle:Up() * upperdistance
					local RightBorder = aimvecAngle:Right() * rightdistance

					local c = {}
					c.data = {}
					c.teamcolor = b.teamcolor
					c.IsLooking = true
					c.pos = (aimvector*9000000) + RightBorder + UpperBorder
					local _, cpos = c.pos:IsInSight(v, v)
					c.pos = cpos

					c.origin = origin

					DrawLijst[tostring(entindex) .. "look2"] = c

					local d = {}
					d.data = {}
					d.teamcolor = b.teamcolor
					d.IsLooking = true
					d.pos = (aimvector*9000000) - RightBorder + UpperBorder
					local _, dpos = d.pos:IsInSight(v, v)
					d.pos = dpos
					d.origin = origin

					DrawLijst[tostring(entindex) .. "look3"] = d

					local e = {}
					e.data = {}
					e.teamcolor = b.teamcolor
					e.IsLooking = true
					e.pos = (aimvector*9000000) - RightBorder - UpperBorder
					local _, epos = e.pos:IsInSight(v, v)
					e.pos = epos
					e.origin = origin


					DrawLijst[tostring(entindex) .. "look4"] = e

					local f = {}
					f.data = {}
					f.teamcolor = b.teamcolor
					f.IsLooking = true
					f.pos = (aimvector*9000000) + RightBorder - UpperBorder
					local _, fpos = f.pos:IsInSight(v, v)
					f.pos = fpos
					f.origin = origin

					DrawLijst[tostring(entindex) .. "look5"] = f

					local g = {}
					g.data = {}
					g.teamcolor = b.teamcolor
					g.IsLooking = true
					g.pos = c.pos
					g.origin = d.pos

					DrawLijst[tostring(entindex) .. "look6"] = g

					local h = {}
					h.data = {}
					h.teamcolor = b.teamcolor
					h.IsLooking = true
					h.pos = d.pos
					h.origin = e.pos

					DrawLijst[tostring(entindex) .. "look7"] = h

					local i = {}
					i.data = {}
					i.teamcolor = b.teamcolor
					i.IsLooking = true
					i.pos = e.pos
					i.origin = f.pos

					DrawLijst[tostring(entindex) .. "look8"] = i

					local j = {}
					j.data = {}
					j.teamcolor = b.teamcolor
					j.IsLooking = true
					j.pos = f.pos
					j.origin = c.pos

					DrawLijst[tostring(entindex) .. "look0"] = j
				end
			end

			if ticktable[tick+((k-1)*2)] or not DrawLijst[entindex] then
				a.data = {}
				local ADataCount = 0 -- It's faster to not user table.insert.

				teamcolor = team.GetColor(FTeam(v))
				if FShowName:GetInt() == 1 then
					a.data[ADataCount + 1] = FNick(v)
					ADataCount = ADataCount + 1
				end

				if v.getHitTarget and IsValid(v:getHitTarget()) and v:getHitTarget() ~= v then
					a.data[ADataCount + 1] = "Hit target: "..FNick(v:getHitTarget())
					ADataCount = ADataCount + 1
				end
				if FShowHealth:GetInt() == 1 then
					a.data[ADataCount + 1] = "Health: " .. v:Health()
					ADataCount = ADataCount + 1
				end

				local money = (v.DarkRPVars and v.DarkRPVars.money) or FGetNWInt(v, "money")

				if FShowRPMoney:GetInt() == 1 and money ~= 0 then
					a.data[ADataCount + 1] = "Money: " .. tostring(money)
					ADataCount = ADataCount + 1
				end

				if FShowSpeed:GetInt() == 1 then
					a.data[ADataCount + 1] = "Speed: " .. tostring(math.floor(v:GetVelocity():Length()))
					ADataCount = ADataCount + 1
				end

				if FShowWeapon:GetInt() == 1 and wep:IsValid() then
					a.data[ADataCount + 1] = FGetPrintName(wep)
					ADataCount = ADataCount + 1
				end

				if FShowDistance:GetInt() == 1 then
					a.data[ADataCount + 1] = "Distance: " .. tostring(math.floor(FDistance(a.pos, LocalPlayer():GetPos())))
					ADataCount = ADataCount + 1
				end

				if v:GetObserverTarget() ~= NULL and v:GetObserverTarget() ~= nil then
						a.data[ADataCount] = "SPECTATING: "..(v:GetObserverTarget().Nick and v:GetObserverTarget():Nick() or v:GetObserverTarget():GetClass())
					ADataCount = ADataCount + 1
				end

				a.teamcolor = {}
				local entered = false
				local usergroup = string.lower(FGetNWString(v, "UserGroup"))
				if usergroup ~= "user" and usergroup ~= "" and usergroup ~= "superadmin" and usergroup ~= "admin" and usergroup ~= "undefined" and usergroup ~= "guest" and FShowAdmin:GetInt() == 1 then
					a.data[ADataCount + 1] =  usergroup
					ADataCount = ADataCount + 1
					entered = true
				end

				local ASSadmin = FGetNWInt(v, "ASS_isAdmin", 0)
				if LevelToString ~= nil then
					local ASSAdminString = LevelToString(ASSadmin)
					if ASSAdminString ~= "Guest" and ASSAdminString ~= "Admin" and ASSAdminString ~= "Super Admin" and not table.HasValue(a.data, LevelToString(ASSadmin)) then
						a.data[ADataCount + 1] = LevelToString(ASSadmin)
						ADataCount = ADataCount + 1
						entered = true
					end

					if (usergroup == "superadmin" or usergroup == "admin") and not entered then
						a.data[ADataCount + 1] = LevelToString(ASSadmin)
						ADataCount = ADataCount + 1
					end
				end

				local IsAdmin, IsSuperAdmin = FIsAdmin(v), FIsSuperAdmin(v)
				if IsAdmin and not IsSuperAdmin then
					if FShowAdmin:GetInt() == 1 and not table.HasValue(a.data, "Admin") then
						a.data[ADataCount + 1] = "Admin"
						ADataCount = ADataCount + 1
					end
					if teamcolor.r == 255 and teamcolor.g == 255 and teamcolor.b == 100 then
						a.teamcolor.r = 30
						a.teamcolor.g = 200
						a.teamcolor.b = 50
					else
						a.teamcolor.r = teamcolor.r
						a.teamcolor.g = teamcolor.g
						a.teamcolor.b = teamcolor.b
					end
				elseif FIsSuperAdmin(v) then
					if FShowAdmin:GetInt() == 1 and not table.HasValue(a.data, "superadmin") and not table.HasValue(a.data, "Owner") and not table.HasValue(a.data, "Super Admin") then
						a.data[ADataCount + 1] = "Super Admin"
						ADataCount = ADataCount + 1
					end
					if teamcolor.r == 255 and teamcolor.g == 255 and teamcolor.b == 100 then
						a.teamcolor.r = 30
						a.teamcolor.g = 200
						a.teamcolor.b = 50
					else
						a.teamcolor.r = teamcolor.r
						a.teamcolor.g = teamcolor.g
						a.teamcolor.b = teamcolor.b
					end
				elseif not IsAdmin then
					if teamcolor.r == 255 and teamcolor.g == 255 and teamcolor.b == 100 then
						a.teamcolor.r = 100
						a.teamcolor.g = 150
						a.teamcolor.b = 245
					else
						a.teamcolor.r = teamcolor.r
						a.teamcolor.g = teamcolor.g
						a.teamcolor.b = teamcolor.b
					end
				end
			end

			DrawLijst[entindex] = a
		end
	end

	if #EntityShowTable >= 1 then
		for k,v in pairs(ents.GetAll()) do
			for a, b in pairs(EntityShowTable) do
				local a = {}
				if IsValid(v) and string.find(FGetClass(v), b)  then
					local pos = FGetPos(v)
					local EntIndex = FEntIndex(v)


					a.data = {}
					if FShowName:GetInt() == 1 then
						table.insert(a.data, FGetClass(v))
					end
					a.pos = pos
					a.teamcolor = Color(255,255,255,255)
					local owner = FGetNWString(v, "Owner")
					if FShowOwner:GetInt() == 1 and owner ~= "" then
						table.insert(a.data, owner)
					end
					local speed = math.floor(v:GetVelocity():Length())
					if FShowSpeed:GetInt() == 1 and speed > 0 then
						table.insert(a.data, "speed: " .. tostring(speed))
					end

					if FShowDistance:GetInt() == 1 then
						table.insert(a.data, "Distance: " .. tostring(math.floor(a.pos:Distance(LocalPlayer():GetPos()))))
					end
					DrawLijst[EntIndex] = a
				end
			end
		end
	end

	if table.Count(CustomENTS) > 0 then
		for k,v in pairs(CustomENTS) do
			if not IsValid(v) then CustomENTS[k] = nil continue end
			local EntIndex = FEntIndex(v)
			local a = {}
			a.data = {}
			table.insert(a.data, FGetClass(v))
			a.pos = FGetPos(v)
			a.teamcolor = Color(255,0,0,255)
			local owner = FGetNWString(v, "Owner")
			if FShowOwner:GetInt() == 1 and owner ~= "" then
				table.insert(a.data, owner)
			end
			local speed = math.floor(v:GetVelocity():Length())
			if FShowSpeed:GetInt() == 1 and speed > 0 then
				table.insert(a.data, "speed: " .. tostring(speed))
			end
			if FShowDistance:GetInt() == 1 then
				table.insert(a.data, "Distance: " .. tostring(math.floor(FDistance(a.pos, FGetPos(LocalPlayer())))))
			end
			DrawLijst[EntIndex] = a
		end
	end
	tick = tick + 1
	if tick >= 1000 then
		DrawLijst = {}
		tick = 0

		ticktable = {}
		for i=1,1000,#AllPly*2 do
			ticktable[i] = true
		end
	end
end

if ESPOn:GetInt() == 1 then
	hook.Add("Think", "FespThink", FESPThink)
end

cvars.AddChangeCallback("FESPTOGGLE", function(cvar, prevvalue, newvalue)
	if math.floor(newvalue) == 1 then
		hook.Add("Think", "FespThink", FESPThink)
	else
		hook.Remove("Think", "FespThink")
	end
end)

function FESPVgui()
	local frame = vgui.Create("DFrame")
	frame:SetTitle("FESP config")
	frame:SetSize(280, 660)
	frame:Center()
	frame:SetVisible(true)
	frame:MakePopup()

	local Panel = vgui.Create( "DPanelList", frame )
	Panel:SetPos(20,30)
	Panel:SetSize(240, 630)
	Panel:SetSpacing(5)
	Panel:EnableHorizontal( false )
	Panel:EnableVerticalScrollbar( true )

	local ToggleEsp = vgui.Create( "DCheckBoxLabel", frame )
	ToggleEsp:SetText("Toggle FESP")
	ToggleEsp:SetConVar("FESPTOGGLE")
	Panel:AddItem(ToggleEsp)

	local ShowName = vgui.Create( "DCheckBoxLabel", frame )
	ShowName:SetText("Show names")
	ShowName:SetConVar("FESPShowName")
	Panel:AddItem(ShowName)

	local ShowHealth = vgui.Create( "DCheckBoxLabel", frame )
	ShowHealth:SetText("Show health")
	ShowHealth:SetConVar("FESPShowHealth")
	Panel:AddItem(ShowHealth)

	local ShowAdmin = vgui.Create( "DCheckBoxLabel", frame )
	ShowAdmin:SetText("Show admin")
	ShowAdmin:SetConVar("FESPShowAdmin")
	Panel:AddItem(ShowAdmin)

	local ShowOwner = vgui.Create( "DCheckBoxLabel", frame )
	ShowOwner:SetText("Show owner")
	ShowOwner:SetConVar("FESPShowOwner")
	Panel:AddItem(ShowOwner)

	local ToggleChair = vgui.Create( "DCheckBoxLabel", frame )
	ToggleChair:SetText("Show what they're looking at")
	ToggleChair:SetConVar("FESPCHair")
	Panel:AddItem(ToggleChair)

	local ToggleChairLimit = vgui.Create( "DCheckBoxLabel", frame )
	ToggleChairLimit:SetText("Looking at limited weapons")
	ToggleChairLimit:SetConVar("FESPCHairLimited")
	Panel:AddItem(ToggleChairLimit)

	local ToggleRPMoney = vgui.Create( "DCheckBoxLabel", frame )
	ToggleRPMoney:SetText("Show their money(DarkRP)")
	ToggleRPMoney:SetConVar("FESPShowRPMoney")
	Panel:AddItem(ToggleRPMoney)

	local ToggleSpeed = vgui.Create( "DCheckBoxLabel", frame )
	ToggleSpeed:SetText("Show their speed")
	ToggleSpeed:SetConVar("FESPShowSpeed")
	Panel:AddItem(ToggleSpeed)

	local ToggleDistance = vgui.Create( "DCheckBoxLabel", frame )
	ToggleDistance:SetText("Show the Distance")
	ToggleDistance:SetConVar("FESPShowDistance")
	Panel:AddItem(ToggleDistance)

	local ToggleWeapon = vgui.Create( "DCheckBoxLabel", frame )
	ToggleWeapon:SetText("Show the Weapon")
	ToggleWeapon:SetConVar("FESPShowWeapon")
	Panel:AddItem(ToggleWeapon)

	local AllignMiddle = vgui.Create( "DCheckBoxLabel", frame )
	AllignMiddle:SetText("Allign in the middle")
	AllignMiddle:SetConVar("FESPMiddleAllign")
	Panel:AddItem(AllignMiddle)

	local SuperCHair = vgui.Create( "DCheckBoxLabel", frame )
	SuperCHair:SetText("Super CHair")
	SuperCHair:SetConVar("FESPCHairSuper")
	Panel:AddItem(SuperCHair)


	local mirrorbutton = vgui.Create( "DButton", frame)
	mirrorbutton:SetText( "Mirror" )
	mirrorbutton:SetSize(220, 20)
	function mirrorbutton:DoClick()
		frame:SetVisible(false)
		RunConsoleCommand("Falco_Mirror")
	end
	Panel:AddItem(mirrorbutton)

	local dotsizeslider = vgui.Create( "DNumSlider", frame )
	dotsizeslider:SetConVar("FESPDotSize")
	dotsizeslider:SetMin(0)
	dotsizeslider:SetMax(50)
	dotsizeslider:SetText("The size of the dots")
	dotsizeslider:SetDecimals(0)
	dotsizeslider:SetValue(GetConVarNumber("FESPDotSize"))
	Panel:AddItem(dotsizeslider)

	local bordersizeslider = vgui.Create( "DNumSlider", frame )
	bordersizeslider:SetConVar("FESPBorderSize")
	bordersizeslider:SetMin(0)
	bordersizeslider:SetMax(50)
	bordersizeslider:SetText("The size of the borders around the text")
	bordersizeslider:SetDecimals(0)
	bordersizeslider:SetValue(GetConVarNumber("FESPBorderSize"))
	Panel:AddItem(bordersizeslider)

	local EntList = vgui.Create("DListView", frame)
	EntList:SetSize(260, 70)
	EntList:AddColumn("FESP shows these entities:")
	EntList:SetMultiSelect(false)
	for k,v in pairs(EntityShowTable) do
		EntList:AddLine(v)
	end
	function EntList:OnClickLine(line)
		line:SetSelected(true)
		RunConsoleCommand("FESPRemoveEntity", line:GetValue(1))
		EntList:RemoveLine(EntList:GetSelectedLine())
	end

	local AddEntLabel = vgui.Create( "DLabel", frame )
	AddEntLabel:SetText("\nSelect custom entities\nto make FESP show\nuse the ClassName of the ent(advanced)")
	AddEntLabel:SizeToContents()
	Panel:AddItem(AddEntLabel)

	local AddEntTextEntry = vgui.Create("DTextEntry", frame)
	local notagain = notagain or 0
	function AddEntTextEntry:OnEnter()
		if notagain < RealTime() then
			local text = AddEntTextEntry:GetValue()
			EntList:AddLine(text)
			RunConsoleCommand("FESPAddEntity", text)
			AddEntTextEntry:SetText("")
			AddEntTextEntry:RequestFocus( )
			notagain = RealTime() + 0.1
		end
	end
	Panel:AddItem(AddEntTextEntry)


	local AddEntLabel2 = vgui.Create( "DLabel", frame )
	AddEntLabel2:SetText("\nLook at something\nClick the next button\nAnd FESP will detect all of his kind")
	AddEntLabel2:SizeToContents()
	Panel:AddItem(AddEntLabel2)

	local AddLookingAtButton = vgui.Create("DButton", frame)
	AddLookingAtButton:SetText("Add Looking at")
	function AddLookingAtButton:DoClick( )
		local trace = LocalPlayer():GetEyeTrace()
		if trace.Hit and trace.Entity:IsValid() then
			RunConsoleCommand("FESPAddEntity", trace.Entity:GetClass())
			EntList:AddLine(trace.Entity:GetClass())
		end
	end
	Panel:AddItem(AddLookingAtButton)
	Panel:AddItem(EntList)

end
concommand.Add("falco_ESPConfig", FESPVgui)

local function fmirrorderma()
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "FESP miror config" )
	frame:SetSize( 300, 300 )
	frame:Center()
	frame:SetVisible( true )
	frame:MakePopup( )

	local Panel = vgui.Create( "DPanelList", frame )
	Panel:SetPos(20,30)
	Panel:SetSize(260, 260)
	Panel:SetSpacing(5)
	Panel:EnableHorizontal( false )
	Panel:EnableVerticalScrollbar( true )

	local Mirror = vgui.Create( "DCheckBoxLabel", frame )
	Mirror:SetText("Enable mirror")
	Mirror:SetConVar("FESPMirror")
	Panel:AddItem(Mirror)

	local slidermirrorx = vgui.Create( "DNumSlider", frame )

	slidermirrorx:SetConVar("FESPMirrorx")
	slidermirrorx:SetMin(0)
	slidermirrorx:SetMax(ScrW())
	slidermirrorx:SetText("Mirror X position")
	slidermirrorx:SetDecimals(0)
	slidermirrorx:SetValue(GetConVarNumber("FESPMirrorx"))
	Panel:AddItem(slidermirrorx)
	function slidermirrorx:Think()
		slidermirrorx:SetMax(ScrW() - GetConVarNumber("FESPMirrorw"))
	end
	local slidermirrory = vgui.Create( "DNumSlider", frame )

	slidermirrory:SetConVar("FESPMirrory")
	slidermirrory:SetMin(0)
	slidermirrory:SetMax(ScrH())
	slidermirrory:SetText("Mirror Y position")
	slidermirrory:SetDecimals(0)
	slidermirrory:SetValue(GetConVarNumber("FESPMirrory"))
	Panel:AddItem(slidermirrory)
	function slidermirrory:Think()
		slidermirrory:SetMax(ScrH() - GetConVarNumber("FESPMirrorh"))
	end

	local slidermirrorw = vgui.Create( "DNumSlider", frame )
	slidermirrorw:SetConVar("FESPMirrorw")
	slidermirrorw:SetMin(0)
	slidermirrorw:SetMax(ScrW())
	slidermirrorw:SetText("Mirror width")
	slidermirrorw:SetDecimals(0)
	slidermirrorw:SetValue(GetConVarNumber("FESPMirrorw"))
	Panel:AddItem(slidermirrorw)

	local slidermirrorh = vgui.Create( "DNumSlider", frame )
	slidermirrorh:SetConVar("FESPMirrorh")
	slidermirrorh:SetMinMax(0, ScrH())
	slidermirrorh:SetText("Mirror height")
	slidermirrorh:SetDecimals(0)
	slidermirrorh:SetValue(GetConVarNumber("FESPMirrorh"))
	Panel:AddItem(slidermirrorh)
end
concommand.Add("falco_Mirror", fmirrorderma)

falco_addchatcmd("fespconfig", function() RunConsoleCommand("falco_ESPConfig") end)

local Footsteps = CreateClientConVar("Falco_footsteps", 1, true, false)
hook.Add("PlayerFootstep", "Falco_footstepsound", function(ply, Pos, Foot, Soundname, Volume)
	if not tobool(GetConVarNumber("Falco_footsteps")) then return end
	if ply ~= LocalPlayer() then ply:EmitSound("hl1/fvox/hiss.wav", 70, 100) end
	return true
end)

local WeaponClasses = {"crossbow_bolt", "ent_explosivegrenade", "npc_grenade_frag", "npc_satchel", "rpg_missile", "grenade_ar2", "prop_combine_ball", "ent_mad_grenade", "ent_flashgrenade", "ent_grenade", "gmod_dynamite"}
hook.Add("OnEntityCreated", "FESPAddWeaponEnts", function(ent)
	if not IsValid(ent) then return end
	local class = ent:GetClass()

	if table.HasValue(WeaponClasses, class) then
		FESPAddEnt(ent)
	end
end)
