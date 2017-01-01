/*---------------------------------------------------------------------------
Drawing lines between the LocalPlayer and whatever target
with some gimmicks that really aren't that useful
---------------------------------------------------------------------------*/

local AutoKill = CreateClientConVar("falco_autopropsurfkill", 0, true, false)
local AutoKill2 = CreateClientConVar("falco_autopropsurfkill2", 0, true, false)
FALCO_LineOnTarget = FALCO_LineOnTarget or {}

local function gunpos()
	local wep = LocalPlayer():GetViewModel()
	if not IsValid(wep) then return LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 100 end
	local att = wep:LookupAttachment("muzzle")
	if not wep:GetAttachment(att) then
		return LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 100
	end
	return wep:GetAttachment(att).Pos
end

local function Sanitize()
	for k,v in pairs(FALCO_LineOnTarget) do
		if not IsValid(v) then
			table.remove(FALCO_LineOnTarget, k)
		end
	end
end

local TargetLine = Material("sprites/lookingat")
local TargetColors = {Color(255, 0, 0, 255), Color(0, 0, 255, 255), Color(0, 255, 0, 255), Color(128, 128, 0, 255), Color(128, 0, 128, 255), Color(0, 128, 128, 255), Color(255, 255, 0, 255), Color(255, 0, 255, 255), Color(0, 255, 255, 255)}
local autoLineon = CreateClientConVar("falco_lineonauto", 0, false, false)
local doAutoLineOn = false
cvars.AddChangeCallback("falco_lineonauto", function(cvar, prevvalue, newvalue) doAutoLineOn = tobool(newvalue) print(doAutoLineOn) end)
local function DrawTargetLine()
	for k,v in pairs(doAutoLineOn and player.GetAll() or FALCO_LineOnTarget) do
		if v == LocalPlayer() or not IsValid(v) or not v:Alive() then continue end

		local APos, BPos = gunpos(), (v.GetShootPos and v:GetShootPos()) or v:GetPos()
		local distance = BPos:Distance(APos)
		cam.Start3D(EyePos(), EyeAngles())
			--render.SetMaterial(Material( "cable/chain" ))
			--render.SetMaterial(Material( "cable/new_cable_lit" ))
			--render.SetMaterial(Material("sprites/yellowlaser1"))
			--render.SetMaterial(Material("cable/cable_metalwinch01"))
			render.SetMaterial(TargetLine)
			render.DrawBeam(BPos, APos, 4, 0.01, distance/30, TargetColors[k % #TargetColors])
		cam.End3D()
	end
end
hook.Add("HUDPaint", "LineOn", DrawTargetLine)

--Kill Surfers

local DontKill = false
local Alive = true
local function KillSurfer()
	for k,v in pairs(FALCO_LineOnTarget) do
		if not IsValid(v) then continue end
		if DontKill and v:GetVelocity().z < 0  then
			Alive = true
			DontKill = false
		end

		if not DontKill and IsValid(v) and v:GetVelocity().z > 50  then
			local tracedata = {}
			tracedata.start = v:GetPos()
			tracedata.endpos = tracedata.start-Vector(0,0,500)
			tracedata.filter = v
			local trace = util.TraceLine(tracedata)
			if IsValid(trace.Entity) and trace.Entity:GetClass() == "prop_physics" and trace.Entity:GetMoveType() == 6 then
				tracedata.endpos = tracedata.start + LocalPlayer():GetVelocity()*2+Vector(0,0,1000)
				local trace2 = util.TraceLine(tracedata)

				if not trace2.HitPos:IsInSight() then return end

				local angle = LocalPlayer():EyeAngles()
				--local SpeedNorm = LocalPlayer():GetVelocity():GetNormal()
				--fprint(Vector(SpeedNorm.x*trace2.HitPos.x, SpeedNorm.y* trace2.HitPos.y, SpeedNorm.z* trace2.HitPos.z), trace2.HitPos, LocalPlayer():GetVelocity():GetNormal())
				LocalPlayer():SetEyeAngles((trace2.HitPos-LocalPlayer():GetShootPos()):Angle())
				--FESPAddPos(v:LocalToWorld(SpeedNorm*trace2.HitPos:Distance(tracedata.start)))
				--FESPAddPos(tracedata.start, trace2.HitPos)
				timer.Simple(0.1, function() FSpawnModel("models/props_vehicles/truck001a.mdl") end)
				DontKill = true

				hook.Add("OnEntityCreated", "Trucked", function(prop)
					if IsValid(prop) and prop:GetModel() and string.lower(prop:GetModel()) == "models/props_vehicles/truck001a.mdl" then
						LocalPlayer():SetEyeAngles(angle)
						hook.Remove("OnEntityCreated", "Trucked")
					end
				end)
			end
		end
	end
end

local function settarget(ply, cmd, args)
	Sanitize()
	if args[1] == "all" then
		FALCO_LineOnTarget = table.Copy(player.GetAll())
		return
	else
		local target = Falco_FindPlayer(args[1]) or LocalPlayer():GetEyeTrace().Entity

		table.insert(FALCO_LineOnTarget, target)
	end

	if tobool(AutoKill:GetInt()) then
		hook.Add("Think", "KillSurfer", KillSurfer)
	end
end
concommand.Add("falco_lineon", settarget)

local function RemoveTarget(ply, cmd, args)
	Sanitize()
	if args[1] and #FALCO_LineOnTarget > 1 then
		local target = Falco_FindPlayer(args[1])

		for a,b in pairs(FALCO_LineOnTarget) do
			if b == target then FALCO_LineOnTarget[a] = nil break end
		end
	else
		FALCO_LineOnTarget = {}
		hook.Remove("HUDPaint", "LineOn")
		hook.Remove("Think", "KillSurfer")
	end
end
concommand.Add("falco_lineoff", RemoveTarget)

hook.Add("PostGamemodeLoaded", "Falco_LineOnFAdmin", function()
	if not FAdmin then return end
	FAdmin.ScoreBoard.Player:AddActionButton("Falco Line", "FAdmin/icons/changeteam", Color(0, 200, 0, 255), true, function(ply, button)
		if not table.HasValue(FALCO_LineOnTarget, ply) then
			settarget(nil, nil, {ply:UserID()})
		else
			RemoveTarget(nil, nil, {ply:UserID()})
		end
	end)
end)


/*---------------------------------------------------------------------------
Lines up
---------------------------------------------------------------------------*/
local plyUpTrace = {}

/*---------------------------------------------------------------------------
getSlamPos
Parameters:
	ply: the player from whom to get the slam position

Returns:
	CanSlam: Whethere a slam position is available
	RoofPos: The location on the roof that is exactly above the player
	SlamPos: The location on the roof where the slam prop can be spawned
---------------------------------------------------------------------------*/
local function getSlamPos(ply, time)
	local myPos, hisPos = LocalPlayer():GetShootPos(), ply:GetShootPos()

	if time then
		hisPos = hisPos + ply:GetVelocity() * time
	end

	plyUpTrace.start = hisPos
	plyUpTrace.endpos = plyUpTrace.start + Vector(0,0,2048)
	plyUpTrace.filter = player.GetAll()

	local TraceLine = util.TraceLine(plyUpTrace)
	local radius = hisPos:Distance(myPos)
	local height = hisPos:Distance(TraceLine.HitPos) + hisPos.z - myPos.z -- Account for the difference in height between the two players

	-- There is no slam possibility when you're standing too close.
	if radius < height then
		return false, TraceLine.HitPos, nil -- Just return the position right above the player
	end

	local root = math.sqrt(-height*height + radius*radius)
	local slampos = (Vector(hisPos.x, hisPos.y, myPos.z) - myPos):GetNormalized() * root + myPos
	slampos.z = TraceLine.HitPos.z

	return true, TraceLine.HitPos, slampos
end


local LinesUp = CreateClientConVar("falco_linesup", 0, true, false)

local LineUpMat = Material("cable/new_cable_lit")
local slamLine = Material("cable/new_cable_lit")
local endPosMat = Material("sprites/splodesprite")
local function linesUp()
	if not tobool(LinesUp:GetInt()) then return end
	for k,v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end

		cam.Start3D(EyePos(), EyeAngles())
			local hisPos = v:GetShootPos()
			local slamExists, roofPos, slamPos = getSlamPos(v)

			-- Always draw a line up to the sky
			render.SetMaterial(LineUpMat)
			render.DrawBeam(hisPos, roofPos, 6, 10, 0.001, Color(255,255,255,255))

			-- There is no slam possibility when you're standing too close.
			if not slamExists then
				cam.End3D()
				continue
			end

			render.SetMaterial(slamLine)
			render.DrawBeam(hisPos, slamPos, 4, 10, 0.001, Color(255,255,255,255))
			render.SetMaterial(endPosMat)
			render.DrawSprite(slamPos, 16, 16, Color(255, 255, 255, 255), true)
		cam.End3D()
	end
end
hook.Add("RenderScreenspaceEffects", "LinesUP", linesUp)

local function aimAtLine(ply, bind, pressed)
	if not pressed or
	 string.sub(string.lower(bind), 1, 8) ~= "gm_spawn" or
	 not LocalPlayer():KeyDown(IN_ATTACK) or not AutoKill2:GetBool() then
	 	return
	end

 	-- get the closest slam position.\
 	local closestAngle = 0
 	local closestPly
 	local closestSlamPos = nil

 	local myPos = LocalPlayer():GetShootPos()
 	local aimVector = LocalPlayer():GetAimVector()

 	for k,v in pairs(player.GetAll()) do
 		if v == LocalPlayer() then continue end

 		local slamExists, roofPos, slamPos = getSlamPos(v, 0.4)

 		if not slamExists then continue end

 		local slamDirection = (slamPos - myPos):GetNormalized()

 		-- Get the cosine of the angle between the aim vector and the slam pos
 		-- (how closely are you looking in the direction of the slam position)
 		local cosAngle = slamDirection:Dot(aimVector)
 		if cosAngle > closestAngle then
 			closestAngle = cosAngle
 			closestPly = v
 			closestSlamPos = slamDirection
 		end
 	end

 	if closestAngle > 0.994 and closestSlamPos and closestSlamPos:IsInSight() then
 		local aimPos = closestSlamPos //+ closestPly:GetVelocity() * 0.0003
 		LocalPlayer():SetEyeAngles(aimPos:Angle())

 		-- Delay the spawning of the prop just a bit, otherwise it might spawn in the old position
 		timer.Simple(0.1, function() RunConsoleCommand("gm_spawn", string.sub(bind, 10, -1)) end)
 		return true
 	end
end
hook.Add("PlayerBindPress", "lineUpAim", aimAtLine)
