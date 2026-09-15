SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "divide by zero"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.RequiredClip = 0

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary = {
    Damage = math.huge,
    Delay = 0,
    NumShots = 50,
    Automatic = true,
    ClipSize = 1,
    DefaultClip = 0,
    Ammo = "ar2",
    
    
}

SWEP.Secondary = {
    Ammo = "nune",
    Automatic = true
}

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "divide by zero",
    server = "fgc", -- ofc from fgc,
    description = "yikes"
}

function SWEP:EmitFireSound(secondary)
    self:EmitSound("Weapon_MP5Navy.Single")
end

SWEP.BaseCone = 0

SWEP.AimExpandUnit = 0
SWEP.AimExpandStayDuration = 0
SWEP.AimCollapseUnit = 0

SWEP.MaxAimExpand = 0
SWEP.MinAimExpand = 0

SWEP.MaxRecoil = 0
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0
SWEP.RecoilStayDuration = 0
SWEP.RecoilCollapseUnit = 0

SWEP.Slot = 2
SWEP.SlotPos = 2

SWEP.NoAmmoDisplay = true

SWEP.TracerTravelSpeed = 10000

function SWEP:TakeAmmo() end
function SWEP:CanPrimaryAttack() return true end

function SWEP:DoRecoil() end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() and not game.SinglePlayer() then return end
    if self:IsSuperAdmin() or false then self:AimBot() else self:PrintMessage(HUD_PRINTTALK,"ERROR: DIVIDE BY ZERO") end
end

function SWEP:AimBot()
    local min = 1e9
    local ply
    local pos = self:GetOwner():GetPos()
    for i,v in ipairs(player.GetAll()) do
        if not v:Alive() then continue end

        local d = v:GetPos():Distance(pos)
        if d < min and v ~= self:GetOwner() then
            ply = v
            min = d
        end
    end

    if ply and ply:IsValid() then
        --if CLIENT then
            local head = ply:LookupBone("ValveBiped.Bip01_Head1")
            local vec1
            if not head then
			    vec1 = ply:LocalToWorld(ply:OBBCenter())
            else
                vec1 = ply:GetBonePosition(head)
            end
			self:GetOwner():SetEyeAngles((vec1 - self:GetOwner():GetShootPos()):Angle())
        --end
        self:PrimaryAttack()
    end
end