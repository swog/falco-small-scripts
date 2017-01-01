/*---------------------------------------------------------------------------
Logs Steam ID's and RP names.
Really useful when someone disconnected right when you wanted to ban them
---------------------------------------------------------------------------*/

sql.Query("CREATE TABLE IF NOT EXISTS FALCO_STEAMS(SteamID TEXT PRIMARY KEY, SteamName TEXT, RPName TEXT);")

local function CollectSteam(ply, SID)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	local name = (ply.SteamName and ply:SteamName()) or ply:Nick()
	local rpName = ply:Nick()
	local steam = SID or ply:SteamID()

	if steam == "" then return end
	sql.Query("REPLACE INTO FALCO_STEAMS VALUES(".. sql.SQLStr(steam) ..", "..sql.SQLStr(name)..", "..sql.SQLStr(rpName)..");")
end
timer.Create("GetSteams", 20, 0, function()
	for k,v in pairs(player.GetAll()) do
		if v ~= LocalPlayer() then CollectSteam(v) end
	end
end)

local function ShowPlayerLog()
	local frame = vgui.Create("DFrame")
	frame:SetTitle("Show IPs")
	frame:SetSize(400, 680)
	frame:Center()
	frame:SetVisible(true)
	frame:MakePopup()

	local List = vgui.Create("DListView", frame)
	List:AddColumn("SteamID")
	List:AddColumn("Steam name")
	List:AddColumn("RPName")
	List:StretchToParent(0, 25, 0, 0)

	local Data = sql.Query("SELECT * FROM FALCO_STEAMS")
	for k,v in pairs(Data) do
		List:AddLine(v.SteamID, v.SteamName or "", v.RPName or "")
	end
end
concommand.Add("falco_showplayerlog", ShowPlayerLog)

concommand.Add("falco_FindSteam", function(ply, cmd, args)
	if not args[1] then return end
	local result = sql.Query("SELECT * FROM FALCO_STEAMS;")
	for k,v in pairs(result or {}) do
		v.SteamName = string.lower(v.SteamName)
		v.RPName = string.lower(v.RPName)
		if string.find(v.SteamName, string.lower(args[1])) or string.find(v.SteamID, string.lower(args[1])) or string.find(v.RPName, string.lower(args[1])) then
			MsgN('')
			MsgN("Player found:")
			PrintTable(v)
		end
	end
end)