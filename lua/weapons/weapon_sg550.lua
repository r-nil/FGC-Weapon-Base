SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "5fitty"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 48,
    Delay = 0.25,
    NumShots = 1,
    Automatic = true,
    ClipSize = 30,
    DefaultClip = 30,
    Ammo = "357",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "5fitty",
    server = "fgc", -- ofc from fgc
    description = "bullet launcher\nauto sniper wtf!"
}

SWEP.HoldType = "ar2"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_SG550.Single")
end

SWEP.BaseCone = 0.0005

SWEP.AimExpandUnit = 0.04 * 90
SWEP.AimExpandStayDuration = 0.45
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 100
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.04
SWEP.RecoilStayDuration = 0.5
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 0.2
SWEP.AimCrouchMul = 0.2

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Ironsights_FOV = 10

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-self:GetRecoilMul() * 9 - 0.5, self:GetRand(-0.4,0.4),0))
    local ang = self:GetViewPunch(false) + Angle(-13.5,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)
end

function SWEP:SecondaryAttack() self:SecondaryAttack_Ironsights() end