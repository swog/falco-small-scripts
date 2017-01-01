local bounce = CreateClientConVar("falco_protectbounce", 0, true, false)
local bouncewait = false -- Don't edit this one :)
local gravity = GetConVarNumber("sv_gravity") -- The current gravity on the server
local fallDelay = 0.27 -- Time before you land to spawn the bounce prop
local minSpawningHeight = 72 -- Minimum distance to the floor to spawn the bounce prop (prevents getting stuck in it)

local BounceProp = "models/xqm/coastertrack/slope_225_2.mdl" -- The default bounce prop

local propUses = {} -- The horizontal offset to spawn the prop.
propUses["models/xqm/coastertrack/slope_225_2.mdl"] = 180
propUses["models/xqm/coastertrack/slope_225_1.mdl"] = 270
propUses["models/xqm/coastertrack/slope_90_1.mdl"] = 250
propUses["models/PHXtended/trieq2x2x1.mdl"] = 65
propUses["models/hunter/misc/cone4x1.mdl"] = 85
propUses["models/hunter/misc/cone2x1.mdl"] = 60

/*---------------------------------------------------------------------------
The function that calculates the player trajectory and spawns the prop
---------------------------------------------------------------------------*/
local function ProtectBounce()
	if not LocalPlayer():KeyDown(IN_DUCK) or LocalPlayer():GetVelocity().z >= -200 then
		bouncewait = false
		return
	end

	-- Always keep in mind the proper gravity
	gravity = GetConVarNumber("sv_gravity")

	BounceProp, blocked = FSpawnModel("models/xqm/coastertrack/slope_225_2.mdl", true)

	-- spawn a prop that makes you go up more when holding space
	if LocalPlayer():KeyDown(IN_JUMP) then
		BounceProp = FSpawnModel("models/xqm/coastertrack/slope_90_1.mdl", true)
	end

	local onground = LocalPlayer():IsOnGround()
	local pos = LocalPlayer():GetPos()
	local speed = LocalPlayer():GetVelocity()
	local horizontalSpeed = Vector(speed.x, speed.y, 0)

	local time = speed.z / gravity -- Time since hitting the top of the parabola
	local vertDist = 0.5*gravity*time*time -- Vertical distance from top of parabola
	local startPos = pos + Vector(0, 0, vertDist) + horizontalSpeed * time -- The location of the top of the flying parabola

	-- Estimating the height of the landing zone, because calculating it in the while loop is too resource intensive
	local trace = {
			start = pos,
			endpos = pos + speed * 100000000,
			filter = LocalPlayer()
		}

	local tr = util.TraceLine(trace)

	-- Don't spawn a prop if the player is too close to the floor
	if (pos.z - tr.HitPos.z) < minSpawningHeight or horizontalSpeed:Length() < 200 then
		bouncewait = true
		return
	end


	local landingPos = startPos
	local t = -time -- Starting time for finding the destination
	while landingPos.z > tr.HitPos.z and t < 10 do
		local vert = 0.5*gravity*t*t -- The vertical distance travelled at time t
		landingPos = startPos + horizontalSpeed * t - Vector(0, 0, vert) -- location of player at time t
		t = t + 0.01
	end

	-- Adapt landing pos to spawn the prop a bit more to the back, to account for the size of the prop
	local backDirection = horizontalSpeed:GetNormalized() * -1
	landingPos = landingPos + backDirection * (propUses[BounceProp] or 180) -- the multplier depends on the prop used

	-- Spawn the prop before we land
	if (t - time * -1) < (fallDelay + LocalPlayer():Ping()/1000) and
	 not bouncewait and
	 not onground and
	 LocalPlayer():Alive() then
		bouncewait = true
		LocalPlayer():SetEyeAngles((landingPos - pos):Angle()) -- Set eye angles to the landing position

		timer.Simple(.05, function() FSpawnModel(BounceProp) end) -- The delay is so the server knows that we changed aiming direction

		timer.Simple(fallDelay * 1.5, function() RunConsoleCommand("gmod_undo") end)
	end
end

if bounce:GetInt() == 1 then
	hook.Add("Think", "Protectbounce", ProtectBounce)
end

cvars.AddChangeCallback("falco_protectbounce", function(cvar, prevvalue, newvalue)
	if newvalue == "1" then
		hook.Add("Think", "Protectbounce", ProtectBounce)
	else
		hook.Remove("Think", "Protectbounce")
	end
end)