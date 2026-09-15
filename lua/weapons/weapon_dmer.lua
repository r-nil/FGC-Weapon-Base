SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "dmer"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 45,
    Delay = 0.25,
    NumShots = 1,
    Automatic = false,
    ClipSize = 17,
    DefaultClip = 17,
    Ammo = "ar2",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "cere",
    name = "dmer",
    server = "fgc", -- ofc from fgc
    description = "wip in progress"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_Galil.Single")
end

SWEP.BaseCone = 0.002 * 90

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0.25
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 0.04 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Ironsights_FOV = 0.5

SWEP.HoldType = "ar2"

SWEP.Slot = 3
SWEP.SlotPos = 2

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-6 * self:GetRecoilMul() * 0.075 - 0.5, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.1,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)

    self:SetRecoilAdder(self:GetRecoilAdder() + 0.02)
end

function SWEP:SecondaryAttack()
    self:SecondaryAttack_Ironsights()
end