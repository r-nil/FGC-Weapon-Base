SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "beamcutter"

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 5

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 3,
    Delay = 0.06,
    NumShots = 1,
    Automatic = true,
    ClipSize = -1,
    DefaultClip = 600,
    Ammo = "ar2",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "beamcutter",
    server = "fgc", -- ofc from fgc
    description = "quake thundergun\nrequires good tracking to deal damage"
}

SWEP.HoldType = "ar2"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("npc/vort/attack_shoot.wav",100,115,0.5)
end

SWEP.BaseCone = 0

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 0
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 0
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0
SWEP.RecoilStayDuration = 0
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 0
SWEP.AimCrouchMul = 0

SWEP.Slot = 2
SWEP.SlotPos = 4

SWEP.Tracer = "ToolTracer"
SWEP.HullSize = 1

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-0.1, 0,0))
end