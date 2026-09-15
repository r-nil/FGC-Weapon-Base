SWEP.Base = "weapon_fgcbase_melee"
SWEP.FGCMelee = true
SWEP.IsMelee = true

SWEP.Primary.Ammo = "nune"
SWEP.Primary.DefaultClip = 0

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = "models/weapons/c_arms.mdl"

SWEP.ViewModelFOV = 54
SWEP.ShowWorldModel = false

SWEP.Secondary.Automatic = true
SWEP.Primary.Automatic = true

SWEP.MeleeComboDamage = 24
SWEP.MeleeDamage = 12
SWEP.MeleeInaccurate = 0
SWEP.MeleeSize = 10
SWEP.MeleeRange = 48
SWEP.MeleeDelay = 0.9
SWEP.SwingTime = 0.2

SWEP.ComboCount = 2
SWEP.ComboResetTime = 0.1

SWEP.HoldType = "fist"
SWEP.NPCHoldType = "melee"

function SWEP:SetUpNetVars()
    self:NetworkVar("Float", 25, "SwingEnd")
    self:NetworkVar("Int", 31, "Combo")
end

function SWEP:BulletCallback(att,tr,dmg)

    dmg:SetDamageType(DMG_GENERIC)

    if tr.Hit then
        self:EmitFireSound(true,self.LastAnim)
    end

    local combo = self:GetCombo()
    if IsValid(tr.Entity) then
        if self:GetCombo() <= self.ComboCount then
            self:SetCombo(self:GetCombo() + 1)
        end
    end

    self:MeleeCallback(att,tr,dmg,self.LastAnim)

    return {
        tracer = false,
        impact = false,
        damage = true,
        ragdoll_impact = true
    }
end

function SWEP:EmitFireSound(hit)
    if hit then
        self:EmitSound("Flesh.ImpactHard")
    else
        self:EmitSound("WeaponFrag.Throw")
    end
end

function SWEP:GetBulletInfo(dmg,num,cone)
    return {
        Src = self:GetBulletSrc(),
        Dir = self:GetBulletDir(),
        Spread = cone,
        Num = num,
        Damage = self:GetCombo() > self.ComboCount and self.MeleeComboDamage or self.MeleeDamage,
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

function SWEP:SendFireAnim(right)
	local anim = right and "fists_right" or "fists_left"
    if self:GetCombo() > self.ComboCount then
        anim = "fists_uppercut"
        self:SetCombo(0)
    end

    self.LastAnim = anim

    local owner = self:GetOwner()
    if owner:IsPlayer() then
		local vm = owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end

function SWEP:PrimaryAttack(right)
    if not self:CanPrimaryAttack() then return end
    self:SendWeaponAnimation(right)
    self:EmitFireSound(false)

    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)

    self:SetSwingEnd(CurTime() + self.SwingTime)

    self:SetNextPrimaryFire(CurTime() + self.MeleeDelay)
    self:SetNextSecondaryFire(CurTime() + self.MeleeDelay)
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack(true)
end

function SWEP:Deploy(...)
    if self:PreDeploy() then return false end

    self:SetNextReload(0)
	self:SetReloadFinish(0)
    self:SetIronsights(false)

	self:SetViewPunchP(0)
	self:SetViewPunchY(0)

    self:SetCombo(0)
    self:SetSwingEnd(0)

	self:SendDeployAnim()

    if self:PostDeploy() then return false end

    return true
end

function SWEP:Think()
    self:PreThink()

    if self.IdleAnimation and self.IdleAnimation <= CurTime() then
        self.IdleAnimation = nil
        local vm = self:GetOwner():GetViewModel()
        if IsValid(vm) then
            vm:SendViewModelMatchingSequence(vm:LookupSequence( "fists_idle_0" .. math.random(1,2)))
            self.IdleAnimation = CurTime() + self:SeqDur()
        end
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

    if SERVER and CurTime() > self:GetNextPrimaryFire() + self.ComboResetTime then
		self:SetCombo(0)
	end

    self:PostThink()
end

function SWEP:OnDrop()
	self:Remove() -- You can't drop fists
end

function SWEP:SendDeployAnim()
    local vm = self:GetOwner():GetViewModel()
    if IsValid(vm) then
        vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
        self.IdleAnimation = CurTime() + self:SeqDur()
    end
end