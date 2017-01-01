-- hotkey script by FPtje

sql.Query("CREATE TABLE IF NOT EXISTS MultiKeyBinds('firstkey' INTEGER NOT NULL, 'secondkey' TEXT NOT NULL, 'commandname' TEXT NOT NULL, PRIMARY KEY('firstkey', 'secondkey'));")

local FirstButtons = {ctrl = KEY_LCONTROL, alt = KEY_LALT, shift = KEY_LSHIFT, space = KEY_SPACE}
local Binds = {}

local SQLBinds = sql.Query("SELECT * FROM MultiKeyBinds;")
if SQLBinds then
	for k,v in pairs(SQLBinds) do
		Binds[k] = {}
		Binds[k].firstkey = tonumber(v.firstkey)
		Binds[k].secondkey = string.lower(v.secondkey)
		Binds[k].commandname = v.commandname
	end
end

local AddGUI

local function Add(ply, cmd, args)
	if not args[1] then AddGUI() return end
	if not args[3] then print("Not enough arguments") return "Not enough arguments" end
	if not FirstButtons[string.lower(args[1])] then print("First key has to be shift, ctrl, alt or space") return "First key has to be shift, ctrl, alt or space" end

	local bind = {firstkey = FirstButtons[string.lower(args[1])], secondkey = string.lower(args[2]), commandname = args[3]}
	for k,v in pairs(Binds) do
		if v.firstkey == bind.firstkey and v.secondkey == bind.secondkey then
			Binds[k].commandname = bind.commandname

			sql.Query("UPDATE MultiKeyBinds SET commandname = "..sql.SQLStr(bind.commandname).." WHERE firstkey = "..bind.firstkey .." AND secondkey = "..sql.SQLStr(bind.secondkey)..";")
			print("Keybind updated!")
			return "Keybind updated!"
		end
	end
	table.insert(Binds, bind)

	sql.Query("INSERT INTO MultiKeyBinds VALUES(".. bind.firstkey ..", "..sql.SQLStr(bind.secondkey)..", "..sql.SQLStr(bind.commandname)..");")
	print("Keybind made!")
	return "Keybind made!"
end
concommand.Add("falco_hotkey", Add, function() return "falco_hotkey <Ctrl/alt/shift/space> \"<bind other key>\" \"<command>\"" end)

AddGUI = function()
	local firstkey, secondkey, commandname

	local function _3()
		Derma_StringRequest("Command name",
		[[ What will be the command that will be executed when you press the hotkey?
		NOTE: Some commands are blocked! Examples of blocked commands: quit, ent_*,
		lua_run_cl etc.]], "",
		function(text) commandname = text

			local text = Add(LocalPlayer(), "fuck you", {firstkey, secondkey, commandname})
			chat.AddText(Color(0, 255, 0, 255), text)
		end)
	end

	local function _2()
		hook.Add("HUDPaint", "TEMPHotKey", function()
			draw.DrawText([[Press the second key for the hotkey
			Note: The key must already be bound to something!
			If it's not it won't work!

			Well who would use a hotkey with an unbound key anyway]], "HUDNumber5", ScrW()/2, ScrH()/2, Color(0,0,255,255), TEXT_ALIGN_CENTER)
		end)

		hook.Add("PlayerBindPress", "TEMPHotKey", function(ply, bind, pressed)
			hook.Remove("HUDPaint", "TEMPHotKey")
			hook.Remove("PlayerBindPress", "TEMPHotKey")
			secondkey = input.LookupBinding(bind)
			_3()
			return true
		end)
	end

	Derma_Query([[What will be the first key for the hotkey?]], "First key",
		"ctrl", function() firstkey = "ctrl" _2() end,
		"alt", function() firstkey = "alt" _2() end,
		"shift", function() firstkey = "shift" _2() end,
		"space", function() firstkey = "space" _2() end)

end

local RemoveGUI
local function Remove(ply, cmd, args)
	if not args[1] then RemoveGUI() return end
	if not args[2] then print("Not enough arguments") return "Not enough arguments" end
	if not FirstButtons[string.lower(args[1])] then print("First key has to be shift, ctrl, alt or space") return "First key has to be shift, ctrl, alt or space" end

	for k,v in pairs(Binds) do
		if v.firstkey == FirstButtons[string.lower(args[1])] and v.secondkey == string.lower(args[2]) then
			sql.Query("DELETE FROM MultiKeyBinds WHERE firstkey = "..v.firstkey.." AND secondkey = "..sql.SQLStr(v.secondkey)..";")
			table.remove(Binds, k)
			print("Keybind removed!")
			return "Keybind Removed!"
		end
	end
	print("Keybind not found!")
	return "Keybind not found!"
end
concommand.Add("falco_Unhotkey", Remove, function() return "falco_Unhotkey <ctrl/alt/shift/space> \"bind other key\"" end)
concommand.Add("falco_hotkeyListgui", Remove, function() return "falco_Unhotkey <ctrl/alt/shift/space> \"bind other key\"" end)

RemoveGUI = function()
	local frame = vgui.Create("DFrame")
	frame:SetTitle( "Remove hotkeys" )
	frame:SetSize( 480, 200 )
	frame:Center()
	frame:SetVisible( true )
	frame:MakePopup( )

	local HotKeyList = vgui.Create("DListView", frame)
	HotKeyList:SetSize(470, 170)
	HotKeyList:SetPos(5, 25)
	HotKeyList:AddColumn("First key")
	HotKeyList:AddColumn("Second key")
	HotKeyList:AddColumn("command")
	HotKeyList:SetMultiSelect(false)

	local NumToKey = {[KEY_LCONTROL] = "ctrl", [KEY_LALT] = "alt", [KEY_LSHIFT] = "shift", [KEY_SPACE] = "space"}

	for k,v in pairs(Binds) do
		HotKeyList:AddLine(NumToKey[v.firstkey], v.secondkey, v.commandname)
	end

	function HotKeyList:OnClickLine(line)
		line:SetSelected(true)
		local text = Remove(LocalPlayer(), "get out", {line:GetValue(1), line:GetValue(2)})
		chat.AddText(Color(0, 255, 0, 255), text)

		HotKeyList:RemoveLine(HotKeyList:GetSelectedLine())
	end
end

concommand.Add("falco_hotkeyList", function() PrintTable(Binds) end)

hook.Add("PlayerBindPress", "falco_hotkey", function(ply, bind, pressed)
	for k,v in pairs(Binds) do
		if input.IsKeyDown(v.firstkey) and (string.lower(bind) == string.lower(v.secondkey) or string.lower(input.LookupBinding(bind) or "") == string.lower(v.secondkey)) and pressed then
			RunConsoleCommand(unpack(string.Explode(" ", v.commandname))) -- Using RunConsoleCommand instead of LocalPlayer():ConCommand to prevent unnecessary blocking
			return true
		end
	end
end)
