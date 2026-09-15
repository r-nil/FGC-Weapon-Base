SWEP.Base = "weapon_fgcbase_melee"

SWEP.PrintName = "knoife v2"

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.OriginalInfo = {
    category = "atom",
    name = "knoife v2",
    server = "fgc", -- ofc from fgc
}

SWEP.Secondary.Automatic = true

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.HoldType = "knife"

SWEP.SwingTime = 0

SWEP.MeleeRange = 48
SWEP.MeleeSize = 32

function SWEP:EntityFaceBack(ent)
    local angle = self:GetOwner():GetAngles().y - ent:GetAngles().y
    if angle < -180 then angle = 360 + angle end
    if angle <= 90 and angle >= -90 then return true end
    return false
end

function SWEP:EmitFireSound() end

function SWEP:MeleeCallback(att,tr,dmg,anim)
    dmg:SetDamageType(DMG_SLASH + DMG_NEVERGIB)

    local hit = tr.Hit
    local secondary = self.ALTFire

    self.Backstab = false
    if IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsNextBot() or tr.Entity:IsPlayer()) then
        self.Backstab = self:EntityFaceBack(tr.Entity)

        self:EmitSound(secondary and "Weapon_Knife.Stab" or "Weapon_Knife.Hit")
    elseif tr.Hit then
        self:EmitSound("Weapon_Knife.HitWall")
    else
        self:EmitSound("Weapon_Knife.Slash")
    end

    tr.HitGroup = HITGROUP_GENERIC

    if secondary then
        dmg:SetDamage(self.Backstab and 180 or 60)
    else
        dmg:SetDamage(self.Backstab and 90 or (self:GetNextPrimaryFire() + 0.4 > CurTime()) and 25 or 40)
    end

    self:SetNextPrimaryFire(CurTime() + (secondary and 1 or hit and 0.5 or 0.4))
end

function SWEP:BulletCallback(att,tr,dmg)

    dmg:SetDamageType(DMG_CLUB)

    if tr.Hit then
        self:SendWeaponAnimation(true)
        self:EmitFireSound(true)
    end
    self:MeleeCallback(att,tr,dmg)

    if tr.HitWorld and not tr.HitSky then
        util.Decal("ManhackCut", tr.StartPos - tr.Normal, tr.HitPos + tr.Normal, true)
        local effectdata = EffectData()
        effectdata:SetOrigin(tr.HitPos + tr.HitNormal)
        effectdata:SetStart(tr.StartPos)
        effectdata:SetSurfaceProp(tr.SurfaceProps)
        effectdata:SetDamageType(DMG_SLASH)
        effectdata:SetHitBox(tr.HitBox)
        effectdata:SetNormal(tr.HitNormal)
        effectdata:SetEntity(tr.Entity)
        effectdata:SetAngles(tr.Normal:Angle())
        util.Effect("Impact", effectdata)
    end

    return {
        tracer = false,
        impact = false,
        damage = true,
        ragdoll_impact = true
    }
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    self:EmitFireSound(false)

    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)

    self:Swung()

    --self:SetNextPrimaryFire(CurTime() + self.MeleeDelay)
end

function SWEP:SecondaryAttack()
    if not self:CanPrimaryAttack() then return end
    self:EmitFireSound(false)

    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)
        
    self:Swung(true)

    --self:SetNextPrimaryFire(CurTime() + self.MeleeDelay)
end

function SWEP:SendFireAnim(hit)
    local secondary = self.ALTFire
    if secondary then
	    self:SendWeaponAnim(hit and ACT_VM_SECONDARYATTACK or ACT_VM_MISSCENTER)
    else
        self:SendWeaponAnim(hit and (self.Backstab and ACT_VM_MISSCENTER or ACT_VM_PRIMARYATTACK) or ACT_VM_PRIMARYATTACK)
    end
end

function SWEP:Swung(secondary)
    self.MeleeRange = secondary and 48 or 64
    self.ALTFire = secondary
    self:SendWeaponAnimation(false)

    self:ShootBullets(self.MeleeDamage,1,self.MeleeInaccurate)
end