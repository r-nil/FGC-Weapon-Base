SWEP.Base = "weapon_fgcbase_shotgun"

SWEP.PrintName = "atogun1"

FGCWEP_NOTGUN()

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = 10000,
    Delay = 0.05,
    NumShots = 16,
    Automatic = true,
    ClipSize = 150,
    DefaultClip = 150,
    Ammo = "buckshot",
    NoNextSecondaryFire = true
}

SWEP.Secondary = {
    Damage = 250000,
    Delay = 0.3,
    NumShots = 16,
    Automatic = false,
    NoNextPrimaryFire = true
}

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "atogun1",
    server = "fgc", -- ofc from fgc
    description = "wew lad"
}

SWEP.HoldType = "shotgun"

SWEP.NoAmmoDisplay = true
SWEP.BaseCone = 0.125 * 90

SWEP.Slot = 3
SWEP.SlotPos = 1

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_XM1014.Single")
end

function SWEP:SendFireAnim(secondary)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:DoRecoil() end
function SWEP:PrimaryAttack() self.BaseCone = 0.125 * 90 self.BaseClass.PrimaryAttack(self) end
function SWEP:SecondaryAttack() self.BaseCone = 0.25 * 90 self:SecondaryAttack_Shoot() end