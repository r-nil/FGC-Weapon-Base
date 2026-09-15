SWEP.Base = "weapon_fgcbase"
SWEP.FGCMelee = true
SWEP.IsMelee = true

SWEP.Primary.Ammo = "nune"
SWEP.Primary.DefaultClip = 0

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.MeleeDamage = 69
SWEP.MeleeInaccurate = 0
SWEP.MeleeSize = 4
SWEP.MeleeRange = 64
SWEP.MeleeDelay = 0.5
SWEP.SwingTime = 0.1

local nope = {Draw = false}
function SWEP:CustomAmmoDisplay() return nope end

function SWEP:EmitFireSound(hit)
    if hit then
        self:EmitSound("Weapon_Crowbar.Melee_HitWorld")
    else
        self:EmitSound("Weapon_Crowbar.Single")
    end
end

function SWEP:GetCone() return 0 end

function SWEP:MeleeCallback() end

function SWEP:BulletCallback(att,tr,dmg)

    dmg:SetDamageType(DMG_CLUB)

    if tr.Hit then
        self:SendWeaponAnimation(true)
        self:EmitFireSound(true)
    elseif self.SwingTime == 0 then
        self:EmitFireSound(false)
    end
    self:MeleeCallback(att,tr,dmg)

    return {
        tracer = false,
        impact = true,
        damage = true,
        ragdoll_impact = true
    }
end

function SWEP:GetBulletInfo(dmg,num,cone)
    return {
        Src = self:GetBulletSrc(),
        Dir = self:GetBulletDir(),
        Spread = cone,
        Num = num,
        Damage = dmg,
        Force = dmg / 70,
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

function SWEP:SendFireAnim(secondary)
	self:SendWeaponAnim(secondary and ACT_VM_HITCENTER or ACT_VM_MISSCENTER)
end

function SWEP:SetUpNetVars()
    self:NetworkVar("Float", 25, "SwingEnd")
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    self:SendWeaponAnimation(false)

    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)


    if not self.SwingTime or self.SwingTime == 0 then
        self:Swung()
    else
        self:EmitFireSound(false)
        self:SetSwingEnd(CurTime() + self.SwingTime)
    end

    self:SetNextPrimaryFire(CurTime() + self.MeleeDelay)
end

function SWEP:SecondaryAttack()
    
end

function SWEP:Think()
    self:PreThink()

    if self.IdleAnimation and self.IdleAnimation <= CurTime() then
        self.IdleAnimation = nil
        self:SendWeaponAnim(self.IdleActivity)
    end

	if self:GetOwner():IsNPC() then
        self:GetOwner():ClearCondition(13)
        self:GetOwner():ClearCondition(17)
        self:GetOwner():ClearCondition(18)
        self:GetOwner():ClearCondition(20)

        self:GetOwner():CapabilitiesAdd(CAP_FRIENDLY_DMG_IMMUNE)
        self:GetOwner():CapabilitiesRemove(CAP_WEAPON_MELEE_ATTACK1)
        self:GetOwner():CapabilitiesRemove(CAP_INNATE_MELEE_ATTACK1)

        self:OnMove()

        local enemy = self:GetOwner():GetEnemy()
        if IsValid(enemy) and enemy:NearestPoint(self:GetBulletSrc()):Distance(self:GetBulletSrc()) < self.MeleeRange and self:CanPrimaryAttack() then
            self:NPCShoot_Primary()
            self:GetOwner():SetSchedule(SCHED_MELEE_ATTACK1)
        elseif IsValid(enemy) and not self:GetOwner():IsCurrentSchedule(SCHED_CHASE_ENEMY) then
            self:GetOwner():SetSchedule(SCHED_CHASE_ENEMY)
        end
    end

    if self:GetSwingEnd() > 0 and self:GetSwingEnd() < CurTime() and (not game.SinglePlayer() or SERVER) then
        self:SetSwingEnd(0)
        self:Swung()
    end

    self:PostThink()
end

function SWEP:CanReload()
	return false
end


function SWEP:Deploy()
    if self:PreDeploy() then return false end

    self:SetNextReload(0)
	self:SetReloadFinish(0)
    self:SetIronsights(false)

	self:SetViewPunchP(0)
	self:SetViewPunchY(0)

	self:SendDeployAnim()

    self:SetSwingEnd(0)

    if self:PostDeploy() then return false end

    return true
end

function SWEP:IsSwinging()
    return self:GetSwingEnd() > 0
end

function SWEP:CanPrimaryAttack()
    return not self:IsSwinging() and self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:Swung()
    self:ShootBullets(self.MeleeDamage,1,self.MeleeInaccurate)
end