SWEP.Base = "weapon_fgcbase_fists"

SWEP.PrintName = "nukefist"

SWEP.Category = "FGC_phil_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.OriginalInfo = {
    category = "phil_admin",
    name = "nukefist",
    server = "fgc", -- ofc from fgc
    description = "serious punch\nself explanatory"
}

SWEP.ComboCount = 100000

SWEP.Slot = 0
SWEP.SlotPos = 30

SWEP.ComboResetTime = 0.1

function SWEP:MeleeCallback(att,tr,dmg,anim)
    dmg:SetDamage(self.HitDamage)
    
    if CLIENT or not tr.Hit then return end
    local eyetrace = att.GetEyeTrace and att:GetEyeTrace() or tr
    local ent = ents.Create("env_explosion")
    ent:SetPos(eyetrace.HitPos)
    ent:SetOwner(att)
    ent:Spawn()
    ent:SetKeyValue("iMagnitude","1999")
    ent:Fire("Explode",0,0)
    ent:EmitSound("ambient/explosions/explode_9.wav",400)
end

function SWEP:SendFireAnim(right)
	local anim = right and "fists_right" or "fists_left"
    if self.Crit then
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

    local crit = math.Round(self:GetRand(1,3))
    self.Crit = crit >= 3
    self.HitDamage = 20
    self:SendWeaponAnimation(right)
end