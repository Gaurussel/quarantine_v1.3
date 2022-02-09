AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "knife base"
	SWEP.CSMuzzleFlashes = true
end

SWEP.ImpactDecal = "ManhackCut"
SWEP.CanBackstab = true
SWEP.CanCustomize = false
SWEP.SprintingEnabled = false -- can attack regardless of sprint state
SWEP.FiremodesEnabled = false
SWEP.NearWallEnabled = false
SWEP.FireModes = {"auto"}
SWEP.Attachments = {}

SWEP.Animations = {}

SWEP.SpeedDec = 0

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.NormalHoldType = "knife"
SWEP.RunHoldType = "knife"
SWEP.Base = "cw_base"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= 0
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			= ""

SWEP.PrimaryAttackRange = 50
SWEP.SecondaryAttackRange = 50

SWEP.PrimaryDamage = 10
SWEP.SecondaryDamage = {10, 11}
SWEP.BackstabDamageMultiplier = 3
SWEP.VelocityToDamageDivider = 20

SWEP.PrimaryHitAABB = {
	Vector(-10, -5, -5),
	Vector(-10, 5, 5)
}

SWEP.SecondaryHitAABB = {
	Vector(-10, -5, -5),
	Vector(-10, 5, 5)
}

SWEP.HipSpread = 0
SWEP.AimSpread = 0
SWEP.VelocitySensitivity = 0
SWEP.MaxSpreadInc = 0

SWEP.PrimaryAttackImpactTime = 0.2
SWEP.PrimaryAttackDamageWindow = 0.15

SWEP.DamageForce = 10000

SWEP.PushVelocity = 100 -- how much velocity to apply to an object when we hit it

-- registering default knife sounds here
CustomizableWeaponry:addFireSound("CW_KNIFE_HIT", {"weapons/knife/knife_hit1.wav", "weapons/knife/knife_hit2.wav", "weapons/knife/knife_hit3.wav", "weapons/knife/knife_hit4.wav"}, 1, 75, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KNIFE_HITWALL", "weapons/knife/knife_hitwall1.wav", 1, 80, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KNIFE_SLASH", {"weapons/knife/knife_slash1.wav", "weapons/knife/knife_slash2.wav"}, 1, 60, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KNIFE_DRAW", "weapons/knife/knife_deploy1.wav", 1, 60, CHAN_STATIC)

SWEP.PlayerHitSounds = {"CW_KNIFE_HIT"}
SWEP.NPCHitSounds = {} -- key is npc class, value is table containing the sounds, if npc class key is not found within this table it will fall back to the sounds in PlayerHitSounds
SWEP.MiscHitSounds = {"CW_KNIFE_HITWALL"}

if CLIENT then
	local cw_customhud = GetConVar("cw_customhud")

	function SWEP:DrawHUD()
		local customHUD = cw_customhud:GetInt() >= 1
		local disableCrosshair, disableCustomHUD, disableTabDisplay = CustomizableWeaponry.callbacks.processCategory(self, "suppressHUDElements", customHUD)

		if not disableCrosshair then
			self:drawClumpSpread(ScrW() * 0.5, ScrH() * 0.5, 0.02, 255)
		end

		if not disableCustomHUD and cw_customhud:GetInt() >= 1 then
			self:drawCustomHUD()
		end

		if not disableTabDisplay then
			if self.dt.State == CW_CUSTOMIZE then
				self:drawTabDisplay()
			end

			CustomizableWeaponry.callbacks.processCategory(self, "drawToHUD", customHUD)
		end
	end
end

local SP = game.SinglePlayer()
local traceData = {}

function SWEP:isBackstab(ent)
	if not self.CanBackstab then
		return false
	end

	local ourEye = self.Owner:EyeAngles()
	ourEye.p = 0
	ourEye = ourEye:Forward()

	local ang = ent:EyeAngles()
	ang.p = 0
	ang = ang:Forward()

	return ang:Dot(ourEye) >= 0.7
end

function SWEP:getDealtDamage(ent)
	local dmg = type(self.attackDamage) == "table" and math.random(self.attackDamage[1], self.attackDamage[2]) or self.attackDamage

	if ent:IsPlayer() and self:isBackstab(ent) then
		dmg = dmg * self.BackstabDamageMultiplier
	end

	local velocity = self.Owner:GetVelocity()
	dmg = dmg + velocity:Length() / self.VelocityToDamageDivider

	return dmg
end

function SWEP:emitSoundFromList(list)
	self:EmitSound(list[math.random(1, #list)], 75, 100)
end

function SWEP:createBloodEffect(ent, trace)
	local effectData = EffectData()
	effectData:SetOrigin(trace.HitPos)
	effectData:SetEntity(ent)

	util.Effect("BloodImpact", effectData)
end

local bullet = {}
bullet.Damage = 0
bullet.Force = 0
bullet.Tracer = 0
bullet.Num = 1
bullet.Spread = Vector(0, 0, 0)

local noNormal = Vector(1, 1, 1)

function SWEP:IndividualThink()
	if (SP and SERVER) or IsFirstTimePredicted() then
		local ct = CurTime()

		if self.attackDamageTime and ct > self.attackDamageTime and ct < self.attackDamageTime + self.attackDamageTimeWindow then
			self.Owner:LagCompensation(true)
				local eyeAngles = self.Owner:EyeAngles()
				local forward = eyeAngles:Forward()
				traceData.start = self.Owner:GetShootPos()
				traceData.endpos = traceData.start + forward * self.attackRange

				traceData.mins = self.attackAABB[1]:Rotate(eyeAngles)
				traceData.maxs = self.attackAABB[2]:Rotate(eyeAngles)

				traceData.filter = self.Owner

				local trace = util.TraceHull(traceData)
			self.Owner:LagCompensation(false)

			if trace.Hit then
				local entity = trace.Entity

				if (IsValid(entity)) then
					if (!entity:IsPlayer() and !entity:IsNPC()) then
						bullet.Src = traceData.start
						bullet.Dir = forward

						self.Owner:FireBullets(bullet)

						if SERVER then
							local phys = entity:GetPhysicsObject()

							if IsValid(phys) then
								phys:AddVelocity(forward * self.PushVelocity)
							end
						end
					end

					if SERVER then
						local forceDir = noNormal

						if !entity:IsPlayer() and !entity:IsNPC() then
							forceDir = trace.HitNormal
						end

						local damageInfo = DamageInfo()
						damageInfo:SetDamage(self:getDealtDamage(entity))
						damageInfo:SetAttacker(self.Owner)
						damageInfo:SetInflictor(self)
						damageInfo:SetDamageForce(forward * self.DamageForce * forceDir)
						damageInfo:SetDamagePosition(trace.HitPos)

						entity:TakeDamageInfo(damageInfo)
					end
				end

				if (!self:DoImpactEffect(trace)) then
					util.Decal(self.ImpactDecal, trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
				end

				self.attackDamageTime = nil
			end
		end
	end
end

function SWEP:canAttack(skipQuickGrenade)
	if not self:canFireWeapon(1) then
		return false
	end

	if not skipQuickGrenade and self.Owner:KeyDown(IN_USE) then
		if CustomizableWeaponry.quickGrenade.canThrow(self) then
			CustomizableWeaponry.quickGrenade.throw(self)
			return false
		end
	end

	if not self:canFireWeapon(2) then
		return false
	end

	if not self:canFireWeapon(3) then
		return false
	end

	return true
end

function SWEP:beginAttack(timeToImpact, damageWindow, damage, range, aabb)
	self.attackDamageTime = CurTime() + timeToImpact
	self.attackDamageTimeWindow = damageWindow
	self.attackDamage = damage
	self.attackRange = range
	self.attackAABB = aabb
end

function SWEP:PrimaryAttack()
	if not self:canAttack() then
		return
	end

	if IsFirstTimePredicted() then
		self:beginAttack(self.PrimaryAttackImpactTime, self.PrimaryAttackDamageWindow, self.PrimaryAttackDamage, self.PrimaryAttackRange, self.PrimaryHitAABB)
		self:sendWeaponAnim("slash_primary", self.FireAnimSpeed)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end

	local time = CurTime() + self.PrimaryAttackDelay
	self:SetNextPrimaryFire(time)
	self:SetNextSecondaryFire(time)
	self.ReloadWait = time
end

function SWEP:SecondaryAttack()
	if not self:canAttack(true) then
		return
	end

	if IsFirstTimePredicted() then
		self:beginAttack(self.SecondaryAttackImpactTime, self.SecondaryAttackDamageWindow, self.SecondaryAttackDamage, self.SecondaryAttackRange, self.SecondaryHitAABB)
		self:sendWeaponAnim("slash_secondary", self.FireAnimSpeed)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end

	local time = CurTime() + self.SecondaryAttackDelay
	self:SetNextPrimaryFire(time)
	self:SetNextSecondaryFire(time)
	self.ReloadWait = time
end

function SWEP:DoImpactEffect(trace)
	local entity = IsValid(trace.Entity) and trace.Entity
	local sounds = self.MiscHitSounds

	if (entity) then
		if (entity:IsPlayer()) then
			sounds = self.PlayerHitSounds
			self:createBloodEffect(entity, trace)
		elseif (entity:IsNPC()) then
			sounds = self.NPCHitSounds[entity:GetClass()] or self.PlayerHitSounds
			self:createBloodEffect(entity, trace)
		end
	end

	self:emitSoundFromList(sounds)
end