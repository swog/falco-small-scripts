ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "key"
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

 	local ent = ents.Create( "sent_key" )
 	ent:SetPos( SpawnPos )
 	ent:Spawn()
 	ent:Activate()

 	return ent

end

function FSpawnPianoKey(pos, args, color, parent)
	local ent = ents.Create( "sent_key" )
	ent:SetPos( pos )
	ent:SetAngles(Angle(0,90,0))
 	ent:Spawn()
 	ent:Activate()
	//ent:SetMoveType(MOVETYPE_NONE)
	ent.sound = args.sound
	ent.pitch = args.pitch
	ent:SetColor(color.r, color.b, color.g, color.a)
	//ent:SetParent(parent)
	return ent
	//constraint.Weld(ent,parent,0,0,0, true)
end


function ENT:Initialize()
	self:SetModel( "models/props_trainstation/traincar_rack001.mdl" )
	//self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	--[[local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end]]
	self:SetMoveType( MOVETYPE_NONE )
end

function ENT:OnTakeDamage(dmg)
	if not self:IsValid() then return end
	local r,g,b,a = self:GetColor()
	self:EmitSound(self.sound, 500, self.pitch)
	if r==255 and g == 0 and b == 0 and a == 255 then
		return
	elseif r==0 and g == 0 and b == 255 and a == 255 then
		return
	end

	if r==0 and g == 0 and b == 0 and a == 255 then
		self:SetColor(0,0,255,255)
	else
		self:SetColor(255,0,0,255)
	end
	timer.Simple(0.5, function() self:SetColor(r, g, b, a ) end)
end