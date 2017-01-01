timer.Simple(0, function()
	hook.Add("DrawPhysgunBeam", "GetHoldingProp", function(ply, weapon, isOn, entity, boneID, pos)
		if IsValid(entity) and not IsValid(ply.isHolding) then
			hook.Call("FPhysgunPickup", nil, ply, entity)
		elseif IsValid(ply.isHolding) and not IsValid(entity) then
			hook.Call("FPhysgunDrop", nil, ply, entity)
		end
		ply.isHolding = entity
		ply.lastHelt = IsValid(entity) and entity or ply.lastHelt
	end)

	hook.Add("EntityRemoved", "GetHoldingProp", function(ent)
		if LocalPlayer().isHolding == ent then
			hook.Call("FPhysgunDrop", nil, LocalPlayer(), ent)
		end
	end)
end)
