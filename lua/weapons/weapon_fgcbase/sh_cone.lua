FGCWEP_CONESPEEDMUL = FGCCONVAR_SH("fgcwep_sv_aconeincreasemul","1",0,"the weapon spread increase speed multiplier",0,10000)
FGCWEP_CONEDESPEEDMUL = FGCCONVAR_SH("fgcwep_sv_aconedecreasemul","1",0,"the weapon spread decrease speed multiplier",0,10000)
FGCWEP_CONEMUL = FGCCONVAR_SH("fgcwep_sv_aconemul","1",0,"the weapon spread multiplier",0,10000)
FGCWEP_CONEINCREASEMUL = FGCCONVAR_SH("fgcwep_sv_aconeincreasemul","1",0,"the weapon spread increase multiplier",0,10000)

SWEP.BaseCone = 0.02 * 90

SWEP.AimExpandUnit = 0.08 * 90
SWEP.AimExpandStayDuration = 0.2
SWEP.AimCollapseUnit = 0.25 * 90
SWEP.AimCrouchMul = 0.25

SWEP.MaxAimExpand = 0.5 * 90
SWEP.MinAimExpand = 0 * 90

SWEP.AimAirMul = 0.1

function SWEP:GetCone()
    return self.BaseCone * FGCWEP_CONEMUL:GetFloat() + self:GetConeAdder() * FGCWEP_CONEINCREASEMUL:GetFloat()
end

function SWEP:GetConeExpandMul()
    return math.max(0,(1 + self:GetOwner():GetVelocity():Length() / 200) * ((self:OOnGround() and self:Crouching()) and self.AimCrouchMul or 1) + (self:OOnGround() and 0 or self.AimAirMul)) * FGCWEP_CONESPEEDMUL:GetFloat()
end

function SWEP:GetConeCollapseMul()
    return 1 * FGCWEP_CONEDESPEEDMUL:GetFloat()
end

function SWEP:ConeThink()
    local ct = CurTime()
    local last = self:LastShootTime()

    if (last + self:GetFireDelay(false,true) + self.AimExpandStayDuration) > ct then
        self:SetConeAdder(math.Clamp(self:GetConeAdder() + self.AimExpandUnit * FrameTime() * self:GetConeExpandMul(),self.MinAimExpand,self.MaxAimExpand))
    else
        self:SetConeAdder(math.Clamp(self:GetConeAdder() - self.AimCollapseUnit * FrameTime() * self:GetConeCollapseMul(),self.MinAimExpand,self.MaxAimExpand))
    end
end