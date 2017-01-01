if snelheid == nil then
	snelheid = 0
end

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "nil"
end

if ( CLIENT ) then
	SWEP.PrintName			= "Piano Player"			
	SWEP.Author				= "FPtje"
	SWEP.Instructions		= "Shoot the piano with this gun to play a tone or a chord"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 6
	SWEP.IconLetter			= "x"
	SWEP.IconLetter			= "Piano Player Swep"
	killicon.AddFont( "Piano", "akbar", SWEP.IconLetter, Color( 255, 80, 0, 0 ) )
end


SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_hands.mdl"
SWEP.WorldModel			= "models/props_c17/briefcase001a.mdl"

SWEP.Weight				= 1
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "smg"


function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha ) 
	surface.CreateFont( "akbar", 48, 500, true, true, "Falcootje" )
	draw.SimpleText( "Piano player", "Falcootje", x + wide/2, y + tall*0.3, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
end
	
	
function SWEP:Reload()
	self.snelheid = self.snelheid or 0
	self.snelheiddelay = self.snelheiddelay or 0
	
	if (self.snelheiddelay < RealTime()) and SERVER then
		if self.snelheid == 0 then
			self.snelheid = 0.05
			self.Owner:PrintMessage( HUD_PRINTTALK, "Firing rate is set to " .. self.snelheid)
		elseif self.snelheid == 0.05 then
			self.snelheid = 0.1
			self.Owner:PrintMessage( HUD_PRINTTALK, "Firing rate is set to " .. self.snelheid)
		elseif self.snelheid == 0.1 then
			self.snelheid = 0.3
			self.Owner:PrintMessage( HUD_PRINTTALK, "Firing rate is set to " .. self.snelheid)
		elseif self.snelheid == 0.3 then
			self.snelheid = 0.5
			self.Owner:PrintMessage( HUD_PRINTTALK, "Firing rate is set to " .. self.snelheid)
		elseif self.snelheid == 0.5 then
			self.snelheid = 0
			self.Owner:PrintMessage( HUD_PRINTTALK, "Firing rate is set to " .. self.snelheid)
		end
		
		self.snelheiddelay = RealTime() + 0.3 -- Wait 0.3 seconds before we change again
	end
end


function SWEP:SecondaryAttack()
	if self.snelheid == nil then
		self.snelheid = 0
	end
	self.Weapon:SetNextSecondaryFire(CurTime() + self.snelheid)
	
	local trace = self.Owner:GetEyeTrace()
	
if (SERVER) then
		if(trace.Hit and trace.Entity:IsValid()) then
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then return end
		trace.Entity:TakeDamage(1, self.Owner);
		end
end
	
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
end

function SWEP:PrimaryAttack()
	local trace = self.Owner:GetEyeTrace()
if (SERVER) then
	if(trace.Hit and trace.Entity:IsValid()) then
		if trace.Entity:IsPlayer() or trace.Entity:IsNPC( ) then return end
		trace.Entity:TakeDamage(1, self.Owner);
	end
end

	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
end

function SWEP:DrawHUD()

	local x = ScrW() / 2.0
	local y = ScrH() / 2.0
	local scale = 0.1
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	// Draw an awesome crosshair
	local gap = 0 * scale
	local length = gap + 60 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )

end

function SWEP:HUDShouldDraw( element )
	if (element == "CHudAmmo") then
		return false
	else
		return true
	end
end 
