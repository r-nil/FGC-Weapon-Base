SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "ewites"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.FGCAngleOffset = Angle(0,0,-90)

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_twoface"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 18,
    Delay = 0.15,
    NumShots = 1,
    Automatic = false,
    ClipSize = 28,
    DefaultClip = 28,
    Ammo = "357",
}

SWEP.Secondary = {
    Damage = 18,
    Delay = 0.15,
    NumShots = 1,
    Automatic = false,
    ClipSize = -1,
    DefaultClip = -1,
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = nil,
    name = "ewites",
    server = "fgc", -- ofc from fgc
    description = "left & right buttons to alternate and shoot faster\nakimbo guns woo yeah",
    author = "twoface, Atomix27"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_Elite.Single")
end

SWEP.HoldType = "duel"

SWEP.BaseCone = 0.02 * 90

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0.04 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.2
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Slot = 1
SWEP.SlotPos = 3

function SWEP:DoRecoil() end

function SWEP:SendFireAnim(secondary)
    --self:SendWeaponAnim(secondary and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK)
    if secondary and self.ShootLeft and self.ShootLeft > CurTime() then
        self:SendMatchingSequence("shoot_right2")
        return
    elseif not secondary and self.ShootRight and self.ShootRight > CurTime() then
        self:SendMatchingSequence("shoot_left2")
        return
    end
    self:SendMatchingSequence(secondary and "shoot_right1" or "shoot_left1")
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    if game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end -- fuck you single player

    self:EmitFireSound(false)
    self:SendWeaponAnimation(false)
    self.PrimaryAttacked = true
    self:ShootBullets(self.Primary.Damage,self.Primary.NumShots,self:GetCone())
    self:SetLastShootTime(CurTime())
    self:TakeAmmo(false)
    self:DoRecoil(false)
    self.ShootLeft = CurTime() + 0.2

	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(false) * 0.5)
    self:SetNextPrimaryFire(CurTime() + self:GetFireDelay(false))
end

function SWEP:CanSecondaryAttack()
	if self:GetReloadFinish() > 0 then return false end
    if self.NeedAiming and not self:GetIronsights() then return false end
	if self:Clip1() < self.RequiredClip then
		self:EmitSound("Weapon_Pistol.Empty")
        self:SetNextSecondaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextSecondaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
    if game.SinglePlayer() then self:CallOnClient("SecondaryAttack") end -- fuck you single player

    self:EmitFireSound(true)
    self:SendWeaponAnimation(true)
    self.PrimaryAttacked = false
    self:ShootBullets(self.Primary.Damage,self.Primary.NumShots,self:GetCone(), true)
    self:SetLastShootTime(CurTime())
    self:TakeAmmo(false)
    self:DoRecoil(true)
    self.ShootRight = CurTime() + 0.2

    self:SetNextPrimaryFire(CurTime() + self:GetFireDelay(false) * 0.5)
	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(false))

    self.IdleAnimation = CurTime() + self:SeqDur()
end

function SWEP:GetTracerOrigin()
	local owner = self:GetOwner()
	if owner:IsValid() and owner.GetViewModel then
		local vm = owner:GetViewModel()
		if vm and vm:IsValid() then
			local attachment = vm:GetAttachment(self.PrimaryAttacked and 4 or 3)
			if attachment then
				return attachment.Pos
			end
		end
	end
end