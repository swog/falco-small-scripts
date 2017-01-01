-- The sound used to indicate prop speed
util.PrecacheSound("Canals.d1_canals_01_combine_shield_touch_loop1")

-- Speed up the vars!
local ents = ents
local GetConVarNumber = GetConVarNumber
local GetGlobalInt = GetGlobalInt
local hook = hook
local LocalPlayer = LocalPlayer
local math = math
local pairs = pairs
local player = player
local render = render
local RunConsoleCommand = RunConsoleCommand
local string = string
local surface = surface
local table = table
local timer = timer
local type = type
local util = util
local IsValid = IsValid

local _R = debug.getregistry()
local SetColor = _R.Entity.SetColor
local GetColor = _R.Entity.GetColor
local SetMat = _R.Entity.SetMaterial
local GetMat = _R.Entity.GetMaterial
local GetClass = _R.Entity.GetClass
local GetRagdollEntity = _R.Player.GetRagdollEntity
local SetNoDraw = _R.Entity.SetNoDraw
local GetVelocity = _R.Entity.GetVelocity
local VelLength = _R.Vector.Length


-- XRay variables!
local RayOn = false -- Xray toggle variable
local entityMaterials = {}
local entityColors = {}
local AllHooks = {}
local VIEWMODEL = NULL
local NoDraws = {
	["cluaeffect"] = true,
	["fog"] = true,
	["waterlodcontrol"] = true,
	["clientragdoll"] = true,
	["envtonemapcontroller"] = true,
	["entityflame"] = true,
	["func_tracktrain"] = true,
	["env_sprite"] = true,
	["env_spritetrail"] = true,
	["prop_effect"] = true,
	["class c_sun"] = true,
	["class C_ClientRagdoll"] = true,
	["class C_BaseAnimating"] = true,
	["clientside"] = true,
	["illusionary"] = true,
	["shadowcontrol"] = true,
	["keyframe"] = true,
	["wind"] = true,
	["gmod_wire_hologram"] = true,
	["effect"] = true,
	["stasisshield"] = true,
	["shadertest"] = true,
	["portalball"] = true,
	["portalskydome"] = true,
	["cattails"] = true
}

-- cvars
local repmat = CreateClientConVar("falco_xraymaterial", "mat1", true, false)
local FRaySoundMode = CreateClientConVar("falco_xraySoundMode", 1, true, false)
local PROPColor = CreateClientConVar("falco_xrayPROPColor", "255,200,0,60", true, false)
local PROPBGColor = CreateClientConVar("falco_xrayPROPBGColor", "0,204,0,39", true, false)
local MINEColor = CreateClientConVar("falco_xrayMINEColor", "255,204,255,60", true, false)
local HOLDINGColor = CreateClientConVar("falco_xrayHOLDINGColor", "0,0,0,40", true, false)
local MINEBGColor = CreateClientConVar("falco_xrayPROPMINEBGColor", "255,0,0,39", true, false)
local PLYColor = CreateClientConVar("falco_xrayPLAYERcolor", "255,255,0,100", true, false)

local cPROPColor = Color(unpack(string.Explode(",", PROPColor:GetString())))
local cPROPBGColor = Color(unpack(string.Explode(",", PROPBGColor:GetString())))
local cPROPMINEBGColor = Color(unpack(string.Explode(",", MINEBGColor:GetString())))
local cPROPHOLDINGColor = Color(unpack(string.Explode(",", HOLDINGColor:GetString())))
local cMINEColor = Color(unpack(string.Explode(",", MINEColor:GetString())))
local cPLYColor = Color(unpack(string.Explode(",", PLYColor:GetString())))
local FRayMat = repmat:GetString()


local ExecuteFray

-- Overriding effects!
local OldEffectFunctions = {}
OldEffectFunctions.render_AddBeam = render.AddBeam
OldEffectFunctions.render_DrawSprite = render.DrawSprite
local OLDUtilEffect = util.Effect

local EMITTER = FindMetaTable("CLuaEmitter")
EMITTER.OldAdd = EMITTER.OldAdd or EMITTER.Add
function EMITTER:Add(...)
	if RayOn then
		local returnal = table.Copy(FindMetaTable("CLuaParticle"))
		for k,v in pairs(returnal or {}) do
			if type(v) == "function" then
				returnal[k] = function() end
			end
		end
		return returnal--override all the functions of this FAKE particle to do nothing
	end
	return self:OldAdd(...)
end

function render.AddBeam(...)
	if not RayOn then
		return OldEffectFunctions.render_AddBeam(...)
	end
end

function render.DrawSprite(a,b,c,d,e, ...)
	if not RayOn or e then
		OldEffectFunctions.render_DrawSprite(a,b,c,d, ...)
	end
end

-- Register babygodded players
local babygod, bgodtime
local function RegisterSpawn()
	local Pls = player.GetAll()
	for ply=1, #Pls do
		Health = Pls[ply]:Health()
		if Health < 1 and Pls[ply].Spawned then
			Pls[ply].Spawned = false
			Pls[ply].BabyGod = false
		elseif Health > 0 and not Pls[ply].Spawned then
			Pls[ply].Spawned = true
			Pls[ply].BabyGod = true
			timer.Simple(bgodtime, function()
				if not IsValid(Pls[ply]) then return end
				Pls[ply].BabyGod = false
				if entityColors[Pls[ply]] then entityColors[Pls[ply]] = Color(255,255,255,255) end
			end)
		end
	end
end
timer.Simple(0, function()
	babygod = GAMEMODE and GAMEMODE.Config and GAMEMODE.Config.babygod
	bgodtime = GAMEMODE and GAMEMODE.Config and GAMEMODE.Config.babygodtime
	if babygod then
		hook.Add("Think", "FalcoDetectSpawn", RegisterSpawn)
	end
end)


local function ToggleFRay(ply, cmd, args)
	FRayMat = repmat:GetString()
	RunConsoleCommand("r_cleardecals")

	-- Turn some annoying things off
	Falco_ForceVar("r_drawparticles", RayOn and 1 or 0)
	//Falco_ForceVar("r_3dsky", RayOn and 1 or 0)
	Falco_ForceVar("r_drawsprites", RayOn and 1 or 0)

	-- Get rid of DeathPOV
	if hook.GetTable().CalcView and hook.GetTable().CalcView.rp_deathPOV then hook.Remove("CalcView", "rp_deathPOV") end

	-- Turning xray off
	if RayOn then
		surface.PlaySound("buttons/button19.wav")

		local ENTS = ents.GetAll()
		for v = 1, #ENTS do
			if not IsValid(ENTS[v]) then continue end

			SetMat(ENTS[v], entityMaterials[ENTS[v]])
			local z = entityColors[ENTS[v]]
			if z and type(z) == "table" then
				SetColor(ENTS[v], Color(z.r, z.g, z.b, z.a))
			else
				SetColor(ENTS[v], Color(255,255,255,255))
			end


			local model = ENTS[v]:GetModel() or ""
			local class = GetClass(ENTS[v])
			if NoDraws[class] or NoDraws[model] then -- Hide effects
				SetNoDraw(ENTS[v], false)
			end

			--Sound System:
			if ENTS[v].FRaySound then
				ENTS[v].FRaySound:Stop()
			end
		end
		entityColors = {}

		-- Revive post processing effects
		if hook.GetTable().RenderScreenspaceEffects then
			for k,v in pairs(hook.GetTable().RenderScreenspaceEffects) do
				if k ~= "FESP_DrawLines" and k ~= "DrawCourse" and k ~= "LinesUP" then
					hook.Add("RenderScreenspaceEffects", k, AllHooks[k])--Override them with the old functions again
				end
			end
		end

		hook.Remove("PostDrawOpaqueRenderables", "falco_xray")
		hook.Remove("OnEntityCreated", "FalcoRayEntityInPVS")
		hook.Remove("PreDrawSkyBox", "removeSkybox")

		util.Effect = OLDUtilEffect
	else
		-- Play a nice sound
		surface.PlaySound("buttons/button1.wav")

		-- Kill all post processing effects
		if hook.GetTable().RenderScreenspaceEffects then
			for k,v in pairs(hook.GetTable().RenderScreenspaceEffects) do
				if k ~= "FESP_DrawLines" and k ~= "DrawCourse" and k ~= "LinesUP" then
					AllHooks[k] = v
					hook.Add("RenderScreenspaceEffects", k, function() end)--Override them with empty functions
				end
			end
		end

		-- Get rid of ropes
		for k,v in pairs(ents.FindByClass("class C_RopeKeyframe")) do
			SetColor(v, Color(0,0,0,0))
		end

		-- and effects
		util.Effect = function() end

		local ENTS = ents.GetAll()
		for v = 1, #ENTS do
			ExecFRayOnce(ENTS[v])
		end

		-- remove the skybox
		hook.Add("PreDrawSkyBox", "removeSkybox", function()
			render.Clear(50, 50, 50, 255)

			return true
		end)

		-- Add the rendering hook
		hook.Add("PostDrawOpaqueRenderables", "falco_xray", ExecuteFray)
		hook.Add("OnEntityCreated", "FalcoRayEntityInPVS", function(ent)
			if tobool(FRaySoundMode:GetInt()) and IsValid(ent) and ent:GetClass() == "prop_physics" then
				ent:EmitSound("eli_lab.al_buttonPunch", 100, 100)

			end
			ExecFRayOnce(ent)
		end)
	end
	RayOn = not RayOn
end
concommand.Add("falcop_xray", ToggleFRay)

function ExecFRayOnce(v)
	if not IsValid(v) then return end
	local color = GetColor(v)
	local r,g,b,a = color.r, color.g, color.b, color.a
	local class = GetClass(v)
	local low = string.lower(class)
	local model = v:GetModel() or ""

	-- Set some entities to not draw
	if NoDraws[class] or NoDraws[model] then
		SetNoDraw(v, true)
		return
	end

	v:SetRenderMode(RENDERMODE_TRANSALPHA)
	if v:IsNPC() and (r ~= 0 or g ~= 0 or b ~= 255 or a ~= 255) then
		entityColors[v] = Color(r,g,b,a)
		SetColor(v, Color(0, 0, 255, 30))
	elseif class == "viewmodel" and (r ~= 0 or g ~= 0 or b ~= 0 or a ~= 30)  then
		VIEWMODEL = v
		entityColors[v] = Color(r,g,b,a)
		SetColor(v, Color(0, 0, 0, 30))
		SetMat(v, "mat1")
	elseif string.find(class, "ghost") and a ~= 100 then
		entityColors[v] = Color(r,g,b,a)
		SetColor(v, Color(255,255,255,100))
	elseif (class == "drug_lab" or class == "money_printer") and (r ~= 255 or g ~= 0 or b ~= 100 or a ~= 50) then
		entityColors[v] = Color(r,g,b,a)
		SetColor(v, Color(255, 0, 100, 50))
	elseif class == "prop_physics" or v:IsPlayer() then
		entityColors[v] = Color(r,g,b,a)
	elseif not v:IsPlayer() and not v:IsNPC() and class ~= "prop_physics" and class ~= "prop" and class ~= "drug_lab" and class ~= "money_printer" and class ~= "func_breakable" and class ~= "func_wall" and not v:IsWeapon() and class ~= "viewmodel" and not v.NoXRay and not string.find(class, "ghost") and ( r ~= 255 or g ~= 200 or b ~= 0 or a ~= 100) then
		entityColors[v] = Color(r,g,b,a)
		--SetColor(v, 255, 200, 0, 100)
		SetColor(v, Color(0, 255, 0, 100))
	end
	if class ~= "viewmodel" and GetMat(v) ~= FRayMat and class ~= "func_door" and class ~= "func_door_rotating" and class ~= "prop_door_rotating" and class ~= "func_breakable" and class ~= "func_wall" and not v.NoXRay and not string.find(class, "ghost") then
		entityMaterials[v] = GetMat(v)
		SetMat(v, FRayMat)
	end

	-- Sound system
	if class == "prop_physics" and tobool(FRaySoundMode:GetInt()) then
		SetMat(v, FRayMat)
		v.FRaySound = v.FRaySound or CreateSound(v, "Canals.d1_canals_01_combine_shield_touch_loop1")
		v.FRaySound:PlayEx(100, 0)
		v:CallOnRemove("RemoveFRaySound", function(ent) if ent.FRaySound then ent.FRaySound:Stop() end end)
	end
end


local PhysicsVelocity = 2500
local ScaleNormal = Vector()
local ScaleOutline1	= Vector()
local function DrawEntityOutline(ent, size, r, g, b, a)
	--size = size or 1.0
	render.SetBlend(a)
	render.SetColorModulation(r, g, b)

	-- First Outline
	--ent:SetModelScale(ScaleOutline1 * size) -- WARNING: RESIZE LAGS
	--SetMaterialOverride("mat4")
	ent:DrawModel()

	-- Revert everything back to how it should be
	render.MaterialOverride(nil)
	--ent:SetModelScale(ScaleNormal)


end

-- fallback getOwner
local function getOwner(ent)
    return ent.IsMine and LocalPlayer() or NULL
end
timer.Simple(0, function() if CPPI and CPPI:GetName() then getOwner = FindMetaTable("Entity").CPPIGetOwner end end)

function ExecuteFray()
	if not RayOn then return end

	local PROPS = ents.FindByClass("prop_physics")
	local PLYS = player.GetAll()
    local localPly = LocalPlayer()

	local ang = EyeAngles()
	local eyePos = EyePos()
	cam.Start3D(eyePos, ang)
		for v = 1, #PROPS do
			if not IsValid(PROPS[v]) then continue end

			local prop = PROPS[v]
            local isMine = getOwner(prop) == localPly

			local IsHolding = localPly.isHolding == prop
			local Speed = VelLength(GetVelocity(prop))

			--local r,g,b,a = 110+(145/PhysicsVelocity*Speed), 0, 50 - (50/PhysicsVelocity*Speed), 100 + (50/PhysicsVelocity*Speed)
			--local r,g,b,a =  255/PhysicsVelocity*Speed, 255 - (255/PhysicsVelocity*Speed), 0, 20 + (50/PhysicsVelocity*Speed)
			--local multiplier = math.Clamp(Speed/PhysicsVelocity, 0, 1)
			local r,g,b,a =
				cPROPColor.r,-- - (255 + cPROPTOColor.r) * multiplier % 255,
				cPROPColor.g,-- - (255 + cPROPTOColor.g) * multiplier % 255,
				cPROPColor.b,-- - (255 + cPROPTOColor.b) * multiplier % 255,
				cPROPColor.a-- - (255 + cPROPTOColor.a) * multiplier % 255
			--local r,g,b,a =  255, 200 - (200/PhysicsVelocity*Speed), 0,
			--((prop:GetModel():lower() == "models/props/cs_militia/sheetrock_leaning.mdl" and 15) or 60) + (50/PhysicsVelocity*Speed)
			if getOwner(prop) == localPly then
				r, g, b, a = cMINEColor.r, cMINEColor.g, cMINEColor.b, cMINEColor.a or a
			end
			if prop.IsBreakable and prop:IsBreakable() then
				r, g, b = (isMine and cMINEColor.r) or 0, 0, 255
			end

			prop:SetRenderMode(RENDERMODE_TRANSALPHA)
			SetColor(prop, Color(r, g, b, a))
			SetMat(prop, "mat4")
			if isMine then
				local col = IsHolding and cPROPHOLDINGColor or cPROPMINEBGColor
				DrawEntityOutline(prop, 1.00, col.r/255, col.g/255, col.b/255, col.a/255)
			elseif ang:Forward():Dot(prop:GetPos() - eyePos) > 0 then
				DrawEntityOutline(prop, 1.00, cPROPBGColor.r/255, cPROPBGColor.g/255, cPROPBGColor.b/255, cPROPBGColor.a/255)
			end
			SetMat(prop, FRayMat)

			--FRaySound
			if prop.FRaySound then
				prop.FRaySound:ChangePitch(math.Min(255,255*(Speed/PhysicsVelocity)), 0)
			end
		end

		for v = 1, #PLYS do
			if IsValid(PLYS[v]) then
				if PLYS[v].BabyGod then
					SetColor(PLYS[v], Color(150,0,255,255))
					if PLYS[v] == localPly and IsValid(VIEWMODEL) then
						SetMat(VIEWMODEL, "mat2")
						SetColor(VIEWMODEL, 255,0,0,40)
					end
				else
					if PLYS[v] == localPly and IsValid(VIEWMODEL) then
						SetMat(VIEWMODEL, "mat1")
						SetColor(VIEWMODEL, Color(0,0,0,30))
					end
					SetColor(PLYS[v], Color(cPLYColor.r, cPLYColor.g, cPLYColor.b, cPLYColor.a))
				end
				SetMat(PLYS[v], "mat4")
				DrawEntityOutline(PLYS[v], 1.00, 1, 0.2, 0.2, 0.17)
				SetMat(PLYS[v], FRayMat)
				if IsValid(PLYS[v]:GetActiveWeapon()) then
					SetMat(PLYS[v]:GetActiveWeapon(),  "mat4")
					DrawEntityOutline(PLYS[v]:GetActiveWeapon(), 1.00, 1, 0.2, 0.2, 0.17)
				end
			end
			if GetRagdollEntity(PLYS[v]) then
				SetNoDraw(GetRagdollEntity(PLYS[v]), true)
			end
		end
	cam.End3D()

end
