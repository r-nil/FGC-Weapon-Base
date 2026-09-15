SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "peeneind"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_twoface"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 12,
    Delay = 0.0625,
    NumShots = 1,
    Automatic = true,
    ClipSize = 50,
    DefaultClip = 150,
    Ammo = "smg1",
}

SWEP.Secondary = {
    Ammo = "nune",
    Automatic = true
}

SWEP.OriginalInfo = {
    category = "twoface",
    name = "peeneind",
    server = "fgc", -- ofc from fgc,
    description = "just shoot it"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_P90.Single")
end

SWEP.BaseCone = 0

SWEP.BaseCone = 0.002 * 90

SWEP.AimExpandUnit = 0.015 * 90
SWEP.AimExpandStayDuration = 0.25
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 0.5 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.HoldType = "smg"

SWEP.Slot = 2
SWEP.SlotPos = 3

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-1 * self:GetRecoilMul() * 0.075 - 0.5, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.04 - 0.2,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)

    self:SetRecoilAdder(self:GetRecoilAdder() + 0.01)
end