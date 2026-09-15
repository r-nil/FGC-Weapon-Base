local dotcol = Color(255,255,255)
local linecol = Color(255,255,255)

FGCWEP_CROSSHAIR_ENABLED = FGCCONVAR_CL("fgcwep_cl_crosshair","1",0,"enable crosshair on fgc weapons",0,1)
FGCWEP_CROSSHAIR_ONLYDOT = FGCCONVAR_CL("fgcwep_cl_crosshair_onlydot","0",0,"remove the lines",0,1)

FGCWEP_CROSSHAIR_DOT_R = FGCCONVAR_CL("fgcwep_cl_crosshair_dot_r","255",0,"R",0,255)
FGCWEP_CROSSHAIR_DOT_G = FGCCONVAR_CL("fgcwep_cl_crosshair_dot_g","255",0,"G",0,255)
FGCWEP_CROSSHAIR_DOT_B = FGCCONVAR_CL("fgcwep_cl_crosshair_dot_b","255",0,"B",0,255)
FGCWEP_CROSSHAIR_DOT_A = FGCCONVAR_CL("fgcwep_cl_crosshair_dot_a","255",0,"A",0,255)

FGCWEP_CROSSHAIR_LINE_R = FGCCONVAR_CL("fgcwep_cl_crosshair_line_r","255",0,"R",0,255)
FGCWEP_CROSSHAIR_LINE_G = FGCCONVAR_CL("fgcwep_cl_crosshair_line_g","255",0,"G",0,255)
FGCWEP_CROSSHAIR_LINE_B = FGCCONVAR_CL("fgcwep_cl_crosshair_line_b","255",0,"B",0,255)
FGCWEP_CROSSHAIR_LINE_A = FGCCONVAR_CL("fgcwep_cl_crosshair_line_a","255",0,"A",0,255)

FGCWEP_CROSSHAIR_THICKNESS = FGCCONVAR_CL("fgcwep_cl_crosshair_thickness","1",0,"crosshair thickness",0.01,25)

local THICKNESS = FGCWEP_CROSSHAIR_THICKNESS:GetFloat()

local function RefreshColors()
    dotcol = Color(FGCWEP_CROSSHAIR_DOT_R:GetFloat(),FGCWEP_CROSSHAIR_DOT_G:GetFloat(),FGCWEP_CROSSHAIR_DOT_B:GetFloat(),FGCWEP_CROSSHAIR_DOT_A:GetFloat())
    linecol = Color(FGCWEP_CROSSHAIR_LINE_R:GetFloat(),FGCWEP_CROSSHAIR_LINE_G:GetFloat(),FGCWEP_CROSSHAIR_LINE_B:GetFloat(),FGCWEP_CROSSHAIR_LINE_A:GetFloat())
end

RefreshColors()

local cb = function()
    RefreshColors()
end

cvars.AddChangeCallback("fgcwep_cl_crosshair_dot_r",cb)
cvars.AddChangeCallback("fgcwep_cl_crosshair_dot_g",cb)
cvars.AddChangeCallback("fgcwep_cl_crosshair_dot_b",cb)
cvars.AddChangeCallback("fgcwep_cl_crosshair_dot_a",cb)
cvars.AddChangeCallback("fgcwep_cl_crosshair_line_r",cb)
cvars.AddChangeCallback("fgcwep_cl_crosshair_line_g",cb)
cvars.AddChangeCallback("fgcwep_cl_crosshair_line_b",cb)
cvars.AddChangeCallback("fgcwep_cl_crosshair_line_a",cb)
cvars.AddChangeCallback("fgcwep_cl_crosshair_thickness",function(_,_,new)
    THICKNESS = tonumber(new)
end)

local CrossHairScale = 1
local function DrawDot(x, y)
	surface.SetDrawColor(dotcol)
    local t = 4 * THICKNESS
    local ht = t * 0.5
	surface.DrawRect(x - ht, y - ht, t, t)
	surface.SetDrawColor(0, 0, 0, dotcol.a)
	surface.DrawOutlinedRect(x - ht, y - ht, t, t)
end

local gradright = Material("vgui/gradient-r")
local function DrawLine(x, y, rot, w)
	rot = 270 - rot
    surface.SetDrawColor(0,0,0,linecol.a)
	surface.SetMaterial(gradright)
	surface.DrawTexturedRectRotated(x, y, 14 * w + 1, 2 * THICKNESS + 2, rot)
	surface.SetDrawColor(linecol)
	surface.SetMaterial(gradright)
	surface.DrawTexturedRectRotated(x, y, 14 * w, 2 * THICKNESS, rot)
end

function SWEP:DrawCrosshairCross()
	local x,y = self:GetCrosshairPos()
	local cone = self:GetCone() / 90

	if cone <= 0 then return end

	cone = ScrH() * 0.0003125 * cone * 90
	cone = cone * 90 / LocalPlayer():GetFOV()

	CrossHairScale = math.Approach(CrossHairScale, cone, FrameTime() * math.max(24, math.abs(CrossHairScale - cone) ^ 4 * 2))

	local midarea = 40 * CrossHairScale

	local ang = Angle(0, 0, 0)
	for i=0, 359, 360 / 4 do
        ang.roll = ang.roll + i
		local p = ang:Up() * midarea
		DrawLine(math.Round(x + p.y), math.Round(y + p.z), ang.roll, math.max(1,CrossHairScale * 1.4))
	end

end

function SWEP:DrawCrosshairDot()
	local x,y = self:GetCrosshairPos()

	DrawDot(x,y)
end

SWEP.CrosshairX = nil
SWEP.CrosshairY = nil
function SWEP:GetUnsmoothedCrosshairPos()
    local src,dir = self:GetBulletSrc(),self:GetBulletDir(true)
    local p
    if self:GetOwner():ShouldDrawLocalPlayer() then
        p = util.TraceLine({
            start = src,
            endpos = src + dir * 1e7,
            filter = {self,self:GetOwner()}
        }).HitPos
    else
        p = MainEyePos() + dir * 1000
    end
    local t
    cam.Start3D()
    t = p:ToScreen()
    cam.End3D()
    return math.Round(t.x),math.Round(t.y)
end

function SWEP:GetCrosshairPos()
    --[[
    if not self.CrosshairX or not self.CrosshairY then
        local x,y = self:GetUnsmoothedCrosshairPos()
        self.CrosshairX = x
        self.CrosshairY = y
    end

    return math.Round(self.CrosshairX), math.Round(self.CrosshairY)
    ]]
    return self:GetUnsmoothedCrosshairPos()
end

function SWEP:CrosshairThink()
    --[[
    local x,y = self:GetUnsmoothedCrosshairPos()
    local cx,cy = self:GetCrosshairPos()
    self.CrosshairX = Lerp(FrameTime() * 50,cx,x)
    self.CrosshairY = Lerp(FrameTime() * 50,cy,y)
    ]]
end

function SWEP:Crosshair_Holster(newwep)
    --[[
    local x,y = self.CrosshairX,self.CrosshairY
    self.CrosshairX = nil
    self.CrosshairY = nil

    if IsValid(newwep) then
        newwep.CrosshairX = x
        newwep.CrosshairY = y
    end
    ]]
end