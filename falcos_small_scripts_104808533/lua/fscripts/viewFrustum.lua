local drawFrustums = CreateClientConVar("falco_drawfrustums", 1, true, false)
local drawPeopleWhoSeeMe = CreateClientConVar("falco_drawPeopleWhoSeeMe", 0, true, false)
local drawCameraFrustums = CreateClientConVar("falco_drawcamerafrustums", 1, true, false)

local znear = 3
local zfar = 600

local horFOV = 53.15
local verFOV = 24.3//36

local function GetViewfrustum(pos, ang, near, far)
	local pos = pos or Vector(0, 0, 0)
	local ang = ang or Angle(0, 0, 0)

	near = near or znear
	far = far or zfar

	local topLeft = Angle(ang.p, ang.y, ang.r)
	topLeft:RotateAroundAxis(ang:Right(), verFOV)
	topLeft:RotateAroundAxis(ang:Up(), horFOV)

	local topRight = Angle(ang.p, ang.y, ang.r)
	topRight:RotateAroundAxis(ang:Right(), verFOV)
	topRight:RotateAroundAxis(ang:Up(), -horFOV)

	local bottomLeft = Angle(ang.p, ang.y, ang.r)
	bottomLeft:RotateAroundAxis(ang:Right(), -verFOV)
	bottomLeft:RotateAroundAxis(ang:Up(), horFOV)

	local bottomRight = Angle(ang.p, ang.y, ang.r)
	bottomRight:RotateAroundAxis(ang:Right(), -verFOV)
	bottomRight:RotateAroundAxis(ang:Up(), -horFOV)

	return {
		NearTopLeft = pos + topLeft:Forward() * znear,
		NearTopRight = pos + topRight:Forward() * znear,
		NearBottomLeft = pos + bottomLeft:Forward() * znear,
		NearBottomRight = pos + bottomRight:Forward() * znear,

		FarTopLeft = pos + topLeft:Forward() * far,
		FarTopRight = pos + topRight:Forward() * far,
		FarBottomLeft = pos + bottomLeft:Forward() * far,
		FarBottomRight = pos + bottomRight:Forward() * far,
	}
end

local frustum = GetViewfrustum()
local function Drawfrustum(ent, col)
	local ang = ent:EyeAngles()

	local mat = Matrix()
	mat:Translate(ent:EyePos())
	mat:Scale(Vector(1,1,1))
	mat:Rotate(ang)

	local r, g, b, a = col.r, col.g, col.b, 40
	local fr, fg, fb, fa = r, g, b, 60 -- Colours for the vertices in the far plane
	local stretch = 0.05
	cam.PushModelMatrix(mat)

		-- Near plane
		local normal = Vector(-1,0,0)
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.NearBottomRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearBottomLeft)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearTopLeft)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()

		mesh.End()

		-- near plane
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.NearTopLeft)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearTopRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearBottomRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, stretch)
			mesh.AdvanceVertex()

		mesh.End()

		-- Right face
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.NearTopRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.FarTopRight)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearBottomRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, stretch)
			mesh.AdvanceVertex()

		mesh.End()

		-- Right face
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.FarTopRight)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.FarBottomRight)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearBottomRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, stretch)
			mesh.AdvanceVertex()

		mesh.End()

		-- Top face
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.NearTopLeft)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.FarTopLeft)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearTopRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()

		mesh.End()

		-- Top face
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.FarTopLeft)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.FarTopRight)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearTopRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()

		mesh.End()

		-- Left face
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.NearBottomLeft)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.FarBottomLeft)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearTopLeft)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, 0)
			mesh.AdvanceVertex()

		mesh.End()

		-- Left face
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.FarBottomLeft)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.FarTopLeft)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearTopLeft)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, 0)
			mesh.AdvanceVertex()

		mesh.End()

		-- Bottom face
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.NearBottomLeft)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.NearBottomRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.FarBottomLeft)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, stretch)
			mesh.AdvanceVertex()

		mesh.End()

		-- Bottom face
		mesh.Begin(MATERIAL_TRIANGLES, 1)

			mesh.Position(frustum.NearBottomRight)
			mesh.Color(r, g, b, a)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()

			mesh.Position(frustum.FarBottomRight)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, 0, stretch)
			mesh.AdvanceVertex()

			mesh.Position(frustum.FarBottomLeft)
			mesh.Color(fr, fg, fb, fa)
			mesh.Normal(normal)
			mesh.TexCoord(0, stretch, stretch)
			mesh.AdvanceVertex()

		mesh.End()

	cam.PopModelMatrix()
end

local cameraColor = Color(0, 200, 255)
local material = Material("mat3")
hook.Add("PostDrawTranslucentRenderables", "DrawViewfrustum", function()
	if not tobool(drawFrustums:GetInt()) then return end
	for k,v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end

		local col = team.GetColor(v:Team())
		render.SetMaterial(material)

		Drawfrustum(v, col)
	end

	if not tobool(drawCameraFrustums:GetInt()) then return end

	local cameras = ents.FindByClass("gmod_cameraprop")
	for k,v in pairs(cameras) do
		Drawfrustum(v, cameraColor)
	end

	cameras = ents.FindByClass("gmod_rtcameraprop")
	for k,v in pairs(cameras) do
		Drawfrustum(v, cameraColor)
	end
end)

local _R = debug.getregistry()
function _R.Vector:IsInFrustum(frustum)
	-- Normal of the near plane
	local nearPlane = (frustum.NearTopRight - frustum.NearBottomRight):Cross(frustum.NearBottomLeft - frustum.NearBottomRight):GetNormalized()
	if (frustum.NearBottomRight - self):Dot(nearPlane) < 0 then
		return false
	end

	-- the normal of the right plane of the frustum
	local rightPlane = (frustum.NearBottomRight - frustum.NearTopRight):Cross(frustum.FarBottomRight - frustum.NearTopRight):GetNormalized()
	if (frustum.NearBottomRight - self):Dot(rightPlane) < 0 then
		return false
	end

	-- check against left plane
	local leftPlane = (frustum.NearBottomLeft - frustum.NearTopLeft):Cross(frustum.NearTopLeft - frustum.FarBottomLeft):GetNormalized()
	if (frustum.NearBottomRight - self):Dot(leftPlane) < 0 then
		return false
	end

	local topPlane = (frustum.NearTopRight - frustum.NearTopLeft):Cross(frustum.FarTopLeft - frustum.NearTopLeft):GetNormalized()
	if (frustum.NearBottomRight - self):Dot(topPlane) < 0 then
		return false
	end

	local bottomPlane = (frustum.NearBottomLeft - frustum.NearBottomRight):Cross(frustum.FarBottomRight - frustum.NearBottomRight):GetNormalized()
	if (frustum.NearBottomRight - self):Dot(bottomPlane) < 0 then
		return false
	end

	local farPlane = (frustum.FarTopLeft - frustum.FarBottomLeft):Cross(frustum.FarBottomRight - frustum.FarBottomLeft):GetNormalized()
	if (frustum.FarBottomLeft - self):Dot(farPlane) < 0 then
		return false
	end

	return true
end

function _R.Entity:SeesPosition(position)
	local pos, ang
	local position = position or LocalPlayer():GetShootPos()

	if self:IsPlayer() then
		pos, ang = self:EyePos(), self:EyeAngles()
	else
		pos, ang = self:GetPos(), self:GetAngles()
	end

	local frustum = GetViewfrustum(pos, ang, 3, 6000)

	if not position:IsInFrustum(frustum) then
		return false
	end


	-- Run a trace to see if the players have the LocalPlayer in their line of sight
	local data = {}
	data.start = pos
	data.endpos = position
	data.filter = {self, LocalPlayer()}
	data.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_MONSTER
	local trace = util.TraceLine(data)
	return not trace.Hit
end

function _R.Entity:SeesMe()
	return self:SeesPosition(LocalPlayer():GetPos() + Vector(0, 0, 32))
end

local seenBy = {}
local function getSeenBy()
	local seesMeCount = 1

	for k,v in pairs(player.GetAll()) do
		if (not v:SeesMe() and v:GetObserverTarget() ~= LocalPlayer()) or v == LocalPlayer() then continue end

		seenBy[seesMeCount] = v
		seesMeCount = seesMeCount + 1
	end

	local cameras = ents.FindByClass("gmod_cameraprop")
	for k,v in pairs(cameras) do
		if not v:SeesMe() then continue end

		seenBy[seesMeCount] = v
		seesMeCount = seesMeCount + 1
	end

	for i = #seenBy, seesMeCount, -1 do
		table.remove(seenBy, i)
	end
end
getSeenBy = FrameCached(getSeenBy)

local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)
local font = "FALCO_FONT"
local function ShowPeopleWhoSeeMe()
	if not tobool(drawPeopleWhoSeeMe:GetInt()) then return end
	getSeenBy()
	local ScrWidth, ScrHeight = ScrW(), ScrH()
	local txtHeight = ScrWidth > 2000 and 25 or 13
	local name, txtColor, txtWidth

	for i, ent in pairs(seenBy) do
		if not IsValid(ent) then continue end
		name = ent:IsPlayer() and ent:Nick() or "Camera prop #" .. ent:EntIndex()
		txtColor = ent:IsPlayer() and ent:IsAdmin() and red or white
		surface.SetFont(font)
		txtWidth = surface.GetTextSize(name)

		draw.WordBox(2, ScrWidth / 2 - txtWidth / 2, ScrHeight - txtHeight * i, name,  font, ent:IsPlayer() and team.GetColor(ent:Team()) or cameraColor, txtColor)
	end
end
hook.Add("HUDPaint", "FrustumInfo", ShowPeopleWhoSeeMe)
