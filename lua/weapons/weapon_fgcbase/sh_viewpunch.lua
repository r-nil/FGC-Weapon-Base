FGCWEP_VIEWPUNCH_ENABLED = FGCCONVAR_SH("fgcwep_sv_aimpunch","1",0,"enable aim punch on fgc weapons",0,1)

SWEP.MaxViewPunchP = 30 

--swcs

function SWEP:AddViewPunch(ang)
    ang = self:GetUninterpolatedViewPunch() + ang
    ang:Normalize()
    self:SetViewPunch(ang)
end

FGCWEP_DefineInterpolatedVar(SWEP, "m_ViewPunch", "ViewPunch", true)
SWEP.m_ViewPunchLast = Angle()

function SWEP:GetUninterpolatedViewPunch()
    return Angle(self:GetViewPunchP(), self:GetViewPunchY(), 0)
end

-- viewpunch gets custom setter because we network the pitch and yaw seperately
function SWEP:SetViewPunch(ang)
    if IsFirstTimePredicted() then
        self:SetLastViewPunch(self:GetUninterpolatedViewPunch())
    end

    local p, y, r = ang:Unpack()
    self:SetViewPunchP(p)
    self:SetViewPunchY(y)
end


local sqrt = math.sqrt
local ANGLE = FindMetaTable("Angle")
local AMul = ANGLE.Mul
local AZero = ANGLE.Zero
local AUnpack = ANGLE.Unpack

local function DecayAngles(v, fExp, fLin, dT)
	fExp = fExp * dT
	fLin = fLin * dT

	AMul(v, math.exp(-fExp))

	local x, y, z = AUnpack(v)
	local fMag = sqrt(x * x + y * y + z * z) --v:Length()
	if fMag > 0.1 and fMag > fLin then
		AMul(v, 1 - fLin / fMag)
	else
		AZero(v)
	end
end

local view_punch_decay = 10
function SWEP:ViewPunchThink()
    local ct = CurTime()
    local last = self:LastShootTime()

    local punchAng = self:GetUninterpolatedViewPunch()
	punchAng:Normalize()

    if ((last + self:GetFireDelay(false,true) + self.RecoilStayDuration) > ct) and math.abs(punchAng.p) <= self.MaxViewPunchP then return end

	DecayAngles(punchAng, view_punch_decay, 0, FrameTime())
	punchAng:Normalize()

	self:SetViewPunch(punchAng)
end