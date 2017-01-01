sql.Query("CREATE TABLE IF NOT EXISTS falco_worldprops('map' TEXT NOT NULL, 'model' TEXT NOT NULL, 'x' INTEGER NOT NULL, 'y' INTEGER NOT NULL, 'z' INTEGER NOT NULL, 'pitch' INTEGER NOT NULL, 'yaw' INTEGER NOT NULL, 'roll' INTEGER NOT NULL, PRIMARY KEY('map'));")

function AddWorldProp(ply)
	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) or not ply:IsSuperAdmin() then return end

	local pos = ent:GetPos()
	pos = Vector(math.Round(pos.x), math.Round(pos.y), math.Round(pos.z))
	ent:SetPos(pos)
	local ang = ent:EyeAngles()
	ang = Angle(math.Round(ang.p), math.Round(ang.y), math.Round(ang.r))
	ent:SetAngles(ang)
	local map = string.lower(game.GetMap())
	local model = ent:GetModel()

	local data = sql.Query("SELECT * FROM falco_worldprops;") or {}
	sql.Query("INSERT INTO falco_worldprops VALUES("..sql.SQLStr(map..tostring(table.Count(data) + 1))..", "..sql.SQLStr(model)..", "..sql.SQLStr(pos.x)..", "..sql.SQLStr(pos.y)..", "..sql.SQLStr(pos.z)..", "..sql.SQLStr(ang.p)..", "..sql.SQLStr(ang.y)..", "..sql.SQLStr(ang.r)..");")
	ply:ChatPrint("added "..model)
end
concommand.Add("falco_addmapprop", AddWorldProp)

function RestoreMapItems(ply)
	if ply and not ply:IsSuperAdmin() then return end
	timer.Simple(1, function()
		local data = sql.Query("SELECT * FROM falco_worldprops;")
		if not data then return end
		for k,v in pairs(data) do
			if string.find(v.map, string.lower(game.GetMap())) == 1 then
				local ent = ents.Create("prop_physics")
				ent:SetPos(Vector(tonumber(v.x), tonumber(v.y), tonumber(v.z)))
				ent:SetAngles(Angle(v.pitch, v.yaw, v.roll))
				ent:SetModel(v.model)
				ent:SetSolid(SOLID_VPHYSICS)
				ent:Spawn()
				ent:Activate()
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then phys:EnableMotion(false) end
				ent:SetNWString("Owner", "World") --SPP
				ent:SetNWBool("mapprop", true)

				function ent:PhysgunPickup() return false end
				function ent:CanTool() return false end
			end
		end
	end)
end
hook.Add( "InitPostEntity", "falco_RestoreMapItems", RestoreMapItems)
concommand.Add("falco_restoremapprops", RestoreMapItems)

function ClearMapEnts(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	local data = sql.Query("SELECT * FROM falco_worldprops;") or {}
	for k,v in pairs(data) do
		if string.find(v.map, string.lower(game.GetMap())) == 1 then
			sql.Query("DELETE FROM falco_worldprops WHERE map = "..sql.SQLStr(v.map)..";")
		end
	end
end
concommand.Add("falco_clearmapprops", ClearMapEnts)