AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/animals/elephant.mdl" 
ENT.StartHealth = GetConVarNumber("vj_el_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackDistance = 105 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 330 -- How far the damage goes



ENT.HasExtraMeleeAttackSounds = true-- Set to true to use the extra melee attack sounds
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 900
ENT.MeleeAttackKnockBack_Forward2 = 900
ENT.MeleeAttackKnockBack_Up1 = 500 
ENT.MeleeAttackKnockBack_Up2 = 500-- Knockback Up Number
ENT.TimeUntilMeleeAttackDamage = 1.3 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 1 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = GetConVarNumber("vj_el_d")
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.Immune_CombineBall = true 

ENT.HasDeathAnimation = false -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {"die"} -- Death Animations
ENT.DeathAnimationTime = 4 -- Time until the SNPC spawns its corpse and gets removed
ENT.HasDeathRagdoll = true



ENT.PlayerFriendly = true -- When true, it will still attack If you attack to much, also this will make it friendly to rebels and characters like that
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.BecomeEnemyToPlayerLevel = 3 -- How many times does the player have to hit the SNPC for it to become enemy?
ENT.HasWorldShakeOnMove = true -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 0.9 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 2 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveRadius = 1900 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.4 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"elephant/woosh1.wav","elephant/woosh2.wav"}
ENT.SoundTbl_Idle = {"elephant/idle1.wav","elephant/idle2.wav"}
ENT.SoundTbl_Alert = {"elephant/toot.wav"}
ENT.SoundTbl_MeleeAttack = {"elephant/hunt1.wav","elephant/hunt2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"bear/woosh1.wav"}
ENT.SoundTbl_Pain = {"elephant/toot.wav"}
ENT.SoundTbl_Death = {""}

ENT.AlertSoundLevel = 150
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(190, 50, 240), Vector(-150, -50, 0))
end

function ENT:MultipleMeleeAttacks()
	local attack = 1
	if attack == 1 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
		self.MeleeAttackDistance = 105
		self.MeleeAttackDamageDistance = 330
		self.TimeUntilMeleeAttackDamage = 1.3
		self.NextAnyAttackTime_Melee = 1
		self.MeleeAttackDamage = GetConVarNumber("vj_el_d")
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackKnockBack_Forward1 = 900
		self.MeleeAttackKnockBack_Forward2 = 900
		self.MeleeAttackKnockBack_Up1 = 500
		self.MeleeAttackKnockBack_Up2 = 500
		self.MeleeAttackWorldShakeOnMiss = false
		self.SoundTbl_MeleeAttack = {"npc/antlion_guard/shove1.wav"}
		
		end
		end

		function ENT:CreateDeathCorpse(dmginfo,hitgroup)	

	self.HasDeathRagdoll = true -- Disable ragdoll
	self.HasDeathAnimation = false -- Disable death animation
	
	local gib = ents.Create( "prop_ragdoll" )
	gib:SetModel( "models/animal_ragd/piratecat_elephant.mdl" )
		gib:SetPos( self:LocalToWorld(Vector(0,0,0))) -- The Postion the model spawns
	gib:SetAngles( self:GetAngles() )
	gib:Spawn()
	end

		
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/