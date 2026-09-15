SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "pistolgun"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = 10,
    Delay = 0.25,
    NumShots = 1,
    Automatic = false,
    ClipSize = 18,
    DefaultClip = 18,
    Ammo = "Pistol",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "pistolgun",
    server = "fgc", -- ofc from fgc
    description = "shazam all 18 bullets gone"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_Pistol.Single")
end

SWEP.HoldType = "pistol"

SWEP.BaseCone = 0.125 * 90

SWEP.AimExpandUnit = 0.5
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0.04 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.2
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Slot = 1
SWEP.SlotPos = 3

function SWEP:EmitReloadSound()
    self:EmitSound("Weapon_Pistol.Reload")
end

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(0.5, self:GetRand(-0.4,0.4)))
end

function SWEP:GetBulletInfo(dmg,num,cone)
    return {
        Src = self:GetBulletSrc(),
        Dir = self:GetBulletDir(),
        Spread = cone,
        Num = num * self:Clip1(),
        Damage = dmg,
        Force = dmg == math.huge and 1e9 or dmg / 70,
        Attacker = self:GetOwner(),
        Callback = self.BulletCallback,
        filter = self:GetBulletFilter(),
        HullSize = self.HullSize,
        Distance = self.Distance,
        Inflictor = self,
        CanHitWater = self.HitWater,
        TracerSpeed = self.TracerTravelSpeed,
        Tracer = self.Tracer,
    }
end

function SWEP:TakeAmmo(secondary)
	if not secondary then
        self:TakePrimaryAmmo(self:Clip1())
    else
        self:TakeSecondaryAmmo(self:Clip2())
    end
end
