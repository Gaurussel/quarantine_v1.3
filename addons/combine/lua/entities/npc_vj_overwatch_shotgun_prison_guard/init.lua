AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/player/hazmat/hazmat1980_npc.mdl" -- Leave empty if using more than one model
ENT.StartHealth = 250
ENT.MeleeAttackDamage = 25
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 10000 -- How far it can see
ENT.SightAngle = 80 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.Bleeds = false -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = false -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = false -- Does it spawn a decal when damaged?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Flinches = 1 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 12 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.MoveWhenDamagedByEnemy = true -- Should the SNPC move when being damaged by an enemy?
ENT.MoveWhenDamagedByEnemySCHED1 = SCHED_FORCED_GO_RUN -- The schedule it runs when MoveWhenDamagedByEnemy code is ran | The first # in math.random
ENT.MoveWhenDamagedByEnemySCHED2 = SCHED_FORCED_GO_RUN -- The schedule it runs when MoveWhenDamagedByEnemy code is ran | The second # in math.random
ENT.NextMoveWhenDamagedByEnemy1 = 3 -- Next time it moves when getting damaged | The first # in math.random
ENT.HasShootWhileMoving = true -- Can it shoot while moving?
ENT.AnimTbl_ShootWhileMovingRun = {ACT_RUN_AIM} -- Animations it will play when shooting while running | NOTE: Weapon may translate the animation that they see fit!
ENT.AnimTbl_ShootWhileMovingWalk = {ACT_WALK_AIM} -- Animations it will play when shooting while walking | NOTE: Weapon may translate the animation that they see fit!
ENT.NextMoveWhenDamagedByEnemy2 = 3.5 -- Next time it moves when getting damaged | The second # in math.random
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = false -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.NextThrowGrenadeTime1 = 10 -- Time until it runs the throw grenade code again | The first # in math.random
ENT.NextThrowGrenadeTime2 = 30 -- Time until it runs the throw grenade code again | The second # in math.random
ENT.Passive_RunOnDamage = false -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.ThrowGrenadeChance = 1 -- Chance that it will throw the grenade | Set to 1 to throw all the time
ENT.GrenadeAttackThrowDistance = 1000 -- How far it can throw grenades
ENT.GrenadeAttackThrowDistanceClose = 500 -- How close until it stops throwing grenades
ENT.AnimTbl_GrenadeAttack = {"grenThrow"} -- Grenade Attack Animations
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
ENT.FollowPlayer = false
ENT.BringFriendsOnDeath = true -- Should the SNPC's friends come to its position before it dies?
ENT.BringFriendsOnDeathDistance = 250 -- How far away does the signal go? | Counted in World Units
ENT.BringFriendsOnDeathLimit = 2 -- How many people should it call? | 0 = Unlimited
ENT.AlertFriendsOnDeath = true -- Should the SNPCs allies get alerted when it dies? | Its allies will also need to have this variable set to true!
ENT.AlertFriendsOnDeathDistance = 400 -- How far away does the signal go? | Counted in World Units
ENT.AlertFriendsOnDeathLimit = 5 -- How many people should it alert?
ENT.AnimTbl_AlertFriendsOnDeath = {ACT_RANGE_ATTACK1} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
ENT.IsGuard = true -- If set to false, it will attempt to stick to its current position at all times
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by it or it witnesses another ally killed by it
ENT.BecomeEnemyToPlayerLevel = 100 -- Any time the player does something bad, the NPC's anger level raises by 1, if it surpasses this, it will become enemy!
ENT.DisableChasingEnemy = false
ENT.EnemyReset = true
ENT.LastSeenEnemyTimeUntilReset = 1 -- Time until it resets its enemy if its current enemy is not visible
ENT.CombatFaceEnemy = true -- If enemy is exists and is visible
	-- ====== Pose Parameter Variables ====== --
ENT.HasPoseParameterLooking = true -- Does it look at its enemy using poseparameters?
ENT.PoseParameterLooking_CanReset = true -- Should it reset its pose parameters if there is no enemies?
ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw poseparameters (Y)
ENT.PoseParameterLooking_InvertRoll = false -- Inverts the roll poseparameters (Z)
ENT.PoseParameterLooking_TurningSpeed = 10 -- How fast does the parameter turn?

ENT.DropWeaponOnDeath = false -- Should it drop its weapon on death?

ENT.DeathCorpseFade = true -- Fades the ragdoll on death
ENT.DeathCorpseFadeTime = 5 -- How much time until the ragdoll fades | Unit = Seconds

	-- ====== Medic Code ====== --
ENT.IsMedicSNPC = false -- Is this SNPC a medic? Does it heal other friendly friendly SNPCs, and players(If friendly)
ENT.AnimTbl_Medic_GiveHealth = {ACT_SPECIAL_ATTACK1} -- Animations is plays when giving health to an ally
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
"military_voice/orushie_k_bou_vosmoshna_opasnost.mp3",
"military_voice/orushie_k_boyu.mp3",
"military_voice/ogon.mp3",
"military_voice/kontakt_s_celiu.mp3",
"military_voice/kontak.mp3",
"military_voice/kontakt_s_severa_zapada.mp3",
"military_voice/otkrivau_ogon.mp3",
"military_voice/otkrivau_ogon_2.mp3",
"military_voice/doloshite_kod_2_1_B.mp3"}

ENT.SoundTbl_Death = {
"military_voice/peredaite_semie_shto_ya_ih_lubil.mp3",
"npc/combine_soldier/die2.wav",
"npc/combine_soldier/die3.wav"}

ENT.SoundTbl_Pain = {
"military_voice/ya_ranen.mp3",
"military_voice/maslinu.mp3",
"npc/combine_soldier/pain3.wav"}

ENT.SoundTbl_CombatIdle = {
"military_voice/atakuut.mp3",
"military_voice/perezarashaus.mp3"}

ENT.SoundTbl_OnKilledEnemy = {
"military_voice/cel_unichtoshena.mp3",
"military_voice/plohishi_nakazani.mp3"}

ENT.SoundTbl_GrenadeAttack = {
"military_voice/granata.mp3",
"military_voice/granata_poshla.mp3",
"military_voice/ostoroshno_granata.mp3",
"military_voice/kidau_granatu.mp3"}

--[[ENT.SoundTbl_Suppressing = {
"SNPC/Overwatch_Soldier/suppressing1.wav",
"SNPC/Overwatch_Soldier/suppressing2.wav",
"SNPC/Overwatch_Soldier/suppressing3.wav",
"SNPC/Overwatch_Soldier/suppressing4.wav",
"SNPC/Overwatch_Soldier/suppressing5.wav",
"SNPC/Overwatch_Soldier/suppressing6.wav"}]]

--[[ENT.SoundTbl_AllyDeath = {
"SNPC/Overwatch_Soldier/mandown1.wav",
"SNPC/Overwatch_Soldier/mandown2.wav",
"SNPC/Overwatch_Soldier/mandown3.wav",
"SNPC/Overwatch_Soldier/mandown4.wav",
"SNPC/Overwatch_Soldier/mandown5.wav",
"SNPC/Overwatch_Soldier/mandown6.wav",
"SNPC/Overwatch_Soldier/mandown7.wav"}]]

ENT.SoundTbl_LostEnemy = {
"military_voice/vnimatelno.mp3",
"military_voice/gotovtes_k_kontaktu.mp3",
"military_voice/ne_strelyat_gotovnost_k_kontaktu.mp3",
"military_voice/nepar_5_vse_chisto_v_kvadrate.mp3",
"military_voice/pepegruppirovatsa.mp3",
"military_voice/plohishi_nakazani.mp3"}

ENT.SoundTbl_IdleDialogue = {
"military_voice/doloshite_kod_2_1_B.mp3",
"military_voice/doloshite_o_nalichii_ugrosi.mp3",
"military_voice/chimi_changi.mp3"}

ENT.SoundTbl_IdleDialogueAnswer = {
"military_voice/est_vse_сhisto.mp3",
"military_voice/kod_1_2.mp3",
"military_voice/kod_2_1_3.mp3",
"military_voice/kod_2_3_1.mp3",
"military_voice/kod_4_1_priem.mp3",
"military_voice/kod_20_45.mp3",
"military_voice/est.mp3",
"military_voice/chisto.mp3",
"military_voice/omega_vse_chisto.mp3",
"military_voice/2_0_chisto.mp3",
"military_voice/2_1_chisto.mp3",
"military_voice/11_3.mp3",
"military_voice/415_zdu_ukazaniy.mp3",
"military_voice/charli_ya_gotov.mp3",
"military_voice/nepar_5_vse_chisto_v_kvadrate"}

ENT.SoundTbl_FootStep = {
"npc/combine_soldier/gear1.wav",
"npc/combine_soldier/gear2.wav",
"npc/combine_soldier/gear3.wav",
"npc/combine_soldier/gear4.wav",
"npc/combine_soldier/gear5.wav",
"npc/combine_soldier/gear6.wav"}

	-- ====== Sound Pitch ====== --
-- Higher number = Higher pitch | Lower number = Lower pitch
-- Highest number is 254
	-- !!! Important variables !!! --
ENT.UseTheSameGeneralSoundPitch = true 
	-- If set to true, it will make the game decide a number when the SNPC is created and use it for all sound pitches set to "UseGeneralPitch"
	-- It picks the number between the two variables below:
ENT.GeneralSoundPitch1 = 97
ENT.GeneralSoundPitch2 = 97
ENT.NextResetEnemyT = 5
	-- This two variables control any sound pitch variable that is set to "UseGeneralPitch"
	-- To not use these variables for a certain sound pitch, just put the desired number in the specific sound pitch
ENT.FootStepPitch1 = "UseGeneralPitch"
ENT.FootStepPitch2 = "UseGeneralPitch"
ENT.BreathSoundPitch1 = "UseGeneralPitch"
ENT.BreathSoundPitch2 = "UseGeneralPitch"
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
ENT.AfterHealSoundPitch1 = "UseGeneralPitch"
ENT.AfterHealSoundPitch2 = "UseGeneralPitch"
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
ENT.MeleeAttackSoundPitch1 = "UseGeneralPitch"
ENT.MeleeAttackSoundPitch2 = "UseGeneralPitch"
ENT.ExtraMeleeSoundPitch1 = "UseGeneralPitch"
ENT.ExtraMeleeSoundPitch2 = "UseGeneralPitch"
ENT.MeleeAttackMissSoundPitch1 = "UseGeneralPitch"
ENT.MeleeAttackMissSoundPitch2 = "UseGeneralPitch"
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
ENT.ImpactSoundPitch1 = "UseGeneralPitch"
ENT.ImpactSoundPitch2 = "UseGeneralPitch"
ENT.DamageByPlayerPitch1 = "UseGeneralPitch"
ENT.DamageByPlayerPitch2 = "UseGeneralPitch"
ENT.DeathSoundPitch1 = "UseGeneralPitch"
ENT.DeathSoundPitch2 = "UseGeneralPitch"
-- To add rest of the SNPC and get full list of the function, you need to decompile VJ Base.

function ENT:CustomInitialize()
	self:SetSkin(3)
end

/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/