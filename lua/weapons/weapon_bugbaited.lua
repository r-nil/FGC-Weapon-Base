SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "jebaited"

FGCWEP_NOTGUN()

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/c_bugbait.mdl"
SWEP.WorldModel = "models/weapons/w_bugbait.mdl"
SWEP.FGCDisplayDistance = 12

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.UseHands = true

SWEP.Primary = {
    Ammo = "nune",
    ClipSize = -1,
    Automatic = true,
    Delay = 0.1
}
SWEP.Secondary = {
    Ammo = "nune",
    ClipSize = -1,
    Automatic = true,
    Delay = 0.01
}

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "jebaited",
    server = "fgc", -- ofc from fgc
    description = "haha fool"
}

SWEP.HoldType = "normal"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.NoAmmoDisplay = true

function SWEP:SendWeaponAnimation() end

function SWEP:SecondaryAttack()
    if not self:IsMod() then
        if IsFirstTimePredicted() then
            self:PrintMessage(HUD_PRINTTALK,"you got jebaited")
        end
        return
    end
    self:SecondaryAttack_Shoot()
end

function SWEP:ShootBullets(dmg,num,cone,secondary)
    if CLIENT then return end

    if secondary then
        local ent = ents.Create("crossbow_bolt")
        ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 70 + VectorRand(-25,25))
        ent:SetVelocity(self:GetBulletDir() * 3500)
        ent:SetAngles(self:GetBulletDir():Angle())
        ent:SetOwner(self:GetOwner())
        ent:Spawn()
        ent:SetSaveValue("m_iDamage",100)
        ent.FGCWEP_ForceWeapon = self
    else
        local ent = ents.Create("npc_grenade_bugbait")
        ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 70 + VectorRand(-20,20))
        ent:SetVelocity(self:GetBulletDir() * 1000)
        ent:SetAngles(self:GetBulletDir():Angle())
        ent:SetOwner(self:GetOwner())
        ent:Spawn()
    end
end