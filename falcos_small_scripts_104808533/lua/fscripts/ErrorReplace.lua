local errorEnts = {}
local entMeta = FindMetaTable("Entity")
CreateClientConVar("falco_replaceErrors", 0, true, false)
include("fn.lua")

local disallow = {
	["trace1"] = true,
	["ent_checkpoint"] = true,
	["ent_start"] = true,
	["ent_finish"] = true,
	["class CLuaEffect"] = true
}

-- An entity is not an error ent if this condition is not met
local entCondition = fn.FAnd{
	IsValid, -- ent is valid
	fc{fp{fn.Eq, "models/error.mdl"}, string.lower, fn.FOr{entMeta.GetModel, fp{fn.Id, ""}}}, -- model is error.mdl
	fc{fn.Not, fp{fn.Flip(fn.GetValue), disallow}, entMeta.GetClass}, -- class is not in the blacklist
	fc{fn.Not, entMeta.IsWeapon} -- ent is not a weapon
}

local function addErrorEnt(ent)
	if not entCondition(ent) then return end
	table.insert(errorEnts, ent)
end

local function removeErrorEnt(i)
	errorEnts[i] = errorEnts[#errorEnts]
	errorEnts[#errorEnts] = nil
end

local function drawError(i, ent)
	if not IsValid(ent) then return removeErrorEnt(i) end
	ent:SetNoDraw(true)

	local mins, maxs, center = ent:OBBMins(), ent:OBBMaxs(), ent:OBBCenter()
	local width, height, length = maxs.x - mins.x, maxs.z - mins.z, maxs.y - mins.y
	local rwidth, rheight, rlength = width / 2, height / 2, length / 2 -- Divide by two because we work from the center
	local ang = ent:GetAngles()

	local mat = Matrix()
	mat:Translate(ent:LocalToWorld(ent:OBBCenter()))
	mat:Scale(Vector(1,1,1))
	mat:Rotate(ang)

	local v = Vector(0, 0, rheight)
	local norm = Vector(0, 0, 1)
	cam.PushModelMatrix(mat)
		-- TOP
		mesh.Begin(MATERIAL_QUADS, 6)
		mesh.Color(50, 50, 50, 50)
		mesh.QuadEasy(v, norm, length, width)
		norm.z = -1
		v.z = -rheight

		-- BOTTOM
		mesh.QuadEasy(v, norm, length, width)
		norm.x, norm.z = 1, 0
		v.x, v.z = rwidth, 0

		-- RIGHT
		mesh.QuadEasy(v, norm, length, height)
		norm.x = -1
		v.x = -rwidth

		-- LEFT
		mesh.QuadEasy(v, norm, length, height)
		norm.y, norm.x = 1, 0
		v.y, v.x = rlength, 0

		-- TOP
		mesh.QuadEasy(v, norm, width, height)
		norm.y = -1
		v.y = -rlength
		-- BOTTOM
		mesh.QuadEasy(v, norm, width, height)
		mesh.End()

	cam.PopModelMatrix()
end

local drawMaterial = Material("models/debug/debugwhite")
local function drawErrorReplacements()
	if not tobool(GetConVarNumber("falco_replaceErrors")) then return end

	render.SetMaterial(drawMaterial)
	for i, ent in ipairs(errorEnts) do
		drawError(i, ent)
	end
end
hook.Add("PostDrawTranslucentRenderables", "drawErrorReplacements", drawErrorReplacements)

-- Check current entities to see if they are errors
timer.Simple(1, function()
	if not tobool(GetConVarNumber("falco_replaceErrors")) then return end
	for i, ent in pairs(ents.GetAll()) do
		addErrorEnt(ent)
	end
end)

-- Check newly created entities for error models
hook.Add("OnEntityCreated", "replace errors", addErrorEnt)
