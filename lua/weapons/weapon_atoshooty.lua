SWEP.Base = "weapon_fgcbase_shotgun"

SWEP.PrintName = "atoshooty"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 10,
    Delay = 0.3,
    NumShots = 7,
    Automatic = true,
    ClipSize = 8,
    DefaultClip = 8,
    Ammo = "buckshot",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "atoshooty",
    server = "fgc", -- ofc from fgc
    description = "have a spasm attack"
}

SWEP.HoldType = "shotgun"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_XM1014.Single")
end

SWEP.BaseCone = 0.1 * 90

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
SWEP.SlotPos = 2

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-3, self:GetRand(-1,1)))
    local ang = self:GetViewPunch(false) + Angle(-0.8 * self:GetRecoilMul() - 0.2,0,0)
    self:SetViewPunch(ang)
end