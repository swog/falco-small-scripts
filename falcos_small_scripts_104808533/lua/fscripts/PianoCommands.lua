util.PrecacheSound("falco/piano.wav")
util.PrecacheSound("falco/pianohigh.wav")

local recording = false
local recordtime = CurTime()
local RecordKeys = {}
local function DoSounds(ply,cmd,args)
	local sound = args[1]
	local pitch = tonumber(args[2]) or 100
	local vol = tonumber(args[3]) or falcoPianovolume:GetInt()
	LocalPlayer():EmitSound(sound,vol,pitch)
	
	-- RECORD PART
	if recording then
		if #RecordKeys == 0 then recordtime = CurTime() end
		local time =  tonumber(string.sub(tostring(CurTime() - recordtime), 1, 5))
		if string.find(sound, "high") then
			table.insert(RecordKeys, {time, pitch, true})
		else
			table.insert(RecordKeys, {time, pitch, false})
		end
	end
end
concommand.Add("falcoCLplay",DoSounds) 

------------------------------
--ENCODING PART
------------------------------

local LowSound = "falco/piano.wav"
local HighSound = "falco/pianohigh.wav"
local function FalcoSendRecord()
	Falco_DelayedSay("_falco_startpianomessage|"..LowSound.."|"..HighSound)
	local message = ""
	local amountoftimessaid = 0
	for k,v in pairs(RecordKeys) do
		local ishigh = {}
		ishigh[true] = 1
		ishigh[false] = 0
		if message == "" then
			message = tostring(v[1])..","..tostring(v[2])..","..ishigh[v[3]]
		else
			local nomoreadd = false
			if string.len(message) > 110 then
				amountoftimessaid = amountoftimessaid + 1
				local rep = message
				timer.Simple(amountoftimessaid * FALCO_CHATTIME, function() Falco_DelayedSay(rep) LocalPlayer():ChatPrint("UPLOADING PARTS: " .. tostring(math.floor((k/#RecordKeys)*100)) .. "%") end)
				message = tostring(v[1])..","..tostring(v[2])..","..ishigh[v[3]]
				nomoreadd = true
			end				
			if not nomoreadd then
				message = message .. "|" ..tostring(v[1])..","..tostring(v[2])..","..ishigh[v[3]]
			end
		end	
	end
	amountoftimessaid = amountoftimessaid + 2
	local rep = message
	timer.Simple(amountoftimessaid * FALCO_CHATTIME, function() LocalPlayer():ChatPrint("UPLOADING DONE") Falco_DelayedSay(rep) end)
	amountoftimessaid = amountoftimessaid + 2
	message = ""
	timer.Simple(amountoftimessaid * FALCO_CHATTIME, function() Falco_DelayedSay("_falco_stoppianomessage") end)
end

local function FalcoRecord(ply, cmd, args)
	recording = not recording
	LowSound = args[1] or LowSound
	HighSound = args[2] or HighSound

	if recording then
		RecordKeys = {} --Reset the recorded shit so it doesn't continue the last record
	else
		FalcoSendRecord() -- I'm done recording! send it to everyone else!
	end
end
concommand.Add("frecordpiano", FalcoRecord)

-------------------------
--DECODER PART--
------------------------

local decoding = false
local encoder 
local decodedmessage = {}
local DecodePlaySounds = {}

local function falco_DecodeAll()
	for k,v in pairs(decodedmessage) do
		for a,b in pairs(v) do
			local play = string.Explode(",", b)
			if tonumber(play[3]) ~= 1 then
				if not play[1] or not DecodePlaySounds[2] or not tonumber(play[2]) then return end
				timer.Simple(play[1] + 3, function() LocalPlayer():EmitSound(DecodePlaySounds[2], 100, tonumber(play[2])) end)
			else
				timer.Simple(play[1] + 5, function() LocalPlayer():EmitSound(DecodePlaySounds[3], 100, tonumber(play[2])) end)
			end
		end
	end
	LocalPlayer():ChatPrint("PIANO MESSAGE DECODED! PLAYING IN: 3")
	for i = 1,3,1 do
		timer.Simple(i, function() LocalPlayer():ChatPrint(tostring(3 - i)) end)
	end
end

local ignore = {}
local function GetPianoPlayer(ply, oldtext, teamonly, dead)--id, name, oldtext)
	if ply:EntIndex() == 0 then return end
	local text = oldtext
	if ignore.id and ignore.id ~= "" then
		text = string.sub(oldtext, string.len(ignore.id) + 1)
	end
	
	if string.find(oldtext, "_falco_startpianomessage") then 
		ignore.id = string.sub(oldtext, 1, string.find(oldtext, "_falco_startpianomessage") - 1)
		text = string.sub(oldtext, string.len(ignore.id) + 1)
		LocalPlayer():ChatPrint("RECIEVING A PIANO MESSAGE! DECODING!!!")
		DecodePlaySounds = string.Explode("|", text)
		decoding = true 
		encoder = ply
		decodedmessage = {} 
		return 
	end

	--  When someone stops playing
	if text == "_falco_stoppianomessage" then 
		decoding = false 
		falco_DecodeAll() 
	end
	if decoding and ply == encoder then
		table.insert(decodedmessage, string.Explode("|", text))
	end
end
hook.Add("OnPlayerChat", "FalcoPianoDecoder", GetPianoPlayer)