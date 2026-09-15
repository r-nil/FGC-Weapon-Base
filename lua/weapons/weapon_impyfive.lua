SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "impy five"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 15,
    Delay = 0.075,
    NumShots = 1,
    Automatic = true,
    ClipSize = 30,
    DefaultClip = 30,
    Ammo = "smg1",
}

SWEP.Secondary = {
    Ammo = "nune",
    Automatic = true
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "impy five",
    server = "fgc", -- ofc from fgc,
    description = "pew pew (accurate when crouching still)"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_MP5Navy.Single")
end

SWEP.BaseCone = 0

SWEP.BaseCone = 0.01 * 90

SWEP.AimExpandUnit = 0.015 * 2.25 * 90
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
SWEP.SlotPos = 2

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-1 * self:GetRecoilMul() * 0.075 - 0.5, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.04 - 0.2,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)

    self:SetRecoilAdder(self:GetRecoilAdder() + 0.05)
end