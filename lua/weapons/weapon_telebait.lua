SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "antlion pearl"

if CLIENT then language.Add("weapon_telebait","") end

FGCWEP_NOTGUN()

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_bugbait.mdl"
SWEP.WorldModel = "models/weapons/w_bugbait.mdl"
SWEP.FGCDisplayDistance = 12

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.UseHands = true

SWEP.Primary = {
    Ammo = "nune",
    ClipSize = 1,
    DefaultClip = 5,
    Automatic = false,
    Delay = 0.1
}
SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "antlion pearl",
    server = "fgc", -- ofc from fgc
    description = "you teleport to where ever the bait lands\nTHIS, is an ENDER PEARL"
}

SWEP.HoldType = "grenade"

SWEP.Slot = 5
SWEP.SlotPos = 5

function SWEP:CanPrimaryAttack()
	if self:GetReloadFinish() > 0 then return false end
    if self.NeedAiming and not self:GetIronsights() then return false end
	if (self:Clip1() < self.RequiredClip) then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextSecondaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:TakeAmmo(secondary)
    self:SetClip1(self:Clip1() - 1)
end

function SWEP:PostInitialize()
    self:SetClip1(5)
end

function SWEP:SetUpNetVars()
    self:NetworkVar("Float", 25, "NextRegen")
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {} 
 
	self.AmmoDisplay.Draw = true
 
	if self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self:Clip1()
	end

	return self.AmmoDisplay
end

function SWEP:EmitFireSound()
    self:EmitSound("WeaponFrag.Throw")
end

function SWEP.OnProjectileCollide(ent,data)
    if ent.FGCWEP_Collided then return end
    ent.FGCWEP_Collided = true

    local owner = ent:GetOwner()
    if not IsValid(owner) then return end

    local source = IsValid(ent.FGCWEP_ForceWeapon) and ent.FGCWEP_ForceWeapon or ent

    local effect = EffectData()
    effect:SetOrigin(ent:GetPos())
    util.Effect("VortDispel", effect, true, true)

    local prevel = owner:GetVelocity()
    timer.Simple(0,function() 
        owner:SetPos(ent:GetPos())
        local dmg = DamageInfo()
        dmg:SetDamage(25)
        dmg:SetAttacker(source)
        dmg:SetInflictor(source)
        dmg:SetDamageType(DMG_FALL)
        owner:TakeDamageInfo(dmg)

        local invel = owner:GetVelocity()
        owner:SetVelocity(prevel - invel)
    end)

    ent:EmitSound("npc/waste_scanner/grenade_fire.wav")

    SafeRemoveEntityDelayed(ent,0)
end

function SWEP:SendWeaponAnimation() end

function SWEP:PostThink()
    if self:GetNextRegen() < CurTime() and self:Clip1() < 5 then
        self:SetClip1(math.min(5,self:Clip1() + 1))
        self:SetNextRegen(CurTime() + 1.5)
    end
end

function SWEP:ShootBullets(dmg,num,cone,secondary)

    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:SetNextRegen(CurTime() + 1.5)

    if CLIENT then return end

    local ent = ents.Create("prop_physics")
    ent:SetModel("models/weapons/w_bugbait.mdl")
    ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 1)
    ent:SetAngles(self:GetBulletDir():Angle())
    ent:SetOwner(self:GetOwner())
    ent:Spawn()

    ent.FGCWEP_ForceWeapon = self

    local phy = ent:GetPhysicsObject()
    if not phy:IsValid() then return end
    phy:ApplyForceCenter(self:GetBulletDir() * 1500 * phy:GetMass() + VectorRand(-5,5))
    ent:AddCallback("PhysicsCollide",self.OnProjectileCollide)
end