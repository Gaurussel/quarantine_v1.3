AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Топор"
	SWEP.CSMuzzleFlashes = false
	
	SWEP.DisableSprintViewSimulation = true
	
	SWEP.DrawTraditionalWorldModel = true
	SWEP.WM = "models/weapons/HL2meleepack/w_axe.mdl"
	SWEP.WMPos = Vector(0.25, -1, 1.25)
	SWEP.WMAng = Vector(-10, 90, 180)
	
	SWEP.IconLetter = "j"
	killicon.AddFont("cw_extrema_ratio_official", "CW_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
end

SWEP.Animations = {
	slash_primary = "misscenter1",
	slash_secondary = "misscenter1",
	--draw = "draw"
}

SWEP.Sounds = {
	--misscenter1 = {{time = 0.01, sound = "Canister.ImpactHard"}},
	--stab = {{time = 0.1, sound = "Canister.ImpactHard"}},
	--draw = {{time = 0.1, sound = "WeaponFrag.Roll"}},
}

-- SWEP.PlayerHitSounds = Sound("npc/ministrider/flechette_flesh_impact1.wav")
-- SWEP.MiscHitSounds = Sound( "Canister.ImpactHard" )

SWEP.PlayerHitSounds = {"Flesh.ImpactHard"}
SWEP.MiscHitSounds = {"Canister.ImpactHard"}

SWEP.Slot = 0
SWEP.SprintingEnabled = true
SWEP.SlotPos = 0
SWEP.Base = "cw_melee_base"
SWEP.Category = "CW 2.0"

SWEP.Author			= "Gaurussel"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 67
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= Model( "models/weapons/HL2meleepack/v_axe.mdl" )
SWEP.WorldModel		= Model( "models/weapons/HL2meleepack/w_axe.mdl" )

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.HoldType = "melee2"

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.PrimaryAttackDelay = 1
SWEP.SecondaryAttackDelay = 2

SWEP.PrimaryAttackDamage = {30, 35}
SWEP.SecondaryAttackDamage = {65, 70}

SWEP.PrimaryAttackRange = 65

SWEP.HolsterTime = 0.4
SWEP.DeployTime = 0.6

SWEP.PrimaryAttackImpactTime = 0.2
SWEP.PrimaryAttackDamageWindow = 0.15

SWEP.SecondaryAttackImpactTime = 0.2
SWEP.SecondaryAttackDamageWindow = 0.15

SWEP.PrimaryHitAABB = {
	Vector(-10, -5, -5),
	Vector(10, 5, 5)
}