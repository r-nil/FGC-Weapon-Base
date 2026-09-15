SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "peashooter"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.ViewModelFOV = 54
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 0

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 1,
    Delay = 0.1,
    NumShots = 1,
    Automatic = false,
    ClipSize = 1,
    DefaultClip = 0,
    Ammo = "nune",
}

SWEP.Secondary = {
    Ammo = "nune",
    Automatic = true
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "peashooter",
    server = "fgc", -- ofc from fgc,
    description = "this P.O.S. deals 1 damage per shot\nshoot things - no ammo needed"
}

SWEP.BaseCone = 0

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 0

SWEP.MaxAimExpand = 0
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 0
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0
SWEP.RecoilStayDuration = 0
SWEP.RecoilCollapseUnit = 0

SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.NoAmmoDisplay = true

--[[
    ] developer 1
    0:Stopped sound ^thrusters\rocket00.wav
    1:Stopped sound npc\scanner\scanner_scan_loop2.wav
    2:Stopped sound player\footsteps\concrete1.wav
    4:Stopped sound physics\concrete\concrete_impact_bullet1.wav
    5:Stopped sound )weapons\pistol\pistol_fire2.wav

    did atomix just use developer 1 and stopsound to copy the pistol sound? really?
]]

function SWEP:EmitFireSound()
    self:EmitSound(")weapons/pistol/pistol_fire2.wav", 80, math.random(142,154))
end

function SWEP:TakeAmmo() end
function SWEP:CanPrimaryAttack() return true end

function SWEP:DoRecoil() end