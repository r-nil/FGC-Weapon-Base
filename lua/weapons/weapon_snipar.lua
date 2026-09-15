SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "snipar"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 80,
    Delay = 2,
    NumShots = 1,
    Automatic = false,
    ClipSize = 5,
    DefaultClip = 5,
    Ammo = "357",
    NoNextSecondaryFire = true
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "cere",
    name = "snipar",
    server = "fgc", -- ofc from fgc
    description = "be polite. be efficient. have a plan to kill everyone you meet."
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_Scout.Single")
    --self:EmitSound("weapons/357_fire2.wav",75,50)
end

SWEP.HoldType = "ar2"

SWEP.BaseCone = 0

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0.04 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Ironsights_FOV = 9

SWEP.Slot = 1
SWEP.SlotPos = 2

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-6 * self:GetRecoilMul() * 0.075 - 1.6, self:GetRand(-0.1,0.1)))
end

function SWEP:SecondaryAttack()
    self:SecondaryAttack_Ironsights()
end