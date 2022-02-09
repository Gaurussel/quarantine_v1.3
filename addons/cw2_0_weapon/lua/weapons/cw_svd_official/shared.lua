AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

CustomizableWeaponry:registerAmmo("7.62x54MMR", "7.62x54MMR", 7.62, 54)

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "SVD"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.IronsightPos = Vector(-3.178, -4.77, 1.472)
	SWEP.IronsightAng = Vector(0.257, 0, 0)
	
	SWEP.ShortDotPos = Vector(-3.177, -5.531, 0.56)
	SWEP.ShortDotAng = Vector(0, 0, 0)
	
	SWEP.NXSPos = Vector(-3.178, -3.3, 0.333)
	SWEP.NXSAng = Vector(0, 0, 0)

	SWEP.PSOPos = Vector(-2.967, -0.885, 0.694)
	SWEP.PSOAng = Vector(-0.732, 0.488, 0)
	
	SWEP.ACOGPos = Vector(-3.214, -4.753, 0.367)
	SWEP.ACOGAng = Vector(-0.973, -0.317, 0)

	SWEP.AlternativePos = Vector(-0.24, 0, -0.48)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.DrawTraditionalWorldModel = false
	SWEP.WM = "models/cw2/rifles/svd_world.mdl"
	SWEP.WMPos = Vector(-1, -1, 0.5)
	SWEP.WMAng = Vector(0, 0, 180)

	SWEP.ViewModelMovementScale = 1.15
	SWEP.CustomizationMenuScale = 0.019

	SWEP.IconLetter = "b"
	killicon.AddFont("cw_svd_official", "CW_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "muzzleflash_m14"
	SWEP.PosBasedMuz = false
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = -2, y = 0, z = -3}
	SWEP.SightWithRail = true
	
	SWEP.BoltBone = "Bolt"
	SWEP.BoltShootOffset = Vector(0, 4.669, 0.144)
	SWEP.OffsetBoltOnBipodShoot = true

	SWEP.AttachmentModelsVM = {
		["md_schmidt_shortdot"] = {model = "models/cw2/attachments/schmidt.mdl", bone = "Base", pos = Vector(-0.468, -5.356, -3.155), angle = Angle(-1.966, -87.372, 1.379), size = Vector(0.8, 0.8, 0.8)},
		["md_pso1"] = {model = "models/cw2/attachments/pso.mdl", bone = "Base", pos = Vector(-0.116, -4.847, -2.024), angle = Angle(-1.966, -177.372, -1.032), size = Vector(0.8, 0.8, 0.8)},
		["md_nightforce_nxs"] = {model = "models/cw2/attachments/l96_scope.mdl", bone = "Base", pos = Vector(-0.176, 0.194, 2.404), angle = Angle(-1.966, -87.373, 1.378), size = Vector(1.1, 1.1, 1.1)},
		["md_pbs1"] = {model = "models/cw2/attachments/pbs1.mdl", bone = "Base", pos = Vector(1.427, 27.118, -2.033), angle = Angle(0, -177.01, -2.658), size = Vector(0.699, 0.699, 0.699)},
		["md_acog"] = {model = "models/wystan/attachments/2cog.mdl", bone = "Base", pos = Vector(-0.505, -6.011, -3.149), angle = Angle(1.965, 3.263, 1.378), size = Vector(0.8, 0.8, 0.8)}
	}
	
	SWEP.BackupSights = {["md_acog"] = {[1] = Vector(-3.21, -4.753, -0.515), [2] = Vector(-0.973, -0.317, 0)}}

	SWEP.PSO1AxisAlign = {right = -1.32, up = 2.49, forward = 90 + 2.2}
	SWEP.SchmidtShortDotAxisAlign = {right = -2.09, up = 2.93, forward = 0}
	SWEP.NXSAlign = {right = -2.09, up = 2.93, forward = 0}
end

SWEP.MuzzleVelocity = 880 -- in meter/s

SWEP.LuaViewmodelRecoil = true
SWEP.LuaViewmodelRecoilOverride = true
SWEP.LuaVMRecoilAxisMod = {vert = 1, hor = 5, roll = 3, forward = 2, pitch = 1}

SWEP.PreventQuickScoping = true
SWEP.QuickScopeSpreadIncrease = 0.3

--SWEP.Attachments = {[1] = {header = "Sight", offset = {300, -50},  atts = {"md_kobra", "md_eotech", "md_aimpoint"}},
--	[2] = {header = "Barrel", offset = {-175, -100}, atts = {"md_pbs1"}},
--	[3] = {header = "Handguard", offset = {-100, 200}, atts = {"md_foregrip"}}}

SWEP.RailBGs = {main = 1, on = 0, off = 1}

SWEP.Attachments = {[1] = {header = "Sight", offset = {950, -500},  atts = {"md_schmidt_shortdot", "md_pso1", "md_acog", "md_nightforce_nxs"}},
	[2] = {header = "Barrel", offset = {-300, -100}, atts = {"md_pbs1"}},
	["+reload"] = {header = "Ammo", offset = {950, 0}, atts = {"am_magnum", "am_matchgrade"}}}

SWEP.Animations = {fire = {"shoot", "shoot2"},
	reload = "reload",
	idle = "idle",
	draw = "draw"}
	
SWEP.Sounds = {draw = {{time = 0, sound = "CW_FOLEY_MEDIUM"}},

	reload = {
		{time = 0.93, sound = "CW_SVD_OFFICIAL_MAGOUT"},
		{time = 1.1, sound = "CW_FOLEY_LIGHT"},
		{time = 1.8, sound = "CW_SVD_OFFICIAL_MAGIN_PARTIAL"},
		{time = 1.98, sound = "CW_SVD_OFFICIAL_MAGIN"},
		{time = 2.24, sound = "CW_SVD_OFFICIAL_MAGTAP"},
		{time = 2.83, sound = "CW_SVD_OFFICIAL_BOLTPULL"},
		{time = 3.04, sound = "CW_SVD_OFFICIAL_BOLTFORWARD"},
		{time = 3.38, sound = "CW_FOLEY_MEDIUM"}
	}
}

SWEP.SpeedDec = 40

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.SetHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cw2/rifles/svd.mdl"
SWEP.WorldModel		= "models/cw2/rifles/svd_world.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "5.56x45MM"

SWEP.FireDelay = 0.15
SWEP.FireSound = "CW_SVD_OFFICIAL_FIRE"
SWEP.FireSoundSuppressed = "CW_SVD_OFFICIAL_FIRE_SUPPRESSED"
SWEP.Recoil = 1.85

SWEP.HipSpread = 0.06
SWEP.AimSpread = 0.0015
SWEP.VelocitySensitivity = 2.5
SWEP.MaxSpreadInc = 0.08
SWEP.SpreadPerShot = 0.015
SWEP.SpreadCooldown = 0.25
SWEP.Shots = 1
SWEP.Damage = 53
SWEP.DeployTime = 0.85
SWEP.NearWallDistance = 40

SWEP.ReloadSpeed = 1
SWEP.ReloadTime = 2.5
SWEP.ReloadTime_Empty = 4
SWEP.ReloadHalt = 2.6
SWEP.ReloadHalt_Empty = 4
SWEP.SnapToIdlePostReload = true

function SWEP:checkAttachmentDependency()
	-- wrap around this method to enable the rail when no sight attachment is active
	self.BaseClass.checkAttachmentDependency(self)
	
	if CLIENT then
		if not self:isAttachmentActive("sights") then			
			self.CW_VM:SetBodygroup(1, 0)
		end
	end
end