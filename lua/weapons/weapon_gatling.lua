SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "chaingun"

SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 10,
    Delay = 0.08,
    NumShots = 4,
    Automatic = true,
    ClipSize = 300,
    DefaultClip = 600,
    Ammo = "smg1",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "phil",
    name = "chaingun",
    server = "fgc", -- ofc from fgc
    description = "turn them into fucking cheese\nslower walk speed while firing, slight knockback"
}

SWEP.HoldType = "ar2"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_SG552.Single")
end

SWEP.BaseCone = 0.025

SWEP.AimExpandUnit = 0.04 * 90
SWEP.AimExpandStayDuration = 0.45
SWEP.AimCollapseUnit = 1000

SWEP.MaxAimExpand = 100
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.05
SWEP.RecoilStayDuration = 0.5
SWEP.RecoilCollapseUnit = 1000

SWEP.RecoilCrouchMul = 0.2
SWEP.AimCrouchMul = 0.2

SWEP.Slot = 3
SWEP.SlotPos = 5

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-self:GetRecoilMul() * 6 - 0.5, self:GetRand(-0.4,0.4),0))
    local ang = self:GetViewPunch(false) + Angle(-2,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)
end

function SWEP:ShootBullets(dmg,num,cone,secondary)
    self.BaseClass.ShootBullets(self,dmg,num,cone)

    self:GetOwner():SetVelocity(self:GetBulletDir() * -40)
end

function SWEP:PostOnMove(own,move)
    if move then
        if self:Clip1() < 0 or self:GetReloadFinish() <= 0 then
            move:SetMaxClientSpeed(math.min(move:GetMaxClientSpeed(),100))
        end
    end
end