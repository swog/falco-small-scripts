/*
Not my script.
Author unknown
*/
local showSpectators = true
hook.Add("HUDPaint", "SpectatorsListing", function()
	if !showSpectators then return end
	local spectatePlayers = {}
	local x = 0
	for k,v in pairs(player.GetAll()) do
		if v:GetObserverTarget() == LocalPlayer() then
			table.insert(spectatePlayers, v:Name())
		end
	end

	if #spectatePlayers == 0 then return end

	local textLength = surface.GetTextSize(table.concat(spectatePlayers) ) / 3
	draw.RoundedBox(1, ScrW() - 180, ScrH() - ScrH() + 15, 150, 30 + textLength, Color(0,0,0,150))
	draw.SimpleText("Spectators", "TabLarge", ScrW() - 140, ScrH() - ScrH() + 17, Color(0, 0, 0, 150))
	draw.SimpleText("Spectators", "TabLarge", ScrW() - 140, ScrH() - ScrH() + 16, Color(255, 255, 255, 255))

	for k, v in pairs(spectatePlayers) do
        draw.SimpleText(v, "TabLarge", ScrW() - 140, ScrH() - ScrH() + 35 + x, Color(255, 255, 255, 255))
        x = x + 15
    end
end)
concommand.Add("showspecs", function(ply, command, args)
	showSpectators = !showSpectators
end)
