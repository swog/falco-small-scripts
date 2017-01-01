/*---------------------------------------------------------------------------
Extremely simple script that shows you the info of the thing you're looking at
---------------------------------------------------------------------------*/

function EntityInformation()
	local trace = LocalPlayer():GetEyeTrace()
	print(trace.Entity:GetClass())
	print(trace.Entity:GetModel())
	if trace.Hit and trace.Entity:IsValid() and string.find(string.lower(trace.Entity:GetClass()), "prop") then
		print(trace.Entity:GetModel())
		print(trace.Entity:GetOwner())
		print(trace.Entity:Health())
		PrintTable(trace.Entity:GetTable())
	elseif trace.Hit and trace.Entity:IsValid() and trace.Entity:GetClass() == "player" then
		print(trace.Entity:Nick())
		print(trace.Entity:Health())
		print(trace.Entity:GetActiveWeapon():GetPrintName())
		print("the guy you're looking at is admin:", trace.Entity:IsAdmin())
	end
end
concommand.Add("falco_GetModel", EntityInformation)
