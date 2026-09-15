SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "geewiz"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 38,
    Delay = 0.19,
    NumShots = 1,
    Automatic = true,
    ClipSize = 20,
    DefaultClip = 20,
    Ammo = "ar2",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "5fitty",
    server = "fgc", -- ofc from fgc
    description = "shoot em\nprimary"
}

SWEP.HoldType = "ar2"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_G3SG1.Single")
end

SWEP.BaseCone = 0.0005

SWEP.AimExpandUnit = 0.06 * 90
SWEP.AimExpandStayDuration = 0.45
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 100
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.04
SWEP.RecoilStayDuration = 0.5
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 0.2
SWEP.AimCrouchMul = 0.2

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Ironsights_FOV = 9.5

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-self:GetRecoilMul() * 2 - 0.1, self:GetRand(-0.05,0.05),0))
    local ang = self:GetViewPunch(false) + Angle(-13.5,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)
end

function SWEP:SecondaryAttack() self:SecondaryAttack_Ironsights() end