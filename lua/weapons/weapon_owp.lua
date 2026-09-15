SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "op"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel	= "models/weapons/w_snip_awp.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 100,
    Delay = 2,
    NumShots = 1,
    Automatic = false,
    ClipSize = 10,
    DefaultClip = 10,
    Ammo = "357",
    NoNextSecondaryFire = true
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "op",
    server = "fgc", -- ofc from fgc
    description = "big damage gun go blam\nsniping's a good job mate"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_AWP.Single")
end

SWEP.HoldType = "ar2"

SWEP.BaseCone = 0

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0.04 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Ironsights_FOV = 13.33333333333333

SWEP.Slot = 3
SWEP.SlotPos = 2

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-1,0,0))
end

function SWEP:SecondaryAttack()
    self:SecondaryAttack_Ironsights()
end

function SWEP:GetCone()
    return self:GetIronsights() and 0 or 0.004
end