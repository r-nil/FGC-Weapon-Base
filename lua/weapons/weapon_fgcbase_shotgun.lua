SWEP.Base = "weapon_fgcbase"

-- this code is from zombie survival's weapon_zs_baseshotgun
-- i assume you have seen fgc/luabullet.lua's license, i won't paste it again

SWEP.ReloadDelay = 0.5
SWEP.ReloadActivity = ACT_VM_RELOAD
SWEP.PumpActivity = ACT_SHOTGUN_RELOAD_FINISH
SWEP.ReloadStartActivity = ACT_SHOTGUN_RELOAD_START
SWEP.ReloadStartGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

function SWEP:Reload()
	if not self:IsReloading() and self:CanReload() then
		self:StartReloading()
	end
end

function SWEP:Think()
    self:PreThink()

	if self:IsReloading() and self:GetOwner():KeyDown(IN_ATTACK) then
		self:StopReloading()
	end

    if self:ShouldDoReload() then
		self:DoReload()
	end

    if self.IdleAnimation and self.IdleAnimation <= CurTime() then
        self.IdleAnimation = nil
        self:SendWeaponAnim(self.IdleActivity)
    end

    if self:GetIronsights() and self:GetOwner():IsPlayer() and not self:GetOwner():KeyDown(IN_ATTACK2) then
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

	if self:GetOwner():IsNPC() then self:OnMove() end

    self:PostThink()
end

function SWEP:StartReloading()
	local delay = self:GetReloadDelay()
	self:SetDTFloat(3, CurTime() + delay)
	self:SetDTBool(2, true) -- force one shell load
	self:SetNextPrimaryFire(CurTime() + math.max(self:GetFireDelay(false,true), delay))
	self:SetNextSecondaryFire(CurTime() + math.max(self:GetFireDelay(true,true), delay))

	self:GetOwner():DoReloadEvent()

	if self.ReloadStartActivity then
		self:SendWeaponAnim(self.ReloadStartActivity)
		self:ProcessReloadAnim()
	end

    self.IdleAnimation = nil
end

function SWEP:StopReloading()
	self:SetDTFloat(3, 0)
	self:SetDTBool(2, false)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 0.75)

	-- do the pump stuff if we need to
	if self:Clip1() > 0 then
		if self.PumpSound then
			self:EmitSound(self.PumpSound)
		end
		if self.PumpActivity then
			self:SendWeaponAnim(self.PumpActivity)
			self:ProcessReloadAnim()
		end
	end
end

function SWEP:DoReload()
	if not self:CanReload() then
		self:StopReloading()
		return
	end

	local delay = self:GetReloadDelay()
	if self.ReloadActivity then
		self:SendWeaponAnim(self.ReloadActivity)
		self:ProcessReloadAnim()
		self.IdleAnimation = CurTime() + delay + 0.5
	end
	if self.ReloadSound then
		self:EmitSound(self.ReloadSound)
	end

	self:GetOwner():RemoveAmmo(1, self.Primary.Ammo, false)
	self:SetClip1(self:Clip1() + 1)

	self:SetDTBool(2, false)
	-- We always wanna call the reload function one more time. Forces a pump to take place.
	self:SetDTFloat(3, CurTime() + delay)

	self:SetNextPrimaryFire(CurTime() + math.max(self:GetFireDelay(false,true), delay))
	self:SetNextSecondaryFire(CurTime() + math.max(self:GetFireDelay(true,true), delay))
end

function SWEP:ProcessReloadAnim()
	local reloadspeed = self.ReloadSpeed
	if not self.DontScaleReloadSpeed then
		self:GetOwner():GetViewModel():SetPlaybackRate(reloadspeed)
        self.IdleAnimation = CurTime() + self:SeqDur()
	end
end

function SWEP:GetReloadDelay()
	local reloadspeed = self.ReloadSpeed
	return self.ReloadDelay / reloadspeed
end

function SWEP:ShouldDoReload()
	return self:GetDTFloat(3) > 0 and CurTime() >= self:GetDTFloat(3)
end

function SWEP:IsReloading()
	return self:GetDTFloat(3) > 0
end

function SWEP:CanReload()
	return self:Clip1() < self.Primary.ClipSize and 0 < self:GetOwner():GetAmmoCount(self.Primary.Ammo)
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() < self.RequiredClip then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)

		return false
	end

	if self:IsReloading() then
		self:StopReloading()
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end