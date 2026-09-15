SWEP.Base = "weapon_fgcbase_shotgun"

SWEP.PrintName = "shootgun"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 11,
    Delay = 1,
    NumShots = 8,
    Automatic = false,
    ClipSize = 8,
    DefaultClip = 8,
    Ammo = "buckshot",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "cere",
    name = "shootgun",
    server = "fgc", -- ofc from fgc
    description = "hi"
}

SWEP.HoldType = "shotgun"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_M3.Single")
end

SWEP.BaseCone = 0.07 * 90

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

SWEP.Slot = 4
SWEP.SlotPos = 2

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-3, self:GetRand(-1,1)))
    local ang = self:GetViewPunch(false) + Angle(-0.8 * self:GetRecoilMul() - 0.2,0,0)
    self:SetViewPunch(ang)
end