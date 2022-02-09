AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/humans/rajio/female_01.mdl", "models/humans/rajio/female_02.mdl", "models/humans/rajio/female_03.mdl", "models/humans/rajio/female_04.mdl", "models/humans/rajio/female_05.mdl", "models/humans/rajio/female_06.mdl", "models/humans/rajio/male_01.mdl", "models/humans/rajio/male_02.mdl", "models/humans/rajio/male_03.mdl", "models/humans/rajio/male_04.mdl", "models/humans/rajio/male_05.mdl", "models/humans/rajio/male_06.mdl", "models/humans/rajio/male_07.mdl", "models/humans/rajio/male_08.mdl", "models/humans/rajio/male_09.mdl",}
ENT.StartHealth = 100
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 1000 -- How far it can see
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
ENT.DropWeaponOnDeath = false -- Should it drop its weapon on death?

ENT.DeathCorpseFade = true -- Fades the ragdoll on death
ENT.DeathCorpseFadeTime = 5 -- How much time until the ragdoll fades | Unit = Seconds

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
"snpc/elite_metro-cop/freeze.wav",
"snpc/elite_metro-cop/pointer01.wav",
"snpc/elite_metro-cop/pointer02.wav",
"snpc/elite_metro-cop/pointer03.wav",
"snpc/elite_metro-cop/shooter05.wav"}

ENT.SoundTbl_Death = {
"SNPC/Civil_Protection/die1.wav",
"SNPC/Civil_Protection/die2.wav",
"SNPC/Civil_Protection/die3.wav",
"SNPC/Civil_Protection/die4.wav",
"SNPC/Civil_Protection/die5.wav",
"SNPC/Civil_Protection/die6.wav",
"SNPC/Civil_Protection/die7.wav"}

ENT.SoundTbl_Pain = {
"snpc/elite_metro-cop/pain1.wav",
"snpc/elite_metro-cop/pain2.wav",
"snpc/elite_metro-cop/pain3.wav",
"snpc/elite_metro-cop/pain4.wav"}

ENT.SoundTbl_CombatIdle = {
"snpc/elite_metro-cop/takedown.wav",
"snpc/elite_metro-cop/getonground.wav",
"snpc/elite_metro-cop/dropweapon.wav",
"snpc/elite_metro-cop/pointer04.wav",
"snpc/elite_metro-cop/hiding01.wav",
"snpc/elite_metro-cop/hiding02.wav",
"snpc/elite_metro-cop/hiding03.wav",
"snpc/elite_metro-cop/hiding04.wav",
"snpc/elite_metro-cop/hiding05.wav",
"snpc/elite_metro-cop/shooter01.wav",
"snpc/elite_metro-cop/shooter02.wav",
"snpc/elite_metro-cop/shooter03.wav",
"snpc/elite_metro-cop/shooter04.wav"}

ENT.SoundTbl_Idle = {
"snpc/elite_metro-cop/mc1que_feelinggood.wav",
"snpc/elite_metro-cop/mc1que_peoplesuck.wav",
"snpc/elite_metro-cop/mc1que_raise.wav",
"snpc/elite_metro-cop/mc1que_justthought.wav",
"snpc/elite_metro-cop/mc1que_goingtohell.wav",
"snpc/elite_metro-cop/mc1que_feetkillin.wav",
"snpc/elite_metro-cop/mc1que_everythingihoped.wav",
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

ENT.SoundTbl_OnGrenadeSight = {
"snpc/elite_metro-cop/cs_everybodyback.wav",
"snpc/elite_metro-cop/cs_fallback.wav",
"snpc/elite_metro-cop/cs_lookout.wav",
"snpc/elite_metro-cop/surprise1.wav",
"snpc/elite_metro-cop/surprise2.wav",
"snpc/elite_metro-cop/surprise3.wav",
"snpc/elite_metro-cop/surprise4.wav"}

ENT.SoundTbl_GrenadeAttack = {
"snpc/elite_metro-cop/deploy01.wav",
"snpc/elite_metro-cop/deploy02.wav",
"snpc/elite_metro-cop/deploy03.wav",
"snpc/elite_metro-cop/deploy04.wav",
"snpc/elite_metro-cop/deploy06.wav",}

ENT.SoundTbl_OnKilledEnemy = {
"snpc/elite_metro-cop/mc1que_career.wav",
"snpc/elite_metro-cop/mc1que_lastjob"} 

ENT.SoundTbl_AllyDeath = {
"snpc/elite_metro-cop/cs_mandown2"}


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