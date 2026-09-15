SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "fittydos"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_sg552.mdl"
SWEP.WorldModel = "models/weapons/w_rif_sg552.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 14,
    Delay = 0.08,
    NumShots = 1,
    Automatic = true,
    ClipSize = 30,
    DefaultClip = 30,
    Ammo = "smg1",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "fittydos",
    server = "fgc", -- ofc from fgc
    description = "light em up\nwith a ratta tat tat"
}

SWEP.HoldType = "ar2"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_SG552.Single")
end

SWEP.BaseCone = 0.0005

SWEP.AimExpandUnit = 0.035 * 90
SWEP.AimExpandStayDuration = 0.45
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 100
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.01
SWEP.RecoilStayDuration = 0.5
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 0.2
SWEP.AimCrouchMul = 0.2

SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.Ironsights_FOV = 0.35

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-self:GetRecoilMul() * 6 - 0.5, self:GetRand(-0.4,0.4),0))
    local ang = self:GetViewPunch(false) + Angle(-3.5,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)
end

function SWEP:SecondaryAttack() self:SecondaryAttack_Ironsights() end