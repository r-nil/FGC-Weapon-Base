fgc_insh("shared.lua")

FGCWEP_VIEWMODEL_FOV = FGCCONVAR_CL("fgcwep_cl_vm_fov_mul","1",0,"viewmodel fov multiplier",0,67)
FGCWEP_VIEWMODEL_FOV_FIXED_ENABLED = FGCCONVAR_CL("fgcwep_cl_vm_fov_fixed","0",0,"use fixed viewmodel fov",0,67)
FGCWEP_VIEWMODEL_FOV_FIXED = FGCCONVAR_CL("fgcwep_cl_vm_fov_fixed_value","54",0,"fixed viewmodel fov",0,179.99)

FGCWEP_VIEWMODEL_OFFSET = FGCCONVAR_CL("fgcwep_cl_vm_offset","0",0,"enable viewmodel offset",0,1)
FGCWEP_VIEWMODEL_OFFSET_X = FGCCONVAR_CL("fgcwep_cl_vm_offset_x","0",0,"viewmodel offset x",-1000,1000)
FGCWEP_VIEWMODEL_OFFSET_Y = FGCCONVAR_CL("fgcwep_cl_vm_offset_y","0",0,"viewmodel offset y",-1000,1000)
FGCWEP_VIEWMODEL_OFFSET_Z = FGCCONVAR_CL("fgcwep_cl_vm_offset_z","0",0,"viewmodel offset z",-1000,1000)

function SWEP:PreDrawViewModel(vm)
	if FGCWEP_VIEWMODEL_FOV_FIXED_ENABLED:GetBool() then
		self.ViewModelFOV = FGCWEP_VIEWMODEL_FOV_FIXED:GetFloat()
	else
		self.ViewModelFOV = self.OViewModelFOV * FGCWEP_VIEWMODEL_FOV:GetFloat()
	end
	if self.ShowViewModel == false then
		render.SetBlend(0)
	end
end

function SWEP:PostDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(1)
	end
end

function SWEP:ViewModelDrawn()
    self:Anim_ViewModelDrawn()
end


function SWEP:DrawWorldModel()
    self:Anim_DrawWorldModel()
end

function SWEP:GetIronsightsDeltaMultiplier()
	--[[
	local bIron = self:GetIronsights()
	local fIronTime = self.fIronTime or 0

	if not bIron and fIronTime < CurTime() - 0.25 then 
		return 0
	end

	local Mul = 1

	if fIronTime > CurTime() - 0.25 then
		Mul = math.Clamp((CurTime() - fIronTime) * 8, 0, 1)
		if not bIron then Mul = 1 - Mul end
	end

	return Mul
	]]

	return self.IronsightsDelta
end

function SWEP:TranslateFOV(fov)
    self.PlyOriginalFOV = fov
    if self:GetIronsightsDeltaMultiplier() ~= 0 then
        return fov / (1 + self:GetIronsightsDeltaMultiplier() * self.Ironsights_FOV)
    end
	return fov
end

local ratio = GetConVar("zoom_sensitivity_ratio")
function SWEP:AdjustMouseSensitivity()
	if self:GetIronsights() then 
        return (self.PlyOriginalFOV / (1 + self:GetIronsightsDeltaMultiplier() * self.Ironsights_FOV)) / self.PlyOriginalFOV * ratio:GetFloat()
    end
end

SWEP.bLastIron = false
SWEP.fIronTime = CurTime()
SWEP.IronsightsDelta = 0

function SWEP:AnimThink()
	self.IronsightsDelta = Lerp(FrameTime() * 17, self.IronsightsDelta, self:GetIronsights() and 1 or 0)
end

function SWEP:ViewModelOffset(vm,oldpos,oldang,pos,ang)
	if FGCWEP_VIEWMODEL_OFFSET:GetBool() then
		pos = pos + ang:Up() * FGCWEP_VIEWMODEL_OFFSET_Z:GetFloat() + ang:Right() * FGCWEP_VIEWMODEL_OFFSET_X:GetFloat() + ang:Forward() * FGCWEP_VIEWMODEL_OFFSET_Y:GetFloat()
	end

	return self:CalcViewModelSway(vm, oldpos, oldang, pos, ang)
end

function SWEP:CalcViewModelView(vm,oldpos,oldang,pos,ang)
	pos, ang = self:ViewModelOffset(vm,oldpos,oldang,pos,ang)

	local bIron = self:GetIronsights()

	if bIron ~= self.bLastIron then
		self.bLastIron = bIron
		self.fIronTime = CurTime()
	end

	self.SwayScale = bIron and 0.3 or self.OSwayScale or 1
	self.BobScale = bIron and 0.1 or self.OBobScale or 1

    if not self.IronSightsPos then return pos, ang end

	local Mul = math.Clamp((CurTime() - (self.fIronTime or 0)) * 4, 0, 1)
	if not bIron then Mul = 1 - Mul end

	if Mul > 0 then
		local Offset = self.IronSightsPos
		if self.IronSightsAng then
			ang = Angle(ang.p, ang.y, ang.r)
			ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
			ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
			ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
		end

		pos = pos + Offset.x * Mul * ang:Right() + Offset.y * Mul * ang:Forward() + Offset.z * Mul * ang:Up()
	end

	return pos, ang
end

function SWEP:DrawHUD()
	if FGCWEP_CROSSHAIR_ENABLED:GetBool() then
		if not FGCWEP_CROSSHAIR_ONLYDOT:GetBool() then
			self:DrawCrosshairCross()
		end
		self:DrawCrosshairDot()
	end
end

local nodraw = {Draw = false}
function SWEP:CustomAmmoDisplay()
	if self.NoAmmoDisplay then return nodraw end

	self.AmmoDisplay = self.AmmoDisplay or {} 
	self.AmmoDisplay.Draw = true

	if self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self:Clip1()
		self.AmmoDisplay.PrimaryAmmo = self:Ammo1()
	else
		self.AmmoDisplay.PrimaryClip = self:Ammo1()
		self.AmmoDisplay.PrimaryAmmo = nil
	end

	if self.Secondary.ClipSize > 0 then
		self.AmmoDisplay.SecondaryAmmo = self:Ammo2()
	end

	return self.AmmoDisplay
end