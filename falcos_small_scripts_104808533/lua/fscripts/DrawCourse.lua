/*---------------------------------------------------------------------------
Testing script
---------------------------------------------------------------------------*/

--[[
local LocalPlayer = LocalPlayer
local LineMat = Material("sprites/lookingat")
hook.Add("RenderScreenspaceEffects", "DrawCourse", function()
	if not LocalPlayer().isHolding or not IsValid(LocalPlayer().isHolding) or not LocalPlayer():KeyDown(IN_ATTACK) then return end
	local HoldingENT = LocalPlayer().isHolding

	--local Min, Max = HoldingENT:WorldSpaceAABB()
	local LMin, LMax = HoldingENT:OBBMins(), HoldingENT:OBBMaxs()
	local Min, Max = HoldingENT:LocalToWorld(LMin), HoldingENT:LocalToWorld(LMax)
	local center = HoldingENT:LocalToWorld(HoldingENT:OBBCenter())

	local EndDirection = LocalPlayer():GetAimVector() * 2048
	local traceMinData = {}
	traceMinData.start = Min
	traceMinData.endpos = traceMinData.start + EndDirection
	traceMinData.filter = {HoldingENT, LocalPlayer()}
	traceMinData.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER

	local traceMaxData = {}
	traceMaxData.start = Max
	traceMaxData.endpos = traceMaxData.start + EndDirection
	traceMaxData.filter = {HoldingENT, LocalPlayer()}
	traceMaxData.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER

	local traceMin = util.TraceLine(traceMinData)
	local traceMax = util.TraceLine(traceMaxData)

	local distance = traceMin.HitPos:Distance(Min)
	local MinMaxDistance = (Max - Min).z

	cam.Start3D(EyePos(), EyeAngles())
		render.SetMaterial(LineMat)
		render.DrawBeam(Min, traceMin.HitPos, 3, distance/30, 0, Color(255, 0, 0, 255))
		render.DrawBeam(Max, traceMax.HitPos, 3, distance/30, 0, Color(255, 0, 0, 255))

		render.DrawBeam(traceMin.HitPos, traceMin.HitPos + Vector(0,0,MinMaxDistance), 5, MinMaxDistance/20, 0, Color(255, 0, 0, 255))
		render.DrawBeam(traceMax.HitPos, traceMax.HitPos - Vector(0,0,MinMaxDistance), 5, MinMaxDistance/20, 0, Color(255, 0, 0, 255))

		--render.DrawBeam(traceMin.HitPos + Vector(0,0,MinMaxDistance), traceMax.HitPos - Vector(0,0,MinMaxDistance), 5, MinMaxDistance/20, 0, Color(255, 0, 0, 255))
	cam.End3D()
end)
]]
local DoFollowProp = CreateClientConVar("Falco_FollowProp", 1, true, false)
--[[local CamData = {}
hook.Add("HUDPaint", "DrawPropCourse", function()
	if not LocalPlayer().isHolding or not IsValid(LocalPlayer().isHolding) or not LocalPlayer():KeyDown(IN_ATTACK) or not tobool(DoFollowProp:GetInt()) then return end
		local HoldingEnt = LocalPlayer().isHolding
		local PropPos = HoldingEnt:LocalToWorld(HoldingEnt:OBBCenter())
		local SelfPos = LocalPlayer():GetShootPos()

		local LookAt = SelfPos + LocalPlayer():GetAimVector() * 2 * PropPos:Distance(SelfPos)

		CamData.angles = (LookAt - PropPos):Angle()
		CamData.origin = PropPos
		CamData.x, CamData.y, CamData.w, CamData.h = ScrW()/2-150, ScrH()-280, 300, 280
		HoldingEnt:SetNoDraw(true)
		render.RenderView(CamData)
		HoldingEnt:SetNoDraw(false)
end)]]
local SpherePlayer = CreateClientConVar("Falco_SpherePlayer", 0, true, false)
local PosLA = CreateClientConVar("Falco_PositionLookingAt", 0, true, false)
hook.Add("PhysgunPickup", "MakeClientsideModel", function(ply, ent)
	if not tobool(SpherePlayer:GetInt()) then return end
	if ent:GetClass() ~= "prop_physics" then return end
	for _, target in pairs(FALCO_LineOnTarget) do
		target.CourseSphere = target.CourseSphere or ClientsideModel("models/Combine_Helicopter/helicopter_bomb01.mdl", RENDER_GROUP_OPAQUE_ENTITY)
		target.CourseSphere:SetColor(0,255,0,70)
		target.CourseSphere:SetNoDraw(false)
		target.CourseSphere.NoXRay = true

		target.CourseSphere2 = target.CourseSphere2 or ClientsideModel("models/Combine_Helicopter/helicopter_bomb01.mdl", RENDER_GROUP_OPAQUE_ENTITY)
		target.CourseSphere2:SetColor(0,0,255,70)
		target.CourseSphere2:SetNoDraw(false)
		target.CourseSphere2.NoXRay = true
	end
end)

local function RemoveSphere(ent)
	if ent and not ent:IsPlayer() and LocalPlayer().isHolding ~= ent then return end
	for _, target in pairs(FALCO_LineOnTarget or {}) do
		if target.CourseSphere and target.CourseSphere:IsValid() then target.CourseSphere:SetNoDraw(true) end
		if target.CourseSphere2 and target.CourseSphere2:IsValid() then target.CourseSphere2:SetNoDraw(true) end
	end
end

hook.Add("PhysgunDrop", "RemoveClientsideModel", RemoveSphere)
hook.Add("EntityRemoved", "RemoveClientsideModel", RemoveSphere)


hook.Add("RenderScene", "DoHitCourse", function()
	if not tobool(SpherePlayer:GetInt()) or not IsValid(LocalPlayer().isHolding) then return end

	local ent = LocalPlayer().isHolding


	for _, target in pairs(FALCO_LineOnTarget) do
		if  target.CourseSphere and target.CourseSphere:IsValid() then
			local plyDistance = target:GetShootPos():Distance(LocalPlayer():GetShootPos())
			local propDistance = ent:GetPos():Distance(LocalPlayer():GetShootPos())
			local Threshold = ent:OBBMins():Distance(ent:OBBMaxs())

			target.CourseSphere:SetMaterial("mat5")
			target.CourseSphere2:SetMaterial("mat4")

			target.CourseSphere:SetPos(LocalPlayer():GetShootPos())
			target.CourseSphere2:SetPos(LocalPlayer():GetShootPos())
			local scale = plyDistance / 15 -- 200 = size of ball
			target.CourseSphere:SetModelScale(Vector(scale,scale,scale))
			target.CourseSphere2:SetModelScale(Vector(scale,scale,scale))

			if math.abs(plyDistance - propDistance) < Threshold then
				target.CourseSphere:SetColor(255,0,0,70)
				target.CourseSphere2:SetColor(255,255,255,30)
			else
				target.CourseSphere:SetColor(0,255,0,70)
				target.CourseSphere2:SetColor(0,0,255,70)
			end
		end
	end
end)

hook.Add("HUDPaint", "DrawDistance", function()
	if (not tobool(SpherePlayer:GetInt()) or not IsValid(LocalPlayer().isHolding)) and not tobool(PosLA:GetInt()) then return end

	local ent = (IsValid(LocalPlayer().isHolding) and LocalPlayer().isHolding:GetPos()) or LocalPlayer():GetEyeTrace().HitPos
	local ScaleX, ScaleY = 50, 400
	local DrawX, DrawY = ScrW()*0.5 - ScaleX/2,ScrH() - ScaleY


	local QuadTable = {}

 	QuadTable.texture = "icon16/user.png"
 	QuadTable.color	= Color(255,255,255,255)

 	QuadTable.x = DrawX + ScaleX/2 - 16
 	QuadTable.y = DrawY + ScaleY - 32
 	QuadTable.w = 32
 	QuadTable.h = 32


	for _, target in pairs(FALCO_LineOnTarget) do
		if tobool(PosLA:GetInt()) and  target.CourseSphere and target.CourseSphere:IsValid() and IsValid(target) then
			local plyDistance = target:GetShootPos():Distance(LocalPlayer():GetShootPos())
			local propDistance = ent:Distance(LocalPlayer():GetShootPos())
			local Total = math.Round(plyDistance - propDistance)

			--draw.DrawText(Total, "HUDNumber5", ScrW()*0.6+1,ScrH()*0.7+1,Color(0,0,0,255), TEXT_ALIGN_CENTER)
			--draw.DrawText(Total, "HUDNumber5", ScrW()*0.6,ScrH()*0.7,Color(255,255,255,255), TEXT_ALIGN_CENTER)
			--Drawing self
			draw.RoundedBox(8, DrawX, DrawY, ScaleX, ScaleY, Color(0,0,0,170))
			draw.TexturedQuad(QuadTable)

			--if Total >= 0 then
			--Drawing other player
			QuadTable.y = DrawY + 64
			draw.TexturedQuad(QuadTable)

			--Drawing prop
			QuadTable.texture = surface.GetTextureID((IsValid(LocalPlayer().isHolding) and "gui/silkicons/car") or "gui/silkicons/add")
			QuadTable.y = math.Max(DrawY + 64 + (Total/plyDistance)*ScaleY, DrawY)
			draw.TexturedQuad(QuadTable)
		end
		--[[else
			--Drawing prop
			QuadTable.y = DrawY
			QuadTable.texture = surface.GetTextureID("gui/silkicons/car")
			draw.TexturedQuad(QuadTable)

			--Drawing prop
			QuadTable.texture = surface.GetTextureID("gui/silkicons/user")
			QuadTable.y = DrawY + (math.abs(Total)/plyDistance)*ScaleY
			--fprint((math.abs(Total)/plyDistance)*ScaleY)
			draw.TexturedQuad(QuadTable)
		end]]

		break
	end
end)