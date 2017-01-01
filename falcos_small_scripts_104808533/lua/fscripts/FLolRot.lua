/*---------------------------------------------------------------------------
Ancient script that makes you rotate around like a mad man and spam flashlight.
---------------------------------------------------------------------------*/

local RotateOn = false
local hoesnel = 20

local flashon = false
local function doMahRotate()
	local ang = LocalPlayer():EyeAngles().y
	RunConsoleCommand("impulse", "100")
	flashon = not flashon
	LocalPlayer():SetEyeAngles(Angle(0,ang + hoesnel,0))
end

local ding
local function kalkie()
	local view = {}
	view.origin = LocalPlayer():GetShootPos()
	view.angles = ding
	return view
end

local ToggleOfYes = false
function DraaienOmhoog()
	Jang = LocalPlayer():EyeAngles()
	ToggleOfYes = not ToggleOfYes
	if ToggleOfYes then
		LocalPlayer():SetEyeAngles(Angle(Jang.p+40, Jang.y,Jang.r))
	else
		LocalPlayer():SetEyeAngles(Angle(Jang.p-40, Jang.y,Jang.r))
	end
end

local JaOn = false
function JaZeggen()
	JaOn = not JaOn
	if JaOn then
		ToggleOfYes = false
		ding = LocalPlayer():EyeAngles()
		LocalPlayer():SetEyeAngles(Angle(ding.p-20, ding.y,ding.r))
		timer.Create("SayYAY",0.2	, 0, DraaienOmhoog)
	else
		LocalPlayer():SetEyeAngles(ding)
		timer.Remove("SayYAY")
	end
end
concommand.Add("FYes", JaZeggen)

local NoOn = false
local ToggleOfNo = false
function DraaienLR()
	Jang = LocalPlayer():EyeAngles()
	ToggleOfNo = not ToggleOfNo
	if ToggleOfNo then
		LocalPlayer():SetEyeAngles(Angle(Jang.p, Jang.y -40,Jang.r))
	else
		LocalPlayer():SetEyeAngles(Angle(Jang.p, Jang.y+40,Jang.r))
	end
end
local NoOn = false
function NoZeggen()
	NoOn = not NoOn
	if NoOn then
		ToggleOfNo = false
		ding = LocalPlayer():EyeAngles()
		LocalPlayer():SetEyeAngles(Angle(ding.p, ding.y +20,ding.r))
		timer.Create("SayNAY",0.2, 0, DraaienLR)
	else
		timer.Remove("SayNAY")
		LocalPlayer():SetEyeAngles(ding)
	end
end
concommand.Add("FNo", NoZeggen)

local function LatenWeIsLekkerBegginnenMetDraaien(ply, cmd, args)
	if not RotateOn then
		if args[1] then
			hoesnel = tonumber(args[1])
		end
		hook.Add( "Think", "RotateThing", doMahRotate)
		ding = LocalPlayer():EyeAngles()
		hook.Add( "CalcView", "fakezem", kalkie)
	else
		hook.Remove("Think", "RotateThing")
		hook.Remove( "CalcView", "fakezem")
		if ding then
			LocalPlayer():SetEyeAngles(ding)
		end
	end
	RotateOn = not RotateOn
end
concommand.Add("frotate", LatenWeIsLekkerBegginnenMetDraaien)

