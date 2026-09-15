SWEP.Base = "weapon_fgcbase_fists"

SWEP.PrintName = "fists op"

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "fists op",
    server = "fgc", -- ofc from fgc
    description = "garry pls nerf\nobligatory mgr:revengeance joke"
}

SWEP.ComboCount = 1

SWEP.MeleeComboDamage = 65
SWEP.MeleeDamage = 3
SWEP.MeleeInaccurate = 0
SWEP.MeleeSize = 10
SWEP.MeleeRange = 96
SWEP.MeleeDelay = 0
SWEP.SwingTime = 0

SWEP.Slot = 0
SWEP.SlotPos = 50

SWEP.ComboResetTime = 0.1

function SWEP:MeleeCallback(_,_,dmg,anim)
    if anim == "fists_uppercut" then
        dmg:SetDamage(self:GetRand(100, 100000))
    else
        dmg:SetDamage(self:GetRand(50, 50000))
    end
end