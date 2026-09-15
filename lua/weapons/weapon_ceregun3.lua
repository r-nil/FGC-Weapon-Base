SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "ceregun3"

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = 0,
    Delay = 0.1,
    NumShots = 0,
    Automatic = true,
    ClipSize = 1,
    DefaultClip = 0,
    Ammo = "nune",
    NoNextSecondaryFire = true
}

SWEP.Secondary = {
    Damage = 0,
    Delay = 0.001,
    NumShots = 0,
    Automatic = true,
    ClipSize = 1,
    DefaultClip = 0,
    Ammo = "nune",
    NoNextPrimaryFire = true
}

SWEP.OriginalInfo = {
    category = "cere_admin",
    name = "ceregun3",
    server = "fgc", -- ofc from fgc,
    description = "room"
}

SWEP.HoldType = "pistol"

function SWEP:EmitFireSound(secondary) end

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

SWEP.NoAmmoDisplay = true

function SWEP:SetUpNetVars()
    self:NetworkVar("Bool", 30, "Alt")
end

function SWEP:TakeAmmo() end
function SWEP:CanPrimaryAttack() return true end

function SWEP:DoRecoil() end

function SWEP:SecondaryAttack()
    self:SecondaryAttack_Shoot()
end

function SWEP:SendWeaponAnimation(secondary) end

function SWEP:ShootBullets(dmg,num,cone,secondary)
    if CLIENT then return end

    local ent = ents.Create("rpg_missile")
    ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * (secondary and 1000 or 125) + VectorRand() * (secondary and 300 or 100))
    ent:SetVelocity(self:GetBulletDir() * 1000)
    ent:SetAngles(self:GetBulletDir():Angle())
    ent:SetOwner(self:GetOwner())
    ent:Spawn()
    ent:SetSaveValue("m_flDamage",200)
    ent.FGCWEP_ForceWeapon = self
end