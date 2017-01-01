local spawnAlternatives = CreateClientConVar("falco_spawnalternatives", 0, true, false)

local LastSpawned = ""
local BlockedModels = {}
local Falco_Alternatives = {}
Falco_Alternatives["models/props_c17/lockers001a.mdl"] = "models/props/cs_militia/refrigerator01.mdl"
Falco_Alternatives["models/props_junk/gascan001a.mdl"] = "models/props_junk/metal_paintcan001a.mdl"
Falco_Alternatives["models/props_wasteland/laundry_dryer001.mdl"] = "models/props_rooftop/dome_copper.mdl"
Falco_Alternatives["models/props_rooftop/dome_copper.mdl"] = "models/props/cs_militia/crate_stackmill.mdl"
Falco_Alternatives["models/props_combine/combine_fence01a.mdl"] = "models/props_c17/utilitypole01b.mdl"
Falco_Alternatives["models/props_c17/utilitypole01b.mdl"] = "models/xqm/helicopterrotorlarge.mdl"
Falco_Alternatives["models/props_combine/breen_tube.mdl"] = "models/props/de_nuke/coolingtower.mdl"
Falco_Alternatives["models/props/de_tides/gate_large.mdl"] = "models/props/de_train/lockers_long.mdl"
Falco_Alternatives["models/props/cs_militia/skylight_glass_p6.mdl"] = "models/props_debris/concrete_chunk02b.mdl"
Falco_Alternatives["models/props_rooftop/roof_vent002.mdl"] = "models/props/cs_assault/firehydrant.mdl"
Falco_Alternatives["models/props_debris/walldestroyed03a.mdl"] = "models/props_junk/ibeam01a_cluster01.mdl"
Falco_Alternatives["models/props_wasteland/interior_fence002d.mdl"] = "models/props/de_inferno/lattice.mdl"
Falco_Alternatives["models/props_junk/sawblade001a.mdl"] = "models/props/cs_militia/skylight_glass_p6.mdl"
Falco_Alternatives["models/props/cs_militia/refrigerator01.mdl"] = "models/props_c17/furniturestove001a.mdl"
Falco_Alternatives["models/props_c17/furniturestove001a.mdl"] = "models/props_c17/FurnitureWashingmachine001a.mdl"
Falco_Alternatives["models/props_c17/furniturewashingmachine001a.mdl"] = "models/props_interiors/refrigerator01a.mdl"
Falco_Alternatives["models/props_vents/vent_large_grill001.mdl"] = "models/cheeze/pcb2/pcb6.mdl"
Falco_Alternatives["models/props/de_train/lockers_long.mdl"] = "models/props_lab/blastdoor001c.mdl"
Falco_Alternatives["models/props_canal/canal_bars004.mdl"] = "models/props/cs_militia/sheetrock_leaning.mdl"
Falco_Alternatives["models/xqm/coastertrack/slope_225_2.mdl"] = "models/xqm/coastertrack/slope_225_1.mdl"
Falco_Alternatives["models/xqm/coastertrack/slope_225_1.mdl"] = "models/hunter/misc/cone4x1.mdl"
Falco_Alternatives["models/xqm/coastertrack/slope_90_1.mdl"] = "models/hunter/misc/cone2x1.mdl"
Falco_Alternatives["models/hunter/tubes/tube1x1x6.mdl"] = "models/props_docks/dock03_pole01a.mdl"
Falco_Alternatives["models/props_docks/dock03_pole01a.mdl"] = "models/XQM/helicopterrotorlarge.mdl"
Falco_Alternatives["models/props_phx/construct/metal_angle360.mdl"] = "models/props_junk/trashdumpster02b.mdl"

function FSpawnModel(Model, DontSpawn)
	local check = string.lower(Model)
	if not DontSpawn then
		LastSpawned = string.lower(Model)
	end
	while(table.HasValue(BlockedModels, check) and Falco_Alternatives[check]) do
		check = string.lower(Falco_Alternatives[check])
	end
	if not DontSpawn then RunConsoleCommand("gm_spawn", check) end
	return check, table.HasValue(BlockedModels, check)
end

hook.Add("PlayerBindPress", "SpawnModel", function(ply, bind, pressed, extraArg)
	if not tobool(spawnAlternatives:GetInt()) then return end

	local TheBind = string.Explode(' ', bind)
	if not TheBind[1] or string.lower(TheBind[1]) ~= "gm_spawn" or not pressed or extraArg then return end
	local DoSpawn = hook.Call("PlayerBindPress", nil, ply, bind, pressed, true)
	if not DoSpawn then FSpawnModel(TheBind[2]) end
	return true
end)

concommand.Add("falco_resetBlockedModels", function() BlockedModels = {} end)

timer.Simple(0, function()
	if not FPP then return end
	local notify = FPP.AddNotify
	function FPP.AddNotify(str, type)
		if LastSpawned ~= '' and (str == "The model of this entity is in the black list!" or str == "The model of this entity is not in the white list!") then
			table.insert(BlockedModels, string.lower(LastSpawned))
			if Falco_Alternatives[string.lower(LastSpawned)] then
				FSpawnModel(Falco_Alternatives[string.lower(LastSpawned)])
			end
		end
		return notify(str, type)
	end
end)
