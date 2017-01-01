ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "chord"
ENT.Author			= "FPtje"
ENT.Information		= "none"
ENT.Category		= "Fun + Games"
ENT.RenderGroup 	= RendERGROUP_TRANSLUCENT

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

//local zelf

function ENT:SpawnFunction( ply, tr )

 	if ( !tr.Hit ) then return end

 	local SpawnPos = tr.HitPos + tr.HitNormal * 16

 	local ent = ents.Create( "sent_chord" )
 	ent:SetPos( SpawnPos )
 	ent:Spawn()
 	ent:Activate()

 	return ent

end

//lua_run FSpawnPianoChord(Vector(0,0,0), Angle(180,90,0), { sound1 = "falco/piano.wav", pitch1 = 100, sound2 = "falco/piano.wav", pitch2 = 150, sound3 = "falco/piano.wav", pitch3 = 200})
function FSpawnPianoChord(pos, angle, sounds)
	local ent = ents.Create( "sent_chord" )
	ent:SetPos( pos )
	ent:SetAngles(angle)
 	ent:Spawn()
 	ent:Activate()
	ent:SetMaterial("models/debug/debugwhite")
	//ent:SetMoveType(MOVETYPE_NONE)
	ent.sound = {}
	ent.sound.sound1 = sounds.sound1
	ent.sound.pitch1 = sounds.pitch1
	ent.sound.sound2 = sounds.sound2
	ent.sound.pitch2 = sounds.pitch2
	ent.sound.sound3 = sounds.sound3
	ent.sound.pitch3 = sounds.pitch3
	ent:SetColor(0,255,0,255)
	//ent:SetParent(parent)
	return ent
	//constraint.Weld(ent,parent,0,0,0, true)
end


function ENT:Initialize()
	self:SetModel( "models/props_junk/PlasticCrate01a.mdl" )
	//self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	--[[ local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end ]]
	self:SetMoveType( MOVETYPE_NONE )
end

function ENT:OnTakeDamage(dmg)
	local r,g,b,a = self:GetColor()

	self:EmitSound(self.sound.sound1, 500, self.sound.pitch1)
	self:EmitSound(self.sound.sound2, 500, self.sound.pitch2)
	self:EmitSound(self.sound.sound3, 500, self.sound.pitch3)


	if r==0 and g == 255 and b == 0 and a == 255 then
		return
	end

	self:SetColor(255,0,0,255)
	timer.Simple(0.5, function() self:SetColor(r, g, b, a ) end)
end