SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "mfawr unsilenced"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 25,
    Delay = 0.07,
    NumShots = 1,
    Automatic = true,
    ClipSize = 30,
    DefaultClip = 30,
    Ammo = "ar2",
}

SWEP.Secondary = {
    Ammo = "nune",
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "mfawr unsilenced",
    server = "fgc", -- ofc from fgc
    description = "crouching is more accurate"
}

SWEP.HoldType = "ar2"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_M4A1.Single")
end

SWEP.BaseCone = 0.01 * 90

SWEP.AimExpandUnit = 0.07 * 90
SWEP.AimExpandStayDuration = 0.1
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0.12 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1.5
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.IdleActivity = ACT_VM_IDLE
SWEP.DeployAnim = ACT_VM_DRAW
function SWEP:SendFireAnim(secondary)
	self:SendWeaponAnim(secondary and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK)
end
function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_RELOAD)
end

SWEP.RecoilCrouchMul = 0.35
SWEP.AimCrouchMul = 0.5

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-6 * self:GetRecoilMul() * 0.25 - 0.5, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.8 * self:GetRecoilMul() - 0.2,0,0)
    self:SetViewPunch(ang)
end