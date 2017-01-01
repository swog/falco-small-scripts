/*---------------------------------------------------------------------------
Spam flashlight and use
---------------------------------------------------------------------------*/
local function FastUndo()
	hook.Add("Think", "fastundo", function()
		RunConsoleCommand("impulse", "100")
	end)
end
concommand.Add("+falco_makesound", FastUndo)

local function UndoFastUndo()
	hook.Remove( "Think", "fastundo")
	timer.Simple(0.5, function()
		if LocalPlayer():FlashlightIsOn( ) then
			RunConsoleCommand("impulse", "100")
		end
	end)
end
concommand.Add("-falco_makesound", UndoFastUndo)

local bool = false
local function fastsound()
	bool = not bool
	if bool then
		hook.Add("Think", "fastsound", function()
			RunConsoleCommand("impulse", "100")
		end)
	else
		hook.Remove( "Think", "fastsound")
		timer.Simple(0.5, function()
			if LocalPlayer():FlashlightIsOn( ) then
				RunConsoleCommand("impulse", "100")
			end
		end)
	end
end
concommand.Add("falco_makesound", fastsound)

local enableRotate2 = false
local LookAngle
local function fastsound2()
	enableRotate2 = not enableRotate2
	if enableRotate2 then
		LookAngle = EyeAngles()
		hook.Add("CreateMove", "RotateWeird", function(umc)
			LookAngle = Angle(LookAngle.p + 3, LookAngle.y + umc:GetMouseX()/30, LookAngle.r)
			RunConsoleCommand("impulse", "100")
			umc:SetViewAngles(LookAngle)
		end)
	else
		hook.Remove("CreateMove", "RotateWeird")
		timer.Simple(0.5, function()
			if LocalPlayer():FlashlightIsOn( ) then
				RunConsoleCommand("impulse", "100")
			end
		end)
	end
end
concommand.Add("falco_makesound2", fastsound2)

local usespam = false
concommand.Add("falco_usespam", function()
	if usespam then
		hook.Remove("Think", "UseSpam")
		timer.Simple(0.5, function()
			RunConsoleCommand("-use")
		end)
	else
		local spam = false
		hook.Add("Think", "UseSpam", function()
			if not spam then
				RunConsoleCommand("+use")
			else
				RunConsoleCommand("-use")
			end
			spam = not spam
		end)
	end
	usespam = not usespam
end)
