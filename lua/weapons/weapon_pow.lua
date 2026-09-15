SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "pow420"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = 10000000000,
    Delay = 0.125,
    NumShots = 1,
    Automatic = false,
    ClipSize = 1,
    DefaultClip = 1,
    Ammo = "Pistol",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "pow420",
    server = "fgc", -- ofc from fgc
    description = "you only get one shot\nvery ouch"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_AWP.Single")
end

SWEP.HoldType = "revolver"

SWEP.BaseCone = 0

SWEP.AimExpandUnit = 0.5
SWEP.AimExpandStayDuration = 0.25
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

SWEP.Ironsights_FOV = 9

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-25, self:GetRand(-50,50),self:GetRand(-30,30)))
end

function SWEP:SecondaryAttack()
    self:SecondaryAttack_Ironsights()
end