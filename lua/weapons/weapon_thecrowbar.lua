SWEP.Base = "weapon_fgcbase_melee"

SWEP.PrintName = "the crowbar"

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel	= "models/weapons/w_crowbar.mdl"

SWEP.ViewModelFOV = 54

SWEP.OriginalInfo = {
    category = "atom",
    name = "the crowbar",
    server = "fgc", -- ofc from fgc
    description = "hey why's that guy running at me with a crowbar"
}

SWEP.Secondary.Automatic = true

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.HoldType = "melee"

SWEP.SwingTime = 0

SWEP.MeleeDamage = 25
SWEP.MeleeInaccurate = 0
SWEP.MeleeSize = 32
SWEP.MeleeRange = 750
SWEP.MeleeDelay = 0.0004
SWEP.SwingTime = 0

function SWEP:EmitFireSound(hit)
    if hit then
        self:EmitSound("Weapon_Crowbar.Melee_Hit")
    else
        self:EmitSound("Weapon_Crowbar.Single")
    end
end