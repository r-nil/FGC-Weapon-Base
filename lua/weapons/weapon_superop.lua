SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "super op"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel	= "models/weapons/w_snip_awp.mdl"


SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 0

SWEP.Category = "FGC_atom_admin_legacy"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = math.huge,
    Delay = 0,
    NumShots = 50,
    Automatic = true,
    ClipSize = 1,
    DefaultClip = 0,
    Ammo = "ar2",
}

SWEP.Secondary = {
    Ammo = "nune",
    Automatic = true
}

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "super op",
    server = "fgc", -- ofc from fgc,
    description = "<color=0,0,0,255>nil</color>: this weapon was removed so i don't know the description\nbut heres my description:\nshoot these motherfuckers who likes sniping"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_AWP.Single")
end

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

SWEP.NoAmmoDisplay = true

--SWEP.Tracer = "fgccooltracer"
SWEP.Tracer = "Tracer"
SWEP.TracerTravelSpeed = 6000

function SWEP:TakeAmmo() end
function SWEP:CanPrimaryAttack() return true end

function SWEP:DoRecoil() end

SWEP.Ironsights_FOV = 20

SWEP.Slot = 3
SWEP.SlotPos = 2

function SWEP:SecondaryAttack()
    self:SecondaryAttack_Ironsights()
end