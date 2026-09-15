SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "gwock"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 1

SWEP.Category = "FGC_cere"
SWEP.Spawnable = true

SWEP.Primary = {
    Damage = 20,
    Delay = 0.1,
    NumShots = 1,
    Automatic = false,
    ClipSize = 17,
    DefaultClip = 17,
    Ammo = "Pistol",
}

SWEP.Secondary = {
    Ammo = "nune",
    Delay = 0.0675,
    NeverAutomatic = true
}

SWEP.OriginalInfo = {
    category = "cere",
    name = "gwock",
    server = "fgc", -- ofc from fgc
    description = "right click to ratatatatat"
}

SWEP.HoldType = "revolver"

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_Glock.Single")
end

SWEP.BaseCone = 0.002 * 90

SWEP.AimExpandUnit = 0.05 * 90
SWEP.AimExpandStayDuration = 0.1
SWEP.AimCollapseUnit = 100

SWEP.MaxAimExpand = 0.1 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.MaxRecoil = 2
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 1
SWEP.RecoilStayDuration = 0.25
SWEP.RecoilCollapseUnit = 1000

SWEP.Slot = 1
SWEP.SlotPos = 3

function SWEP:SetUpNetVars()
    self:NetworkVar("Bool", 30, "Alt")
end

-- if fixed is true, please return the max fire delay
function SWEP:GetFireDelay(secondary,fixed)
    return self:GetAlt() and FGCWEP_ROUND_TO_TICKINTERVAL(self.Secondary.Delay) or FGCWEP_ROUND_TO_TICKINTERVAL(self.Primary.Delay)
end

function SWEP:DoRecoil()
    if not self:GetOwner():IsPlayer() then return end

    self:GetOwner():ViewPunch(Angle(-6 * self:GetRecoilMul() * 0.015 - 0.2, self:GetRand(-0.4,0.4)))
    local ang = self:GetViewPunch(false) + Angle(-0.2,0,0) * self:GetRecoilMul()
    self:SetViewPunch(ang)

    self:SetRecoilAdder(self:GetRecoilAdder() + 0.03)
end

function SWEP:SecondaryAttack()
    self:SetAlt(not self:GetAlt())
    self:PrintMessage(HUD_PRINTCENTER,self:GetAlt() and "automatic fire" or "single fire")
    self:SetPrimaryAutomatic(self:GetAlt())

    self:SetNextSecondaryFire(CurTime() + 0.5)
end