SWEP.Author				 = "Mikael #"
SWEP.Spawnable			 = true
SWEP.AdminSpawnable		 = false
SWEP.PrintName			 = "Лопата"
SWEP.ViewModel			 = "models/custom_models/sterling/v_ahshop_shovel_02.mdl"
SWEP.WorldModel			 = "models/custom_models/sterling/ahshop_shovel.mdl"
SWEP.UseHands 		     = true
SWEP.HoldType 			 = "melee2"
SWEP.DrawAmmo 			 = false
SWEP.Primary.ClipSize 	 = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo 		 = "none"
SWEP.Primary.AmmoType    = "none"
SWEP.Secondary.Ammo      = "none"
SWEP.DrawCrosshair       = true
SWEP.UseHands 			 = true
SWEP.ViewModelFOV 		 = 53

SWEP.Offset = {
	Pos = {
		Up = -1,
		Right = 0,
		Forward = 1,
	},
	Ang = {
		Up = 350,
		Right = 60,
		Forward = -15,
	}
}
 
function SWEP:DrawWorldModel()
	local hand, offset, rotate
	if !IsValid( self.Owner ) then
		self:DrawModel( )
		return
	end
 
	if !self.Hand then
		self.Hand = self.Owner:LookupAttachment( "anim_attachment_rh" )
	end
 
	hand = self.Owner:GetAttachment( self.Hand )
 
	if !hand then
		self:DrawModel( )
		return
	end
 
	offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up
	hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
	hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
	hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )
	self:SetRenderOrigin( hand.Pos + offset )
	self:SetRenderAngles( hand.Ang )
	self:DrawModel( )
end

local map = game.GetMap()

local farmdowntownmaps = {
	["rp_downtown_v4c_v2"] = true,
	["rp_downtown_v4c"] = true,
	["rp_downtown_v1"] = true,
	["rp_downtown_v4c_v4_sewers"] = true,
	["rp_downtown"] = true,
	["rp_downtown_evilmelon_v1"] = true,
	["rp_Downtown_v4c_v3"] = true,
	["rp_downtown_v2_fiend_v2b"] = true,
	["rp_downtown_winter_v2"] = true,
	["rp_downtown_v4c_v2_fix"] = true,
	["rp_zombie_town"] = true,
}

function SWEP:PrimaryAttack() 
	local value
	local ply = self.Owner
	local trace = ply:GetEyeTrace()
	local mat, dist = trace.HitTexture, trace.HitPos
	
	if timer.Exists( "cooldowntimer"..self:EntIndex() ) then
		return
	end
	
	if !( ply:GetPos():Distance(dist) <= 200 ) then
		return
	end
	
	if ( farmdowntownmaps[map] ) then
		value = 1.013
	else
		value = 0.96
	end
	
	local calc = dist.z * value	
	
	if fastfarm2.GrassMaterials[mat] then
		timer.Simple( 0.3, function()
			if !IsValid(self) then return end
			self:EmitSound( "shovel.wav" )
		end)

		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		if SERVER then
			
			timer.Create( "cooldowntimer"..self:EntIndex(), 2.3, 1, function()
				if !IsValid(self) then return end
				if ply:GetActiveWeapon():GetClass() != "fm_shovel" then return end

				local hole = ents.Create( "fm_plant" )

				if ( !IsValid( hole ) ) then return end 

				hole:SetPos( Vector(dist.x,dist.y,calc) )
				hole:Spawn()
				hole.phys = hole:GetPhysicsObject()

				if hole.phys and hole.phys:IsValid() then
					hole.phys:EnableMotion(false) 
				end
			end)
		end
	end		
end

function SWEP:SecondaryAttack()
end