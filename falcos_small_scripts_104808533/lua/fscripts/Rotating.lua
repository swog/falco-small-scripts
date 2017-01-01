/*---------------------------------------------------------------------------
Rotating for prop boosting
---------------------------------------------------------------------------*/

local function Rotate180()
	FALCO_NOAUTOPICKUP = true
	timer.Simple(0.5, function() FALCO_NOAUTOPICKUP = false end)

	if hook.GetTable().CreateMove and hook.GetTable().CreateMove.PickupEnt then
		hook.Remove("CreateMove", "PickupEnt")
		hook.Remove("CalcView", "Ididntseeit")
		timer.Simple(0.05, function()
			local a = LocalPlayer():EyeAngles() LocalPlayer():SetEyeAngles(Angle(a.p, a.y-180, a.r))
		end)
		return
	end
	local a = LocalPlayer():EyeAngles() LocalPlayer():SetEyeAngles(Angle(a.p, a.y-180, a.r))
end
concommand.Add("falco_180", Rotate180)

local function Rotate180Up()
	FALCO_NOAUTOPICKUP = true
	timer.Simple(0.5, function() FALCO_NOAUTOPICKUP = false end)

	if hook.GetTable().CreateMove and hook.GetTable().CreateMove.PickupEnt then
		hook.Remove("CreateMove", "PickupEnt")
		hook.Remove("CalcView", "Ididntseeit")
		timer.Simple(0.05, function()
			local a = LocalPlayer():EyeAngles() LocalPlayer():SetEyeAngles(Angle(a.p-a.p-a.p, a.y-180, a.r))
			RunConsoleCommand("+jump")
			timer.Simple(0.2, function() RunConsoleCommand("-jump") end)
		end)
		return
	end
	local a = LocalPlayer():EyeAngles() LocalPlayer():SetEyeAngles(Angle(a.p-a.p-a.p, a.y-180, a.r))
	RunConsoleCommand("+jump")
	timer.Simple(0.2, function() RunConsoleCommand("-jump") end)
end
concommand.Add("falco_180up", Rotate180Up)

concommand.Add("falco_180shot", function()
	local IsHook = hook.GetTable().CalcView and hook.GetTable().CalcView["180shot"]
	if IsHook then
		Rotate180()
		hook.Remove("CalcView", "180shot")
		timer.Destroy("180shot")
		return
	end

	hook.Add("CalcView", "180shot", function(ply, origin, angle, fov)
		local view = {}
		view.origin = origin
		view.angles = angle - Angle(0,180,0)
		view.fov = fov

		if not LocalPlayer():KeyDown(IN_ATTACK) then
			hook.Remove("CalcView", "180shot")
			Rotate180()
			timer.Destroy("180shot")
		end

		return view
	end)
	Rotate180()
	timer.Create("180shot", 5, 1, function()
		hook.Remove("CalcView", "180shot")
		Rotate180()
	end)
end)

local AntiFallProp = "models/props/cs_office/table_meeting.mdl"
local function BreakFallMidAir()
	FALCO_NOAUTOPICKUP = true
	timer.Simple(0.5, function() FALCO_NOAUTOPICKUP = false end)

	FSpawnModel(AntiFallProp)
	RunConsoleCommand("+attack")
	hook.Add("OnEntityCreated", "SpawnAntiDrop", function(ent)
		if not IsValid(ent) or string.lower(ent:GetModel() or "") ~= AntiFallProp then return end
		hook.Remove("OnEntityCreated", "SpawnAntiDrop")

		local a = LocalPlayer():EyeAngles()
		LocalPlayer():SetEyeAngles(Angle(-90, a.y-180, a.r))
		if IsValid(ent) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" and LocalPlayer():KeyDown(IN_ATTACK) then
			hook.Add("Think", "BreakFallInMidAir", function()
				if not IsValid(ent) or not LocalPlayer():KeyDown(IN_ATTACK) then hook.Remove("Think", "BreakFallInMidAir") return end
				if ent:GetPos():Distance(LocalPlayer():GetPos()) < 650 then
					RunConsoleCommand("+attack2")

					timer.Simple(0.1, function() RunConsoleCommand("-attack2") end)
					timer.Simple(0.15, function() RunConsoleCommand("-attack") end)
					hook.Remove("Think", "BreakFallInMidAir")
				end
			end)
		end
	end)
	timer.Simple(1, function() hook.Remove("OnEntityCreated", "SpawnAntiDrop") end)
end
concommand.Add("falco_180BreakFall", BreakFallMidAir)


/*---------------------------------------------------------------------------
Backwards
You'll be looking behind your back. literally.
---------------------------------------------------------------------------*/

local backwards = CreateClientConVar("falco_backwards", 0, false, false) -- We don't want it to save
local sensitivity
local FSetEyeAngles = debug.getregistry().Player.SetEyeAngles
local FGetEyeAngles = debug.getregistry().Player.EyeAngles
local eyeAng

local function overrideSetEyeAngle(ply, angle, ...)
	if (angle.p % 360) > 270 or (angle.p % 360) < 90 then
		angle.p = 180 - angle.p
		angle.y = 180 + angle.y
	end
	eyeAng = angle

	return FSetEyeAngles(ply, angle, ...)
end

local function overrideGetEyeAngles(ply, ...)
	if ply == LocalPlayer() then
		return Angle(180 - eyeAng.p, 180 + eyeAng.y, eyeAng.r)
	end

	return FGetEyeAngles(ply, ...)
end

local function mouseMovement(umc)
	local ang = Angle((eyeAng.p - umc:GetMouseY() / sensitivity) % 360, (eyeAng.y - umc:GetMouseX() / sensitivity) % 360, eyeAng.r)

	if ang.p > 270 or ang.p < 90 then
		--eyeAng.p = 180 - ang.p
		umc:SetViewAngles(eyeAng)
		return
	end

	local weapon = LocalPlayer():GetActiveWeapon()

	-- Account for holding props with the physgun
	if not IsValid(weapon) or weapon:GetClass() ~= "weapon_physgun" or not LocalPlayer():KeyDown(IN_USE) then
		eyeAng = ang
	end

	umc:SetViewAngles(eyeAng)
end

local function TurnVision(ply, origin, angles, fov)
	local view = {}

	view.origin = origin
	view.angles = angles

	if eyeAng.p < 270 or ang.p > 90 then
		view.angles.r = 180
	end

	return view
end

local function fixMovementKeys(ply, bind, pressed)
	if bind == "+moveright" and pressed then
		RunConsoleCommand("+moveleft")
		return true
	elseif bind == "+moveright" and not pressed then
		RunConsoleCommand("-moveleft")
		return true
	elseif bind == "+moveleft" and pressed then
		RunConsoleCommand("+moveright")
		return true
	elseif bind == "+moveleft" and not pressed then
		RunConsoleCommand("-moveright")
		return true
	end
end

local function doBackwards()
	eyeAng = LocalPlayer():EyeAngles()

	debug.getregistry().Player.SetEyeAngles = overrideSetEyeAngle
	debug.getregistry().Player.EyeAngles = overrideGetEyeAngles

	-- makes you look in the same direction, but upside down
	eyeAng.p = 180 - eyeAng.p
	eyeAng.y = 180 + eyeAng.y

	hook.Add("CreateMove", "falco_backwards", mouseMovement)
	hook.Add("CalcView", "falco_backwards", TurnVision)
	hook.Add("PlayerBindPress", "falco_backwards", fixMovementKeys)
end

if tobool(backwards:GetInt()) then
	doBackwards()
end

cvars.AddChangeCallback("falco_backwards", function(cvar, prevvalue, newvalue)
	sensitivity = GetConVarNumber("sensitivity") * 10

	if tobool(newvalue) then
		doBackwards()
	else
		hook.Remove("CreateMove", "falco_backwards")
		hook.Remove("CalcView", "falco_backwards")
		hook.Remove("PlayerBindPress", "falco_backwards")

		debug.getregistry().Player.SetEyeAngles = FSetEyeAngles
		debug.getregistry().Player.EyeAngles = FGetEyeAngles

		local ang = eyeAng
		ang.p = 180 - ang.p
		ang.y = 180 + ang.y
		LocalPlayer():SetEyeAngles(ang)
	end
end)

/*---------------------------------------------------------------------------
View without limits
---------------------------------------------------------------------------*/
local noLimit = CreateClientConVar("falco_noLimitView", 0, false, false)

cvars.AddChangeCallback("falco_noLimitView", function(cvar, prevvalue, newvalue)
	sensitivity = GetConVarNumber("sensitivity") * 10

	if tobool(newvalue) then
		eyeAng = LocalPlayer():EyeAngles()

		hook.Add("CreateMove", "falco_nolimit", function(umc)
			eyeAng = Angle((eyeAng.p + umc:GetMouseY() / sensitivity) % 360, (eyeAng.y - umc:GetMouseX() / sensitivity) % 360, 0)
			umc:SetViewAngles(eyeAng)
		end)
	else
		hook.Remove("CreateMove", "falco_nolimit")
	end
end)