SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "akk11"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 29,
    Delay = 0.1,
    NumShots = 1,
    Automatic = true,
    ClipSize = 30,
    DefaultClip = 30,
    Ammo = "ar2",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "cere",
    name = "akk11",
    server = "fgc", -- ofc from fgc
    description = "akkarmnbb11 shoooot shooot"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_AK47.Single")
end

SWEP.BaseCone = 0.005 * 90

SWEP.AimExpandUnit = 0.02 * 90
SWEP.AimExpandStayDuration = 0.25
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 0.5 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.HoldType = "ar2"

SWEP.Slot = 2
SWEP.SlotPos = 3

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-6 * self:GetRecoilMul() * 0.075 - 0.5, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.13 - 0.1,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)

    self:SetRecoilAdder(self:GetRecoilAdder() + 0.05)
end