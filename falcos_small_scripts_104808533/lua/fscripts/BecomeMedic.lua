-- I use this every single time I join a server
local Medics = {"medic", "doctor", "krankenhaus", "accro77doctor", "paramedic"}

concommand.Add("falco_becomeMedic", function()
	for k,v in pairs(RPExtraTeams or {}) do
		if table.HasValue(Medics, string.lower(v.command or "")) then
			RunConsoleCommand("say", "/"..v.command)
		end
	end
end)
