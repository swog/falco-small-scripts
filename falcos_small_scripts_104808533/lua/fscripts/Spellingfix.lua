/*---------------------------------------------------------------------------
Very annoying spelling corrector.
---------------------------------------------------------------------------*/

local toggle = CreateClientConVar("falco_spellingchecker", 0, true, false)

local fixes = {}

local function AddFix(from, to)
	fixes[from] = to
end

local function SpellingCheck(ply, text, teamonly, dead)
	if ply == LocalPlayer() then return end
	local FixText = ""
	for from, to in pairs(fixes) do
		if string.find(string.lower(text), from) then
			FixText = FixText.. to ..", "
		end
	end

	if FixText ~= "" and ply.Nick then
		Falco_DelayedSay(sql.SQLStr(ply:Nick())..": "..string.sub(FixText, 1, -3).. "*")
		--fprint(ply:Nick()..": "..string.sub(FixText, 1, -3).. "*")
	end
end

if tobool(toggle:GetInt()) then
	hook.Add("OnPlayerChat", "falco_spellingchecker", SpellingCheck)
end

cvars.AddChangeCallback("falco_spellingchecker", function(cvar, prevvalue, newvalue)
	if newvalue == "1" then
		hook.Add("OnPlayerChat", "falco_spellingchecker", SpellingCheck)
	else
		hook.Remove("OnPlayerChat", "falco_spellingchecker")
	end
end)

AddFix("could of", "could have")
AddFix("would of", "would have")
AddFix("should of", "should have")

AddFix("hav%s", "have")
AddFix("hav$", "have")

AddFix("wan't", "want")
AddFix("er then", "*er THAN")
AddFix("retart", "retard")
--AddFix("were .+ing", "we're")
AddFix("^ive", "I've")
AddFix("%sive", "I've")
AddFix(" im%s", "I'm")
AddFix("^im%s", "I'm")
AddFix("imma%s", "I'm going to")

AddFix("tht", "that")
AddFix(" ur ", "you're (or your when talking about possession)")
AddFix("^ur ", "you're (or your when talking about possession)")
AddFix("urs$", "yours")
AddFix("%su%s", "you")
AddFix("^u%s", "you")
AddFix("%su$", "you")
AddFix(" ?urs", "yours")
AddFix("youre", "you're")
AddFix("^its", "It's")
AddFix("^u ?faggit", "faggot")
AddFix("^u ?fagget", "faggot")
AddFix("^r%s", "are")
AddFix("%sr%s", "are")
AddFix("%sr&", "are")
AddFix("alot", "a lot")

AddFix("^an [b|c|d|f|g|j|k|l|m|n|p|q|r|s|t|v|w|x|z]", "a")
AddFix(" an [b|c|d|f|g|j|k|l|m|n|p|q|r|s|t|v|w|x|z]", "a")
AddFix("^a [a|e|i|o|u]", "an")
AddFix(" a [a|e|i|o|u]", "an")


AddFix("to no", "to know")
AddFix("don.?t no", "don't know")

AddFix("doesnt", "doesn't")
AddFix("dosent", "doesn't")
AddFix("%sdose", "does")
AddFix("^dose", "does")
AddFix("dont", "don't")
AddFix("didnt", "didn't")
AddFix("wont", "won't")
AddFix("cant", "can't")
AddFix("isnt", "isn't")
AddFix("wasnt", "wasn't")
AddFix("couldnt", "couldn't")
AddFix("thats", "that's")
AddFix("cus", "because")


AddFix("dewd", "dude(s)")
AddFix("dawg", "dude(s)")
AddFix("evry ?1", "everyone")
AddFix("every ?1", "everyone")
AddFix("gai$", "gay")
AddFix("grammer", "grammar")
AddFix("guise", "guys")
AddFix("%sh8", "hate")
AddFix("^h8", "hate")
AddFix("h8$", "hate")
AddFix("lieing", "lying")
AddFix("offence", "offense")
AddFix("raep", "rape")
AddFix("eated", "ate")
AddFix("couse", "cause/because")
AddFix("what you want", "what DO you want")
AddFix("rilly", "really")
AddFix("sentance", "sentence")
AddFix("drinked", "drunk")
