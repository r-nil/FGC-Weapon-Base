SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "mwem"

SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_twoface"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 12,
    Delay = 0.061,
    NumShots = 1,
    Automatic = true,
    ClipSize = 100,
    DefaultClip = 300,
    Ammo = "smg1",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "twoface",
    name = "mwem",
    server = "fgc", -- ofc from fgc
    description = "spin and shoot"
}

SWEP.HoldType = "ar2"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_M249.Single")
end

SWEP.BaseCone = 0.012

SWEP.AimExpandUnit = 0.02 * 90
SWEP.AimExpandStayDuration = 0.45
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 100
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.05
SWEP.RecoilStayDuration = 0.5
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 0.6
SWEP.AimCrouchMul = 0.6

SWEP.Slot = 2
SWEP.SlotPos = 3

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-self:GetRecoilMul() * 12 - 0.3, self:GetRand(-0.5,0.5),0))
    local ang = self:GetViewPunch(false) + Angle(-3,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)
end