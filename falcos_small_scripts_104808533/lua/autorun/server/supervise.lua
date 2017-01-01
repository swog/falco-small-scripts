local function supervise(ply)
	if ply.IsSuperVising then ply.NextSpawnTime = CurTime() ply:UnSpectate() ply:Spawn() return end
	ply:KillSilent()
	ply:Spectate(OBS_MODE_ROAMING)
	ply.IsSuperVising = true
	ply.NextSpawnTime = CurTime() + 99999999
end
concommand.Add("supervise", supervise)
concommand.Add("poki_supervise", supervise)

hook.Add( "PlayerSpawnProp", "supervise", function(ply, model)
	if ply.IsSuperVising then return false end
end)

hook.Add("PlayerSpawn", "supervise", function(ply)
	ply.IsSuperVising = nil
end)


local function GetPropWeight(ply)
	local ent = ply:GetEyeTrace().Entity
	if IsValid(ent) and ent:GetPhysicsObject():IsValid() then
		ply:ChatPrint("Weight: " .. tostring(ent:GetPhysicsObject():GetMass()))
	end
end
concommand.Add("PoKi_Getweight", GetPropWeight)