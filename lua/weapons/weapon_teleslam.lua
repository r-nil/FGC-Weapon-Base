SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "tele slam"

if CLIENT then language.Add("weapon_telebait","") end

FGCWEP_NOTGUN()

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"
SWEP.FGCDisplayDistance = 12
SWEP.FGCAngleOffset = Angle(-90,-90,0)
SWEP.FGCUnhoverDisplayAngles = Angle(0,180,0)

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.UseHands = true

SWEP.Primary = {
    Ammo = "nune",
    ClipSize = 1,
    DefaultClip = 5,
    Automatic = false,
    Delay = 1.5
}
SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "tele slam",
    server = "fgc", -- ofc from fgc
    description = "no description yet"
}

SWEP.HoldType = "slam"

SWEP.Slot = 5
SWEP.SlotPos = 5

function SWEP:CanPrimaryAttack()
	if self:GetReloadFinish() > 0 then return false end
    if self.NeedAiming and not self:GetIronsights() then return false end
	if (self:Clip1() < self.RequiredClip) then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextSecondaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:TakeAmmo(secondary)
    self:SetClip1(self:Clip1() - 1)
end

function SWEP:PostInitialize()
    self:SetClip1(5)
end

function SWEP:SetUpNetVars()
    self:NetworkVar("Float", 25, "NextRegen")
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {} 
 
	self.AmmoDisplay.Draw = true
 
	if self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self:Clip1()
	end

	return self.AmmoDisplay
end

function SWEP:EmitFireSound()
    self:EmitSound("WeaponFrag.Throw")
end

function SWEP:SecondaryAttack()
    local owner = self:GetOwner()
    if owner.FGCWEP_TeleSlams and SERVER then
        local slam
        for i,v in pairs(owner.FGCWEP_TeleSlams) do
            if IsValid(v) then slam = v end
        end

        if IsValid(slam) then
            self:CallOnClient("dosounds")
            self:EmitSound("Weapon_CombineGuard.Special1")
            self:SendWeaponAnim(ACT_SLAM_THROW_DETONATE)
            self.IdleActivity = ACT_SLAM_THROW_IDLE
            self.IdleAnimation = CurTime() + self:SeqDur()
            if IsFirstTimePredicted() or game.SinglePlayer() then
                timer.Simple(1.35,function()
                    if not IsValid(slam) or not IsValid(self) then return end
                    local effect = EffectData()
                    effect:SetOrigin(slam:GetPos())
                    util.Effect("VortDispel", effect, true, true)

                    local prevel = owner:GetVelocity()
                    timer.Simple(0,function() 
                        owner:SetPos(slam:GetPos())

                        local invel = owner:GetVelocity()
                        owner:SetVelocity(prevel - invel)
                    end)

                    slam:EmitSound("npc/waste_scanner/grenade_fire.wav")

                    slam:Remove()
                end)
            end
        end

        self:SetNextSecondaryFire(CurTime() + 2.25)
    end
end

function SWEP:Think()
    self:PreThink()

    if self:GetReloadFinish() > 0 then
        if CurTime() >= self:GetReloadFinish() then
            self:FinishReload()
        end

        return
    elseif self.IdleAnimation and self.IdleAnimation <= CurTime() then
        self.IdleAnimation = nil
        self:SendWeaponAnim(self.IdleActivity)

        if self.IdleActivity == ACT_SLAM_THROW_THROW2 then
            self.IdleActivity = ACT_SLAM_THROW_DRAW
        elseif self.IdleActivity == ACT_SLAM_THROW_DRAW then
            self.IdleActivity = ACT_SLAM_THROW_IDLE
        end
        local vm = IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and self:GetOwner():GetViewModel() or nil
        if IsValid(vm) then
            self.IdleAnimation = CurTime() + self:SeqDur(0.1)
        end
    end

    if self:GetIronsights() and self:GetOwner():IsPlayer() and not self:GetOwner():KeyDown(IN_ATTACK2) and (not game.SinglePlayer() or SERVER) then
        self:SetIronsights(false)
		self:PlayZoomSound()
    end

	if FGCWEP_AUTOMATIC:GetBool() then
		self.Primary.Automatic = true
		if not self.Secondary.NeverAutomatic then
			self.Secondary.Automatic = true
		end
	else
		self.Primary.Automatic = self.OPrimary.Automatic
		self.Secondary.Automatic = self.OSecondary.Automatic
	end

	if self:GetOwner():IsNPC() then self:OnMove(self:GetOwner()) end

    self:PostThink()
end

function SWEP:dosounds()
    self:EmitSound("Weapon_CombineGuard.Special1")
    self:SendWeaponAnim(ACT_SLAM_THROW_DETONATE)
    self.IdleActivity = ACT_SLAM_THROW_IDLE
    local vm = IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and self:GetOwner():GetViewModel() or nil
    if IsValid(vm) then
        self.IdleAnimation = CurTime() + self:SeqDur(0.1)
    end
end

function SWEP:SendWeaponAnimation()
    self:SendWeaponAnim(ACT_SLAM_THROW_THROW)
    local vm = IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and self:GetOwner():GetViewModel() or nil
    if IsValid(vm) then
		self.IdleAnimation = CurTime() + self:SeqDur(0.1)
	end
    self.IdleActivity = ACT_SLAM_THROW_THROW2
end

function SWEP:PostThink()
    if self:GetNextRegen() < CurTime() and self:Clip1() < 5 then
        self:SetClip1(math.min(3,self:Clip1() + 1))
        self:SetNextRegen(CurTime() + 1.5)
    end
end

function SWEP:ShootBullets(dmg,num,cone,secondary)

    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:SetNextRegen(CurTime() + 1.5)

    if CLIENT then return end

    local ent = ents.Create("prop_physics")
    ent:SetModel("models/weapons/w_slam.mdl")
    ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 1)
    ent:SetAngles(self:GetBulletDir():Angle())
    ent:SetOwner(self:GetOwner())
    ent:Spawn()

    ent.FGCWEP_ForceWeapon = self

    local phy = ent:GetPhysicsObject()
    if not phy:IsValid() then return end
    phy:ApplyForceCenter(self:GetBulletDir() * 200 * phy:GetMass() + VectorRand(-5,5))

    self:GetOwner().FGCWEP_TeleSlams = self:GetOwner().FGCWEP_TeleSlams or {}
    table.insert(self:GetOwner().FGCWEP_TeleSlams, ent)
end