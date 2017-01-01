local showLandPos = CreateClientConVar("falco_showLandingPos", 1, true, false)
local col = Color(0, 255, 255, 255)
local colBad = Color(255, 128, 0, 255)

local function drawLandingPos()
	local landPos, tr, parabolaTop = GetLandingPos()
	if not landPos then return end

	endSpeed = parabolaTop.z - tr.HitPos.z

	cam.Start3D2D(landPos, tr.HitNormal:Angle():Up():Angle(), 1)
		draw.RoundedBox(8, -32, -32, 64, 64, endSpeed >= 240 and colBad or col)
	cam.End3D2D()
end

if showLandPos:GetBool() then
	hook.Add("PostDrawOpaqueRenderables", "drawLandingPos", drawLandingPos)
end
cvars.AddChangeCallback("falco_showLandingPos", function(var, prev, new)
	if tobool(new) then
		hook.Add("PostDrawOpaqueRenderables", "drawLandingPos", drawLandingPos)
	else
		hook.Remove("PostDrawOpaqueRenderables", "drawLandingPos")
	end
end)
