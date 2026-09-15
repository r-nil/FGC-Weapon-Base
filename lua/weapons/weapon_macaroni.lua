SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "macaroni"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 9,
    Delay = 0.05,
    NumShots = 1,
    Automatic = true,
    ClipSize = 32,
    DefaultClip = 32,
    Ammo = "smg1",
}

SWEP.Secondary = {
    Ammo = "nune",
    Automatic = true
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "macaroni",
    server = "fgc", -- ofc from fgc,
    description = "rapid shoot"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_MAC10.Single")
end

SWEP.BaseCone = 0

SWEP.BaseCone = 0.005 * 90

SWEP.AimExpandUnit = 0.00848 * 90 * 1.5
SWEP.AimExpandStayDuration = 0.25
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 0.15 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.HoldType = "revolver"

SWEP.Slot = 2
SWEP.SlotPos = 3

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-3 * self:GetRecoilMul() * 0.075 - 0.5, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.1 - 0.1,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)

    self:SetRecoilAdder(self:GetRecoilAdder() + 0.05)
end