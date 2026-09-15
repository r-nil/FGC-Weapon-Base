SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "LAS-AR"

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel	= "models/weapons/w_irifle.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 3

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 10,
    Delay = 0.08,
    NumShots = 1,
    Automatic = true,
    ClipSize = 100,
    DefaultClip = 100,
    Ammo = "nune",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "LAS-AR",
    server = "fgc", -- ofc from fgc
    description = "A standard energy rifle.\nAmmo recharges when not in use.\nRMB for zoom-in, Reload toggles safe mode"
}

SWEP.HoldType = "ar2"

function SWEP:PostInitialize()
    self:SetClip1(self.Primary.ClipSize)
end

function SWEP:EmitFireSound(secondary)
    self:EmitSound("weapons/ar2/fire1.wav",75,self:GetRand(95,105))
end

SWEP.BaseCone = 0.02 * 90

SWEP.AimExpandUnit = 0.0125 * 90
SWEP.AimExpandStayDuration = 0.1
SWEP.AimCollapseUnit = 2

SWEP.MaxAimExpand = 1.5 * 90 / 10
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0
SWEP.RecoilStayDuration = 0
SWEP.RecoilCollapseUnit = 1000

SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.HullSize = 4

SWEP.Ironsights_FOV = 1.4

function SWEP:GetConeExpandMul() return 1 end

function SWEP:SetUpNetVars()
    self:NetworkVar("Bool", 30, "Alt")
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

SWEP.IdleActivity = ACT_VM_IDLE
SWEP.DeployAnim = ACT_VM_DRAW
function SWEP:SendFireAnim(secondary)
	self:SendWeaponAnim(secondary and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK)
end

SWEP.AimCrouchMul = 0.5

function SWEP:ShootBullets(dmg,num,cone)
    self:LagComp(true)
    FGC_FireLuaBullets(self:GetOwner(),self:GetBulletInfo(dmg,num,cone),self)
    self:LagComp(false)

    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:SetNextRegen(CurTime() + 0.8)
end

function SWEP:CanPrimaryAttack()
    if self:GetAlt() then 
        self:Reload()
        return false
    end
    return self.BaseClass.CanPrimaryAttack(self)
end

function SWEP:DoRecoil() end

function SWEP:SecondaryAttack()
    if self:GetAlt() then return end
    self:SecondaryAttack_Ironsights()
end

function SWEP:Reload()
    if self:GetNextSecondaryFire() > CurTime() then return end
    self:EmitSound("Weapon_AR2.Empty")
    self:SetAlt(not self:GetAlt())

    self.IdleActivity = self:GetAlt() and ACT_VM_IDLE_LOWERED or ACT_VM_IDLE
    self.DeployAnim = self:GetAlt() and ACT_VM_IDLE_LOWERED or ACT_VM_DRAW

    self:SendWeaponAnim(self:GetAlt() and ACT_VM_IDLE_LOWERED or ACT_VM_IDLE)

    self:SetHoldType(self:GetAlt() and "passive" or "ar2")

    self:SetNextPrimaryFire(CurTime() + 0.5)
    self:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:PostThink()
    if self:GetNextRegen() < CurTime() and self:Clip1() < self.Primary.ClipSize then
        self:SetClip1(math.min(self.Primary.ClipSize,self:Clip1() + 1))
        self:SetNextRegen(CurTime() + 0.025)
    end
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
        HullSize = self.HullSize,
        Distance = self.Distance,
        Inflictor = self,
        CanHitWater = self.HitWater,
        TracerSpeed = self.TracerTravelSpeed,
        Tracer = "ToolTracer",
    }
end