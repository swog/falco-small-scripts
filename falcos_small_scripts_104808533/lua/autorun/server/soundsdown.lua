
resource.AddFile("materials/VGUI/entities/blackkey.vmt")
resource.AddFile("materials/VGUI/entities/blackkey.vtf")
resource.AddFile("materials/VGUI/entities/PianoPic.vmt")
resource.AddFile("materials/VGUI/entities/PianoPic.vtf")
resource.AddFile("materials/VGUI/entities/whitekey.vmt")
resource.AddFile("materials/VGUI/entities/whitekey.vtf")

for k,v in pairs(file.Find("sound/Falco/*", "GAME")) do resource.AddFile("sound/Falco/"..v) end

AddCSLuaFile("autorun/client/falcoutilities.lua")
AddCSLuaFile("fscripts/pianovgui.lua")
AddCSLuaFile("fscripts/PianoKeyMapping.lua")
AddCSLuaFile("fscripts/PianoCommands.lua")
