/*---------------------------------------------------------------------------
Logs calls to the Player metatable
---------------------------------------------------------------------------*/

local LOGGING = FindMetaTable("Player")
local EntityBackupFunctions = {}
local PlayerFunctionLogText = ""
local File = ""
local Time = 1
local function SetLogging(ply, cmd, args)
	if not args[1] then print("Time to log",Time, "\nWhat to log", LOGGING.MetaName, "\nFile:", "\""..File.."\"" ) return end
	LOGGING = FindMetaTable(args[2] or "Player")
	File = args[3] or ""
	Time = tonumber(args[1])
	print("Set Logging: ", args[2] or "Player", "\nTime to log:", Time, "\nFile:", "\""..File.."\"" )
end
concommand.Add("falco_setlogging", SetLogging)

local function UnlogAll()
	for k,v in pairs(EntityBackupFunctions) do
		LOGGING[k] = v
	end
	file.Write("EntityFunctionLog.txt", PlayerFunctionLogText)
end
concommand.Add("falco_UNlogPlayerFunctions", UnlogAll)

local function LogPlayers()
	timer.Simple(Time, UnlogAll)
	for k,v in pairs(LOGGING) do
		if type(v) == "function" and string.sub(k, 0, 2) ~= "__" then
			EntityBackupFunctions[k] = v
			LOGGING[k] = function(ent, ...)
				local FuncInfo = ""
				local info = debug.getinfo(2, "Sln")
				if not info then return EntityBackupFunctions[k](ent, ...) end
				if not string.find(info.short_src, File) then return EntityBackupFunctions[k](ent, ...) end
				if (info.what) == "C" then
					FuncInfo = "C function"
				else
					FuncInfo = info.short_src .. "\t\tline: "..info.currentline
				end
				local args = {...}
				for k,v in pairs(args) do
					args[k] = tostring(v)
				end


				local Name = tostring(ent)
				if LOGGING.MetaName == "Player" then Name = EntityBackupFunctions["Nick"](ent)
				elseif LOGGING.MetaName == "Entity" and EntityBackupFunctions["IsValid"] and EntityBackupFunctions["IsValid"](ent) then
					Name = EntityBackupFunctions["GetClass"](ent)
				end
				PlayerFunctionLogText = PlayerFunctionLogText .. "\n"..SysTime().."\t\t\t"..Name..":" .. k .."(".. table.concat(args, ", ")..")\t\t\t"..FuncInfo
				return EntityBackupFunctions[k](ent, ...)
			end
		end
	end
end
concommand.Add("falco_logPlayerFunctions", LogPlayers)

