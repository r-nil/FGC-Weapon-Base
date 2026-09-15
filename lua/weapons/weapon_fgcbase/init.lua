fgc_insh("shared.lua")
fgc_incl("cl_init.lua")

function SWEP:AnimThink() end

function SWEP:GetNPCRestTimes()
    return self:GetConeAdder() * 1,self:GetConeAdder() * 1
end

function SWEP:GetNPCBurstSettings()
    return math.max(16,self:Clip1() / 2),math.max(16,self:Clip1()),0
end

function SWEP:GetNPCBulletSpread(good)
    return self:GetConeAdder() / (0.25 + good) + 15 / (0.25 + good)
end

function SWEP:GetCapabilities()
    if self.Capabilities then return self.Capabilities end
    if self.IsMelee then
        return CAP_WEAPON_MELEE_ATTACK1
    end

    return CAP_WEAPON_RANGE_ATTACK1
end

hook.Add("EntityTakeDamage","FGCWEP_SolveInflictor",function(ent,dmg)
    local inf = dmg:GetInflictor()
    if not inf:IsValid() then return end

    local t = inf:GetTable()
    if t.FGCWEP_ForceWeapon and t.FGCWEP_ForceWeapon:IsValid() then
        if FGCWEP_PROJECTILEKILLICON:GetBool() then
            dmg:SetInflictor(t.FGCWEP_ForceWeapon)
        end
        dmg:SetWeapon(t.FGCWEP_ForceWeapon)
    end
end)