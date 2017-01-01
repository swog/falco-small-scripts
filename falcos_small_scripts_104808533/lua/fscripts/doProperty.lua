local function toggleGravity(ent)
	net.Start("properties")
		net.WriteUInt(util.NetworkStringToID("gravity"), 32)
		net.WriteEntity(ent)
	net.SendToServer()
end

concommand.Add("falco_toggleGravityLA", function(ply)
	local ent = ply:GetEyeTrace().Entity
	ent = IsValid(ply.lastHelt) and ply.lastHelt or ent
	if not IsValid(ent) then return end

	toggleGravity(ent)
end)

concommand.Add("+falco_togglegravity", function()
	hook.Add("FPhysgunPickup", "Gravity", function(ply, ent)
		if ply == LocalPlayer() then toggleGravity(ent) end
	end)
end)

concommand.Add("-falco_togglegravity", function()
	hook.Remove("FPhysgunPickup", "Gravity")
end)


// Hack the "no collide all" of anti prop kill systems
local hackAntiPropKill = false
concommand.Add("falco_hackAntiPropKill", function() hackAntiPropKill = not hackAntiPropKill fprint(hackAntiPropKill) end)

/*---------------------------------------------------------------------------
Make holding prop have no collision when holding alt
---------------------------------------------------------------------------*/
local function enableCollision(ent)
	net.Start("properties")
		net.WriteUInt(util.NetworkStringToID("collision_on"), 32)
		net.WriteEntity(ent)
	net.SendToServer()
end

local function disableCollision(ent)
	net.Start("properties")
		net.WriteUInt(util.NetworkStringToID("collision_off"), 32)
		net.WriteEntity(ent)
	net.SendToServer()
end

local lastEnt = nil
local collisionToggled = false

local function physgunPickup(ply, ent)
	if ply ~= LocalPlayer() then return end
	lastEnt = ent
	if LocalPlayer():KeyDown(IN_WALK) then
		disableCollision(ent)
	elseif hackAntiPropKill then
		disableCollision(ent)
		enableCollision(ent)
	end
end

local function doDisableCollision()
	collisionToggled = true
	if not IsValid(lastEnt) then return end
	disableCollision(lastEnt)
end
concommand.Add("+falco_disableCollision", doDisableCollision)

local function doEnableCollision()
	enableCollision(lastEnt)
end
concommand.Add("-falco_disableCollision", doEnableCollision)

timer.Simple(1, function()
	hook.Add("PlayerBindPress", "AltShit", keyPress)
	hook.Add("FPhysgunPickup", "propertyApply", physgunPickup)
end)

/*---------------------------------------------------------------------------
Hacking the anti prop kill on spawn prop
---------------------------------------------------------------------------*/
hook.Add("Falco_ActuallySpawnedProp", "hackAntiPropKill", function(ent)
	if not hackAntiPropKill then return end
	disableCollision(ent)
	enableCollision(ent)
end)
