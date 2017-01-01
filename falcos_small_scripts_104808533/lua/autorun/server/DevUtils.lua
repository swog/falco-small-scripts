function FESPAddPos(pos)
	umsg.Start("FESPAddPos")
		umsg.Vector(pos)
	umsg.End()
end

function FESPAddLine(first, last)
	umsg.Start("FESPAddLine")
		umsg.Vector(first)
		umsg.Vector(last)
	umsg.End()
end

function fprint(str)
	str = tostring(str)
	umsg.Start("fprint")
		umsg.String(str)
	umsg.End()
end