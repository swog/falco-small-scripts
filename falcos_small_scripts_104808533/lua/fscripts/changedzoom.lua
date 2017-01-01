/*---------------------------------------------------------------------------
Old zooming script that allows you to zoom in and out.
---------------------------------------------------------------------------*/

local FalcoZoom = false
local ZoomHowMuch = 1
local ZoomStep = 5
local Extrazoom = 0
local OldSensitivity = GetConVarString("sensitivity")

local function ZoomCalcThing(ply, origin, angles, fov)
	if FalcoZoom then
		local view = {}
		view.origin = ply:GetShootPos() - LocalPlayer():GetAimVector():Angle():Forward() * - Extrazoom
		view.angles = LocalPlayer():EyeAngles()
		view.fov = ZoomHowMuch

		return view
	end
end

local function ChangeSensitivity()
	if Extrazoom > 99 and Extrazoom < 1000 then
		LocalPlayer():ConCommand("sensitivity " .. tostring(1 -(((90 - ZoomHowMuch) + (Extrazoom/1000)) / 100)))
	elseif Extrazoom > 999 and Extrazoom < 10000 then
		LocalPlayer():ConCommand("sensitivity " .. tostring( 1 -(((90 - ZoomHowMuch) + (Extrazoom/10000)) / 100)))
	elseif Extrazoom > 9999 then
		LocalPlayer():ConCommand("sensitivity " .. "0.01")
	elseif Extrazoom < 99 then
		LocalPlayer():ConCommand("sensitivity " .. tostring(1 -(((90 - ZoomHowMuch) + (Extrazoom/100)) / 100)))
	end
end

local function ChangeZoomStuff( ply, bnd, pressed )
	if FalcoZoom and pressed then
		if string.find(bnd, "invprev") or (LocalPlayer():KeyDown(IN_DUCK) and string.find(bnd, "forward")) and pressed then
			if ZoomHowMuch > 1 then
				ZoomHowMuch = ZoomHowMuch - ZoomStep
				ChangeSensitivity()
				LocalPlayer():EmitSound("weapons/sniper/sniper_zoomin.wav")
			else
				Extrazoom = Extrazoom + ZoomStep*200
				ChangeSensitivity()
				LocalPlayer():EmitSound("npc/sniper/reload1.wav")
			end
			return true
		elseif string.find(bnd, "invnext") or (LocalPlayer():KeyDown(IN_DUCK) and string.find(bnd, "back")) and pressed then
			if ZoomHowMuch < 90 and Extrazoom > 0  then
				Extrazoom = Extrazoom - ZoomStep*200
				ChangeSensitivity()
				LocalPlayer():EmitSound("npc/scanner/cbot_servoscared.wav")
			elseif ZoomHowMuch < 90 and Extrazoom == 0 then
				ZoomHowMuch = ZoomHowMuch + ZoomStep
				ChangeSensitivity()
				LocalPlayer():EmitSound("weapons/sniper/sniper_zoomout.wav")
			end
			return true
		elseif string.find(bnd, "reload") and pressed then
			ZoomHowMuch = 11
			Extrazoom = 0
			ChangeSensitivity()
			LocalPlayer():EmitSound("npc/sniper/reload1.wav")
			return true
		end
	end
end

local function FZoomToggle(ply, cmd)
	if string.sub(cmd, 1, 1) == "+" then
		OldSensitivity = GetConVarString("sensitivity")
		hook.Add("CalcView", "ZoomCalcThing", ZoomCalcThing)
		hook.Add("PlayerBindPress", "ChangeZoomStuff", ChangeZoomStuff)
		if Extrazoom > 0 then
			ChangeSensitivity()
			LocalPlayer():EmitSound("npc/sniper/reload1.wav")
		else
			LocalPlayer():EmitSound("weapons/sniper/sniper_zoomin.wav")
			ChangeSensitivity()
		end
	else
		LocalPlayer():ConCommand("sensitivity " .. OldSensitivity)
		hook.Remove("CalcView", "ZoomCalcThing")
		hook.Remove("PlayerBindPress", "ChangeZoomStuff")
	end
	FalcoZoom = not FalcoZoom
end
concommand.Add("+falco_zoom", FZoomToggle)
concommand.Add("-falco_zoom", FZoomToggle)
