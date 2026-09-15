AddCSLuaFile()
if CLIENT then
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "keys"
SWEP.Author = "DRP Developers / cere"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IsDarkRPKeys = true
SWEP.ViewModel = "models/lostcoast/fisherman/keys.mdl"
SWEP.WorldModel = "models/lostcoast/fisherman/keys.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "FGC_cere"
SWEP.Sound = "doors/door_latch3.wav"

SWEP.DrawViewModel = false
SWEP.DrawWorldModel = false

SWEP.Primary.Delay = 0.3
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Delay = 0.3
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "normal"

SWEP.OriginalInfo = {
    --category = "cere",
    author = "DRP Developers / cere",
    name = "keys",
    server = "fgc", -- ofc from fgc
    description = "left click to lock\nright click to unlock\n"
}

FGCWEP_NOTGUN()

local function lockUnlockAnimation(ply, snd)
    ply:EmitSound("npc/metropolice/gear" .. math.floor(math.Rand(1, 7)) .. ".wav")
    timer.Simple(0.9, function() if IsValid(ply) then ply:EmitSound(snd) end end)
    ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
end

local function doKnock(ply, sound)
    ply:EmitSound(sound, 100, math.random(90, 110))
    ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
end

function SWEP:PreDrawViewModel() return true end

function SWEP:PrimaryAttack()
    local trace = self:GetOwner():GetEyeTrace()
    local door = trace.Entity
    if not (IsValid(door) and (door:GetClass() == "prop_door_rotating" or door:GetClass() == "func_door_rotating") and self.Owner:GetPos():Distance(door:GetPos()) < 200) then return end
    self:SetNextPrimaryFire(CurTime() + 0.3)
    if CLIENT then return end
    local owner = door:GetNWString("door_owner", "")
    if owner == self.Owner:SteamID64() or (owner.canKeysLock and owner:canKeysLock(ent)) then
        if door.keysLock then door:keysLock() else door:Fire("lock", "", 0) end
        lockUnlockAnimation(self:GetOwner(), self.Sound)
    else
        doKnock(self:GetOwner(), "physics/wood/wood_crate_impact_hard2.wav")
    end
end

function SWEP:SecondaryAttack()
    local trace = self:GetOwner():GetEyeTrace()
    local door = trace.Entity
    if not (IsValid(door) and (door:GetClass() == "prop_door_rotating" or door:GetClass() == "func_door_rotating") and self.Owner:GetPos():Distance(door:GetPos()) < 200) then return end
    self:SetNextPrimaryFire(CurTime() + 0.3)
    if CLIENT then return end
    local owner = door:GetNWString("door_owner", "")
    if owner == self.Owner:SteamID64() or (owner.canKeysUnlock and owner:canKeysUnlock(ent)) then
        if door.keysUnLock then door:keysUnLock() else door:Fire("unlock", "", 0) end
        lockUnlockAnimation(self:GetOwner(), self.Sound)
    else
        doKnock(self:GetOwner(), "physics/wood/wood_crate_impact_hard3.wav")
    end
end

function SWEP:Reload()
    return
end