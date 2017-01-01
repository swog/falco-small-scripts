local Geluid = "Falco/piano.wav"
local GeluidHigh = "falco/pianohigh.wav"
falcoPianovolume = CreateClientConVar("PianoVolume", 100, true, false)
local wait = {}
local ServerHasPiano = false
local PlayClientSide = true
local pianomuted = false
function GetServerHasPiano()
	ServerHasPiano = true
	PlayClientSide = false
end
usermessage.Hook("ServerHasPiano", GetServerHasPiano)

function PianoVGUI( )
	local FalcoFrame = vgui.Create( "DFrame" )
	local PianoPic1 = vgui.Create( "DImage", FalcoFrame)
	local VolumeSlider = vgui.Create( "DNumSlider", FalcoFrame)
	local GeluidLabel = vgui.Create("DLabel", FalcoFrame)
	local AnderGeluid = vgui.Create("DMultiChoice", FalcoFrame)
	local CustomGeluid = vgui.Create("DTextEntry", FalcoFrame)
	local CustomGeluidLabel = vgui.Create("DLabel", FalcoFrame)
	local OpenSettings = vgui.Create("Button", FalcoFrame)
	local Record = vgui.Create("DButton", FalcoFrame)
	 
	function AnderGeluidFunctie(ply,cmd,args)
		Geluid = args[1]
	end
	concommand.Add("PianoSound", AnderGeluidFunctie)
		
	OpenSettings:SetSize(80,20)
	OpenSettings:SetText( "Open Settings" )
	OpenSettings:SetPos(530,575)
	function OpenSettings:DoClick()
		RunConsoleCommand("StartPianoSettings")
		FalcoFrame:SetVisible( false ) 
	end
	
	AnderGeluid:AddChoice("Piano")
	AnderGeluid:AddChoice("Piano2")
	AnderGeluid:AddChoice("High piano")
	AnderGeluid:AddChoice("Stcse piano")
	AnderGeluid:AddChoice("Hl1 boop")
	AnderGeluid:AddChoice("Hl1 bell")
	AnderGeluid:SetEditable( false )
	AnderGeluid:SetPos(220,575)
	function AnderGeluid:OnSelect(Index,Value,Data)
		if Value == "Piano" then
			Geluid = "Falco/piano.wav"
			GeluidHigh = "Falco/pianoHigh.wav"
		elseif Value == "Piano2" then
			Geluid = "falco/piano2.wav"
			GeluidHigh = "falco/Piano2high.wav"
		elseif Value == "High piano" then
			Geluid = "Falco/pianoHigh.wav"
		elseif Value == "Stcse piano" then
			Geluid = "Falco/Stcse.wav"
		elseif Value == "Hl1 boop" then
			Geluid = "hl1/fvox/boop.wav"
		elseif Value == "Hl1 bell" then
			Geluid = "hl1/fvox/bell.wav"
		end
	end 
	

	CustomGeluid:SetPos(320,575)
	CustomGeluid:SetSize(200,20)
	CustomGeluid:SetConVar("PianoSound")
	CustomGeluid:SetUpdateOnType( true )
	
	GeluidLabel:SetPos(170,575)
	GeluidLabel:SetText("Sound:")
	
	CustomGeluidLabel:SetPos(340,580)
	CustomGeluidLabel:SetText( "Enter a custom sound here" )
	CustomGeluidLabel:SizeToContents()
	CustomGeluidLabel:SetTextColorHovered( 0,0,0,0)

	VolumeSlider:SetPos(20,560)
	VolumeSlider:SetValue(falcoPianovolume:GetInt())
	VolumeSlider:SetWidth(145)
	VolumeSlider:SetMin(1)
	VolumeSlider:SetMax(100)
	VolumeSlider:SetText("Volume:")
	VolumeSlider:SetZPos(500)
	VolumeSlider:SetDecimals(0)
	function VolumeSlider:OnValueChanged( val ) 
		RunConsoleCommand("PianoVolume", val) 
	end
	
	FalcoFrame:SetTitle( "FPtje's piano" )
	FalcoFrame:SetSize( 640, 600 ); 
	FalcoFrame:Center()
	FalcoFrame:SetVisible( true ); 
	FalcoFrame:MakePopup( );
	

	PianoPic1:SetImage( "VGUI/entities/PianoPic" )
	PianoPic1:SetSize( 640, 150 )
	PianoPic1:SetPos( 0, 20)
	PianoPic1:SetZPos( 400 )
	
	if ServerHasPiano then
		local ClientSideCheckBox = vgui.Create("DCheckBoxLabel", FalcoFrame)
		ClientSideCheckBox:SetPos(20, 540)
		ClientSideCheckBox:SetValue(PlayClientSide)
		ClientSideCheckBox:SetText("Only you can hear it")
		ClientSideCheckBox:SizeToContents()
		function ClientSideCheckBox:OnChange()
			PlayClientSide = self:GetChecked()
		end
		
		local MuteBox = vgui.Create("DCheckBoxLabel", FalcoFrame)
		MuteBox:SetPos(150, 540)
		MuteBox:SetText("Mute all other pianos")
		MuteBox:SizeToContents()
		MuteBox:SetValue(pianomuted)
		function MuteBox:OnChange()
			pianomuted = self:GetChecked()
			RunConsoleCommand("MutePiano", tostring(self:GetChecked()))
		end
	else
		local ClientSideCheckBox = vgui.Create("DLabel", FalcoFrame)
		ClientSideCheckBox:SetPos(20, 540)
		ClientSideCheckBox:SetText("Only you can hear the piano")
		ClientSideCheckBox:SizeToContents()
	end
	
	Record:SetSize(120,20)
	Record:SetText( "Record START" )
	Record:SetPos(490,545)
	local recording = false
	function Record:DoClick()
		RunConsoleCommand("frecordpiano", Geluid, GeluidHigh)
		recording = not recording
		if recording then
			Record:SetText( "Record STOP" )
		else
			Record:SetText( "Record START" )
		end
	end
	
	local AllWhiteButtons = {}
	local Whitekeys = { -12, -10, -8, -7, -5, -3, -1, 0, 2, 4, 5, 7, 9, 11, 12, 14, 16}
   
	for i = 1, 17, 1 do
		AllWhiteButtons[i] = vgui.Create( "DImageButton", FalcoFrame )
		AllWhiteButtons[i]:SetImage( "VGUI/entities/whitekey" )
		AllWhiteButtons[i]:SetSize( 35, 350 )
		AllWhiteButtons[i]:SetPos( -15 + (i*35),180 )
		local rep = AllWhiteButtons[i] 
		function rep:OnMousePressed( ) 
			RunConsoleCommand("falcoCLplay", Geluid, tostring(100 * math.pow(2, Whitekeys[i] / 12)), falcoPianovolume:GetInt() )
			if not PlayClientSide then
				RunConsoleCommand("falcoSSplay", Geluid, tostring(100 * math.pow(2, Whitekeys[i] / 12)), falcoPianovolume:GetInt() )
			end
		end
	end
	
	local AllBlackButtons = {}
	local Blackkeys = {[2] = -11, [3] = -9,[5] = -6,[6] = -4,[7] = -2,[9] = 1,[10] = 3,[12] = 6,[13] = 8, [14] =10,[16] = 13,[17] = 15}
	for k,v in pairs(Blackkeys) do
		AllBlackButtons[k] = vgui.Create( "DImageButton", FalcoFrame )
		AllBlackButtons[k]:SetImage( "VGUI/entities/blackkey" )
		AllBlackButtons[k]:SetSize( 35, 190 )
		AllBlackButtons[k]:SetPos( -32 + (k*35),180 )
		local rep = AllBlackButtons[k] 
		function rep:OnMousePressed( ) 
			RunConsoleCommand("falcoCLplay", Geluid, tostring(100 * math.pow(2, Blackkeys[k] / 12)), falcoPianovolume:GetInt() )
			if not PlayClientSide then
				RunConsoleCommand("falcoSSplay", Geluid, tostring(100 * math.pow(2, Blackkeys[k] / 12)), falcoPianovolume:GetInt() )
			end
		end
	end
	-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	local Settings = {}
	if file.Exists("Piano/config.txt") then
		Settings = util.KeyValuesToTable(file.Read("Piano/config.txt"))
	end
	if #Settings < 2 then
		Settings["1"] = {"F1", 25, "0", "C0"} -- C0
		Settings["2"] = {"F2", 26.4865, "0", "CIS0"}
		Settings["3"] = {"F3", 28.0615, "0", "D0"}
		Settings["4"] = {"F4", 29.7301, "0", "ES0"}
		Settings["5"] = {"F5", 31.4980, "0", "E0"}
		Settings["6"] = {"F6", 33.3709, "0", "F0"}
		Settings["7"] = {"F7", 35.3553, "0", "FIS0"}
		Settings["8"] = {"F8", 37.4576, "0", "G0"}
		Settings["9"] = {"F9", 39.6850, "0", "GIS0"}
		Settings["10"] = {"F10", 42.0448, "0", "A0"}
		Settings["11"] = {"F11", 44.5449, "0", "BES0"}
		Settings["12"] = {"F12", 47.1937, "0", "B0"}
		Settings["13"] = {"q", 50, "0", "C1"} -- C1
		Settings["14"] = {"2", 53, "0", "CIS1"}
		Settings["15"] = {"w", 56.1, "0", "D1"}
		Settings["16"] = {"3", 59.5, "0", "ES1"}
		Settings["17"] = {"e", 63, "0", "E1"}
		Settings["18"] = {"r", 66.7, "0", "F1"}
		Settings["19"] = {"5", 70.7, "0", "FIS1"}
		Settings["20"] = {"t", 74.9, "0", "G1"}
		Settings["21"] = {"6", 79.4, "0", "GIS1"}
		Settings["22"] = {"y", 84.1, "0", "A1"}
		Settings["23"] = {"7", 89.1, "0", "BES1"}
		Settings["24"] = {"u", 94.4, "0", "B1"}
		Settings["25"] = {"i", 100, "0", "C2"} -- C2
		Settings["26"] = {"9", 105.9, "0", "CIS2"}
		Settings["27"] = {"o", 112.2, "0", "D2"}
		Settings["28"] = {"0", 118.9, "0", "ES2"}
		Settings["29"] = {"p", 126, "0", "E2"}
		Settings["30"] = {"[", 133.5, "0", "F2"}
		Settings["31"] = {"=", 141.4, "0", "FIS2"}
		Settings["32"] = {"]", 149.8, "0", "G2"}
		Settings["33"] = {"a", 158.7, "0", "GIS2"}
		Settings["34"] = {"z", 168.2, "0", "A2"}
		Settings["35"] = {"s", 178.2, "0", "BES2"}
		Settings["36"] = {"x", 188.8, "0", "B2"}
		Settings["37"] = {"c", 200, "0", "C3"} -- C3
		Settings["38"] = {"f", 211.9, "0", "CIS3"}
		Settings["39"] = {"v", 224.5, "0", "D3"}
		Settings["40"] = {"g", 237.8, "0", "ES3"}
		Settings["41"] = {"b", 252, "0", "E3"}
		Settings["42"] = {"n", 66.7, "1", "F3"}
		Settings["43"] = {"j", 70.7, "1", "FIS3"}
		Settings["44"] = {"m", 74.9, "1", "G3"}
		Settings["45"] = {"k", 79.4, "1", "GIS3"}
		Settings["46"] = {",", 84.1, "1", "A3"}
		Settings["47"] = {"l", 89.1, "1", "BES3"}
		Settings["48"] = {".", 94.4, "1", "B3"}
		Settings["49"] = {"/", 100, "1", "C4"} -- C4
		Settings["50"] = {"'", 105.9, "1", "CIS4"}
		
		Settings["51"] = {"del", 112.2, "1", "D4"}
		Settings["52"] = {"insert", 118.9, "1", "ES4"}
		Settings["53"] = {"end", 126, "1", "E4"}
		Settings["54"] = {"pgdn", 133.5, "1", "F4"}
		Settings["55"] = {"pgup", 141.4, "1", "FIS4"}
		Settings["56"] = {"kp_1", 149.8, "1", "G4"}
		Settings["57"] = {"kp_4", 158.7, "1", "GIS4"}
		Settings["58"] = {"kp_2", 168.2, "1", "A4"} --188.8
		Settings["59"] = {"kp_5", 178.2, "1", "BES4"}
		Settings["60"] = {"kp_3", 188.8, "1", "B4"}
		Settings["61"] = {"kp_7", 200, "1", "C5"} --C5
		Settings["62"] = {"kp_/", 211.9, "1", "CIS5"}
		Settings["63"] = {"kp_8", 224.5, "1", "D5"}
		Settings["64"] = {"kp_*", 237.8, "1", "ES5"}
		Settings["65"] = {"kp_9", 252, "1", "E5"}
		for k,v in pairs(Settings) do
			local rep = {}
			for a,b in pairs(v) do
				rep[tostring(a)] = b
			end
			Settings[k] = rep
		end
		file.Write("Piano/config.txt", util.TableToKeyValues(Settings))
	end
	
	
	for k,v in pairs(Settings) do
		if type(v["1"]) == "number" then
			local a = v["1"]
			v["1"] = tostring(a)
		end
	end 
	
	for i=1, 38, 1 do
		wait[i] = false
	end
	
	function FalcoFrame:Think()
		if CustomGeluid:HasFocus() or not ToKey then return end
		for k,v in pairs(Settings) do
			if not string.find(v["1"], "mouse") then -- 4
				if input.IsKeyDown(ToKey(v["1"])) and (v["3"] == 0 or v["3"] == "0") and not wait[k] then
					wait[k] = true
					RunConsoleCommand( "falcoCLplay", Geluid, v["2"], falcoPianovolume:GetInt())
					if not PlayClientSide then
						RunConsoleCommand( "falcoSSplay", Geluid, v["2"], falcoPianovolume:GetInt())
					end
				elseif input.IsKeyDown(ToKey(v["1"])) and not wait[k] then
					wait[k] = true
					RunConsoleCommand( "falcoCLplay", GeluidHigh, v["2"], falcoPianovolume:GetInt())
					if not PlayClientSide then
						RunConsoleCommand( "falcoSSplay", GeluidHigh, v["2"], falcoPianovolume:GetInt())
					end
				elseif not input.IsKeyDown(ToKey(v["1"])) and wait[k] then
					wait[k] = false
				end
			else -- for people who want to play piano with their mouse...
				local sub = string.sub(ToKey(v["1"]), 6)
				if input.IsMouseDown(sub) and (v["3"] == 0 or v["3"] == "0") and not wait[k] then
					wait[k] = true
					RunConsoleCommand( "falcoCLplay", Geluid, v["2"], falcoPianovolume:GetInt())
					if not PlayClientSide then
						RunConsoleCommand( "falcoSSplay", Geluid, v["2"], falcoPianovolume:GetInt())
					end
				elseif input.IsMouseDown(sub) and not wait[k] then
					wait[k] = true
					RunConsoleCommand( "falcoCLplay", GeluidHigh, v["2"], falcoPianovolume:GetInt())
					if not PlayClientSide then
						RunConsoleCommand( "falcoSSplay", GeluidHigh, v["2"], falcoPianovolume:GetInt())
					end
				elseif not input.IsMouseDown(sub) and wait[k] then
					wait[k] = false
				end
			end
		end
		if (not self.Dragging) then return end 
		local x = gui.MouseX() - self.Dragging[1] 
		local y = gui.MouseY() - self.Dragging[2] 
		if ( self:GetScreenLock() ) then 
			x = math.Clamp( x, 0, ScrW() - self:GetWide() ) 
			y = math.Clamp( y, 0, ScrH() - self:GetTall() ) 
		end 
		self:SetPos( x, y ) 
	end
end
concommand.Add( "falco_piano", PianoVGUI );  


function StartPianoSettings()
	
	local Settings = util.KeyValuesToTable(file.Read("Piano/config.txt"))
	
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "Piano config" )
	frame:SetSize( 270, 630 ) 
	frame:Center()
	frame:SetVisible( true )
	frame:MakePopup( )
	function frame:Close()
		frame:SetVisible(false)
		PianoVGUI( )
	end
	
	local Panel = vgui.Create( "DPanelList", frame )
	Panel:SetPos(20,30)
	Panel:SetSize(230, 580)
	Panel:SetSpacing(5)
	Panel:EnableHorizontal( true )
	Panel:EnableVerticalScrollbar( true )
	
	local TextBoxes = {}
	local Labels = {}
	local Valid = {}
	for k = 1, table.Count(Settings), 1 do-- YES I AM FUCKING UNABLE TO DO A FUCKING FUCK PAIRS LOOP FUCKING FUCK BECAUSE THE FUCKING FUCK PAIRS DOESN"T FUCKING FUCK IN THE RIGHT FUCKING ORDER FUCKING FUCK!
		if Settings[tostring(k)] == nil then break end
		local v = Settings[tostring(k)]
		Labels[k] = vgui.Create("DLabel", frame)
		Labels[k]:SetText(tostring(v["4"]) .. " key:")
		Panel:AddItem(Labels[k])
		
		TextBoxes[k] = vgui.Create("DTextEntry", frame)
		TextBoxes[k]:SetText(tostring(v["1"]))
		local replacement = TextBoxes[k]
		
		Valid[k] = vgui.Create("DLabel", frame) --create already cos the textbox is gonna need it
		
		function replacement:OnEnter()
			local text = TextBoxes[k]:GetValue()
			local b= v["2"]
			local c = v["3"]
			local d = v["4"]
			if ToKey(text) == "INVALID KEY" then
				Valid[k]:SetText("INVALID")
			else
				Valid[k]:SetText("valid")
			end
			Settings[tostring(k)] = {tostring(text), b, c, d}
			
			file.Delete( "Piano/config.txt" )
			file.Write("Piano/config.txt", util.TableToKeyValues(Settings))
		end
		function replacement:OnLoseFocus()
			self:OnEnter()
		end
		Panel:AddItem(TextBoxes[k])
		
		if ToKey(TextBoxes[k]:GetValue()) == "INVALID KEY" then
			Valid[k]:SetText("INVALID")
		else
			Valid[k]:SetText("valid")
		end
		Panel:AddItem(Valid[k])
	end
end
concommand.Add("StartPianoSettings", StartPianoSettings)

falco_addchatcmd("!piano", function() RunConsoleCommand("falco_piano") end)