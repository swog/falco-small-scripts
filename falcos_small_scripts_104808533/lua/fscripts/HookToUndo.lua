/*---------------------------------------------------------------------------
Very hacky script that logs the things you spawn and allows you to undo any entity in the undo list.
---------------------------------------------------------------------------*/

local undoTable
local LastCreated = {} -- Sometimes OnEntityCreated gets called before AddUndo arrives. In that case catch the prop.

/*---------------------------------------------------------------------------
Detour the undo functions to call un hooks
---------------------------------------------------------------------------*/
timer.Simple(0, function()
	local AddUndo = net.Receivers.undo_addundo
	local Undo_Undone = net.Receivers.undo_undone

	net.Receive("undo_addundo", function(l)
		local num, str = net.ReadInt(16), net.ReadString()

		local readInt, readStr = net.ReadInt, net.ReadString

		net.ReadInt, net.ReadString = fn.Curry(fn.Id, 2)(num), fn.Curry(fn.Id, 2)(str)

		hook.Run("UndoAdded", num, str)
		AddUndo(l)

		net.ReadInt, net.ReadString = readInt, readStr
	end)

	net.Receive("undo_undone", function(l)
		local num = net.ReadInt(16)

		local readInt = net.ReadInt

		net.ReadInt = fn.Curry(fn.Id, 2)(num)

		hook.Run("Undone", num)
		Undo_Undone(l)

		net.ReadInt = readInt
	end)
end)

/*---------------------------------------------------------------------------
Use the hooks to call hooks whenever a prop is spawned
---------------------------------------------------------------------------*/
local undoTaken = {}
hook.Add("UndoAdded", "undoAdded", function(num, str)
	local match = string.match(str, "Prop .(.*).")

	if match then
		hook.Run("Falco_SpawnedProp", match, num, str)
	end

	for k,v in pairs(LastCreated) do
		if not IsValid(v) or v.IsMine or string.lower(v:GetModel() or "") ~= string.lower(match or "") then continue end

		local owner = CPPI and v:CPPIGetOwner()
		if IsValid(owner) and owner:IsPlayer() and owner ~= LocalPlayer() then
			LastCreated[k] = nil
			continue
		end

		local wep = LocalPlayer():GetActiveWeapon()

		v.IsMine = true
		table.remove(LastCreated, k)
		hook.Call("Falco_ActuallySpawnedProp", nil, v)
		undoTaken[num] = v

		if IsValid(wep) and wep:GetClass() == "weapon_physgun" and input.IsMouseDown(MOUSE_FIRST) and LocalPlayer():GetEyeTrace().Entity == v then
			hook.Call("PhysgunPickup", nil, LocalPlayer(), v)
		end

		break
	end
end)

hook.Add("Undone", "undone", function(num)
	for k,v in pairs(undo.GetTable()) do
		local match = string.match(v.Name, "Prop .(.*).")
		if v.Key ~= num or not match then continue end

		hook.Call("Falco_RemovedProp", nil, match, undoTaken[num])
	end

	undoTaken[num] = nil
end)

hook.Add("OnEntityCreated", "IActuallySpawnedProp", function(prop)
	if not IsValid(prop) or prop:GetClass() ~= "prop_physics" then return end
	local owner = CPPI and prop:CPPIGetOwner()
	if IsValid(owner) and owner:IsPlayer() and owner ~= LocalPlayer() then return end

	for k, v in pairs(undo.GetTable()) do
		local Match = string.lower(string.match(v.Name, "Prop .(.*).") or "")
		if undoTaken[v.Key] or prop.IsMine or Match ~= string.lower(prop:GetModel() or "") then continue end

		hook.Call("Falco_ActuallySpawnedProp", nil, prop)
		prop.IsMine = true
		undoTaken[v.Key] = prop

		local wep = LocalPlayer():GetActiveWeapon()
		if IsValid(wep) and wep:GetClass() == "weapon_physgun" and input.IsMouseDown(MOUSE_FIRST) and LocalPlayer():GetEyeTrace().Entity == prop then
			hook.Call("PhysgunPickup", nil, LocalPlayer(), prop)
		end
		return
	end

	local Index = table.insert(LastCreated, prop)
end)
--]]

/*---------------------------------------------------------------------------
Undo the nth entity
---------------------------------------------------------------------------*/
concommand.Add("falco_undonum", function(ply,cmd,args)
	local num = tonumber(args[1])
	local Undo = undo.GetTable()
	if not num or not Undo[num] then return end

	RunConsoleCommand("gmod_undonum", Undo[num].Key)
end)
