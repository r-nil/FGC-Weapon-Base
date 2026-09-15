SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "jetpack"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = 20,
    Delay = 0.1,
    NumShots = 1,
    Automatic = true,
    ClipSize = 1,
    DefaultClip = 0,
    Ammo = "nune",
    NoNextSecondaryFire = true
}

SWEP.Secondary = {
    Ammo = "nune",
    Automatic = true,
    NoNextPrimaryFire = true
}

SWEP.OriginalInfo = {
    category = "cere_admin",
    name = "jetpack",
    server = "fgc", -- ofc from fgc
    description = "jump and right click to flyyyy"
}

SWEP.HoldType = "revolver"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_Glock.Single")
end

SWEP.BaseCone = 0.05 * 90

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0.1
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Slot = 1
SWEP.SlotPos = 3

SWEP.NoAmmoDisplay = true

function SWEP:TakeAmmo() end
function SWEP:CanPrimaryAttack() return true end

function SWEP:DoRecoil() end

function SWEP:SecondaryAttack()
    self:GetOwner():SetVelocity(vector_up * 2640 * FrameTime() / 2)
end