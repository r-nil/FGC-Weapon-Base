SWEP.Base = "weapon_fgcbase_fists"

SWEP.PrintName = "dicefist"

SWEP.Category = "FGC_phil"
SWEP.Spawnable = true

SWEP.OriginalInfo = {
    category = "phil",
    name = "dicefist",
    server = "fgc", -- ofc from fgc
    description = "drunken fist\nrandom chance to do 1 - 100 damage on hit"
}

SWEP.ComboCount = 100000

SWEP.Slot = 0
SWEP.SlotPos = 30

SWEP.ComboResetTime = 0.1

function SWEP:MeleeCallback(att,tr,dmg,anim)
    dmg:SetDamage(self.HitDamage)

    if IsValid(tr.Entity) then
        self:PrintMessage(HUD_PRINTCENTER,"You rolled: " .. math.Round(self.HitDamage) .. (self.HitDamage >= 75 and " [CRITICAL!]" or ""))
    end
end

function SWEP:SendFireAnim(right)
	local anim = right and "fists_right" or "fists_left"
    if self.HitDamage >= 75 then
        anim = "fists_uppercut"
    end

    self.LastAnim = anim

    local owner = self:GetOwner()
    if owner:IsPlayer() then
		local vm = owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end


function SWEP:PrimaryAttack(right)
    if not self:CanPrimaryAttack() then return end

    self:SetSwingEnd(CurTime() + self.SwingTime)

    self:SetNextPrimaryFire(CurTime() + self.MeleeDelay)
    self:SetNextSecondaryFire(CurTime() + self.MeleeDelay)

    self:EmitFireSound(false)

    self.HitDamage = self:GetRand(1,100)
    self:SendWeaponAnimation(right)
end