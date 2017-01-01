local DLight = DynamicLight

CreateClientConVar("sec_showlights", 0, true, false)

function DynamicLight(index)
	if GetConVar("sec_showlights"):GetBool() then
		return DLight(index)
	else
		return {Pos = Vector(0, 0, 0), r = 0, g = 0, b = 0, Brightness = 0, Decay = 0, Size = 0, DieTime = 0}
	end
end