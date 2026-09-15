--https://github.com/AirRice/zs_banditwarfare/blob/3ad7fb2ba9d24c4a1c06662090d2ed7007fc66c2/gamemodes/zs_banditwarfare/entities/effects/rico_trace.lua

local EFFECT = {}
EFFECT.DieTime = 0
EFFECT.Base = ""

function EFFECT:Init(data)
	self.StartPos = data:GetStart()

    local ent = data:GetEntity()
    local attach = data:GetAttachment()

    self.StartPos = self:GetTracerShootPos(self.StartPos,ent,attach)

	self.EndPos = data:GetOrigin()
	self.Dir = self.EndPos - self.StartPos
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)

	self.DieTime = CurTime() + 0.1
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matBeam = Material("effects/spark")
function EFFECT:Render()
	local fDelta = (self.DieTime - CurTime()) / 0.1
	fDelta = math.Clamp(fDelta, 0, 1)
	local sinWave = math.sin(fDelta * math.pi)

	render.SetMaterial(matBeam)
	render.DrawBeam(self.EndPos - self.Dir * (fDelta - sinWave * 0.3), self.EndPos - self.Dir * (fDelta + sinWave * 0.3), 2 + sinWave * 8, 1, 0, color_white)
end
effects.Register(EFFECT,"fgccooltracer")