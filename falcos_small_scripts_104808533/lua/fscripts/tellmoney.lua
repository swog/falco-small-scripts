/*---------------------------------------------------------------------------
Say what people's money amounts are
---------------------------------------------------------------------------*/

local function TellAllMoneyAmounts()
	local Rep = table.Copy(player.GetAll())
	table.sort(Rep, function(a, b) return (a.DarkRPVars.money) > (b.DarkRPVars.money) end)

	for k,v in pairs(Rep) do
		local money = v:GetNetworkedInt("money")
		if v.DarkRPVars and v.DarkRPVars.money then
			money = v.DarkRPVars.money
		end
		timer.Simple(k * 1.7, function() Falco_DelayedSay(tostring(k)..": "..v:Nick() .. " has $" .. money .. " in their wallets") end)
	end
end
concommand.Add("falco_sayAllMoney", TellAllMoneyAmounts)
falco_addchatcmd("falco_sayallmoney", TellAllMoneyAmounts)

local function TellAllHunger()
	local Rep = table.Copy(player.GetAll())
	table.sort(Rep, function(a, b) return a:GetNWInt("Energy") > b:GetNWInt("Energy") end)
	for k,v in pairs(Rep) do
		timer.Simple(k * 1.7, function() Falco_DelayedSay(tostring(k)..": "..v:Nick() .. " has " .. v:GetNWInt("Energy") .. "% energy(hunger) left") end)
	end
end
concommand.Add("falco_SayAllHunger", TellAllHunger)
falco_addchatcmd("falco_SayAllHunger", TellAllHunger)

local function FSayMoney(ply, text, teamonly, dead)
	if string.find(string.lower(text), "fsaymoney") ~= 1 then return end
	local nick = ply:Nick()
	local text2 = text
	if string.find(text, nick) then
		text2 = string.lower(string.sub(text, string.len("("..nick..") ") + 1))
	end
	local find = string.gsub(string.lower(text2), "fsaymoney ", "")
	if string.find(find, " ") == 1 then find = string.sub(find, 2) end

	local found = false
	for k,v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Nick()), string.lower(find)) then
			found = v
		end
	end
	if not found then fnotify("Player not found", 1, 4) return end

	local money = found:GetNetworkedInt("money")
	if found.DarkRPVars and found.DarkRPVars.money then
		money = found.DarkRPVars.money
	end

	timer.Simple(1.7, function() Falco_DelayedSay(found:Nick() .. " has $" .. money .. " in their wallet") end)
end
hook.Add( "OnPlayerChat", "FSayMoney", FSayMoney)

function TellAllAdmins(ply, cmd)
	local say = Falco_DelayedSay
	if string.lower(cmd) == "falco_printadmins" then
		say = print
	end
	local a = 0
	local Admins = ""
	local Superadmins = ""
	local ASSUsers = ""
	for k,v in pairs(player.GetAll()) do
		if v:IsAdmin() and not v:IsSuperAdmin() then
			Admins = ", " .. v:Nick() .. Admins
			a = a + 1
		elseif v:IsSuperAdmin() then
			Superadmins = ", " .. v:Nick() .. Superadmins
			a = a + 1
		end

		if ASS_Initialized ~= nil and LevelToString ~= nil and LevelToString(v:GetNWInt("ASS_isAdmin")) ~= "Guest" then -- Check if ASS is active on the server
			ASSUsers = ", " .. v:Nick() .." = " .. LevelToString(v:GetNWInt("ASS_isAdmin"))  .. ASSUsers
		end

		local usergroup = string.lower(v:GetNetworkedString( "UserGroup" ))
		if usergroup ~= "user" and usergroup ~= "" and usergroup ~= "undefined" and not string.find(ASSUsers, v:Nick()) then
			ASSUsers = ASSUsers ..", " .. v:Nick() .." = " .. usergroup
		end
	end
	if Admins ~= "" then
		say("Admins: " .. string.sub(Admins, 3))
	end
	if Superadmins ~= "" then
		timer.Simple(1.7, function() say("SuperAdmins: " .. string.sub(Superadmins, 3)) end)
	end
	if ASSUsers ~= "" then
		timer.Simple(1.8, function() say("ASS+ULX: " .. string.sub(ASSUsers, 3)) end)
	end
	if Admins == "" and Superadmins == "" then
		say( "Falco's scripts: There are no admins on this server")
	end
end
concommand.Add("falco_sayAllAdmins", TellAllAdmins)
falco_addchatcmd("falco_sayalladmins", TellAllAdmins)
concommand.Add("falco_printadmins", TellAllAdmins)
falco_addchatcmd("falco_printadmins", TellAllAdmins)