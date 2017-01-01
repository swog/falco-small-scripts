/*---------------------------------------------------------------------------
Makes you automatically whine in OOC when someone pulls up an arrest baton
---------------------------------------------------------------------------*/

local enabled = CreateClientConVar("Falco_ArrestBatonWarning", 0, true, false)

local waits = {}

local function getAllWeapons()
	for k,v in pairs(player.GetAll()) do
		if IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() == "arrest_stick" and not waits[v] then
			print("ARREST BATON")
			Falco_DelayedSay(v:Nick() .. " pulled out their arrest batons")
			waits[v] = true
		elseif IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() ~= "arrest_stick" and waits[v] then
			print("NOT ARREST BATON")
			waits[v] = false
		end
	end
end

if enabled:GetInt() == 1 then
	hook.Add("Think", "falco_WeaponAlert", getAllWeapons)
end

cvars.AddChangeCallback("falco_WeaponAlert", function(cvar, prevvalue, newvalue)
	if newvalue == "1" then
		hook.Add("Think", "falco_WeaponAlert", getAllWeapons)
	else
		hook.Remove("Think", "falco_WeaponAlert")
	end
end)