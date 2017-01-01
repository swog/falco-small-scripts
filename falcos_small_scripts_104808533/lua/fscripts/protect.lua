local HASSpawned = false
local function Protect(_, cmd, PropID, model)
	local Toggle = string.sub(cmd, 1,1)

	local UsedModel = FSpawnModel(model or "models/props_wasteland/laundry_dryer001.mdl", true)
	if Toggle == "+" then
		if not LocalPlayer():Alive() then return end
		local ang = LocalPlayer():EyeAngles()
		LocalPlayer():SetEyeAngles(Angle(90, ang.y, ang.r))
		timer.Simple(.1, function()
			FSpawnModel(UsedModel)
		end)
		timer.Simple(0.5, function()
			if not HASSpawned then
				Protect(nil, "+")
				HASSpawned = true
			end
		end)
		hook.Add("Falco_SpawnedProp", "Falco_Protect", function(prop, ID)
			if string.lower(prop) == string.lower(UsedModel) then
				HASSpawned = true
				if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" then
					RunConsoleCommand("+attack")
					timer.Simple(0.1, function() RunConsoleCommand("+attack2") end)
					timer.Simple(0.2, function() RunConsoleCommand("-attack") end)
					timer.Simple(0.2, function() RunConsoleCommand("-attack2") end)
				end

				--local Mins,Maxs = LocalPlayer():LocalToWorld(LocalPlayer():OBBMins()), LocalPlayer():LocalToWorld(LocalPlayer():OBBMaxs())
				hook.Add("Think", "Falco_Protect", function()
					local Mins,Maxs = LocalPlayer():LocalToWorld(LocalPlayer():OBBMins()), LocalPlayer():LocalToWorld(LocalPlayer():OBBMaxs())
					local MinEnts = ents.FindInSphere(Mins, 2)
					local found = false
					for k,v in pairs(MinEnts) do
						if string.lower(v:GetModel() or "") == string.lower(prop or "") then found = true break end
					end
					if not found then
						Protect(nil, "-", ID)
						hook.Remove("Think", "Falco_Protect")
						timer.Simple(0.1, function() Protect(nil, "+") end)
					end
				end)

				hook.Remove("Falco_SpawnedProp", "Falco_Protect")
			end
		end)
	else
		if hook.GetTable().Falco_SpawnedProp then
			hook.Remove("Falco_SpawnedProp", "Falco_Protect")
		end
		hook.Remove("Think", "Falco_Protect")

		if PropID and type(PropID) == "number" then
			RunConsoleCommand("gmod_undonum", PropID)
		else
			local found = false
			for k,v in pairs(undo.GetTable()) do
				if string.find(string.lower(v.Name or ""), string.lower(UsedModel) or "") then
					RunConsoleCommand("gmod_undonum", v.Key)
					found = true
				end
			end
		end
	end
end
concommand.Add("+falco_protect", Protect)
concommand.Add("-falco_protect", Protect)

concommand.Add("falco_softprotect", function()
	local UsedModel = FSpawnModel(model or "models/hunter/tubes/tube2x2x4.mdl", true)
	local ang = LocalPlayer():EyeAngles()
	LocalPlayer():SetEyeAngles(Angle(90, ang.y, ang.r))
	timer.Simple(.1, function()
		FSpawnModel(UsedModel)
		hook.Add("Falco_SpawnedProp", "Falco_Protect", function(prop, ID)
			if string.lower(prop) == string.lower(UsedModel) then
				LocalPlayer():SetEyeAngles(ang)

				if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" then
					RunConsoleCommand("+attack")
					timer.Simple(0.1, function() RunConsoleCommand("+attack2") end)
					timer.Simple(0.2, function() RunConsoleCommand("-attack") end)
					timer.Simple(0.2, function() RunConsoleCommand("-attack2") end)
				end
			end
		end)
	end)
end)

local drop = CreateClientConVar("falco_protectdrop", 0, true, false)

local wait = false
local RemoveCount = 0
local ang = Angle(0,0,0)
local DropProp = "models/hunter/tubes/tube1x1x6.mdl"//"models/props/de_inferno/spireb.mdl"-- "models/props_docks/piling_cluster01a.mdl"--"models/props_combine/combine_fence01b.mdl"
hook.Add("Falco_SpawnedProp", "RemoveFallDamagePreventer", function(prop, key)
	--if not IsValid(prop) or not prop.GetModel or not prop:GetModel() then return end
	if string.lower(prop) == FSpawnModel(DropProp, true) and RemoveCount > 0 then
		LocalPlayer():SetEyeAngles(Angle(ang.p, ang.y, ang.r))
		local found = false
		local function doremove()
			RunConsoleCommand("gmod_undo")
		end
		doremove()
		wait = false
		RemoveCount = RemoveCount - 1
	end
end)

local function ProtectDrop(f)
	if (not input.IsKeyDown(KEY_SPACE) or input.IsKeyDown(KEY_LCONTROL)) and not f then return end
	local onground = LocalPlayer():IsOnGround()
	local speed = LocalPlayer():GetVelocity().z
	local mypos = LocalPlayer():GetPos()

	if not wait and not onground and LocalPlayer():Alive() and (speed < -470 or f) then
		local trace = {
			start = mypos,
			endpos = mypos - Vector(0,0,240) + Vector(0,0, (speed + 540) / 30),
			filter = LocalPlayer()
		}
		local tr = util.TraceLine(trace)

		local point = util.PointContents(tr.HitPos + Vector(0,0,1))
		if (tr.Hit and point ~= 32 and point ~= 268435488) or f then
			wait = true
			ang = LocalPlayer():EyeAngles()
			LocalPlayer():SetEyeAngles(Angle(90, ang.y, ang.r))
			RemoveCount = RemoveCount + 1
			timer.Simple(.05, function() FSpawnModel(DropProp) end)
		end
	elseif onground and wait then
		wait = false
	end
end
concommand.Add("falco_DoProtectDrop", function() ProtectDrop(true) end)

if drop:GetInt() == 1 then
	hook.Add("Think", "ProtectDrop", ProtectDrop)
end

cvars.AddChangeCallback("falco_protectdrop", function(cvar, prevvalue, newvalue)
	if newvalue == "1" then
		hook.Add("Think", "ProtectDrop", ProtectDrop)
	else
		hook.Remove("Think", "ProtectDrop")
	end
end)

local safeview = debug.getregistry().CUserCmd.SetViewAngles
local function DoFreeze()
	if not LocalPlayer():Alive() then return end
	local ang = LocalPlayer():EyeAngles()
	local trace = LocalPlayer():GetEyeTrace().HitPos
	local closest
	for k,v in pairs(player.GetAll()) do
		if not closest then closest = v end
		for a, b in pairs(player.GetAll()) do
			if closest and b ~= LocalPlayer() and b:GetPos():Distance(trace) < closest:GetPos():Distance(trace) then
				closest = b
			end
		end
	end

	if not closest then return end

	hook.Add( "CreateMove", "TEMPFREEZE", function(u)
		local tracedata = {}
		tracedata.start = LocalPlayer():GetShootPos()
		tracedata.endpos = closest:GetPos()
		tracedata.filter = LocalPlayer()
		local trace2 = util.TraceLine(tracedata)

		local tracedata2 = {}
		tracedata2.start = trace2.HitPos - LocalPlayer():GetAimVector() * 5
		tracedata2.endpos = tracedata2.start - Vector(0,0,999)
		tracedata2.filter = closest
		local trace3 = util.TraceLine(tracedata2)

		if trace3.Hit then
			safeview(u, (trace3.HitPos - LocalPlayer():GetShootPos()):Angle())
		end

		--[[ if not HasSpawned then
			RunConsoleCommand( "gm_spawn", "models/props_combine/breen_tube.mdl")
			HasSpawned = true
		end ]]
	end)

	timer.Simple(0.05, function() FSpawnModel("models/props_combine/breen_tube.mdl") end)
	local DidCreate = false
	hook.Add("OnEntityCreated", "FreezeBlocker", function(prop)
		if not prop:GetModel() then return end
		if string.lower(prop:GetModel()) == "models/props_combine/breen_tube.mdl" then
			DidCreate = true
			hook.Remove( "CreateMove", "TEMPFREEZE")
			hook.Remove("OnEntityCreated", "FreezeBlocker")

			if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun"then
				local pos = prop:LocalToWorld(prop:OBBCenter())

				timer.Simple(0.05, function() LocalPlayer():SetEyeAngles( (pos - LocalPlayer():GetShootPos()) :Angle() ) end)
				timer.Simple(0.15, function() RunConsoleCommand("+attack") end)
				timer.Simple(0.2,  function() RunConsoleCommand("+attack2") end)
				timer.Simple(0.25, function() RunConsoleCommand("-attack") end)
				timer.Simple(0.25, function() RunConsoleCommand("-attack2") end)
			end
		end
	end)

	timer.Simple(2, function()
		if not DidCreate then
			hook.Remove( "CreateMove", "TEMPFREEZE")
			hook.Remove("OnEntityCreated", "FreezeBlocker")
		end
	end)
end
concommand.Add("falco_freeze", DoFreeze)
