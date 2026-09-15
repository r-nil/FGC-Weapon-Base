SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "pew228"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 35,
    Delay = 0.125,
    NumShots = 1,
    Automatic = false,
    ClipSize = 13,
    DefaultClip = 13,
    Ammo = "Pistol",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "pew228",
    server = "fgc", -- ofc from fgc
    description = "one of the best pistols\nshoot"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_P228.Single")
end

SWEP.HoldType = "revolver"

SWEP.BaseCone = 0.01 * 90

SWEP.AimExpandUnit = 0.5
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0.04 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.2
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Slot = 1
SWEP.SlotPos = 3

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-6 * self:GetRecoilMul() * 0.075 - 0.5, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.5,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)

    self:SetRecoilAdder(self:GetRecoilAdder() + 0.03)
end