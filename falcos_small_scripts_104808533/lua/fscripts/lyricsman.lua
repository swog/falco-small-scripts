/*---------------------------------------------------------------------------
Spam chat with silly lyrics
---------------------------------------------------------------------------*/

local lyrics
local progress = 0
local function lyricsman()
	local frame = vgui.Create("DFrame")
	frame:SetSize( 500, 500 )
	frame:Center()
	frame:SetVisible(true)
	frame:MakePopup()
	frame:SetTitle("Set Lyrics")
	function frame:Close()
		lyrics = nil
		progress = 0
		self:Remove()
	end

	local text = vgui.Create("DTextEntry", frame)
	text:SetSize(460, 370)
	text:SetPos(20, 120)
	text:SetMultiline(true)

	local PlayButton = vgui.Create("DButton", frame)
	PlayButton:SetPos(20,40)
	PlayButton:SetSize(460, 70)
	PlayButton:SetText("Play next line")
	PlayButton.DoClick = function()
		if not lyrics then
			lyrics = string.Explode("\n",text:GetValue())
			progress = 0
		end
		progress = progress + 1
		if not lyrics[progress] then return end
		print("'"..lyrics[progress].."'")
		if not lyrics[progress] or lyrics[progress] == "" then
			progress = progress + 1
		end
		if lyrics[progress] then
			Falco_DelayedSay(lyrics[progress])
		end
	end
end
concommand.Add("falco_lyrics", lyricsman)
-- << See what I did there?