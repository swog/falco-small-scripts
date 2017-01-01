/*---------------------------------------------------------------------------
Script that makes you automatically pick up the props you spawn
---------------------------------------------------------------------------*/

local safeview = debug.getregistry().CUserCmd.SetViewAngles
local Toggle = CreateClientConVar("falco_autopickup", 1, true, false)
local model = ""

local ModelPositions = {}
ModelPositions["models/props_canal/canal_bars004.mdl"] = Vector(0,0,-45)
ModelPositions["models/props/de_tides/gate_large.mdl"] = Vector(0,0,-55)
ModelPositions["models/props_phx/construct/metal_wire2x2b.mdl"] = Vector(45, 0, 0)


local function EntityCreated(prop)
	if not LocalPlayer().GetActiveWeapon or FALCO_NOAUTOPICKUP or not IsValid(prop) or IsValid(LocalPlayer().isHolding) then return end
	-- When joining a server the function doesn't exist yet, starting this hook after InitPostEntity has no effect
	local weapon = LocalPlayer():GetActiveWeapon()


	if LocalPlayer():GetEyeTrace().Entity == prop then
		return
	end

	if IsValid(weapon) and weapon:GetClass() == "weapon_physgun" and LocalPlayer():KeyDown(IN_ATTACK) then
		local OldAimAngles = LocalPlayer():EyeAngles()
		local cancel = false

		hook.Add("CalcView", "PickupPropIdidntseeit", function(ply, origin, angles, fov)
			local view = {}
			view.angles = OldAimAngles
			return view
		end)

		timer.Create("AutoRemovePickup", 0.5, 1, function()
			hook.Remove("CalcView", "PickupPropIdidntseeit")
			hook.Remove("CreateMove", "PickupEnt")
		end)

		hook.Add("CreateMove", "PickupEnt", function(uc)
			OldAimAngles.p = math.Clamp(OldAimAngles.p + uc:GetMouseY() * 0.025, -89, 89)
			OldAimAngles.y = OldAimAngles.y + uc:GetMouseX() * -0.025

			if not IsValid(prop) or LocalPlayer():GetEyeTrace().Entity == prop or not LocalPlayer():KeyDown(IN_ATTACK) or cancel then
				cancel = true

				timer.Destroy("AutoRemovePickup")
				timer.Simple(0, function()
					hook.Remove("CreateMove", "PickupEnt")
					hook.Remove("CalcView", "PickupPropIdidntseeit")
				end)

				safeview(uc, OldAimAngles)
				return
			end

			-- Actual moving mouse
			local Distance = prop:GetPos():Distance(LocalPlayer():GetShootPos())

			local NearestPoint = prop:NearestPoint(LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * Distance)
			local center = prop:LocalToWorld(prop:OBBCenter())
			local MoveTowardsCenter = (NearestPoint - center):GetNormal() * 5
			NearestPoint = NearestPoint - MoveTowardsCenter
			safeview(uc, ( NearestPoint -
				LocalPlayer():GetShootPos()):Angle())
		end)

		timer.Simple(LocalPlayer():Ping()/300, function()
			if not OldAimAngles then return end
			cancel = true
		end)
	end
end

timer.Simple(0, function()
	if tobool(Toggle:GetInt()) then
		hook.Add("Falco_ActuallySpawnedProp", "PickupProp", EntityCreated)
	end
end)

if tobool(Toggle:GetInt()) then
	hook.Add("Falco_ActuallySpawnedProp", "PickupProp", EntityCreated)
end

cvars.AddChangeCallback("falco_autopickup", function(cvar, prevvalue, newvalue)
	if newvalue == "1" then
		hook.Add("Falco_ActuallySpawnedProp", "PickupProp", EntityCreated)
	else
		hook.Remove("Falco_ActuallySpawnedProp", "PickupProp", EntityCreated)
	end
end)
