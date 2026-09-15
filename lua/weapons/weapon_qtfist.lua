SWEP.Base = "weapon_fgcbase_fists"

SWEP.PrintName = "quicktime fists"

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.OriginalInfo = {
    category = "atom",
    name = "quicktime fists",
    server = "fgc", -- ofc from fgc
    description = "'standing here, I realize'\nhold leftclick to do what you'd expect\nlanding 20 consecutive hits rewards a powerful uppercut"
}

SWEP.ComboCount = 18

SWEP.MeleeComboDamage = 65
SWEP.MeleeDamage = 3
SWEP.MeleeInaccurate = 0
SWEP.MeleeSize = 10
SWEP.MeleeRange = 64
SWEP.MeleeDelay = 0.076
SWEP.SwingTime = 0.05

SWEP.Slot = 5
SWEP.SlotPos = 50

SWEP.ComboResetTime = 0.1

function SWEP:SetUpNetVars()
    self:NetworkVar("Float", 25, "SwingEnd")
    self:NetworkVar("Int", 31, "Combo")
    self:NetworkVar("Bool", 30, "Alt")
end

function SWEP:MeleeCallback(_,_,dmg,anim)
    if anim == "fists_uppercut" then
        dmg:SetDamage(math.Round(self:GetRand(50,65)))
    else
        dmg:SetDamage(math.Round(self:GetRand(10,30) / 10))
    end
end

function SWEP:PrimaryAttack(right)
    if not self:CanPrimaryAttack() then return end

    right = self:GetAlt()
    self:SetAlt(not self:GetAlt())

    if self:GetCombo() > self.ComboCount then
        self.FireAnimSpeed = 1
        self.SecondaryFireAnimSpeed = 1
        self:SetSwingEnd(CurTime() + 0.2)

        self:SetNextPrimaryFire(CurTime() + 1.2)
        self:SetNextSecondaryFire(CurTime() + 1.2)
    else
        self.FireAnimSpeed = 2
        self.SecondaryFireAnimSpeed = 2
        self:SetSwingEnd(CurTime() + self.SwingTime)

        self:SetNextPrimaryFire(CurTime() + self.MeleeDelay)
        self:SetNextSecondaryFire(CurTime() + self.MeleeDelay)
    end

    self:SendWeaponAnimation(right)
    self:EmitFireSound(false)

    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)
    if owner:IsPlayer() then
        owner:ViewPunch(Angle(self:GetRand(-0.1,0.3),self:GetRand(-0.4,0.4),0))
    end
end

function SWEP:EmitFireSound(hit,anim)
    if hit then
        if anim == "fists_uppercut" then self:EmitSound("weapons/mortar/mortar_explode3.wav") return end
        self:EmitSound("Flesh.ImpactHard")
    else
        self:EmitSound("WeaponFrag.Throw")
    end
end