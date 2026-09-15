SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "atogun2" 

FGCWEP_NOTGUN()

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = 25,
    Delay = 0.025,
    NumShots = 50,
    Automatic = true,
    ClipSize = 300,
    DefaultClip = 300,
    Ammo = "357",
}

SWEP.Secondary = {
    Damage = 100,
    Delay = 0.05,
    NumShots = 100,
    Automatic = false,
}

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "atogun1",
    server = "fgc", -- ofc from fgc
    description = "revolver op"
}

SWEP.NoAmmoDisplay = true

SWEP.HoldType = "revolver"
SWEP.BaseCone = 0.25 * 90

SWEP.Slot = 1
SWEP.SlotPos = 3

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_357.Single")
end

function SWEP:SendFireAnim(secondary)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:DoRecoil() end
function SWEP:PrimaryAttack() self.BaseCone = 0.25 * 90 self.BaseClass.PrimaryAttack(self) end
function SWEP:SecondaryAttack() self.BaseCone = 0.01 * 90 self:SecondaryAttack_Shoot() end