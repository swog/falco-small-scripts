/*---------------------------------------------------------------------------
Teleport to a location where people won't annoy you
---------------------------------------------------------------------------*/
local locations = {
	["rp_downtown_v4c_v2"] = "1298, -4436, -198",
	["rp_downtown_v2"] = "1626, 2091, 225"
}
local function doTeleport()
	local map = string.lower(game.GetMap())

	if locations[map] then
		timer.Simple(0.2, function() RunConsoleCommand("FAdmin", "TPToPos", locations[map]) end)
	end
end
concommand.Add("falco_FAdminTeleport", doTeleport)