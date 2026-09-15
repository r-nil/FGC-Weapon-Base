SWEP.Base = "weapon_fgcbase"

FGCWEP_BOLTGUN_NAILBOMB = FGCCONVAR_SH("fgcwep_sv_boltgun_nailbomb","1",0,"allow boltgun's nailbomb",0,1)

SWEP.PrintName = "boltgun"

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.ViewModelFOV = 54

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 24,
    Delay = 0.1,
    NumShots = 1,
    Automatic = true,
    ClipSize = 35,
    DefaultClip = 105,
    Ammo = "XBowBolt",
}

SWEP.Secondary = {
    Ammo = "nune",
    Delay = 1,
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "boltgun",
    server = "fgc", -- ofc from fgc
    description = "fires lower damage bolts at a fast rate, altfire launches a nail bomb\nTINK TINK TINK TINK TINK TINK"
}

SWEP.HoldType = "ar2"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_Crossbow.Single")
end

SWEP.BaseCone = 0

SWEP.AimExpandUnit = 0.04 * 90
SWEP.AimExpandStayDuration = 0.45
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 0
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 0
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0
SWEP.RecoilStayDuration = 0
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 02
SWEP.AimCrouchMul = 0.2

SWEP.Slot = 3
SWEP.SlotPos = 0

function SWEP:CanSecondaryAttack()
	if self:GetReloadFinish() > 0 then return false end
    if self.NeedAiming and not self:GetIronsights() then return false end
	if self:Clip1() < self.Primary.ClipSize then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextSecondaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime() and self:GetNextSecondaryFire() <= CurTime()
end

function SWEP:TakeAmmo(secondary)
	if not secondary then
        self:TakePrimaryAmmo(self.RequiredClip)
    else
        self:TakePrimaryAmmo(self.Primary.ClipSize)
    end
end

function SWEP.OnProjectileCollide(ent,data)
    if ent.FGCWEP_Collided then return end
    ent.FGCWEP_Collided = true

    local owner = ent:GetOwner()
    if not IsValid(owner) then return end

    timer.Simple(3,function()
        if not IsValid(ent) then return end
        local eff = EffectData()
        eff:SetOrigin(ent:GetPos())
        util.Effect("Explosion",eff,true,true)
        for i = 1,150 do
            local dir = VectorRand(-1,1)
            local ent2 = ents.Create("crossbow_bolt")
            ent2:SetPos(ent:GetPos())
            ent2:SetAngles(dir:Angle())
            ent2:SetOwner(owner)
            ent2:Spawn()
            ent2:SetVelocity(dir * 2000)
            ent2:SetSaveValue("m_iDamage",70)
            ent2:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            timer.Simple(0.01,function()
                if IsValid(ent2) then ent2:SetCollisionGroup(COLLISION_GROUP_NONE) end
            end)

            ent2.FGCWEP_ForceWeapon = ent.FGCWEP_ForceWeapon
        end

        ent:Remove()
    end)
end

function SWEP:SecondaryAttack()
    if not FGCWEP_BOLTGUN_NAILBOMB:GetBool() then
        return
    end
    if not self:CanSecondaryAttack() then return end
    self:SecondaryAttack_Shoot()
end

function SWEP:DoRecoil() end
function SWEP:ShootBullets(dmg,num,cone,secondary)
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)

    if CLIENT then return end

    if secondary then
        local ent = ents.Create("prop_physics")
	    ent:SetModel("models/items/grenadeammo.mdl")
        ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 20)
        ent:SetAngles(self:GetBulletDir():Angle())
        ent:SetOwner(self:GetOwner())
        ent:Spawn()

        ent.FGCWEP_ForceWeapon = self

        local phy = ent:GetPhysicsObject()
	    if not phy:IsValid() then return end
        phy:ApplyForceCenter(self:GetBulletDir() * 1000 * phy:GetMass() + VectorRand(-5,5))
        ent:AddCallback("PhysicsCollide",self.OnProjectileCollide)
        return
    end

    local ent = ents.Create("crossbow_bolt")
    ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 1)
    ent:SetVelocity(self:GetBulletDir() * 2000)
    ent:SetAngles(self:GetBulletDir():Angle())
    ent:SetOwner(self:GetOwner())
    ent:Spawn()
    ent:SetSaveValue("m_iDamage",dmg)

    ent.FGCWEP_ForceWeapon = self
end