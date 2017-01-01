ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Piano"
ENT.Author			= "FPtje"
ENT.Information		= "none"
ENT.Category		= "Fun + Games"
ENT.RenderGroup 	= RendERGROUP_TRANSLUCENT

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:SpawnFunction( ply, tr )

 	if ( !tr.Hit ) then return end

 	local SpawnPos = tr.HitPos - Vector(0, 0, 67)  + tr.HitNormal
	local keypos = SpawnPos + Vector(0, 0, 70)

 	local ent = ents.Create( "sent_piano" )
	ent:SetModel("models/props_wasteland/cargo_container01.mdl" )
 	ent:SetPos( SpawnPos + Vector(120, 0,130) )
	ent:SetMaterial("models/props_pipes/GutterMetal01a")
	ent:SetColor(68, 51, 51, 255)
 	ent:Spawn()
 	ent:Activate()
	ent:SetMoveType(MOVETYPE_NONE)

	local prop2 = ents.Create( "prop_physics" )
	prop2:SetModel("models/props_wasteland/cargo_container01.mdl" )
	prop2:SetPos( SpawnPos + Vector(120, -383,130) )
	prop2:SetMaterial("models/props_pipes/GutterMetal01a")
	prop2:SetColor(68, 51, 51, 255)
 	prop2:Spawn()
 	prop2:Activate()
	prop2:SetMoveType(MOVETYPE_NONE)
	local keys = {}


 	keys.c1 = FSpawnPianoKey(keypos + Vector(0,180,0), {sound = "falco/piano2.wav", pitch = 50}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.d1 = FSpawnPianoKey(keypos + Vector(0,155,0), {sound = "falco/piano2.wav", pitch = 56.1}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.e1 = FSpawnPianoKey(keypos + Vector(0,130,0), {sound = "falco/piano2.wav", pitch = 63}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.f1 = FSpawnPianoKey(keypos + Vector(0,105,0), {sound = "falco/piano2.wav", pitch = 66.7}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.g1 = FSpawnPianoKey(keypos + Vector(0,80,0), {sound = "falco/piano2.wav", pitch = 74.9}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.a1 = FSpawnPianoKey(keypos + Vector(0,55,0), {sound = "falco/piano2.wav", pitch = 84.1}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.b1 = FSpawnPianoKey(keypos + Vector(0,30,0), {sound = "falco/piano2.wav", pitch = 94.4}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.c2 = FSpawnPianoKey(keypos + Vector(0,5,0), {sound = "falco/piano2.wav", pitch = 100}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.d2 = FSpawnPianoKey(keypos - Vector(0,20,0), {sound = "falco/piano2.wav", pitch = 112.2}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.e2 = FSpawnPianoKey(keypos - Vector(0,45,0), {sound = "falco/piano2.wav", pitch = 126}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.f2 = FSpawnPianoKey(keypos - Vector(0,70,0), {sound = "falco/piano2.wav", pitch = 133.5}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.g2 = FSpawnPianoKey(keypos - Vector(0,95,0), {sound = "falco/piano2.wav", pitch = 149.8}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.a2 = FSpawnPianoKey(keypos - Vector(0,120,0), {sound = "falco/piano2.wav", pitch = 168.2}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.b2 = FSpawnPianoKey(keypos - Vector(0,145,0), {sound = "falco/piano2.wav", pitch = 188.8}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.c3 = FSpawnPianoKey(keypos - Vector(0,170,0), {sound = "falco/piano2.wav", pitch = 200}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.d3 = FSpawnPianoKey(keypos - Vector(0,195,0), {sound = "falco/piano2.wav", pitch = 224.5}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.e3 = FSpawnPianoKey(keypos - Vector(0,220,0), {sound = "falco/piano2.wav", pitch = 252}, {r = 255, b = 255,g = 255, a = 255}, ent)

	keys.f3 = FSpawnPianoKey(keypos - Vector(0,245,0), {sound = "falco/piano2high.wav", pitch = 66.7}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.g3 = FSpawnPianoKey(keypos - Vector(0,270,0), {sound = "falco/piano2high.wav", pitch = 74.9}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.a3 = FSpawnPianoKey(keypos - Vector(0,295,0), {sound = "falco/piano2high.wav", pitch = 84.1}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.b3 = FSpawnPianoKey(keypos - Vector(0,320,0), {sound = "falco/piano2high.wav", pitch = 94.4}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.c4 = FSpawnPianoKey(keypos - Vector(0,345,0), {sound = "falco/piano2high.wav", pitch = 100}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.d4 = FSpawnPianoKey(keypos - Vector(0,370,0), {sound = "falco/piano2high.wav", pitch = 112.2}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.e4 = FSpawnPianoKey(keypos - Vector(0,395,0), {sound = "falco/piano2high.wav", pitch = 126}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.f4 = FSpawnPianoKey(keypos - Vector(0,420,0), {sound = "falco/piano2high.wav", pitch = 133.5}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.g4 = FSpawnPianoKey(keypos - Vector(0,445,0), {sound = "falco/piano2high.wav", pitch = 149.8}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.a4 = FSpawnPianoKey(keypos - Vector(0,470,0), {sound = "falco/piano2high.wav", pitch = 168.2}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.b4 = FSpawnPianoKey(keypos - Vector(0,495,0), {sound = "falco/piano2high.wav", pitch = 188.8}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.c5 = FSpawnPianoKey(keypos - Vector(0,520,0), {sound = "falco/piano2high.wav", pitch = 200}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.d5 = FSpawnPianoKey(keypos - Vector(0,545,0), {sound = "falco/piano2high.wav", pitch = 224.5}, {r = 255, b = 255,g = 255, a = 255}, ent)
	keys.e5 = FSpawnPianoKey(keypos - Vector(0,570,0), {sound = "falco/piano2high.wav", pitch = 252}, {r = 255, b = 255,g = 255, a = 255}, ent)


	keys.cis1 = FSpawnPianoKey(keypos + Vector(50,168,1), {sound = "falco/piano2.wav", pitch = 53}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.es1 = FSpawnPianoKey(keypos + Vector(50,143,1), {sound = "falco/piano2.wav", pitch = 59.5}, {r = 0, b = 0,g = 0, a = 255}, ent)

	keys.fis1 = FSpawnPianoKey(keypos + Vector(50,93,1), {sound = "falco/piano2.wav", pitch = 70.7}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.gis1 = FSpawnPianoKey(keypos + Vector(50,68,1), {sound = "falco/piano2.wav", pitch = 79.4}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.bes1 = FSpawnPianoKey(keypos + Vector(50,43,1), {sound = "falco/piano2.wav", pitch = 89.1}, {r = 0, b = 0,g = 0, a = 255}, ent)

	keys.cis2 = FSpawnPianoKey(keypos + Vector(50,-7,1), {sound = "falco/piano2.wav", pitch = 105.9}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.es2 = FSpawnPianoKey(keypos + Vector(50,-32,1), {sound = "falco/piano2.wav", pitch = 118.9}, {r = 0, b = 0,g = 0, a = 255}, ent)

	keys.fis2 = FSpawnPianoKey(keypos + Vector(50,-82,1), {sound = "falco/piano2.wav", pitch = 141.4}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.gis2 = FSpawnPianoKey(keypos + Vector(50,-107,1), {sound = "falco/piano2.wav", pitch = 158.7}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.bes2 = FSpawnPianoKey(keypos + Vector(50,-132,1), {sound = "falco/piano2.wav", pitch = 178.2}, {r = 0, b = 0,g = 0, a = 255}, ent)

	keys.cis3 = FSpawnPianoKey(keypos + Vector(50,-182,1), {sound = "falco/piano2.wav", pitch = 211.9}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.es3 = FSpawnPianoKey(keypos + Vector(50,-207,1), {sound = "falco/piano2.wav", pitch = 237.8}, {r = 0, b = 0,g = 0, a = 255}, ent)

	keys.fis3 = FSpawnPianoKey(keypos + Vector(50,-257,1), {sound = "falco/piano2high.wav", pitch = 70.7}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.gis3 = FSpawnPianoKey(keypos + Vector(50,-282,1), {sound = "falco/piano2high.wav", pitch = 79.4}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.bes3 = FSpawnPianoKey(keypos + Vector(50,-307,1), {sound = "falco/piano2high.wav", pitch = 89.1}, {r = 0, b = 0,g = 0, a = 255}, ent)

	keys.cis4 = FSpawnPianoKey(keypos + Vector(50,-357,1), {sound = "falco/piano2high.wav", pitch = 105.9}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.es4 = FSpawnPianoKey(keypos + Vector(50,-382,1), {sound = "falco/piano2high.wav", pitch = 118.9}, {r = 0, b = 0,g = 0, a = 255}, ent)

	keys.fis5 = FSpawnPianoKey(keypos + Vector(50,-432,1), {sound = "falco/piano2high.wav", pitch = 141.4}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.gis5 = FSpawnPianoKey(keypos + Vector(50,-457,1), {sound = "falco/piano2high.wav", pitch = 158.7}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.bes5 = FSpawnPianoKey(keypos + Vector(50,-482,1), {sound = "falco/piano2high.wav", pitch = 178.2}, {r = 0, b = 0,g = 0, a = 255}, ent)

	keys.cis6 = FSpawnPianoKey(keypos + Vector(50,-532,1), {sound = "falco/piano2high.wav", pitch = 211.9}, {r = 0, b = 0,g = 0, a = 255}, ent)
	keys.es6 = FSpawnPianoKey(keypos + Vector(50,-557,1), {sound = "falco/piano2high.wav", pitch = 237.8}, {r = 0, b = 0,g = 0, a = 255}, ent)

	keys.chordcc1 = FSpawnPianoChord(keypos + Vector(-75,180,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 149.8})
	keys.chordcm1 = FSpawnPianoChord(keypos + Vector(-105,180,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 118.9, sound3 = "falco/piano2.wav", pitch3 = 149.8})

	keys.chorddc1 = FSpawnPianoChord(keypos + Vector(-75,155,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 168.2})
	keys.chorddm1 = FSpawnPianoChord(keypos + Vector(-105,155,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 168.2})

	keys.chordec1 = FSpawnPianoChord(keypos + Vector(-75,130,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 158.7, sound3 = "falco/piano2.wav", pitch3 = 188.8})
	keys.chordem1 = FSpawnPianoChord(keypos + Vector(-105,130,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 188.8})

	keys.chordfc1 = FSpawnPianoChord(keypos + Vector(-75,105,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 133.5, sound2 = "falco/piano2.wav", pitch2 = 168.2, sound3 = "falco/piano2.wav", pitch3 = 200})
	keys.chordfm1 = FSpawnPianoChord(keypos + Vector(-105,105,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 133.5, sound2 = "falco/piano2.wav", pitch2 = 158.7, sound3 = "falco/piano2.wav", pitch3 = 200})

	keys.chordgc1 = FSpawnPianoChord(keypos + Vector(-75,80,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 149.8, sound2 = "falco/piano2.wav", pitch2 = 188.8, sound3 = "falco/piano2.wav", pitch3 = 224.5})
	keys.chordgm1 = FSpawnPianoChord(keypos + Vector(-105,80,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 149.8, sound2 = "falco/piano2.wav", pitch2 = 178.2, sound3 = "falco/piano2.wav", pitch3 = 224.5})

	keys.chordac1 = FSpawnPianoChord(keypos + Vector(-75,55,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 168.2, sound2 = "falco/piano2.wav", pitch2 = 211.9, sound3 = "falco/piano2.wav", pitch3 = 252})
	keys.chordam1 = FSpawnPianoChord(keypos + Vector(-105,55,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 168.2, sound2 = "falco/piano2.wav", pitch2 = 200, sound3 = "falco/piano2.wav", pitch3 = 252})

	keys.chordbc1 = FSpawnPianoChord(keypos + Vector(-75,30,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 188.8, sound2 = "falco/piano2.wav", pitch2 = 237.8, sound3 = "falco/piano2high.wav", pitch3 = 70.7})
	keys.chordbm1 = FSpawnPianoChord(keypos + Vector(-105,30,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 188.8, sound2 = "falco/piano2.wav", pitch2 = 224.5, sound3 = "falco/piano2high.wav", pitch3 = 70.7})

	keys.chordcc2 = FSpawnPianoChord(keypos + Vector(-75,5,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 149.8})
	keys.chordcm2 = FSpawnPianoChord(keypos + Vector(-105,5,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 118.9, sound3 = "falco/piano2.wav", pitch3 = 149.8})

	keys.chorddc2 = FSpawnPianoChord(keypos + Vector(-75,-20,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 168.2})
	keys.chorddm2 = FSpawnPianoChord(keypos + Vector(-105,-20,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 168.2})

	keys.chordec2 = FSpawnPianoChord(keypos + Vector(-75,-45,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 158.7, sound3 = "falco/piano2.wav", pitch3 = 188.8})
	keys.chordem2 = FSpawnPianoChord(keypos + Vector(-105,-45,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 188.8})

	keys.chordfc2 = FSpawnPianoChord(keypos + Vector(-75,-70,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 133.5, sound2 = "falco/piano2.wav", pitch2 = 168.2, sound3 = "falco/piano2.wav", pitch3 = 200})
	keys.chordfm2 = FSpawnPianoChord(keypos + Vector(-105,-70,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 133.5, sound2 = "falco/piano2.wav", pitch2 = 158.7, sound3 = "falco/piano2.wav", pitch3 = 200})

	keys.chordgc2 = FSpawnPianoChord(keypos + Vector(-75,-95,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 149.8, sound2 = "falco/piano2.wav", pitch2 = 188.8, sound3 = "falco/piano2.wav", pitch3 = 224.5})
	keys.chordgm2 = FSpawnPianoChord(keypos + Vector(-105,-95,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 149.8, sound2 = "falco/piano2.wav", pitch2 = 178.2, sound3 = "falco/piano2.wav", pitch3 = 224.5})

	keys.chordac2 = FSpawnPianoChord(keypos + Vector(-75,-120,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 168.2, sound2 = "falco/piano2.wav", pitch2 = 211.9, sound3 = "falco/piano2.wav", pitch3 = 252})
	keys.chordam2 = FSpawnPianoChord(keypos + Vector(-105,-120,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 168.2, sound2 = "falco/piano2.wav", pitch2 = 200, sound3 = "falco/piano2.wav", pitch3 = 252})

	keys.chordbc2 = FSpawnPianoChord(keypos + Vector(-75,-145,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 188.8, sound2 = "falco/piano2.wav", pitch2 = 237.8, sound3 = "falco/piano2high.wav", pitch3 = 70.7})
	keys.chordbm2 = FSpawnPianoChord(keypos + Vector(-105,-145,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 188.8, sound2 = "falco/piano2.wav", pitch2 = 224.5, sound3 = "falco/piano2high.wav", pitch3 = 70.7})

	keys.chordcc3 = FSpawnPianoChord(keypos + Vector(-75,-170,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 149.8})
	keys.chordcm3 = FSpawnPianoChord(keypos + Vector(-105,-170,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 118.9, sound3 = "falco/piano2.wav", pitch3 = 149.8})

	keys.chorddc3 = FSpawnPianoChord(keypos + Vector(-75,-195,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 168.2})
	keys.chorddm3 = FSpawnPianoChord(keypos + Vector(-105,-195,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 168.2})

	keys.chordec3 = FSpawnPianoChord(keypos + Vector(-75,-220,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 158.7, sound3 = "falco/piano2.wav", pitch3 = 188.8})
	keys.chordem3 = FSpawnPianoChord(keypos + Vector(-105,-220,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 188.8})

	keys.chordfc3 = FSpawnPianoChord(keypos + Vector(-75,-245,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 133.5, sound2 = "falco/piano2.wav", pitch2 = 168.2, sound3 = "falco/piano2.wav", pitch3 = 200})
	keys.chordfm3 = FSpawnPianoChord(keypos + Vector(-105,-245,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 133.5, sound2 = "falco/piano2.wav", pitch2 = 158.7, sound3 = "falco/piano2.wav", pitch3 = 200})

	keys.chordgc3 = FSpawnPianoChord(keypos + Vector(-75,-270,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 149.8, sound2 = "falco/piano2.wav", pitch2 = 188.8, sound3 = "falco/piano2.wav", pitch3 = 224.5})
	keys.chordgm3 = FSpawnPianoChord(keypos + Vector(-105,-270,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 149.8, sound2 = "falco/piano2.wav", pitch2 = 178.2, sound3 = "falco/piano2.wav", pitch3 = 224.5})

	keys.chordac3 = FSpawnPianoChord(keypos + Vector(-75,-295,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 168.2, sound2 = "falco/piano2.wav", pitch2 = 211.9, sound3 = "falco/piano2.wav", pitch3 = 252})
	keys.chordam3 = FSpawnPianoChord(keypos + Vector(-105,-295,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 168.2, sound2 = "falco/piano2.wav", pitch2 = 200, sound3 = "falco/piano2.wav", pitch3 = 252})

	keys.chordbc3 = FSpawnPianoChord(keypos + Vector(-75,-320,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 188.8, sound2 = "falco/piano2.wav", pitch2 = 237.8, sound3 = "falco/piano2high.wav", pitch3 = 70.7})
	keys.chordbm3 = FSpawnPianoChord(keypos + Vector(-105,-320,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 188.8, sound2 = "falco/piano2.wav", pitch2 = 224.5, sound3 = "falco/piano2high.wav", pitch3 = 70.7})

	keys.chordcc4 = FSpawnPianoChord(keypos + Vector(-75,-345,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 149.8})
	keys.chordcm4 = FSpawnPianoChord(keypos + Vector(-105,-345,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 118.9, sound3 = "falco/piano2.wav", pitch3 = 149.8})

	keys.chorddc4 = FSpawnPianoChord(keypos + Vector(-75,-370,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 168.2})
	keys.chorddm4 = FSpawnPianoChord(keypos + Vector(-105,-370,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 168.2})

	keys.chordec4 = FSpawnPianoChord(keypos + Vector(-75,-395,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 158.7, sound3 = "falco/piano2.wav", pitch3 = 188.8})
	keys.chordem4 = FSpawnPianoChord(keypos + Vector(-105,-395,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 188.8})

	keys.chordfc4 = FSpawnPianoChord(keypos + Vector(-75,-420,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 133.5, sound2 = "falco/piano2.wav", pitch2 = 168.2, sound3 = "falco/piano2.wav", pitch3 = 200})
	keys.chordfm4 = FSpawnPianoChord(keypos + Vector(-105,-420,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 133.5, sound2 = "falco/piano2.wav", pitch2 = 158.7, sound3 = "falco/piano2.wav", pitch3 = 200})

	keys.chordgc4 = FSpawnPianoChord(keypos + Vector(-75,-445,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 149.8, sound2 = "falco/piano2.wav", pitch2 = 188.8, sound3 = "falco/piano2.wav", pitch3 = 224.5})
	keys.chordgm4 = FSpawnPianoChord(keypos + Vector(-105,-445,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 149.8, sound2 = "falco/piano2.wav", pitch2 = 178.2, sound3 = "falco/piano2.wav", pitch3 = 224.5})

	keys.chordac4 = FSpawnPianoChord(keypos + Vector(-75,-470,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 168.2, sound2 = "falco/piano2.wav", pitch2 = 211.9, sound3 = "falco/piano2.wav", pitch3 = 252})
	keys.chordam4 = FSpawnPianoChord(keypos + Vector(-105,-470,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 168.2, sound2 = "falco/piano2.wav", pitch2 = 200, sound3 = "falco/piano2.wav", pitch3 = 252})

	keys.chordbc4 = FSpawnPianoChord(keypos + Vector(-75,-495,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 188.8, sound2 = "falco/piano2.wav", pitch2 = 237.8, sound3 = "falco/piano2high.wav", pitch3 = 70.7})
	keys.chordbm4 = FSpawnPianoChord(keypos + Vector(-105,-495,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 188.8, sound2 = "falco/piano2.wav", pitch2 = 224.5, sound3 = "falco/piano2high.wav", pitch3 = 70.7})

	keys.chordcc5 = FSpawnPianoChord(keypos + Vector(-75,-520,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 149.8})
	keys.chordcm5 = FSpawnPianoChord(keypos + Vector(-105,-520,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 100, sound2 = "falco/piano2.wav", pitch2 = 118.9, sound3 = "falco/piano2.wav", pitch3 = 149.8})

	keys.chorddc5 = FSpawnPianoChord(keypos + Vector(-75,-545,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 168.2})
	keys.chorddm5 = FSpawnPianoChord(keypos + Vector(-105,-545,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 112.2, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 168.2})

	keys.chordec5 = FSpawnPianoChord(keypos + Vector(-75,-570,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 158.7, sound3 = "falco/piano2.wav", pitch3 = 188.8})
	keys.chordem5 = FSpawnPianoChord(keypos + Vector(-105,-570,-4), Angle(180,90,0), { sound1 = "falco/piano2.wav", pitch1 = 126, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 188.8})

	//Black chords
	keys.chordcisc1 = FSpawnPianoChord(keypos + Vector(60,168,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 158.7})
	keys.chordcism1 = FSpawnPianoChord(keypos + Vector(60,168,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 158.7})

	keys.chordesc1 = FSpawnPianoChord(keypos + Vector(60,143,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 178.2})
	keys.chordesm1 = FSpawnPianoChord(keypos + Vector(60,143,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 178.2})

	keys.chordfisc1 = FSpawnPianoChord(keypos + Vector(60,93,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 141.4, sound2 = "falco/piano2.wav", pitch2 = 178.2, sound3 = "falco/piano2.wav", pitch3 = 211.9})
	keys.chordfism1 = FSpawnPianoChord(keypos + Vector(60,93,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 141.4, sound2 = "falco/piano2.wav", pitch2 = 168.2, sound3 = "falco/piano2.wav", pitch3 = 211.9})

	keys.chordgisc1 = FSpawnPianoChord(keypos + Vector(60,68,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 158.7, sound2 = "falco/piano2.wav", pitch2 = 200, sound3 = "falco/piano2.wav", pitch3 = 237.8})
	keys.chordgism1 = FSpawnPianoChord(keypos + Vector(60,68,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 158.7, sound2 = "falco/piano2.wav", pitch2 = 188.8, sound3 = "falco/piano2.wav", pitch3 = 237.8})

	keys.chordbesc1 = FSpawnPianoChord(keypos + Vector(60,43,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 178.2, sound2 = "falco/piano2.wav", pitch2 = 224.5, sound3 = "falco/piano2high.wav", pitch3 = 66.7})
	keys.chordbesm1 = FSpawnPianoChord(keypos + Vector(60,43,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 178.2, sound2 = "falco/piano2.wav", pitch2 = 211.9, sound3 = "falco/piano2high.wav", pitch3 = 66.7})

	keys.chordcisc2 = FSpawnPianoChord(keypos + Vector(60,-7,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 158.7})
	keys.chordcism2 = FSpawnPianoChord(keypos + Vector(60,-7,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 158.7})

	keys.chordesc2 = FSpawnPianoChord(keypos + Vector(60,-32,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 178.2})
	keys.chordesm2 = FSpawnPianoChord(keypos + Vector(60,-32,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 178.2})

	keys.chordfisc2 = FSpawnPianoChord(keypos + Vector(60,-82,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 141.4, sound2 = "falco/piano2.wav", pitch2 = 178.2, sound3 = "falco/piano2.wav", pitch3 = 211.9})
	keys.chordfism2 = FSpawnPianoChord(keypos + Vector(60,-82,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 141.4, sound2 = "falco/piano2.wav", pitch2 = 168.2, sound3 = "falco/piano2.wav", pitch3 = 211.9})

	keys.chordgisc2 = FSpawnPianoChord(keypos + Vector(60,-107,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 158.7, sound2 = "falco/piano2.wav", pitch2 = 200, sound3 = "falco/piano2.wav", pitch3 = 237.8})
	keys.chordgism2 = FSpawnPianoChord(keypos + Vector(60,-107,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 158.7, sound2 = "falco/piano2.wav", pitch2 = 188.8, sound3 = "falco/piano2.wav", pitch3 = 237.8})

	keys.chordbesc2 = FSpawnPianoChord(keypos + Vector(60,-132,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 178.2, sound2 = "falco/piano2.wav", pitch2 = 224.5, sound3 = "falco/piano2high.wav", pitch3 = 66.7})
	keys.chordbesm2 = FSpawnPianoChord(keypos + Vector(60,-132,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 178.2, sound2 = "falco/piano2.wav", pitch2 = 211.9, sound3 = "falco/piano2high.wav", pitch3 = 66.7})

	keys.chordcisc3 = FSpawnPianoChord(keypos + Vector(60,-182,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 158.7})
	keys.chordcism3 = FSpawnPianoChord(keypos + Vector(60,-182,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 158.7})

	keys.chordesc3 = FSpawnPianoChord(keypos + Vector(60,-207,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 178.2})
	keys.chordesm3 = FSpawnPianoChord(keypos + Vector(60,-207,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 178.2})

	keys.chordfisc3 = FSpawnPianoChord(keypos + Vector(60,-257,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 141.4, sound2 = "falco/piano2.wav", pitch2 = 178.2, sound3 = "falco/piano2.wav", pitch3 = 211.9})
	keys.chordfism3 = FSpawnPianoChord(keypos + Vector(60,-257,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 141.4, sound2 = "falco/piano2.wav", pitch2 = 168.2, sound3 = "falco/piano2.wav", pitch3 = 211.9})

	keys.chordgisc3 = FSpawnPianoChord(keypos + Vector(60,-282,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 158.7, sound2 = "falco/piano2.wav", pitch2 = 200, sound3 = "falco/piano2.wav", pitch3 = 237.8})
	keys.chordgism3 = FSpawnPianoChord(keypos + Vector(60,-282,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 158.7, sound2 = "falco/piano2.wav", pitch2 = 188.8, sound3 = "falco/piano2.wav", pitch3 = 237.8})

	keys.chordbesc3 = FSpawnPianoChord(keypos + Vector(60,-307,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 178.2, sound2 = "falco/piano2.wav", pitch2 = 224.5, sound3 = "falco/piano2high.wav", pitch3 = 66.7})
	keys.chordbesm3 = FSpawnPianoChord(keypos + Vector(60,-307,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 178.2, sound2 = "falco/piano2.wav", pitch2 = 211.9, sound3 = "falco/piano2high.wav", pitch3 = 66.7})

	keys.chordcisc4 = FSpawnPianoChord(keypos + Vector(60,-357,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 158.7})
	keys.chordcism4 = FSpawnPianoChord(keypos + Vector(60,-357,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 158.7})

	keys.chordesc4 = FSpawnPianoChord(keypos + Vector(60,-382,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 178.2})
	keys.chordesm4 = FSpawnPianoChord(keypos + Vector(60,-382,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 178.2})

	keys.chordfisc4 = FSpawnPianoChord(keypos + Vector(60,-432,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 141.4, sound2 = "falco/piano2.wav", pitch2 = 178.2, sound3 = "falco/piano2.wav", pitch3 = 211.9})
	keys.chordfism4 = FSpawnPianoChord(keypos + Vector(60,-432,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 141.4, sound2 = "falco/piano2.wav", pitch2 = 168.2, sound3 = "falco/piano2.wav", pitch3 = 211.9})

	keys.chordgisc4 = FSpawnPianoChord(keypos + Vector(60,-457,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 158.7, sound2 = "falco/piano2.wav", pitch2 = 200, sound3 = "falco/piano2.wav", pitch3 = 237.8})
	keys.chordgism4 = FSpawnPianoChord(keypos + Vector(60,-457,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 158.7, sound2 = "falco/piano2.wav", pitch2 = 188.8, sound3 = "falco/piano2.wav", pitch3 = 237.8})

	keys.chordbesc4 = FSpawnPianoChord(keypos + Vector(60,-482,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 178.2, sound2 = "falco/piano2.wav", pitch2 = 224.5, sound3 = "falco/piano2high.wav", pitch3 = 66.7})
	keys.chordbesm4 = FSpawnPianoChord(keypos + Vector(60,-482,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 178.2, sound2 = "falco/piano2.wav", pitch2 = 211.9, sound3 = "falco/piano2high.wav", pitch3 = 66.7})

	keys.chordcisc5 = FSpawnPianoChord(keypos + Vector(60,-532,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 133.5, sound3 = "falco/piano2.wav", pitch3 = 158.7})
	keys.chordcism5 = FSpawnPianoChord(keypos + Vector(60,-532,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 105.9, sound2 = "falco/piano2.wav", pitch2 = 126, sound3 = "falco/piano2.wav", pitch3 = 158.7})

	keys.chordesc5 = FSpawnPianoChord(keypos + Vector(60,-557,25), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 149.8, sound3 = "falco/piano2.wav", pitch3 = 178.2})
	keys.chordesm5 = FSpawnPianoChord(keypos + Vector(60,-557,55), Angle(0,90,90), { sound1 = "falco/piano2.wav", pitch1 = 118.9, sound2 = "falco/piano2.wav", pitch2 = 141.4, sound3 = "falco/piano2.wav", pitch3 = 178.2})


	undo.Create("Piano")
		for k,v in pairs(keys) do
			undo.AddEntity(v)
		end
		undo.AddEntity(ent)
		undo.AddEntity(prop2)
		undo.SetPlayer(ply)
	undo.Finish()
	for k,v in pairs(keys) do
		ply:AddCleanup( "sents",v)
	end
	ply:AddCleanup( "sents",ent)
	ply:AddCleanup( "sents",prop2)
end


function ENT:Initialize()
 	self:SetModel( "models/props_wasteland/cargo_container01.mdl" )
	//self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
end
