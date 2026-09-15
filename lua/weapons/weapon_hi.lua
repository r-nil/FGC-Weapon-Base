SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "hi"

SWEP.Category = "FGC_cere"
SWEP.Spawnable = true

SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = Model("models/weapons/c_arms.mdl")
SWEP.FGCDisplayModel = Model("models/player/group01/male_07.mdl")
SWEP.FGCAngleOffset = Angle(0,90,0)
SWEP.FGCUnhoverDisplayDistance = 500
SWEP.FGCUnhoverDisplayAngles = Angle(0,180,0)

SWEP.Primary = {
    Ammo = "nune",
    ClipSize = -1,
    Automatic = false
}
SWEP.Secondary = {
    Ammo = "nune",
    ClipSize = -1
}

SWEP.OriginalInfo = {
    category = "cere",
    name = "hi",
    server = "fgc", -- ofc from fgc
    description = "hi"
}

SWEP.UseHands = false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.HoldType = "normal"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.NoAmmoDisplay = true

FGCWEP_NOTGUN()

function SWEP:PrimaryAttack()
    if CLIENT then return end
    self:GetOwner():EmitSound("vo/npc/male01/hi0" .. math.Round(self:GetRand(10,20) / 10) .. ".wav",75,math.Rand(75,135))
end