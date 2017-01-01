/*---------------------------------------------------------------------------
This is an old script of mine that tries to lower the settings to prevent lag
It's just a bunch of console commands and removing entities.
---------------------------------------------------------------------------*/

local removes = {"env_steam",
"func_illusionary",
"beam",
"class C_BaseEntity",
"env_sprite",
"class C_ShadowControl",
"class C_ClientRagdoll",
"func_illusionary",
"class C_PhysPropClientside",
}

local nolag = false

local function StopLag()
	nolag = true
	RunConsoleCommand("r_3dsky", 0)
	RunConsoleCommand("r_WaterDrawReflection", 0)
	RunConsoleCommand("r_waterforcereflectentities", 0)
	RunConsoleCommand("r_teeth", 0)
	RunConsoleCommand("r_shadows", 0)
	RunConsoleCommand("r_ropetranslucent", 0)
	RunConsoleCommand("r_maxmodeldecal", 0) --50
	RunConsoleCommand("r_maxdlights", 0)--32
	RunConsoleCommand("r_decals", 0)--2048
	RunConsoleCommand("r_drawmodeldecals", 0)
	RunConsoleCommand("r_drawdetailprops", 0)
	RunConsoleCommand("r_decal_cullsize", 0)
	RunConsoleCommand("r_worldlights", 0)
	RunConsoleCommand("r_flashlightrender", 0)
	RunConsoleCommand("cl_forcepreload", 1)
	RunConsoleCommand("r_threaded_renderables", 1)
	RunConsoleCommand("r_threaded_client_shadow_manager", 1)
	RunConsoleCommand("snd_mix_async", 1)
	RunConsoleCommand("cl_ejectbrass", 0)
	RunConsoleCommand("cl_detaildist", 0)
	RunConsoleCommand("cl_show_splashes", 0)
	--RunConsoleCommand("mat_fastnobump", 1)
	RunConsoleCommand("mat_filterlightmaps", 0)
	--RunConsoleCommand("mat_filtertextures", 0)
	RunConsoleCommand("r_drawflecks", 0)
	RunConsoleCommand("r_dynamic", 0)
	RunConsoleCommand("r_WaterDrawRefraction", 0)
	--RunConsoleCommand("mat_showlowresimage", 1)

	for k,v in pairs(removes) do
		for a,b in pairs(ents.FindByClass(v)) do
			b:SetNoDraw(true)
		end
	end

end
concommand.Add("falco_stoplag", StopLag)

local function Reset()
	nolag = false
	RunConsoleCommand("r_3dsky", 1)
	RunConsoleCommand("r_WaterDrawReflection", 1)
	RunConsoleCommand("r_waterforcereflectentities", 1)
	RunConsoleCommand("r_teeth", 1)
	RunConsoleCommand("r_shadows", 1)
	RunConsoleCommand("r_ropetranslucent", 1)
	RunConsoleCommand("r_maxmodeldecal", 50) --50
	RunConsoleCommand("r_maxdlights", 32)--32
	RunConsoleCommand("r_decals", 2048)--2048
	RunConsoleCommand("r_drawmodeldecals", 1)
	RunConsoleCommand("r_drawdetailprops", 1)
	RunConsoleCommand("r_decal_cullsize", 1000)
	RunConsoleCommand("r_worldlights", 1)
	RunConsoleCommand("r_flashlightrender", 1)
	RunConsoleCommand("cl_forcepreload", 0)
	RunConsoleCommand("cl_ejectbrass", 1)
	RunConsoleCommand("cl_show_splashes", 1)
	RunConsoleCommand("cl_detaildist", 1200)
	--RunConsoleCommand("mat_fastnobump", 0)
	RunConsoleCommand("mat_filterlightmaps", 1)
	RunConsoleCommand("r_threaded_renderables", 0)
	RunConsoleCommand("r_threaded_client_shadow_manager", 0)
	--RunConsoleCommand("mat_filtertextures", 1)
	RunConsoleCommand("r_drawflecks", 1)
	RunConsoleCommand("r_WaterDrawRefraction", 0)
	--RunConsoleCommand("mat_showlowresimage", 0)
	RunConsoleCommand("r_dynamic", 1)
	for k,v in pairs(removes) do
		for a,b in pairs(ents.FindByClass(v)) do
			b:SetNoDraw(false)
		end
	end
end
concommand.Add("falco_resetlag", Reset)