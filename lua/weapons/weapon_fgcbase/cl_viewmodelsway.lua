FGCWEP_VIEWMODEL_SWAY = FGCCONVAR_CL("fgcwep_cl_vm_sway","0",0,"enable half life 2 viewmodel sway on fgc weapons",0,1)
FGCWEP_VIEWMODEL_HL2OFFSET = FGCCONVAR_CL("fgcwep_cl_vm_hl2offset","0",0,"enable half life 2 viewmodel offset thing on fgc weapons",0,1)

local host_timescale = GetConVar("host_timescale")

local math_ceil = math.ceil
local game_GetTimeScale = game.GetTimeScale
local FrameTime = FrameTime
local RealFrameTime = RealFrameTime

local function VectorMA(start, scale, direction)
	start.x = start.x + scale * direction.x
	start.y = start.y + scale * direction.y
	start.z = start.z + scale * direction.z
end

local maxLag = 1.5

function SWEP:CalcViewModelSway(vm, oldEyePos, oldEyeAng, eyePos, eyeAng)

    if not FGCWEP_VIEWMODEL_SWAY:GetBool() then return eyePos, eyeAng end

    local owner = self:GetOwner()

    local origPos = oldEyePos * 1
	local origAng = oldEyeAng * 1

    local frametime = RealFrameTime() * math_ceil(host_timescale:GetFloat()) * game_GetTimeScale()

    local forward = eyeAng:Forward()
	local vmTable = vm:GetTable()

	if vmTable.m_vecLastFacing == nil then
		vmTable.m_vecLastFacing = forward
	end
	local m_vecLastFacing = vmTable.m_vecLastFacing

    if frametime ~= 0 then
		local diff = forward - m_vecLastFacing

		local speed = 5

		local diffLen = diff:LengthSqr()
		if diffLen > maxLag * maxLag and maxLag > 0 then
			local scale = diffLen / maxLag
			speed = speed * scale
		end

		VectorMA(m_vecLastFacing, speed * frametime, diff)
		m_vecLastFacing:Normalize()
		VectorMA(eyePos, 5, diff * -1)
		vmTable.m_vecLastFacing = m_vecLastFacing
	end

    local right = oldEyeAng:Right()
	local up = oldEyeAng:Up()

	local pitch = oldEyeAng.x
	if pitch > 180 then
		pitch = pitch - 360
	elseif pitch < -180 then
		pitch = pitch + 360
	end

	if maxLag == 0 then
		eyePos = origPos
		eyeAng = origAng
	end

	if FGCWEP_VIEWMODEL_HL2OFFSET:GetBool() then
		VectorMA(eyePos, -pitch * 0.035, forward)
		VectorMA(eyePos, -pitch * 0.03, right)
		VectorMA(eyePos, -pitch * 0.02, up)
	end

    return eyePos,eyeAng
end