/*---------------------------------------------------------------------------
The old clientside vote system.
The one where no one is actually willing to vote
---------------------------------------------------------------------------*/

local PlayersHaveVoted = {}
local IsVoting = false
local VoteResults = {}

VoteResults.yes = 0
VoteResults.no = 0

local function FStartVote(text)
	print(1)
	IsVoting = true
	timer.Simple(3, function() RunConsoleCommand("say", "/advert Falcovote: \"" .. text .. "\" Vote by saying !yes or !no") end)
	timer.Create("FVote", 120, 1, StopFalcoVote)
end
falco_addchatcmd("fvote", FStartVote)
falco_addchatcmd("(OOC) fvote", FStartVote)

local function GetVotes(ply, text, teamonly, dead)
	if not IsVoting then return end
	if ply ~= LocalPlayer() and ply:EntIndex() ~= 0 and not table.HasValue(PlayersHaveVoted, ply) then
		if string.find(string.lower(text), "!yes") or string.find(string.lower(text), "/yes") then
			table.insert(PlayersHaveVoted, ply)
			VoteResults.yes = VoteResults.yes + 1
			Falco_DelayedSay("'" ..tostring(ply:Nick()) .. "' voted yes")
		elseif string.find(string.lower(text), "!no") or string.find(string.lower(text), "!no") then
			table.insert(PlayersHaveVoted, ply)
			VoteResults.no = VoteResults.no + 1
			Falco_DelayedSay("'" .. tostring(ply:Nick()) .. "' voted no")
		end
		if VoteResults.no + VoteResults.yes == #player.GetAll() - 1 then
			timer.Remove("FVote")
			StopFalcoVote()
		end
	elseif ply ~= LocalPlayer() and table.HasValue(PlayersHaveVoted, ply) and ( string.find(string.lower(text), "!yes") or string.find(string.lower(text), "/yes") or string.find(string.lower(text), "!no") or string.find(string.lower(text), "!no")) then
		Falco_DelayedSay("'" ..tostring( ply:Nick()) .. "' already voted. Can't vote twice")
	end
end
hook.Add( "OnPlayerChat", "FGetVotes", GetVotes)

function StopFalcoVote()
	IsVoting = false
	Falco_DelayedSay("The vote has ended, These are the results:")
	if VoteResults.yes > VoteResults.no then
		addition = "option yes won"
	elseif VoteResults.yes == VoteResults.no then
		addition = "no option won"
	elseif VoteResults.yes < VoteResults.no then
		addition = "option no won"
	end

	if VoteResults.yes == VoteResults.no and VoteResults.yes == 0 then
		addition = "Nobody voted :("
	end
	Falco_DelayedSay("Yes: " .. tostring(VoteResults.yes) .. ", no: " .. tostring(VoteResults.no) .. "    " ..  addition)
	VoteResults.yes = 0
	VoteResults.no = 0
	PlayersHaveVoted = {}
end
