SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "awg"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_aug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_aug.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 23,
    Delay = 0.1,
    NumShots = 1,
    Automatic = true,
    ClipSize = 28,
    DefaultClip = 28,
    Ammo = "ar2",
    NoNextSecondaryFire = true
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "cere",
    name = "awg",
    server = "fgc", -- ofc from fgc
    description = "do zoom thingy"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_AUG.Single")
end

SWEP.BaseCone = 0.005 * 90

SWEP.AimExpandUnit = 0.06 * 90
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

SWEP.Slot = 2
SWEP.SlotPos = 3

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-6 * self:GetRecoilMul() * 0.075 - 0.5, self:GetRand(-0.4,0.4)) * (self:GetIronsights() and 0.25 or 1))
    local ang = self:GetViewPunch(false) + Angle(-0.5,0,0) * self:GetRecoilMul() * (self:GetIronsights() and 0.25 or 1)
    self:SetViewPunch(ang)

    self:SetRecoilAdder(self:GetRecoilAdder() + 0.03 * (self:GetIronsights() and 0.25 or 1))
end

function SWEP:SecondaryAttack()
    self:SecondaryAttack_Ironsights()
end

function SWEP:GetConeExpandMul()
    return self.BaseClass.GetConeExpandMul(self) * (self:GetIronsights() and 0.25 or 1)
end