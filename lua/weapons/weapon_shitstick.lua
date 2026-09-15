SWEP.Base = "weapon_fgcbase_melee"

SWEP.PrintName = "pipe"

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel	= "models/props_canal/mattpipe.mdl"

SWEP.ViewModelFOV = 54

SWEP.OriginalInfo = {
    category = "phil",
    name = "pipe",
    server = "fgc", -- ofc from fgc
    description = "(hits you with pipe) oops!\nhas hilariously high knockback on props"
}

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.HoldType = "melee2"

SWEP.SwingTime = 0

SWEP.MeleeDamage = 75
SWEP.MeleeInaccurate = 0
SWEP.MeleeSize = 32
SWEP.MeleeRange = 125
SWEP.MeleeDelay = 1
SWEP.SwingTime = 0

function SWEP:GetBulletInfo(dmg,num,cone)
    return {
        Src = self:GetBulletSrc(),
        Dir = self:GetBulletDir(),
        Spread = cone,
        Num = num,
        Damage = dmg,
        Force = 10,
        Attacker = self:GetOwner(),
        Callback = self.BulletCallback,
        filter = self:GetBulletFilter(),
        HullSize = self.MeleeSize,
        Distance = self.MeleeRange,
        Inflictor = self,
        CanHitWater = self.HitWater,
        Tracer = "",
        IsMelee = true
    }
end

function SWEP:EmitFireSound(hit)
    if hit then
        self:EmitSound("Weapon_Crowbar.Melee_Hit")
    else
        self:EmitSound("WeaponFrag.Throw")
    end
end