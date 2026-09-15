SWEP.Base = "weapon_fgcbase_shotgun"

SWEP.PrintName = "musket"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 150,
    Delay = 1,
    NumShots = 1,
    Automatic = true,
    ClipSize = 1,
    DefaultClip = 1,
    Ammo = "buckshot",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "musket",
    server = "fgc", -- ofc from fgc
    description = "high damage one shot rifle\nBANG!!!!!!"
}

SWEP.HoldType = "rpg"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_Shotgun.Double")
end

SWEP.BaseCone = 0

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0
SWEP.RecoilStayDuration = 0
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 0.35
SWEP.AimCrouchMul = 0.5

SWEP.ReloadDelay = 0.5

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ReloadSound = "Weapon_Shotgun.Reload"

SWEP.ReloadSpeed = 0.7

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-self:GetRecoilMul() * 0.25 - 6, self:GetRand(-0.4,0.4),self:GetRand(-0.3,0.3)))
end