/*---------------------------------------------------------------------------
Shows you when the prop you're holding is close to another player
---------------------------------------------------------------------------*/

local HitMarker = CreateClientConVar("falco_hitmarker", 1, true, false)

local Size = 25
local Alpha = 0
hook.Add("HUDPaint", "HitMarker", function()
	if not tobool(HitMarker:GetInt()) then return end
	if not IsValid(LocalPlayer().isHolding) or LocalPlayer().isHolding:GetClass() ~= "prop_physics" or not LocalPlayer().isHolding.IsMine or not input.IsMouseDown(MOUSE_FIRST) then return end

	Alpha = (Alpha + 4) % 255

	local ScrHeight, ScrWidth = ScrH(), ScrW()
	for k,v in pairs(player.GetAll()) do
		if LocalPlayer().isHolding:GetPos():Distance(v:GetShootPos()) <= 220 and v ~= LocalPlayer() and v:Alive() then
			surface.SetDrawColor(255,255,255, Alpha)
			surface.DrawLine(ScrWidth/2 - Size, ScrHeight/2 - Size, ScrWidth/2 - Size * 2, ScrHeight/2 - Size * 2)
			surface.DrawLine(ScrWidth/2 - Size, ScrHeight/2 + Size, ScrWidth/2 - Size * 2, ScrHeight/2 + Size * 2)
			surface.DrawLine(ScrWidth/2 + Size, ScrHeight/2 - Size, ScrWidth/2 + Size * 2, ScrHeight/2 - Size * 2)
			surface.DrawLine(ScrWidth/2 + Size, ScrHeight/2 + Size, ScrWidth/2 + Size * 2, ScrHeight/2 + Size * 2)
		end
	end
end)