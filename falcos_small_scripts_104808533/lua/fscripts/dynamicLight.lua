local dlight
local function FDynamicLight()
	dlight = dlight or DynamicLight(LocalPlayer():UserID())
	if not dlight then return end

	dlight.Pos = LocalPlayer():GetEyeTrace().HitPos
	dlight.r = 255
	dlight.g = 255
	dlight.b = 255
	dlight.Brightness = 10
	dlight.Size = 700
	dlight.Decay = 0
	dlight.DieTime = CurTime() + 0.2
end

local togglelight = true
concommand.Add("falcop_light", function()
	togglelight = not togglelight
	LocalPlayer():EmitSound("items/flashlight1.wav",100,100)
	if togglelight then
		//Falco_ForceVar("mat_fullbright", 0)
		hook.Remove("Think", "Falco_Light")
	else
		//Falco_ForceVar("mat_fullbright", 1)
		hook.Add("Think", "Falco_Light", FDynamicLight)
	end
end)
