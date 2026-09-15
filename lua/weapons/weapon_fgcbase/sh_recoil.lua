function SWEP:GetRecoilMul()
    return self:GetRecoilAdder()
end

function SWEP:GetHRecoil(tbl)
    return tbl.HRecoil or ((tbl.VRecoil or tbl.Recoil or 0) / 4)
end

function SWEP:GetVRecoil(tbl)
    return tbl.VRecoil or tbl.HRecoil or tbl.Recoil or 0
end

function SWEP:GetRecoilReset(tbl)
    return tbl.RecoilReset or 10
end

function SWEP:DoRecoil(secondary)
    if not self:GetOwner():IsPlayer() then return end
end

SWEP.MaxRecoil = 3
SWEP.MinRecoil = 0

SWEP.RecoilExpandUnit = 0.08 * 90
SWEP.RecoilStayDuration = 0.2
SWEP.RecoilCollapseUnit = 0.25 * 90
SWEP.RecoilCrouchMul = 0.35

function SWEP:RecoilThink()
    local ct = CurTime()
    local last = self:LastShootTime()

    if (last + self:GetFireDelay(false,true) + (self.RecoilStayDuration or self.AimExpandStayDuration)) > ct then
        self:SetRecoilAdder(math.Clamp(self:GetRecoilAdder() + self.RecoilExpandUnit * FrameTime() * (0.1 + self:GetOwner():GetVelocity():Length() / 200) * (self:Crouching() and self.RecoilCrouchMul or 1),self.MinRecoil,self.MaxRecoil))
    else
        self:SetRecoilAdder(math.Clamp(self:GetRecoilAdder() - self.RecoilCollapseUnit * FrameTime(),self.MinRecoil,self.MaxRecoil))
    end
end