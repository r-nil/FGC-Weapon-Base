function SWEP:GetBulletSrc()
    if not IsValid(self:GetOwner()) then return vector_origin end
    return self:GetOwner():GetShootPos()
end

--[[
function SWEP:GetBulletDir()
    local dir = self:GetOwner():GetAimVector():Angle()
    if self:GetOwner():IsPlayer() then
        dir = dir + self:GetOwner():GetViewPunchAngles()
    end

    dir = dir:Forward()
    dir:Normalize()
    return dir
end
]]

--[[
function SWEP:GetBulletDir()
    return self:GetOwner():GetAimVector()
end
]]

FGCWEP_RVIEWPUNCH_ENABLED = FGCCONVAR_SH("fgcwep_sv_viewpunch","0",0,"add viewpunch to shoot angles",0,1)

function SWEP:GetBulletDir(interpolate)
    if not IsValid(self:GetOwner()) then return vector_origin end

    local dir = self:GetOwner():GetAimVector():Angle()
    dir.r = 0
    if FGCWEP_VIEWPUNCH_ENABLED:GetBool() then
        dir = dir + (interpolate and self:GetViewPunch() or self:GetUninterpolatedViewPunch())
    end

    if FGCWEP_RVIEWPUNCH_ENABLED:GetBool() and self:GetOwner():IsPlayer() then
        dir = dir + self:GetOwner():GetViewPunchAngles()
    end

    dir = dir:Forward()
    dir:Normalize()
    return dir
end

function SWEP:GetBulletFilter()
    return {self,self:GetOwner()}
end

function SWEP:GetBulletInfo(dmg,num,cone)
    return {
        Src = self:GetBulletSrc(),
        Dir = self:GetBulletDir(),
        Spread = cone,
        Num = num,
        Damage = dmg,
        Force = dmg == math.huge and 1e9 or dmg / 70,
        Attacker = self:GetOwner(),
        Callback = self.BulletCallback,
        filter = self:GetBulletFilter(),
        HullSize = self.HullSize,
        Distance = self.Distance,
        Inflictor = self,
        CanHitWater = self.HitWater,
        TracerSpeed = self.TracerTravelSpeed,
        Tracer = self.Tracer,
    }
end

function SWEP:ShootBullets(dmg,num,cone)
    if not IsValid(self:GetOwner()) then return end
    self:LagComp(true)
    FGC_FireLuaBullets(self:GetOwner(),self:GetBulletInfo(dmg,num,cone),self)
    self:LagComp(false)

    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end

function SWEP:Trace(start,endpos,mask,method)
    self:LagComp(true)
    local trace = {
        start = start,
        endpos = endpos,
        mask = mask,
        filter = self:GetBulletFilter()
    }
    trace = method(trace)
    self:LagComp(false)
    return trace
end