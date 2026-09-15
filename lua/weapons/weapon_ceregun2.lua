SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "ceregun2"

SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = 26,
    Delay = 0.2,
    NumShots = 1,
    Automatic = true,
    ClipSize = 100,
    DefaultClip = 100,
    Ammo = "ar2",
    NoNextSecondaryFire = true
}

SWEP.Secondary = {
    Damage = 0,
    Delay = 0.2,
    NumShots = 0,
    Automatic = true,
    ClipSize = -1,
    DefaultClip = -1,
    Ammo = "nune",
    NoNextPrimaryFire = true
}

SWEP.OriginalInfo = {
    category = "cere_admin",
    name = "ceregun2",
    server = "fgc", -- ofc from fgc
}

SWEP.HoldType = "ar2"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_M249.Single")
end

SWEP.BaseCone = 0.002 * 90

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0.1
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Slot = 1
SWEP.SlotPos = 2

function SWEP:SetUpNetVars()
    self:NetworkVar("Bool", 30, "Alt")
end


function SWEP:TakeAmmo() end
function SWEP:CanPrimaryAttack() return self:GetNextPrimaryFire() <= CurTime() end

function SWEP:DoRecoil() end

function SWEP:SecondaryAttack()
    self:SecondaryAttack_Shoot()
end

function SWEP:ShootBullets(dmg,num,cone,secondary)
    self.BaseClass.ShootBullets(self,dmg,num,cone)

    if not secondary then
        self:GetOwner():SetVelocity(self:GetBulletDir() * -220)
    end

    if CLIENT then return end

    if secondary then
        local ent = ents.Create("grenade_ar2")
        ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 100)
        ent:SetVelocity(self:GetBulletDir() * 1000)
        ent:SetAngles(self:GetBulletDir():Angle())
        ent:SetOwner(self:GetOwner())
        ent:Spawn()
        ent.FGCWEP_ForceWeapon = self
    else
        local ent = ents.Create("rpg_missile")
        ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 100)
        ent:SetVelocity(self:GetBulletDir() * 1000)
        ent:SetAngles(self:GetBulletDir():Angle())
        ent:SetOwner(self:GetOwner())
        ent:Spawn()
        ent:SetSaveValue("m_flDamage",200)
        ent.FGCWEP_ForceWeapon = self

        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    end
end