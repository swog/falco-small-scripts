
function DoSound(ply,cmd,args)
	local sound = args[1]
	local pitch = tonumber(args[2])
	local volume = args[3]
	for k,v in pairs(player.GetAll()) do
		if v != ply and not v:GetNWBool("mutepiano") then
			v:ConCommand("falcoCLplay " .. tostring(sound) .. " " .. tostring(pitch) .. " " .. tostring(volume))
		end
	end
end
concommand.Add("falcoSSplay",DoSound)

function MutePiano(ply, cmd, args)
	if not args then
		ply:ChatPrint("You set muting the piano to ".. tostring(not ply:GetNWBool("mutepiano")))
		ply:SetNWBool("mutepiano", not ply:GetNWBool("mutepiano") )
	elseif args[1] == "true" then
		ply:ChatPrint("You set muting the piano to true")
		ply:SetNWBool("mutepiano", true )
	elseif args[1] == "false" then
		ply:ChatPrint("You set muting the piano to false")
		ply:SetNWBool("mutepiano", false )
	end
end
concommand.Add("MutePiano", MutePiano)


function ServerHasPiano(ply)
	timer.Simple(10, function()
		if not IsValid(ply) then return end
		ply:SetNWBool("mutepiano", false)
		umsg.Start("ServerHasPiano", ply)
		umsg.End()
	end)
end
hook.Add( "PlayerInitialSpawn", "SendThatThePianoIsThere", ServerHasPiano)
umsg.Start("ServerHasPiano")
umsg.End()