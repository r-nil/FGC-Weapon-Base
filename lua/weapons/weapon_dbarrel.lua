SWEP.Base = "weapon_fgcbase_shotgun"

SWEP.PrintName = "double-barrel shotgun"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 12,
    Delay = 1,
    NumShots = 12,
    Automatic = true,
    ClipSize = 2,
    DefaultClip = 2,
    Ammo = "buckshot",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "double-barrel shotgun",
    server = "fgc", -- ofc from fgc
    description = "its a d-barrel, just blow their head off"
}

SWEP.HoldType = "shotgun"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("weapons/shotgun/shotgun_dbl_fire.wav",75,secondary and 90 or 100)
end

SWEP.BaseCone = 0.1 * 90

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

SWEP.ReloadSound = "Weapon_Shotgun.Reload"

function SWEP:PrimaryAttack(second)
    if not self:CanPrimaryAttack() then return end
    if game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end -- fuck you single player

    if second then
        local clip = self:Clip1()
        self:ShootBullets(self.Primary.Damage,self.Primary.NumShots * clip,self:GetCone())
        for i = 1,clip do
            self:TakeAmmo(false)
            self:DoRecoil(false)
            self:DoRecoil(false)
        end
        if clip ~= 1 then
            self:SendWeaponAnimation(true)
            self:EmitFireSound(true)
        else
            self:SendWeaponAnimation(false)
            self:EmitFireSound(false)
        end
    else
        self:ShootBullets(self.Primary.Damage,self.Primary.NumShots,self:GetCone())
        self:TakeAmmo(false)
        self:DoRecoil(false)
        self:SendWeaponAnimation(false)
        self:EmitFireSound(false)
    end
    self:SetLastShootTime(CurTime())

	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(false))
    self:SetNextPrimaryFire(CurTime() + self:GetFireDelay(false))

    self.IdleAnimation = CurTime() + self:SeqDur()
end

function SWEP:SecondaryAttack()
    if not self:CanPrimaryAttack() then return end
    self:PrimaryAttack(true)
end

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-6 * self:GetRecoilMul() * 0.25 - 6, self:GetRand(-0.4,0.4),self:GetRand(-0.3,0.3)))
end