/*---------------------------------------------------------------------------
The good old messy spectate script.
---------------------------------------------------------------------------*/

local IsSpectating = false
local holding = {}
local SpectatePosition = Vector(0,0,0)
local CanMove = true -- for if you're in an object you mustn't be able to move
local SaveAngles = Angle(0,0,0) -- Only used when spectating an object
local SpecEnt = LocalPlayer()
local speed = 15
local SpecEntSaveAngle = Angle(0,0,0)
local camsdata = {}
local camsize = CreateClientConVar("Falco_SpecScreenSize", 5, true, false)
local LockMouse = CreateClientConVar("Falco_SpecLockMouse", 0, true, false)
local SpecSpeed = CreateClientConVar("Falco_SpecSpeed", 50, true, false)
local ThPDist = 100
local SpecAng = Angle(0,0,0)
local IsPlayer = true

surface.CreateFont("HUDNumber", {
	size = "Trebuchet",
	weight = 44,
	antialias = 800,
	shadow = true,
	font = false})
local function SelectSomeone() --DONT SAY IT'S STOLEN FROM THE GODDAMN PLAYER POSSESSOR SWEP! I GODDAMN MAAAAADE THE PLAYER POSSESSOR SWEP!
	holding = {}
	if table.Count(player.GetAll()) <= 1  then
		fnotify("You're the only one in the server")
		return
	end
	local frame = vgui.Create("DFrame")
	local button = {}
	local PosSize = {}

	frame:SetSize( 200, 500 )
	frame:Center()
	frame:SetVisible(true)
	frame:MakePopup()
	frame:SetTitle("Choose a player")

	PosSize[0] = 5
	local sorted = player.GetAll()
	table.sort(sorted, function(a, b) return a:Nick() < b:Nick() end )
	for k,v in pairs(sorted) do
		if v == LocalPlayer() then
			PosSize[k] = PosSize[k-1]
		elseif v ~= LocalPlayer() then
			PosSize[k] = PosSize[k-1] + 30
			frame:SetSize(200, PosSize[k] + 40)
			button[k] = vgui.Create("DButton", frame)
			button[k]:SetPos( 20, PosSize[k])
			button[k]:SetSize( 160, 20 )
			button[k]:SetText( v:Nick())
			frame:Center()
			button[k]["DoClick"] = function()
				if not IsValid(v) then fnotify("Can't spectate him at the moment") return end
				if IsValid(SpecEnt) then
					SpecEnt:SetNoDraw(false)
				end
				CanMove = false
				SpecEnt = v
				IsPlayer = true
			end
		end
	end
end

local function OptionsDerma()
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "Spectate config" )
	frame:SetSize( 300, 300 )
	frame:Center()
	frame:SetVisible( true )
	frame:MakePopup( )

	local Panel = vgui.Create( "DPanelList", frame )
	Panel:SetPos(20,30)
	Panel:SetSize(260, 260)
	Panel:SetSpacing(5)
	Panel:EnableHorizontal( false )
	Panel:EnableVerticalScrollbar( true )

	local SelectPerson = vgui.Create( "DButton", frame)
	SelectPerson:SetText( "Select someone to spectate" )
	SelectPerson:SetSize(220, 20)
	function SelectPerson:DoClick()
		frame:Close()
		SelectSomeone()
	end
	Panel:AddItem(SelectPerson)

	local makescreen = vgui.Create( "DButton", frame)
	makescreen:SetText( "Make a screen" )
	makescreen:SetSize(220, 20)
	function makescreen:DoClick()
		if CanMove then
			table.insert(camsdata, {pos = SpectatePosition, ang = SpecAng, obj = false})
		elseif not CanMove then
			table.insert(camsdata, {obj = SpecEnt, dist = ThPDist, ang = SaveAngles, entang = SpecEntSaveAngle})
		end
		fnotify("Screen made")
		frame:Close()
	end
	Panel:AddItem(makescreen)

	local RemoveScreen = vgui.Create( "DButton", frame)
	RemoveScreen:SetText( "Remove last screen" )
	RemoveScreen:SetSize(220, 20)
	function RemoveScreen:DoClick()
		if #camsdata > 0 then
			table.remove(camsdata, #camsdata) -- remove the last one in the table
			fnotify("Last screen removed")
		end
	end
	Panel:AddItem(RemoveScreen)

	if not CanMove and SpecEnt:IsValid() then
		local AddFESP = vgui.Create( "DButton", frame)
		AddFESP:SetText( "Add to FESP" )
		AddFESP:SetSize(220, 20)
		function AddFESP:DoClick()
			FESPAddEnt(SpecEnt, SpecEnt:EntIndex())
		end
		Panel:AddItem(AddFESP)

		local RemoveFESP = vgui.Create( "DButton", frame)
		RemoveFESP:SetText( "Remove from FESP" )
		RemoveFESP:SetSize(220, 20)
		function RemoveFESP:DoClick()
			FESPRemoveEnt(SpecEnt:EntIndex())
		end
		Panel:AddItem(RemoveFESP)
	end

	local ScreenSize = vgui.Create( "DNumSlider", frame )
	ScreenSize:SetConVar("Falco_SpecScreenSize")
	ScreenSize:SetMin(1)
	ScreenSize:SetMax(20)
	ScreenSize:SetText("Set the screensize")
	ScreenSize:SetDecimals(2)
	ScreenSize:SetValue(GetConVarNumber("Falco_SpecScreenSize"))
	Panel:AddItem(ScreenSize)

	local specspeedsldr = vgui.Create( "DNumSlider", frame )
	specspeedsldr:SetConVar("Falco_SpecSpeed")
	specspeedsldr:SetMin(1)
	specspeedsldr:SetMax(200)
	specspeedsldr:SetText("Set the spectate speed")
	specspeedsldr:SetDecimals(0)
	specspeedsldr:SetValue(GetConVarNumber("Falco_SpecSpeed"))
	Panel:AddItem(specspeedsldr)

	local LockMousechkbx = vgui.Create( "DCheckBoxLabel", frame )
	LockMousechkbx:SetText("Lock mouse when spectating non-player")
	LockMousechkbx:SetConVar("Falco_SpecLockMouse")
	Panel:AddItem(LockMousechkbx)
end

local function BindPresses(ply, bind, pressed)
	local use = LocalPlayer():KeyDown(IN_USE)
	if (string.find(bind, "forward") or string.find(bind, "moveleft") or string.find(bind, "moveright") or string.find(bind, "back") or string.find(bind, "jump") or string.find(bind, "duck")) and not use then
		holding[string.sub(bind, 2)] = pressed
		return true
	elseif string.find(bind, "speed") and pressed and not use then
		if speed <= 15 then speed = 50
		elseif speed == 50 then speed = 15
		end
		return true
	elseif string.find(bind, "walk") and pressed and not use then
		if speed ~= 2 then speed = 2
		elseif speed == 2 then speed = 15
		end
		return true
	elseif string.find(bind, "invprev") and pressed and not use then
		ThPDist = ThPDist - 10
		return true
	elseif string.find(bind, "invnext") and pressed and not use then
		ThPDist = ThPDist + 10
		return true
	elseif string.find(bind, "menu") and not string.find(bind, "context") and pressed then
		if not use then
			OptionsDerma()
			fnotify("Hold use + Q to open the spawnmenu while spectating")
			return true
		end
	elseif string.find(bind, "attack2") and pressed and not use then
		if SpecEnt and SpecEnt:IsPlayer() then
			IsPlayer = not IsPlayer
			return true
		end
	elseif string.find(bind, "reload") and pressed and not use then
		if CanMove then
			local Tracey = {}
			Tracey.start = SpectatePosition
			Tracey.endpos = SpectatePosition + SpecAng:Forward() * 100000000
			Tracey.filter = LocalPlayer() -- in case you're aiming at yourself... IF that's even possible but I can't be arsed to test that
			local trace = util.TraceLine(Tracey)

			if trace.Hit and trace.Entity and IsValid(trace.Entity) and not trace.Entity:IsPlayer() then
				FALCO_ENT = trace.Entity
				CanMove = false
				SpectatePosition = trace.Entity:LocalToWorld(trace.Entity:OBBCenter())
				SaveAngles = SpecAng--LocalPlayer():GetAimVector():Angle()
				SpecEntSaveAngle = trace.Entity:EyeAngles()
				SpecEnt = trace.Entity
				fnotify("Now spectating an entity")
				MsgN("-----------------------------SPECTATING ENT INFO: -----------------------------------------------")
				MsgN("Classname: ", trace.Entity:GetClass())
				MsgN("Model: ", trace.Entity:GetModel())
				MsgN("Pos: ", "Vector("..trace.Entity:GetPos().x .. ", "..trace.Entity:GetPos().y ..", "..trace.Entity:GetPos().z ..")")
				MsgN("Angle: ", "Angle("..trace.Entity:GetAngles().p .. ", "..trace.Entity:GetAngles().y ..", "..trace.Entity:GetAngles().r ..")")
				MsgN("Owner: ", trace.Entity:GetNWString("Owner"))
				MsgN("Distance to self: ", math.floor(trace.Entity:GetPos():Distance(LocalPlayer():GetPos())))
				MsgN("Colour: ", trace.Entity:GetColor())
				MsgN("ENT Index: ", trace.Entity:EntIndex())
				MsgN("-----------------------------end OF ENT INFO: -----------------------------------------------")
			elseif trace.Hit and trace.Entity and IsValid(trace.Entity) and trace.Entity:IsPlayer() then
				FALCO_ENT = trace.Entity
				MsgN("-----------------------------SPECTATING PLAYER INFO: -----------------------------------------------")
				MsgN("name: ", trace.Entity:Nick())
				MsgN("Health: ", trace.Entity:Health())
				MsgN("Model: ", trace.Entity:GetModel())
				local money = trace.Entity:GetNetworkedInt("money")
				if trace.Entity.DarkRPVars and trace.Entity.DarkRPVars.money then
					money = trace.Entity.DarkRPVars.money
				end
				MsgN("Money: ", "$"..money)
				MsgN("UserID: ", trace.Entity:UserID())
				MsgN("Distance to self: ", math.floor(trace.Entity:GetPos():Distance(LocalPlayer():GetPos())))
				MsgN("Colour: ", trace.Entity:GetColor())
				MsgN("ENT Index: ", trace.Entity:EntIndex())
				MsgN("-----------------------------end OF ENT INFO: -----------------------------------------------")
				CanMove = false
				SpectatePosition = trace.Entity:GetShootPos()
				SpecEnt = trace.Entity
				SpecEnt:SetNoDraw(true)
				IsPlayer = true
				fnotify("Now spectating " .. trace.Entity:Name())
			elseif trace.Hit then
				MsgN("-----------------------------SPECTATING HIT INFO: -----------------------------------------------")
				MsgN("HitPos", "Vector("..trace.HitPos.x .. ", "..trace.HitPos.y ..", "..trace.HitPos.z ..")")
				MsgN("HitAng", trace.HitNormal)
				MsgN("Texture", trace.HitTexture)
			end
		elseif not CanMove then
			CanMove = true
			SpecEnt:SetNoDraw(false)
			if IsPlayer then
				if SpecEnt:IsPlayer() then
					SpectatePosition = SpecEnt:GetShootPos()
					SpecAng = SpecEnt:EyeAngles()
				else
					SpectatePosition = SpecEnt:GetPos()
					SpecAng = SpecEnt:EyeAngles()
					SpecAng.r = 0
				end
			end
			fnotify("Stopped spectating object")
		end
		return true
	end
end

local function DoMove(what)
	if CanMove then
		if string.find(what, "forward") then
			SpectatePosition = SpectatePosition + SpecAng:Forward() * speed * RealFrameTime() * SpecSpeed:GetInt()
		elseif string.find(what, "back") then
			SpectatePosition = SpectatePosition - SpecAng:Forward() * speed * RealFrameTime() * SpecSpeed:GetInt()
		elseif string.find(what, "moveleft") then
			SpectatePosition = SpectatePosition - SpecAng:Right() * speed * RealFrameTime() * SpecSpeed:GetInt()
		elseif string.find(what, "moveright") then
			SpectatePosition = SpectatePosition + SpecAng:Right() * speed * RealFrameTime() * SpecSpeed:GetInt()
		elseif string.find(what, "jump") then
			SpectatePosition = SpectatePosition + Vector(0,0,speed * RealFrameTime() * SpecSpeed:GetInt())
		elseif string.find(what, "duck") then
			SpectatePosition = SpectatePosition - Vector(0,0,speed * RealFrameTime() * SpecSpeed:GetInt())
		end
	elseif not CanMove then
		if string.find(what, "forward") then -- todo
			SaveAngles = SaveAngles + Angle(0.1 * speed * RealFrameTime() * SpecSpeed:GetInt(), 0, 0)
		elseif string.find(what, "back") then
			SaveAngles = SaveAngles - Angle(0.1 * speed * RealFrameTime() * SpecSpeed:GetInt(), 0, 0)
		elseif string.find(what, "moveleft") then
			SaveAngles = SaveAngles - Angle(0, 0.1 * speed * RealFrameTime() * SpecSpeed:GetInt(), 0)
		elseif string.find(what, "moveright") then
			SaveAngles = SaveAngles + Angle(0, 0.1 * speed * RealFrameTime() * SpecSpeed:GetInt(), 0)
		elseif string.find(what, "jump") then
			ThPDist = ThPDist + 0.5 * speed * RealFrameTime() * SpecSpeed:GetInt()
			if ThPDist > 10 then
				SpecEnt:SetNoDraw(false)
			end
		elseif string.find(what, "duck") and ThPDist > 3 then
			ThPDist = ThPDist - 0.5 * speed * RealFrameTime() * SpecSpeed:GetInt()
			if ThPDist <= 10 then
				SpecEnt:SetNoDraw(true)
			end
		end
	end
end

local function Thinks()
	for k,v in pairs(holding) do
		if v then
			DoMove(k)
		end
	end
end

local PLAYER = FindMetaTable("Player")
PLAYER.FalcooldEyeAngles = PLAYER.FalcooldEyeAngles or PLAYER.GetEyeTrace
function PLAYER:GetEyeTrace()
	if IsSpectating and CanMove and self == LocalPlayer() then
		local trace = {}
		trace.start = SpectatePosition
		trace.endpos = SpectatePosition + SpecAng:Forward() * 1000000
		trace.filter = LocalPlayer()
		traceline = util.TraceLine(trace)
		return traceline
	end
	return self:FalcooldEyeAngles()
end

local OldUtilPlayerTrace = util.GetPlayerTrace
function util.GetPlayerTrace(ply)
	if IsSpectating and ply == LocalPlayer() then
		local trace = {}
		trace.start = SpectatePosition
		trace.endpos = SpectatePosition + SpecAng:Forward() * 1000000
		trace.filter = LocalPlayer()
		return trace
	end
	return OldUtilPlayerTrace(ply)
end

local function CalcViews(ply, origin, angles, fov)
	local view = {}
	if not CanMove and not IsValid(SpecEnt) then
		CanMove = true
	end
	view.vm_origin = Vector(0,0,-13000)
	if not CanMove and not IsPlayer then
		local ang1 = SpecEnt:EyeAngles()
		local ang
		if SpecEnt:IsPlayer() then
			ang = Angle(ang1.p - ang1.p - ang1.p, ang1.y, ang1.r) - SpecEntSaveAngle
		else
			ang = SpecEntSaveAngle
		end
		SpectatePosition = SpecEnt:GetPos() - (SaveAngles + ang ):Forward() * ThPDist
		SpecAng = (SpecEnt:GetPos() - SpectatePosition):Angle()
		view.angles = SpecAng
		view.origin = SpectatePosition
		view.vm_origin = SpectatePosition
	elseif not CanMove and IsPlayer then
		view.angles = SpecEnt:EyeAngles()
		if SpecEnt:IsPlayer() then
			view.origin = SpecEnt:GetShootPos()
		else
			view.origin = SpecEnt:GetPos()
		end
		view.vm_origin = LocalPlayer():GetShootPos()
		SpecEnt:SetNoDraw(true)
	elseif CanMove then
		view.angles = SpecAng
		view.origin = SpectatePosition
		view.vm_origin = SpectatePosition
	end
	return view
end

local function Screens()
	if #camsdata < 1 then return end
	local dat = {}
	for k,v in pairs(camsdata) do
		local ang = LocalPlayer():EyeAngles()
		if not IsValid(v.obj) and v.obj == false then
			dat.origin = v.pos
			dat.angles = v.ang
			dat.y = 0
			dat.w = ScrW() / camsize:GetInt()
			dat.h = ScrH() / (0.75 * camsize:GetInt())
			if k <= camsize:GetInt() then
				dat.x = (k-1) * ScrW() / camsize:GetInt()
			elseif k > camsize:GetInt() and k <=2 * camsize:GetInt() then
				dat.y = ScrH() / (0.75 * camsize:GetInt())
				dat.x = (k - (camsize:GetInt() + 1)) * ScrW() / camsize:GetInt()
			elseif k > 2 * camsize:GetInt() then
				dat.y = 2 * (ScrH() / (0.75 * camsize:GetInt()))
				dat.x = (k - (2*camsize:GetInt()+1)) * ScrW() / camsize:GetInt()
			end
			render.RenderView( dat )
		elseif IsValid(v.obj) then
			dat.w = ScrW() / camsize:GetInt()
			dat.h = ScrH() / (0.75 * camsize:GetInt())
			dat.y = 0
			if k <= camsize:GetInt() then
				dat.x = (k-1) * ScrW() / camsize:GetInt()
			elseif k > camsize:GetInt() and k <=2 * camsize:GetInt() then
				dat.y = ScrH() / (0.75 * camsize:GetInt())
				dat.x = (k - (camsize:GetInt() + 1)) * ScrW() / camsize:GetInt()
			elseif k > 2 * camsize:GetInt() then
				dat.y = 2 * (ScrH() / (0.75 * camsize:GetInt()))
				dat.x = (k - (2*camsize:GetInt()+1)) * ScrW() / camsize:GetInt()
			end

			if v.obj:IsPlayer() then
				dat.origin = v.obj:GetShootPos()
				dat.angles = v.obj:EyeAngles()
				v.obj:SetNoDraw(true)
				render.RenderView( dat )
				v.obj:SetNoDraw(false)
			else
				local ang1 = v.obj:EyeAngles()
				local ang = Angle(ang1.p - ang1.p - ang1.p, ang1.y, ang1.r) - v.entang
				local pos = v.obj:GetPos() - (Angle(ang.p, ang.y, ang.r) + v.ang ):Forward() * v.dist
				dat.origin = pos
				dat.angles = (v.obj:GetPos() - pos):Angle()
				render.RenderView( dat )
			end

		elseif not IsValid(v.obj) and v.obj ~= false then
			local temp = {}
			camsdata[k] = nil
			for k,v in pairs(camsdata) do
				table.insert(temp, v)
			end
			camsdata = {}
			for k,v in pairs(temp) do
				table.insert(camsdata, v)
			end
			dat[k] = nil
		end
	end
	if #camsdata > 0 then
		draw.RoundedBox(1, (ScrW() / 2) - 1.5, (ScrH() / 2) - 1.5, 3, 3, Color(255,255,255,255))
	end

	if IsSpectating then
		surface.SetFont("HUDNumber")
		surface.SetTextColor(255,255,255,255)
		if CanMove then
			surface.SetTextPos( (ScrW() / 2) - 0.5*surface.GetTextSize("Free spectating"), ScrH() - 80)
			surface.DrawText("Free spectating")
		elseif not CanMove and SpecEnt:IsPlayer() then
			surface.SetTextPos( (ScrW() / 2) - 0.5*surface.GetTextSize("Spectating " .. SpecEnt:Name()), ScrH() - 80)
			surface.DrawText("Spectating " .. SpecEnt:Name())
		elseif not CanMove and not SpecEnt:IsPlayer() then
			surface.SetTextPos( (ScrW() / 2) - 0.5*surface.GetTextSize("Spectating an entity"), ScrH() - 80)
			surface.DrawText("Spectating an entity")
		end
	end
end
hook.Add("HUDPaint", "FSpectatePermanentScreens", Screens)

local safeview = debug.getregistry().CUserCmd.SetViewAngles
local function MouseStuff(u)
	if not CanMove and SpecEnt:IsValid() and SpecEnt:IsPlayer() and SpecEnt ~= LocalPlayer() then
		local trace = SpecEnt:GetEyeTrace().HitPos
		safeview(u, (trace - LocalPlayer():GetShootPos()):Angle())
	elseif not CanMove and SpecEnt:IsValid() and not SpecEnt:IsPlayer() and LockMouse:GetInt() ~= 1 then
		SaveAngles.p = SaveAngles.p + u:GetMouseY() * 0.025
		SaveAngles.y = SaveAngles.y - u:GetMouseX() * 0.025
		local trace = {}
		trace.start = SpectatePosition
		trace.endpos = SpectatePosition + SpecAng:Forward() * 100000
		trace.filter = LocalPlayer()
		local traceline = util.TraceLine(trace)
		local pos = traceline.HitPos
		safeview(u, (pos - LocalPlayer():GetShootPos()):Angle())
	elseif CanMove then
		local trace = {}
		trace.start = SpectatePosition
		trace.endpos = SpectatePosition + SpecAng:Forward() * 100000
		trace.filter = LocalPlayer()
		local traceline = util.TraceLine(trace)
		local pos = traceline.HitPos
		SpecAng.p = math.Clamp(SpecAng.p + u:GetMouseY() * 0.025, -90, 90)
		SpecAng.y = SpecAng.y + u:GetMouseX() * -0.025
		safeview(u, (pos - LocalPlayer():GetShootPos()):Angle())
	end
end

local function Toggle()
	if IsSpectating then
		IsSpectating = false
		CanMove = true
		if IsValid(SpecEnt) then
			SpecEnt:SetNoDraw(false)
			SpecEnt = LocalPlayer()
		end
		speed = 15
		holding = {}
		hook.Remove("CreateMove", "FSpectate")
		hook.Remove("CalcView", "FSpectate")
		hook.Remove("Think", "FSpectate")
		hook.Remove("PlayerBindPress", "FSpectate")
		hook.Remove("ShouldDrawLocalPlayer", "FSpectate")
		FESPRemoveEnt(1337)
	else
		IsSpectating = true
		local obs = LocalPlayer():GetObserverTarget()
		SpectatePosition = IsValid(obs) and (obs:IsPlayer() and obs:GetShootPos() or obs:GetPos()) or LocalPlayer():GetShootPos()
		SpecAng = LocalPlayer():EyeAngles()
		-- HOOKS:
		hook.Add("CreateMove", "FSpectate", MouseStuff)
		hook.Add("CalcView", "FSpectate", CalcViews)
		hook.Add("Think", "FSpectate", Thinks)
		hook.Add("PlayerBindPress", "FSpectate", BindPresses)
		hook.Add("ShouldDrawLocalPlayer", "FSpectate", function(...) if CanMove then return true end end)
		FESPAddEnt(LocalPlayer(), 1337)
	end
end
concommand.Add("falcop_spectate", Toggle)

hook.Add("PostGamemodeLoaded", "Falco_spectateFAdmin", function()
	if not FAdmin then return end
	FAdmin.ScoreBoard.Player:AddActionButton("Falco Spectate", "FAdmin/icons/Spectate", Color(0, 200, 0, 255),true, function(ply, button)
			if not IsSpectating then
				Toggle()
			end
			SpectatePosition = ply:GetShootPos()
			SpecEnt = ply
			SpecEnt:SetNoDraw(true)
			IsPlayer = true
			CanMove = false
			fnotify("Now spectating " .. ply:Name())
		end
	)
end)