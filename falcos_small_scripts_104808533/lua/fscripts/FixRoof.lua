/*---------------------------------------------------------------------------
Draws tiles on the roof
---------------------------------------------------------------------------*/

local enableRoofTiles = CreateClientConVar("falco_rooftiles", 0, true, false)

local DrawPos
local params = {
	["$basetexture"] = "phoenix_storms/pack2/train_floor",
	["$nodecal"] = 1,
	["$model"] = 1,
	["$additive"] = 0,
	["$nocull"] = 1,
	["$alpha"] = 0.95
}
local RoofMaterial = CreateMaterial("RoofMaterialTest8", "UnlitGeneric", params)

hook.Add("PostDrawOpaqueRenderables", "ReplaceSkyBox", function()
	if not DrawPos or not tobool(enableRoofTiles:GetInt()) then return end;
	local pos1 = DrawPos + Vector( 5000,  5000, 0)
	local pos2 = DrawPos + Vector(-5000,  5000, 0)
	local pos3 = DrawPos + Vector(-5000, -5000, 0)
	local pos4 = DrawPos + Vector( 5000, -5000, 0)
	cam.Start3D(EyePos(), EyeAngles())
		render.SuppressEngineLighting(true)
		render.SetBlend(0.4)
		render.SetMaterial(RoofMaterial)

		render.DrawQuad(pos1, pos2, pos3, pos4)
		render.DrawQuad(pos1 + Vector(5000), pos2 + Vector(5000), pos3 + Vector(5000), pos4 + Vector(5000))
		render.DrawQuad(pos1 - Vector(5000), pos2 - Vector(5000), pos3 - Vector(5000), pos4 - Vector(5000))
		render.DrawQuad(pos1 - Vector(5000, 5000), pos2 - Vector(5000, 5000), pos3 - Vector(5000, 5000), pos4 - Vector(5000, 5000))
		render.DrawQuad(pos1 - Vector(5000, -5000), pos2 - Vector(5000, -5000), pos3 - Vector(5000, -5000), pos4 - Vector(5000, -5000))
		render.DrawQuad(pos1 - Vector(0, -5000), pos2 - Vector(0, -5000), pos3 - Vector(0, -5000), pos4 - Vector(0, -5000))
		render.DrawQuad(pos1 + Vector(0, -5000), pos2 + Vector(0, -5000), pos3 + Vector(0, -5000), pos4 + Vector(0, -5000))

		render.DrawQuad(pos1 - Vector(-5000, -5000), pos2 - Vector(-5000, -5000), pos3 - Vector(-5000, -5000), pos4 - Vector(-5000, -5000))
		render.DrawQuad(pos1 - Vector(-5000, 5000), pos2 - Vector(-5000, 5000), pos3 - Vector(-5000, 5000), pos4 - Vector(-5000, 5000))


		render.SuppressEngineLighting(false)
		render.SetBlend(1)
	cam.End3D()
end)

timer.Create("ReplaceSkyBox", 0.1, 0, function()
	if not IsValid(LocalPlayer()) then return end
	local tracedata = {}
	tracedata.start = LocalPlayer():GetShootPos()
	tracedata.endpos = tracedata.start + Vector(0,0,9999999)
	tracedata.filter = LocalPlayer()
	tracedata.mask = MASK_NPCWORLDSTATIC
	local trace = util.TraceLine(tracedata)

	if trace.HitWorld and trace.HitTexture == "TOOLS/TOOLSSKYBOX" then
		DrawPos = DrawPos or trace.HitPos
		DrawPos.z = trace.HitPos.z
	end
end)