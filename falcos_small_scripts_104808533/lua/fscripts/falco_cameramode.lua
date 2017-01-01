/*---------------------------------------------------------------------------
Removes all HUD elements.
---------------------------------------------------------------------------*/

local toggle = false
local net_graph = GetConVarNumber("net_graph")
local showfps = GetConVarNumber("cl_showfps")


local function CameraMode(ply, cmd, args)
	toggle = not toggle
	if toggle then
		--RunConsoleCommand("physgun_drawbeams", 0)
		RunConsoleCommand("cl_drawthrusterseffects", 0)
		//RunConsoleCommand("cl_drawhoverballs", 0)
		RunConsoleCommand("cl_drawcameras", 0)
		RunConsoleCommand("net_graph", 0)
		RunConsoleCommand("cl_showfps", 0)
		hook.Add("HUDShouldDraw", "HideThings", function()
			return false
		end)
	else
		RunConsoleCommand("physgun_drawbeams", 1)
		RunConsoleCommand("cl_drawthrusterseffects", 1)
		//RunConsoleCommand("cl_drawhoverballs", 1)
		RunConsoleCommand("cl_drawcameras", 1)
		RunConsoleCommand("net_graph", net_graph)
		RunConsoleCommand("cl_showfps", showfps)
		hook.Remove("HUDShouldDraw", "HideThings")
	end
end
concommand.Add("falco_cameramode", CameraMode)