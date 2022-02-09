AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/police.mdl" -- Leave empty if using more than one model
ENT.StartHealth = GetConVarNumber("npc_vj_metro-cop_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 10000 -- How far it can see
ENT.SightAngle = 80 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Flinches = 1 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 12 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.MoveWhenDamagedByEnemy = true -- Should the SNPC move when being damaged by an enemy?
ENT.MoveWhenDamagedByEnemySCHED1 = SCHED_FORCED_GO_RUN -- The schedule it runs when MoveWhenDamagedByEnemy code is ran | The first # in math.random
ENT.MoveWhenDamagedByEnemySCHED2 = SCHED_FORCED_GO_RUN -- The schedule it runs when MoveWhenDamagedByEnemy code is ran | The second # in math.random
ENT.NextMoveWhenDamagedByEnemy1 = 3 -- Next time it moves when getting damaged | The first # in math.random
ENT.NextMoveWhenDamagedByEnemy2 = 3.5 -- Next time it moves when getting damaged | The second # in math.random
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.NextThrowGrenadeTime1 = 10 -- Time until it runs the throw grenade code again | The first # in math.random
ENT.NextThrowGrenadeTime2 = 15 -- Time until it runs the throw grenade code again | The second # in math.random
ENT.ThrowGrenadeChance = 1 -- Chance that it will throw the grenade | Set to 1 to throw all the time
ENT.GrenadeAttackThrowDistance = 1000 -- How far it can throw grenades
ENT.GrenadeAttackThrowDistanceClose = 500 -- How close until it stops throwing grenades
ENT.AnimTbl_GrenadeAttack = {"grenadeThrow"} -- Grenade Attack Animations
ENT.GrenadeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.GrenadeAttackAnimationStopAttacks = true -- Should it stop attacks for a certain amount of time?
ENT.GrenadeAttackEntity = "npc_grenade_frag" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.CallForBackUpOnDamage = true -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.CallForBackUpOnDamageDistance = 800 -- How far away the SNPC's call for help goes | Counted in World Units
ENT.CallForBackUpOnDamageUseCertainAmount = false -- Should the SNPC only call certain amount of people?
ENT.NextCallForBackUpOnDamageTime1 = 9 -- Next time it use the CallForBackUpOnDamage function | The first # in math.random
ENT.NextCallForBackUpOnDamageTime2 = 11 -- Next time it use the CallForBackUpOnDamage function | The second # in math.random

	-- ====== Medic Code ====== --
ENT.IsMedicSNPC = true -- Is this SNPC a medic? Does it heal other friendly friendly SNPCs, and players(If friendly)
ENT.AnimTbl_Medic_GiveHealth = {"Buttonfront"} -- Animations is plays when giving health to an ally
ENT.Medic_TimeUntilHeal = 0.7 -- Time until the ally receives health | Set to false to let the base decide the time
ENT.Medic_CheckDistance = 600 -- How far does it check for allies that are hurt? | World units
ENT.Medic_HealDistance = 100 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_HealthAmount = 25 -- How health does it give?
ENT.Medic_NextHealTime1 = 10 -- How much time until it can give health to an ally again | First number in the math.random
ENT.Medic_NextHealTime2 = 15 -- How much time until it can give health to an ally again | Second number in the math.random
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on

	-- ====== Sound File Paths ====== --
ENT.SoundTbl_Alert = {
"SNPC/Civil_Protection/alert1.wav",
"SNPC/Civil_Protection/alert2.wav",
"SNPC/Civil_Protection/alert3.wav",
"SNPC/Civil_Protection/alert4.wav",
"SNPC/Civil_Protection/alert5.wav",
"SNPC/Civil_Protection/alert6.wav",
"SNPC/Civil_Protection/alert7.wav",
"SNPC/Civil_Protection/alert8.wav",
"SNPC/Civil_Protection/alert9.wav",
"SNPC/Civil_Protection/alert10.wav",
"SNPC/Civil_Protection/alert11.wav"}

ENT.SoundTbl_Death = {
"SNPC/Civil_Protection/die1.wav",
"SNPC/Civil_Protection/die2.wav",
"SNPC/Civil_Protection/die3.wav",
"SNPC/Civil_Protection/die4.wav",
"SNPC/Civil_Protection/die5.wav",
"SNPC/Civil_Protection/die6.wav",
"SNPC/Civil_Protection/die7.wav"}

ENT.SoundTbl_Pain = {
"npc/metropolice/pain1.wav",
"npc/metropolice/pain2.wav",
"npc/metropolice/pain3.wav",
"npc/metropolice/pain4.wav"}

ENT.SoundTbl_CombatIdle = {
"SNPC/Civil_Protection/combat1.wav",
"SNPC/Civil_Protection/combat2.wav",
"SNPC/Civil_Protection/combat3.wav",
"SNPC/Civil_Protection/combat4.wav",
"SNPC/Civil_Protection/combat5.wav",
"SNPC/Civil_Protection/combat6.wav",
"SNPC/Civil_Protection/combat7.wav",
"SNPC/Civil_Protection/combat8.wav",
"SNPC/Civil_Protection/combat9.wav",
"SNPC/Civil_Protection/combat10.wav",
"SNPC/Civil_Protection/combat11.wav",
"SNPC/Civil_Protection/combat12.wav",
"SNPC/Civil_Protection/combat13.wav"}

ENT.SoundTbl_WeaponReload = {
"SNPC/Civil_Protection/cover1.wav",
"SNPC/Civil_Protection/cover2.wav",
"SNPC/Civil_Protection/cover3.wav",
"SNPC/Civil_Protection/cover4.wav",
"SNPC/Civil_Protection/cover5.wav"}

ENT.SoundTbl_OnKilledEnemy = {
"SNPC/Civil_Protection/killedenemy1.wav",
"SNPC/Civil_Protection/killedenemy2.wav",
"SNPC/Civil_Protection/killedenemy3.wav",
"SNPC/Civil_Protection/killedenemy4.wav",
"SNPC/Civil_Protection/killedenemy5.wav",
"SNPC/Civil_Protection/killedenemy6.wav",
"SNPC/Civil_Protection/killedenemy7.wav",
"SNPC/Civil_Protection/killedenemy8.wav",
"SNPC/Civil_Protection/killedenemy9.wav",
"SNPC/Civil_Protection/killedenemy10.wav",
"SNPC/Civil_Protection/killedenemy11.wav",
"SNPC/Civil_Protection/killedenemy12.wav",
"SNPC/Civil_Protection/killedenemy13.wav",
"SNPC/Civil_Protection/killedenemy14.wav",
"SNPC/Civil_Protection/killedenemy15.wav",
"SNPC/Civil_Protection/killedenemy16.wav",
"SNPC/Civil_Protection/killedenemy17.wav",
"SNPC/Civil_Protection/killedenemy18.wav"}

ENT.SoundTbl_OnGrenadeSight = {
"SNPC/Civil_Protection/grenadespotted1.wav",
"SNPC/Civil_Protection/grenadespotted2.wav",
"SNPC/Civil_Protection/grenadespotted3.wav",
"SNPC/Civil_Protection/grenadespotted4.wav",
"SNPC/Civil_Protection/grenadespotted5.wav",
"SNPC/Civil_Protection/grenadespotted6.wav",
"SNPC/Civil_Protection/grenadespotted7.wav"}

ENT.SoundTbl_Suppressing = {
"SNPC/Civil_Protection/suppressing1.wav",
"SNPC/Civil_Protection/suppressing2.wav",
"SNPC/Civil_Protection/suppressing3.wav",
"SNPC/Civil_Protection/suppressing4.wav"}

ENT.SoundTbl_LostEnemy = {
"SNPC/Civil_Protection/lostenemy1.wav",
"SNPC/Civil_Protection/lostenemy2.wav",
"SNPC/Civil_Protection/lostenemy3.wav",
"SNPC/Civil_Protection/lostenemy4.wav",
"SNPC/Civil_Protection/lostenemy5.wav",
"SNPC/Civil_Protection/lostenemy6.wav",
"SNPC/Civil_Protection/lostenemy7.wav",
"SNPC/Civil_Protection/lostenemy8.wav",
"SNPC/Civil_Protection/lostenemy9.wav"}

ENT.SoundTbl_Idle = {
"SNPC/Civil_Protection/idle1.wav",
"SNPC/Civil_Protection/idle2.wav",
"SNPC/Civil_Protection/idle3.wav",
"SNPC/Civil_Protection/idle4.wav",
"SNPC/Civil_Protection/idle_dispatch1.wav",
"SNPC/Civil_Protection/idle_dispatch2.wav",
"SNPC/Civil_Protection/idle_dispatch3.wav",
"SNPC/Civil_Protection/idle_dispatch4.wav",
"SNPC/Civil_Protection/idle_dispatch5.wav",
"SNPC/Civil_Protection/idle_dispatch6.wav",
"SNPC/Civil_Protection/idle_dispatch7.wav",
"SNPC/Civil_Protection/idle_dispatch8.wav",
"SNPC/Civil_Protection/idle_dispatch9.wav",
"SNPC/Civil_Protection/idle_dispatch10.wav",
"SNPC/Civil_Protection/idle_dispatch11.wav",
"SNPC/Civil_Protection/idle_dispatch12.wav",
"SNPC/Civil_Protection/idle_dispatch13.wav",
"SNPC/Civil_Protection/idle_dispatch14.wav"}

ENT.SoundTbl_IdleDialogue = {
"SNPC/Civil_Protection/question1.wav",
"SNPC/Civil_Protection/question2.wav",
"SNPC/Civil_Protection/question3.wav",
"SNPC/Civil_Protection/question4.wav"}

ENT.SoundTbl_IdleDialogueAnswer = {
"SNPC/Civil_Protection/answer1.wav",
"SNPC/Civil_Protection/answer2.wav",
"SNPC/Civil_Protection/answer3.wav",
"SNPC/Civil_Protection/answer4.wav",
"SNPC/Civil_Protection/answer5.wav",
"SNPC/Civil_Protection/answer6.wav",
"SNPC/Civil_Protection/answer7.wav"}

ENT.SoundTbl_AllyDeath = {
"SNPC/Civil_Protection/mandown1.wav",
"SNPC/Civil_Protection/mandown2.wav",
"SNPC/Civil_Protection/mandown3.wav",
"SNPC/Civil_Protection/mandown4.wav",
"SNPC/Civil_Protection/mandown5.wav",
"SNPC/Civil_Protection/mandown6.wav",
"SNPC/Civil_Protection/mandown7.wav"}


	-- ====== Sound Pitch ====== --
-- Higher number = Higher pitch | Lower number = Lower pitch
-- Highest number is 254
	-- !!! Important variables !!! --
ENT.UseTheSameGeneralSoundPitch = true 
	-- If set to true, it will make the game decide a number when the SNPC is created and use it for all sound pitches set to "UseGeneralPitch"
	-- It picks the number between the two variables below:
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100
	-- This two variables control any sound pitch variable that is set to "UseGeneralPitch"
	-- To not use these variables for a certain sound pitch, just put the desired number in the specific sound pitch
ENT.FootStepPitch1 = 100
ENT.FootStepPitch2 = 100
ENT.BreathSoundPitch1 = 100
ENT.BreathSoundPitch2 = 100
ENT.IdleSoundPitch1 = "UseGeneralPitch"
ENT.IdleSoundPitch2 = "UseGeneralPitch"
ENT.CombatIdleSoundPitch1 = "UseGeneralPitch"
ENT.CombatIdleSoundPitch2 = "UseGeneralPitch"
ENT.OnReceiveOrderSoundPitch1 = "UseGeneralPitch"
ENT.OnReceiveOrderSoundPitch2 = "UseGeneralPitch"
ENT.FollowPlayerPitch1 = "UseGeneralPitch"
ENT.FollowPlayerPitch2 = "UseGeneralPitch"
ENT.UnFollowPlayerPitch1 = "UseGeneralPitch"
ENT.UnFollowPlayerPitch2 = "UseGeneralPitch"
ENT.BeforeHealSoundPitch1 = "UseGeneralPitch"
ENT.BeforeHealSoundPitch2 = "UseGeneralPitch"
ENT.AfterHealSoundPitch1 = 100
ENT.AfterHealSoundPitch2 = 100
ENT.OnPlayerSightSoundPitch1 = "UseGeneralPitch"
ENT.OnPlayerSightSoundPitch2 = "UseGeneralPitch"
ENT.AlertSoundPitch1 = "UseGeneralPitch"
ENT.AlertSoundPitch2 = "UseGeneralPitch"
ENT.CallForHelpSoundPitch1 = "UseGeneralPitch"
ENT.CallForHelpSoundPitch2 = "UseGeneralPitch"
ENT.BecomeEnemyToPlayerPitch1 = "UseGeneralPitch"
ENT.BecomeEnemyToPlayerPitch2 = "UseGeneralPitch"
ENT.BeforeMeleeAttackSoundPitch1 = "UseGeneralPitch"
ENT.BeforeMeleeAttackSoundPitch2 = "UseGeneralPitch"
ENT.MeleeAttackSoundPitch1 = 100
ENT.MeleeAttackSoundPitch2 = 100
ENT.ExtraMeleeSoundPitch1 = 100
ENT.ExtraMeleeSoundPitch2 = 100
ENT.MeleeAttackMissSoundPitch1 = 100
ENT.MeleeAttackMissSoundPitch2 = 100
ENT.SuppressingPitch1 = "UseGeneralPitch"
ENT.SuppressingPitch2 = "UseGeneralPitch"
ENT.WeaponReloadSoundPitch1 = "UseGeneralPitch"
ENT.WeaponReloadSoundPitch2 = "UseGeneralPitch"
ENT.GrenadeAttackSoundPitch1 = "UseGeneralPitch"
ENT.GrenadeAttackSoundPitch2 = "UseGeneralPitch"
ENT.OnGrenadeSightSoundPitch1 = "UseGeneralPitch"
ENT.OnGrenadeSightSoundPitch2 = "UseGeneralPitch"
ENT.PainSoundPitch1 = "UseGeneralPitch"
ENT.PainSoundPitch2 = "UseGeneralPitch"
ENT.ImpactSoundPitch1 = 100
ENT.ImpactSoundPitch2 = 100
ENT.DamageByPlayerPitch1 = "UseGeneralPitch"
ENT.DamageByPlayerPitch2 = "UseGeneralPitch"
ENT.DeathSoundPitch1 = "UseGeneralPitch"
ENT.DeathSoundPitch2 = "UseGeneralPitch"

-- To add rest of the SNPC and get full list of the function, you need to decompile VJ Base.

/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/