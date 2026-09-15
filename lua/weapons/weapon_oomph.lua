SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "womp-45"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 19,
    Delay = 0.085,
    NumShots = 1,
    Automatic = true,
    ClipSize = 25,
    DefaultClip = 25,
    Ammo = "smg1",
}

SWEP.Secondary = {
    Ammo = "nune",
    Automatic = true
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "womp-45",
    server = "fgc", -- ofc from fgc,
    description = "just another smg"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_UMP45.Single")
end

SWEP.BaseCone = 0

SWEP.BaseCone = 0.05 * 90

SWEP.AimExpandUnit = 0.01859375 * 90
SWEP.AimExpandStayDuration = 0.25
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 0.5 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.HoldType = "revolver"

SWEP.Slot = 2
SWEP.SlotPos = 2

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-0.5 * self:GetRecoilMul() - 0.5, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.04 - 0.2,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)

    self:SetRecoilAdder(self:GetRecoilAdder() + 0.05)
end