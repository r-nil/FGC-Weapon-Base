-- You will notice that some things's structure are similar to Zombie Survival's weapon base, that's because i am used to it.
-- Some function name are literally the same.

fgc_insh("sh_bullet.lua")
fgc_insh("sh_cone.lua")
fgc_insh("sh_recoil.lua")
fgc_insh("sh_random.lua")
fgc_insh("sh_viewpunch.lua")
fgc_insh("ai_translations.lua")

fgc_incl("animations.lua")
fgc_incl("cl_info.lua")
fgc_incl("cl_crosshair.lua")
fgc_incl("cl_viewmodelsway.lua")

FGCWEP_AUTOMATIC = FGCCONVAR_SH("fgcwep_sv_allautomatic","0",0,"make every FGC weapon automatic.",0,1)
FGCWEP_PROJECTILEKILLICON = FGCCONVAR_SH("fgcwep_sv_projectile_killicon","1",0,"make projectiles fired by FGC weapon use correct killicon",0,1)

SWEP.Base = "weapon_base"
SWEP.PrintName = "furry garry's mod community server scripted weapon"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.FGCBaseWeapon = true
SWEP.IsFGCBase = true
SWEP.IsFGCBaseWeapon = true
SWEP.FGC = true

SWEP.OriginalInfo = {}

SWEP.HoldType = "smg"

SWEP.FireAnimSpeed = 1
SWEP.SecondaryFireAnimSpeed = 1

SWEP.Ironsights_FOV = 0.2

SWEP.OSwayScale = 1
SWEP.OBobScale = 1

SWEP.Primary = {
    Damage = 30,
    Delay = 0.1,
    NumShots = 1,
    Automatic = true,
    ClipSize = 30,
    Ammo = "ar2",
}

SWEP.Secondary = {
    Damage = 30,
    Delay = 0.2,
    NumShots = 1,
    ClipSize = -1,
    Ammo = "nune"
}

SWEP.IdleActivity = ACT_VM_IDLE

SWEP.ReloadSpeed = 1

SWEP.UseHands = true

SWEP.CSMuzzleFlashes = true

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_AK47.Single")
end

function SWEP:EmitReloadSound() end

function SWEP:EmitReloadFinishSound() end

function SWEP:PreInitialize() end
function SWEP:PostInitialize() end

function SWEP:ResetHoldType(owner)
	owner = owner or self:GetOwner()
	if owner:IsNPC() then
		self:SetHoldType(self.NPCHoldType or self.HoldType)
	else
		self:SetHoldType(self.HoldType)
	end
end

function SWEP:Initialize()
    self:PreInitialize()

    self:ResetHoldType()

    if CLIENT then
        self:Anim_Initialize()
    end

	self.OPrimary = table.Copy(self.Primary)
	self.OSecondary = table.Copy(self.Secondary)

	if FGCWEP_AUTOMATIC:GetBool() then
		self.Primary.Automatic = true
		self.Secondary.Automatic = true
	end

	self.OViewModelFOV = self.ViewModelFOV

    self:PostInitialize()
end

function SWEP:Equip(owner)
	self:ResetHoldType(owner)

	if owner:IsNPC() then
		hook.Add("Think",self,self.Think)
	else
		hook.Remove("Think",self)
	end
end

function SWEP:PreDeploy() end
function SWEP:PostDeploy() end

function SWEP:SendDeployAnim()
	self:SendWeaponAnim(self.DeployAnim or ACT_VM_DRAW)
	self.IdleAnimation = CurTime() + self:SeqDur()
end

function SWEP:Deploy()
    if self:PreDeploy() then return false end

    self:SetNextReload(0)
	self:SetReloadFinish(0)
    self:SetIronsights(false)

	self:SetViewPunchP(0)
	self:SetViewPunchY(0)

	self:SendDeployAnim()

    if self:PostDeploy() then return false end

    return true
end

function SWEP:PreHolster() end
function SWEP:PostHolster() end

function SWEP:Holster(newwep)
    if self:PreHolster() then return false end

    if CLIENT then self:Anim_Holster() self:Crosshair_Holster(newwep) end

	if IsValid(newwep) and newwep.FGC then
		newwep:SetViewPunchP(self:GetViewPunchP())
		newwep:SetViewPunchY(self:GetViewPunchY())
		newwep:SetLastViewPunch(self:GetViewPunch(false))
	end

	self:SetViewPunchP(0)
	self:SetViewPunchY(0)

	self.IronsightsDelta = 0

    if self:PostHolster() then return false end

    return true
end

function SWEP:PreOnRemove() end
function SWEP:PostOnRemove() end

function SWEP:OnRemove()
    self:PreOnRemove()
    if CLIENT then self:Anim_OnRemove() end
	self.IronsightsDelta = 0
    self:PostOnRemove()
end

function SWEP:SetUpNetVars() end

-- lol pasted from ZS: Bandit Warfare you can see how much i love ZS:BW and ZS
function SWEP:SetupDataTables()
	self:NetworkVar("Float", 31, "ConeAdder")
	self:NetworkVar("Float", 30, "ReloadFinish")
	self:NetworkVar("Float", 29, "ReloadStart")
    self:NetworkVar("Float", 28, "RecoilAdder")
	self:NetworkVar("Float", 27, "ViewPunchP")
	self:NetworkVar("Float", 26, "ViewPunchY")

    self:NetworkVar("Bool", 31, "Ironsights")

    self:SetUpNetVars()
end

function SWEP:TakeAmmo(secondary)
	if not secondary then
        self:TakePrimaryAmmo(self.RequiredClip)
    else
        self:TakeSecondaryAmmo(self.RequiredClip)
    end
end

function SWEP:SendFireAnim(secondary)
	self:SendWeaponAnim(secondary and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK)
end

function SWEP:SendWeaponAnimation(secondary)
    local owner = self:GetOwner()
    if not owner:IsPlayer() then return end

	self:SendFireAnim(secondary)
	local vm = owner:GetViewModel()
	
	if (vm:IsValid()) then
		local rate = secondary and self.SecondaryFireAnimSpeed or self.FireAnimSpeed
		vm:SetPlaybackRate(rate)

		self.IdleAnimation = CurTime() + self:SeqDur(0.04)
	end
end

-- if fixed is true, please return the max fire delay
function SWEP:GetFireDelay(secondary,fixed)
    return secondary and FGCWEP_ROUND_TO_TICKINTERVAL(self.Secondary.Delay) or FGCWEP_ROUND_TO_TICKINTERVAL(self.Primary.Delay)
end

function SWEP:CanPrimaryAttack()
	if self:GetReloadFinish() > 0 then return false end
    if self.NeedAiming and not self:GetIronsights() then return false end
	if (self:Clip1() < self.RequiredClip) and (self:Clip1() >= 0 or self:Ammo1() < self.RequiredClip) then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextSecondaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    if game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end -- fuck you single player

    self:EmitFireSound(false)
    self:SendWeaponAnimation(false)
    self:ShootBullets(self.Primary.Damage,self.Primary.NumShots,self:GetCone())
    self:SetLastShootTime(CurTime())
    self:TakeAmmo(false)
    self:DoRecoil(false)

	if not self.Primary.NoNextSecondaryFire then
		self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(false))
	end
    self:SetNextPrimaryFire(CurTime() + self:GetFireDelay(false))
end

function SWEP:PlayZoomSound()
	self:EmitSound("Default.Zoom")
end

-- Do this in your swep if it has ironsights:
-- SWEP.SecondaryAttack = function(self) self:SecondaryAttack_Ironsights() end
function SWEP:SecondaryAttack_Ironsights()
	if not self:GetIronsights() and self:GetNextSecondaryFire() <= CurTime() and not (self:GetReloadFinish() > 0) then
		self:SetIronsights(true)
		self:PlayZoomSound()
	end
end

function SWEP:SecondaryAttack_Shoot()
	if not self:CanPrimaryAttack() then return end
    if game.SinglePlayer() then self:CallOnClient("SecondaryAttack") end -- fuck you single player

    self:EmitFireSound(true)
    self:SendWeaponAnimation(true)
    self:ShootBullets(self.Secondary.Damage,self.Secondary.NumShots,self:GetCone(), true)
    self:SetLastShootTime(CurTime())
    self:TakeAmmo(true)
    self:DoRecoil(true)

	if not self.Secondary.NoNextPrimaryFire then
    	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay(true))
	end
	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(true))

    self.IdleAnimation = CurTime() + self:SeqDur(0.04)
end

function SWEP:SecondaryAttack() end

function SWEP:PreThink() end
function SWEP:PostThink() end

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
		local vm = IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and self:GetOwner():GetViewModel() or nil
		if IsValid(vm) then
			self.IdleAnimation = CurTime() + self:SeqDur(0.04)
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

function SWEP:PreOnMove() end
function SWEP:PostOnMove() end

function SWEP:OnMove(own,...)
	if game.SinglePlayer() and SERVER and self:GetOwner():IsPlayer() then self:CallOnClient("OnMove") end
	self:PreOnMove(own,...)

	self:RecoilThink()
    self:ConeThink()
	self:ViewPunchThink()
	self:AnimThink()
	if CLIENT then self:CrosshairThink() end

	if self:GetOwner():IsNPC() and not self:GetOwner():Alive() then self:Remove() end

	self:PostOnMove(own,...)
end

hook.Add("SetupMove","FGCWEP.OnMove",function(ply,move,cmd)
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return end
	local t = wep:GetTable()
	if t.FGC and t.OnMove then
		t.OnMove(wep,ply,move,cmd)
	end
end)
function SWEP:CanReload()
	local hasclip1 = self:GetMaxClip1() > 0 and self:Clip1() < self:GetMaxClip1() and (self:Ammo1() > 0)
	if self.RequiredClip > 1 then
		hasclip1 = self:GetMaxClip1() > 0 and self:Clip1() < self:GetMaxClip1() and (self:Ammo1() >= self.RequiredClip)
	end

	return self:GetNextReload() <= CurTime() and self:GetReloadFinish() == 0 and
		(
			hasclip1 or self:GetMaxClip2() > 0 and self:Clip1() < self:GetMaxClip2() and self:Ammo1() > 0
		)
end

function SWEP:Reload()
	if self:CanReload() then	
		if self:GetIronsights() then
			self:SetIronsights(false)
		end
		self:SetReloadStart(CurTime())

		self:SendReloadAnimation()
		self:ProcessReloadEndTime()

		self:GetOwner():DoReloadEvent()
		self.IdleAnimation = CurTime() + self:SeqDur(0.04)
		self:SetNextReload(self.IdleAnimation)
		self:EmitReloadSound()

		self:SetViewPunchP(0)
		self:SetViewPunchY(0)
	end
end

function SWEP:FinishReload()
	self:SendWeaponAnim(self.IdleActivity)
	self:SetNextReload(0)
	self:SetReloadStart(0)
	self:SetReloadFinish(0)
	self:EmitReloadFinishSound()

	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local max1 = self:GetMaxClip1()
	local max2 = self:GetMaxClip2()

	if max1 > 0 then
		local ammotype = self:GetPrimaryAmmoType()
		local spare = owner:GetAmmoCount(ammotype)
		local current = self:Clip1()
		local needed = max1 - current

		needed = math.min(spare, needed)

		self:SetClip1(current + needed)
		if SERVER then
			owner:RemoveAmmo(needed, ammotype)
		end
	end

	if max2 > 0 then
		local ammotype = self:GetSecondaryAmmoType()
		local spare = owner:GetAmmoCount(ammotype)
		local current = self:Clip2()
		local needed = max2 - current

		needed = math.min(spare, needed)

		self:SetClip2(current + needed)
		if SERVER then
			owner:RemoveAmmo(needed, ammotype)
		end
	end
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_RELOAD)
end

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed
	self:SetReloadFinish(CurTime() + self:SeqDur(0.04) / reloadspeed)
	if not self.DontScaleReloadSpeed and self:GetOwner():IsPlayer() and IsValid(self:GetOwner():GetViewModel()) then
		self:GetOwner():GetViewModel():SetPlaybackRate(reloadspeed)
	end
end

function SWEP:SetNextReload(fTime)
	self.m_NextReload = fTime
end
function SWEP:GetNextReload()
	return self.m_NextReload or 0
end

function SWEP:LagComp(e)
	if not self:GetOwner():IsPlayer() then return end
	self:GetOwner():LagCompensation(e)
end

function SWEP:Crouching()
	if not self:GetOwner():IsPlayer() then return false end
	return self:GetOwner():Crouching()
end

function SWEP:OOnGround()
	if not self:GetOwner():IsPlayer() then return true end
	return self:GetOwner():OnGround()
end

function SWEP:SetPrimaryAutomatic(automatic)
	self.Primary.Automatic = automatic or FGCWEP_AUTOMATIC:GetBool()
	self.OPrimary.Automatic = automatic
end

function SWEP:SetSecondaryAutomatic(automatic)
	self.Secondary.Automatic = automatic or FGCWEP_AUTOMATIC:GetBool()
	self.OSecondary.Automatic = automatic
end

function SWEP:PrintMessage(type,message)
	if not self:GetOwner():IsPlayer() then return end
	self:GetOwner():PrintMessage(type,message)
end

function SWEP:SendMatchingSequence(anim)
    self.LastAnim = anim

    local owner = self:GetOwner()
    if owner:IsPlayer() then
		local vm = owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end

function SWEP:OnReloaded()
	if CLIENT then return end
	local owner = self:GetOwner()
	if owner:IsPlayer() then
		local clip1,clip2 = self:Clip1(),self:Clip2()

		local vars = self:GetNetworkVars()

		local active = owner:GetActiveWeapon()
		if IsValid(active) then active = active:GetClass() else active = false end
		owner:StripWeapon(self:GetClass())

		local new = owner:Give(self:GetClass(),true)
		if IsValid(new) then
			new:SetClip1(math.min(new.Primary.ClipSize,clip1))
			new:SetClip2(math.min(new.Secondary.ClipSize,clip2))

			new:RestoreNetworkVars(vars)

			owner:SelectWeapon(active)
		end

		local text = FGCWEP_ChatText()
		text:Add(FGCWEP_SERVERS, FGCWEP_SERVERLCLR)
		text:Add("your weapon: ", FGCWEP_TEXTLCLR)
		text:Add(self.PrintName, select(2,self:GetAuthorInfo()))
		text:Add(" has been refreshed due to lua refresh", FGCWEP_TEXTLCLR)

		text:Send(owner)
	elseif owner:IsNPC() then
		self:Remove()

		owner:Give(self:GetClass())
	end
end

function SWEP:GetAuthorInfo()
	if not self.OriginalInfo then return FGCWEP_TEXTLCLR end

	local info = self.OriginalInfo
	local author,authorclr = nil,Color(255,255,255)
	if info.category and FGCWEP_KNOWNMEMBERS[info.category] then
		author = FGCWEP_KNOWNMEMBERS[info.category].text
		authorclr = FGCWEP_KNOWNMEMBERS[info.category].lclr
	elseif info.author and FGCWEP_KNOWNMEMBERS[info.author] then
		author = FGCWEP_KNOWNMEMBERS[info.author].text
		authorclr = FGCWEP_KNOWNMEMBERS[info.author].lclr
	end

	return author,authorclr
end

function SWEP:c_isadmin()
	local owner = self:GetOwner()
	if owner:IsNPC() then return true end
	return c_isadmin(owner)
end

function SWEP:IsMod()
	local owner = self:GetOwner()
	if owner:IsNPC() then return true end
	return owner:IsAdmin() or owner:GetUserGroup() == "mod" or owner:GetUserGroup() == "tmod"
end

function SWEP:IsAdmin()
	local owner = self:GetOwner()
	if owner:IsNPC() then return true end
	return owner:IsAdmin()
end

function SWEP:IsSuperAdmin()
	local owner = self:GetOwner()
	if owner:IsNPC() then return true end
	return owner:IsSuperAdmin() or owner:GetUserGroup() == "atoix" or owner:GetUserGroup() == "genie"-- or owner:GetUserGroup() == "user+"
end

function SWEP:Ammo1()
	if not self:GetOwner().GetAmmoCount then return 1e6 end
	return self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
end

function SWEP:Ammo2()
	if not self:GetOwner().GetAmmoCount then return 1e6 end
	return self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoType())
end

function SWEP:TakePrimaryAmmo(num)
    if self:Clip1() <= 0 then
        if self:Ammo1() <= 0 or not self:GetOwner().RemoveAmmo then return end
        self:GetOwner():RemoveAmmo(num, self:GetPrimaryAmmoType())
        return
    end

    self:SetClip1(self:Clip1() - num)
end

function SWEP:TakeSecondaryAmmo(num)
    if self:Clip2() <= 0 then
        if self:Ammo2() <= 0 or not self:GetOwner().RemoveAmmo then return end
        self:GetOwner():RemoveAmmo(num, self:GetSecondaryAmmoType())
        return
    end

    self:SetClip2(self:Clip2() - num)
end

function SWEP:SeqDur(minus)
	minus = minus or 0
	local vm = IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and self:GetOwner():GetViewModel() or nil
	if IsValid(vm) then
		return vm:SequenceDuration() / vm:GetPlaybackRate() - minus
	else
		return self:SequenceDuration() - minus
	end
end