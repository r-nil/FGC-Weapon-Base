-- internally this uses bullet instead of eyetrace which is probably used by the original swep_del

SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "deletion"

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = Model("models/weapons/c_arms.mdl")

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
    category = "atom_admin",
    name = "deletion",
    server = "fgc", -- ofc from fgc
    description = "[dissolves object with mind]\nlmb removes | rmb disintegrates\nhold reload to target yourself\n\nbe VERY CAREFUL on where you aim the remove.\nSomething could break if you're not careful!"
}

SWEP.UseHands = false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.HoldType = "normal"
SWEP.NPCHoldType = "melee"

SWEP.Slot = 1
SWEP.SlotPos = 2

FGCWEP_NOTGUN()

SWEP.Slot = 4
SWEP.SlotPos = 10

SWEP.Distance = 150

SWEP.NoAmmoDisplay = true

SWEP.Capabilities = CAP_WEAPON_MELEE_ATTACK1

SWEP.ALTFire = false
function SWEP:PrimaryAttack()
    self.ALTFire = self:GetOwner():IsNPC() and true or false
    self.BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
    self.ALTFire = true
    self:SecondaryAttack_Shoot()
end

function SWEP:GetBulletInfo(dmg,num,cone)
    return {
        Src = self:GetBulletSrc(),
        Dir = self:GetBulletDir(),
        Spread = 0,
        Num = 1,
        Damage = 0,
        Force = 0,
        Attacker = self:GetOwner(),
        Callback = self.BulletCallback,
        filter = self:GetBulletFilter(),
        HullSize = 0,
        Distance = self.Distance,
        Inflictor = self,
        CanHitWater = self.HitWater,
        TracerSpeed = self.TracerTravelSpeed,
        Tracer = "",
        IsMelee = true
    }
end

function SWEP:BulletCallback(att,tr,dmg)
    if SERVER then
        if not self.ALTFire then
            SafeRemoveEntity(tr.Entity)

            return {
                tracer = false,
                impact = false,
                damage = true,
                ragdoll_impact = false
            }
        else
            local ent = tr.Entity
            if att:IsPlayer() and att:KeyDown(IN_RELOAD) then ent = att end
            if not IsValid(ent) then return {
                tracer = false,
                impact = false,
                damage = true,
                ragdoll_impact = false
            } end

            ent:SetHealth(1)

            if ent:IsPlayer() then
                ent:GodDisable()
                ent:SetNWBool("build_pvp",false)

                timer.Simple(0,function()
                    if IsValid(ent) then ent:Dissolve(4) end
                end)
            else
                ent:Dissolve(4)
            end

            dmg:SetDamage(math.huge)
			dmg:SetDamageType(DMG_DISSOLVE)
			dmg:SetDamageForce(Vector(0,0,1)) -- not vec origin or console fucking complains

            return {
                tracer = false,
                impact = false,
                damage = true,
                ragdoll_impact = false
            }
        end
    end

    return {
        tracer = false,
        impact = false,
        damage = false,
        ragdoll_impact = false
    }
end

function SWEP:Think()
    if self:GetOwner():IsNPC() then
        self:GetOwner():ClearCondition(13)
        self:GetOwner():ClearCondition(17)
        self:GetOwner():ClearCondition(18)
        self:GetOwner():ClearCondition(20)

        self:GetOwner():CapabilitiesAdd(CAP_FRIENDLY_DMG_IMMUNE)
        self:GetOwner():CapabilitiesRemove(CAP_WEAPON_MELEE_ATTACK1)
        self:GetOwner():CapabilitiesRemove(CAP_INNATE_MELEE_ATTACK1)

        local enemy = self:GetOwner():GetEnemy()
        if IsValid(enemy) and enemy:NearestPoint(self:GetBulletSrc()):Distance(self:GetBulletSrc()) < 140 and self:CanPrimaryAttack() then
            self:NPCShoot_Primary()
            self:GetOwner():SetSchedule(SCHED_MELEE_ATTACK1)
        elseif IsValid(enemy) and not self:GetOwner():IsCurrentSchedule(SCHED_CHASE_ENEMY) then
            self:GetOwner():SetSchedule(SCHED_CHASE_ENEMY)
        end
    end
    self.BaseClass.Think(self)
end