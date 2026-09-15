SWEP.Base = "weapon_fgcbase_shotgun"

SWEP.PrintName = "knockback shotgun"

FGCWEP_NOTGUN()

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = 12,
    Delay = 0.2,
    NumShots = 12,
    Automatic = false,
    ClipSize = 2,
    DefaultClip = 2,
    Ammo = "buckshot",
}

SWEP.Secondary = {
    Ammo = "nune",
    Delay = 0.75,
}

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "knockback shotgun",
    server = "fgc", -- ofc from fgc
    description = "reload to toggle knockback\ninfinite ammo"
}

SWEP.HoldType = "shotgun"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("weapons/shotgun/shotgun_dbl_fire.wav",75,secondary and 90 or 100)
end

SWEP.BaseCone = 0.075 * 90

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0
SWEP.RecoilStayDuration = 0
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 0.35
SWEP.AimCrouchMul = 0.5

SWEP.ReloadDelay = 0.5

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.NoAmmoDisplay = true

SWEP.ReloadSound = "Weapon_Shotgun.Reload"

function SWEP:SetUpNetVars()
    self:NetworkVar("Bool", 30, "Alt")
end

function SWEP:PrimaryAttack(second)
    if not self:CanPrimaryAttack() then return end
    if game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end -- fuck you single player

    if second then
        local clip = self:Clip1()
        self:ShootBullets(self.Primary.Damage,self.Primary.NumShots * clip,self:GetCone())
        for i = 1,clip do
            self:TakeAmmo(false)
        end
        if clip ~= 1 then
            self:SendWeaponAnimation(true)
            self:EmitFireSound(true)
            if self:GetAlt() then self:BoomstickAhhFly(600) end
        else
            self:SendWeaponAnimation(false)
            self:EmitFireSound(false)
            if self:GetAlt() then self:BoomstickAhhFly(250) end
        end
    else
        self:ShootBullets(self.Primary.Damage,self.Primary.NumShots,self:GetCone())
        self:TakeAmmo(false)
        self:SendWeaponAnimation(false)
        self:EmitFireSound(false)
        if self:GetAlt() then self:BoomstickAhhFly(250) end
    end
    self:SetLastShootTime(CurTime())

	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(second))
    self:SetNextPrimaryFire(CurTime() + self:GetFireDelay(second))

    self.IdleAnimation = CurTime() + self:SeqDur()
end

function SWEP:SecondaryAttack()
    if not self:CanPrimaryAttack() then return end
    self:PrimaryAttack(true)
end

function SWEP:DoRecoil() end

function SWEP:Reload()
    if self:GetNextPrimaryFire() > CurTime() then return end

    self:SetAlt(not self:GetAlt())
    self:PrintMessage(HUD_PRINTCENTER,self:GetAlt() and "knockback on" or "knockback off")

    self:EmitSound("weapons/shotgun/shotgun_cock.wav")
    self:SendWeaponAnim(ACT_SHOTGUN_PUMP)

    self:SetNextPrimaryFire(CurTime() + 0.65)
    self:SetNextSecondaryFire(CurTime() + 0.65)
    self.IdleAnimation = CurTime() + 0.65
end

function SWEP:BoomstickAhhFly(force)
    self:GetOwner():SetVelocity(-self:GetBulletDir() * force)
end