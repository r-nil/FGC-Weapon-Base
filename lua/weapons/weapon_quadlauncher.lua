SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "bazooka"

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.ViewModelFOV = 54

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 85,
    Delay = 0.6,
    NumShots = 4,
    Automatic = true,
    ClipSize = 4,
    DefaultClip = 20,
    Ammo = "RPG_Round",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "bazooka",
    server = "fgc", -- ofc from fgc
    description = "I FUCKING LOVE QUAKE DEATHMATCH!!!\nrocket shooter"
}

SWEP.HoldType = "rpg"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_RPG.NPC_Single")
end

SWEP.BaseCone = 0

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 0
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.05
SWEP.RecoilStayDuration = 0.5
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 0.2
SWEP.AimCrouchMul = 0.2

SWEP.Slot = 4
SWEP.SlotPos = 3

function SWEP:DoRecoil() end

function SWEP:ShootBullets(dmg,num,cone,secondary)
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:GetOwner():SetVelocity(self:GetBulletDir() * -200)

    if CLIENT then return end

    local ent = ents.Create("rpg_missile")
    ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 50)
    ent:SetVelocity(self:GetBulletDir() * 1000 + vector_up * 100)
    ent:SetAngles(self:GetBulletDir():Angle())
    ent:SetOwner(self:GetOwner())
    ent:Spawn()
    ent:SetSaveValue("m_flDamage",dmg)

    ent.FGCWEP_ForceWeapon = self
end
