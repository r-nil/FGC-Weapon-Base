SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "uespi"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp_silencer.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 30,
    Delay = 0.1,
    NumShots = 1,
    Automatic = false,
    ClipSize = 9,
    DefaultClip = 9,
    Ammo = "Pistol",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "cere",
    name = "uespi",
    server = "fgc", -- ofc from fgc
    description = "be a secret agent"
}

SWEP.HoldType = "revolver"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_USP.SilencedShot")
end

SWEP.BaseCone = 0.01 * 90

SWEP.AimExpandUnit = 0.05 * 90
SWEP.AimExpandStayDuration = 0.1
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0.04 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1.5
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.IdleActivity = ACT_VM_IDLE_SILENCED
SWEP.DeployAnim = ACT_VM_DRAW_SILENCED
function SWEP:SendFireAnim(secondary)
	self:SendWeaponAnim(secondary and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK_SILENCED)
end
function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_RELOAD_SILENCED)
end

SWEP.RecoilCrouchMul = 0.35
SWEP.AimCrouchMul = 0.5

SWEP.Slot = 1
SWEP.SlotPos = 3

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-2 * self:GetRecoilMul() * 0.25 - 0.2, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.04 * self:GetRecoilMul() - 0.003,0,0)
    self:SetViewPunch(ang)
end