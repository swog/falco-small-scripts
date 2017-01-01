/*---------------------------------------------------------------------------
Ancient player detector script
---------------------------------------------------------------------------*/

local RadiusMode = false
local detectors = {}
local NaarBeeldscherm = debug.getregistry().Vector.ToScreen
surface.CreateFont("FdetectorFont1", {
	size = "coolvetica",
	weight = 32,
	antialias = 500,
	shadow = true,
	font = false})

local FDetDoSay = CreateClientConVar("Falco_Det_DoSay", 0, true, false)

local ignores = {"class C_BaseEntity", "func_door", "prop_door_rotating", "class C_PhysPropClientside", "viewmodel", "worldspawn", "class C_HL2MPRagdoll"}

local function ThinkFunction()
	if #detectors < 1 then return end
	local sound1 = Sound("ambient/alarms/siren.wav" )
	local sound = CreateSound(LocalPlayer(), sound1)
	for num, center in pairs(detectors) do
		if not center:IsValid() then return end
		center:SetPos(center.pozizion)
		if center.detectmode then
			local trace = {}
			trace.start = LocalPlayer():GetShootPos()
			trace.endpos = center.pozizion
			trace.filter = LocalPlayer()
			trace.mask = -1
			local TheTrace = util.TraceLine(trace)
			if TheTrace.Hit then
				center.DrawRadius = false
			else
				center.DrawRadius = true
			end

			for k,v in pairs(center.Entities) do
				if not table.HasValue(ents.FindInSphere( center:GetPos(), center.radius), v) then
					table.remove(center.Entities, k)
				end
			end
			for k,v in pairs(ents.FindInSphere( center:GetPos(), center.radius)) do
				local class = v:GetClass()
				if class ==  "prop_physics" and not table.HasValue(center.Entities, v) and not table.HasValue(ignores, class)  then
					table.insert(center.Entities, v)
					fnotify(v:GetModel() .. " has entered " .. center.Naam, 1, 5)

					local text = tostring(v:GetModel() .. " has entered " .. center.Naam)

					sound:Play()
					timer.Simple(1, function() sound:Stop() end)
					if v:GetNetworkedString("Owner") ~= "" then
						fnotify("Prop belongs to: " .. v:GetNetworkedString("Owner"), 1, 5)
						text = tostring(v:GetModel() .. " of " .. v:GetNetworkedString("Owner") .. " has entered " .. center.Naam)
					elseif (ASS_PP_GetOwner and ASS_PP_GetOwner(v):IsValid()) then
						fnotify("Prop belongs to: " .. ASS_PP_GetOwner(v):Nick(), 1, 5)
						text = tostring(v:GetModel() .. " of " .. ASS_PP_GetOwner(v):Nick() .. " has entered " .. center.Naam)
					end

					if FDetDoSay:GetInt() == 1 then
						Falco_DelayedSay(text)
					end
				elseif class == "player" and not table.HasValue(center.Entities, v) then
					table.insert(center.Entities, v)
					if v == LocalPlayer() then
						surface.PlaySound("buttons/button14.wav")
					else
						sound:Play()
						timer.Simple(1, function() sound:Stop() end)
						fnotify(v:Nick() .. " has entered " ..  center.Naam, 1, 5 )

						if FDetDoSay:GetInt() == 1 then
							Falco_DelayedSay(tostring(v:Nick() .. " has entered " ..  center.Naam))
						end
					end
				elseif class ~= "player" and class ~= "prop_physics" and not v:IsWeapon() and not table.HasValue(center.Entities, v) and not table.HasValue(ignores, class) then
					table.insert(center.Entities, v)
					fnotify(class .. " has entered " .. center.Naam, 1, 5)

					if FDetDoSay:GetInt() == 1 then
						Falco_DelayedSay(tostring(class .. " has entered " .. center.Naam))
					end

					timer.Simple(1, function() sound:Stop() end)
					sound:Play()
				end
			end
		end
	end
end

local function RadiusSelection(ply, bind, pressed)
	if RadiusMode and ply == LocalPlayer() and pressed and string.find(bind, "attack") then
		hook.Remove("HUDPaint", "RadiusFDetector")
		local trace = LocalPlayer():GetEyeTrace()
		detectors[table.Count(detectors)].radius = detectors[table.Count(detectors)]:GetPos():Distance(trace.HitPos)
		RadiusMode = false
		LocalPlayer():ChatPrint("Radius selected: " .. tostring(math.floor(detectors[table.Count(detectors)].radius)))
		detectors[table.Count(detectors)].detectmode = true
		hook.Remove("PlayerBindPress", "Radiusselection")
		hook.Add("Think", "PlayerDetection", ThinkFunction)
		return true
	end
end

local function DrawRadius()
	for k,v in pairs(detectors) do
		if v.DrawRadius == true then
			surface.SetDrawColor(255,0,0,255)
			local pos1_1 = NaarBeeldscherm(v:GetPos() + Vector(v.radius, 0,0))
			local pos1_2 = NaarBeeldscherm(v:GetPos() - Vector(v.radius, 0,0))

			local pos2_1 = NaarBeeldscherm(v:GetPos() + Vector(0, v.radius,0))
			local pos2_2 = NaarBeeldscherm(v:GetPos() - Vector(0, v.radius,0))

			local pos3_1 = NaarBeeldscherm(v:GetPos() + Vector(0,0,v.radius))
			local pos3_2 = NaarBeeldscherm(v:GetPos() - Vector(0,0,v.radius))
			surface.DrawLine(pos1_1.x, pos1_1.y, pos1_2.x, pos1_2.y )
			surface.DrawLine(pos2_1.x, pos2_1.y, pos2_2.x, pos2_2.y )
			surface.DrawLine(pos3_1.x, pos3_1.y, pos3_2.x, pos3_2.y )
		end
	end
end

local function MakeDetector(ply, cmd, args)
	local center = ents.CreateClientProp()
	center:SetPos(LocalPlayer():GetShootPos())
	center:SetModel("models/Items/AR2_Grenade.mdl")
	center:Spawn()
	LocalPlayer():ChatPrint("Select radius(use mouse button)")
	RadiusMode = true
	hook.Add("PlayerBindPress", "Radiusselection", RadiusSelection)
	table.insert(detectors, center)
	detectors[table.Count(detectors)].pozizion = LocalPlayer():GetShootPos() - Vector(0,0,32)
	detectors[table.Count(detectors)].Entities = {}
	detectors[table.Count(detectors)].DrawRadius = false
	detectors[table.Count(detectors)].detectmode = false

	hook.Add("HUDPaint", "RadiusFDetector", function()
		local trace = LocalPlayer():GetEyeTrace()
		local distance = center:GetPos():Distance(trace.HitPos)
		draw.DrawText(tostring(math.floor(distance)), "FdetectorFont1", ScrW() / 2, ScrH() / 2, Color(255,255,255,255), 1)
	end)
	hook.Add("HUDPaint", "DrawRadiusOfDetectors", DrawRadius)

	if args[1] ~= nil then
		detectors[table.Count(detectors)].Naam = tostring(table.concat(args, " "))
	else
		detectors[table.Count(detectors)].Naam = "your detector"
	end
end
concommand.Add("FDetector",MakeDetector)

local function removedetectors()
	RadiusMode = false
	if detectors[table.Count(detectors)] and detectors[table.Count(detectors)]:IsValid() then
		detectors[table.Count(detectors)]:Remove()
		LocalPlayer():ChatPrint("Last detector removed")
		table.remove(detectors, table.Count(detectors))
	end
	if #detectors < 1 then
		hook.Remove("HUDPaint", "RadiusFDetector")
		hook.Remove("HUDPaint", "DrawRadiusOfDetectors")
	end
end
concommand.Add("FRemoveDetector",removedetectors)

falco_addchatcmd("fdetector", function(text) LocalPlayer():ConCommand("FDetector " .. text) end)
falco_addchatcmd("fdet", function(text) LocalPlayer():ConCommand("FDetector " .. text) end)
falco_addchatcmd("fremdet", function(text) LocalPlayer():ConCommand("FRemoveDetector") end)