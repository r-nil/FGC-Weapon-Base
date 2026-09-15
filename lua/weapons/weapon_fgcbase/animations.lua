local emeta = FindMetaTable("Entity")
local getown = emeta.GetOwner
local vector_one = Vector(1, 1, 1)
local vector_origin = Vector(0, 0, 0)
local angle_zero = Angle(0, 0, 0)
local spriteParams = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }

--[[*******************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378


	DESCRIPTION:
		This script is meant for experienced scripters
		that KNOW WHAT THEY ARE DOING. Don't come to me
		with basic Lua questions.

		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.

		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
*******************************************************]]
function SWEP:Anim_Initialize()
	-- other initialize code goes here
	if CLIENT and self.VElements then
		-- Create a new table for every weapon instance
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels
		-- init view model bone build function
		local owner = getown(self)
		if IsValid(owner) then
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end
		end
	end
end

function SWEP:Anim_Holster()
	local owner = getown(self)
	if CLIENT and IsValid(owner) and owner:IsPlayer() then
		local vm = owner:GetViewModel()
		if IsValid(vm) then self:ResetBonePositions(vm) end
	end
	return true
end

function SWEP:Anim_OnRemove()
	self:Anim_Holster()
	for i,v in pairs(self.SCK_CREATEDMODELS or {}) do
		if IsValid(v) then v:Remove() end
	end
end

if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:Anim_ViewModelDrawn()
		local owner = getown(self)
		if not IsValid(owner) then return end
		local vm = owner:GetViewModel()
		if not IsValid(vm) then return end
		if not self.VElements then return end
		self:UpdateBonePositions(vm)
		if not self.vRenderOrder then
			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}
			-- clean up cached clip planes
			for k, v in pairs(self.VElements) do
				if v.type == "Model" then
					v.clipplanes = nil
					v.clipcount = nil
				end
			end

			for k, v in pairs(self.VElements) do
				if v.type == "Model" then
					if v.highrender then
						table.insert(self.vRenderOrder, k)
					else
						table.insert(self.vRenderOrder, 1, k)
					end
				elseif v.type == "Sprite" or v.type == "Quad" then
					table.insert(self.vRenderOrder, k)
				elseif v.type == "ClipPlane" then
					if v.rel == "" or v.rel == nil then continue end
					if self.VElements[v.rel] and self.VElements[v.rel].type == "Model" then
						self.VElements[v.rel].clipplanes = self.VElements[v.rel].clipplanes or {}
						self.VElements[v.rel].clipcount = self.VElements[v.rel].clipcount or 0
						table.insert(self.VElements[v.rel].clipplanes, k)
						self.VElements[v.rel].clipcount = self.VElements[v.rel].clipcount + 1
						table.insert(self.vRenderOrder, k)
					end
				end
			end
		end

		for k, name in ipairs(self.vRenderOrder) do
			local v = self.VElements[name]
			if not v then
				self.vRenderOrder = nil
				break
			end

			if v.hide then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if not v.bone then continue end
			local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)
			if not pos then continue end
			if v.type == "Model" and IsValid(model) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)
				if v.size.x < 0 and not v.inversed then v.inversed = true end
				-- reset back just in case
				if v.inversed and v.size.x > 0 then v.inversed = nil end
				if v.bonemerge then
					if not model:IsEffectActive(EF_BONEMERGE) then
						model:SetParent(vm)
						model:AddEffects(EF_BONEMERGE)
					end
				else
					if model:IsEffectActive(EF_BONEMERGE) then
						model:SetParent(self)
						model:RemoveEffects(EF_BONEMERGE)
					end
				end

				if v.skin and v.skin ~= model:GetSkin() then model:SetSkin(v.skin) end
				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if istable(v) then continue end
						if model:GetBodygroup(tonumber(k) or 0) ~= v then model:SetBodygroup(tonumber(k) or 0, v) end
					end
				end

				if v.surpresslightning then render.SuppressEngineLighting(true) end
				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)

				--[[
				render.OverrideColorWriteEnable( true, false )
				model:SetMaterial("model_color")
				model:DrawModel()
				render.OverrideColorWriteEnable( false, false )
				]]
				render.SetBlend(v.color.a/255 * (v.alphamul or 1))
				if v.inversed then render.CullMode(MATERIAL_CULLMODE_CW) end
				local real_clip_count = 0
				if v.clipplanes and v.clipcount then
					render.EnableClipping(true)
					for i = 1, math.min(v.clipcount, 2) do
						local plane = v.clipplanes[i]
						if plane and self.VElements[plane] then
							local clip_data = self.VElements[plane]
							local clip_ang = ang * 1
							local clip_pos = model:GetPos() + clip_ang:Forward() * clip_data.pos.x + clip_ang:Right() * clip_data.pos.y + clip_ang:Up() * clip_data.pos.z
							clip_ang:RotateAroundAxis(clip_ang:Up(), clip_data.angle.y)
							clip_ang:RotateAroundAxis(clip_ang:Right(), clip_data.angle.p)
							clip_ang:RotateAroundAxis(clip_ang:Forward(), clip_data.angle.r)
							render.PushCustomClipPlane(clip_ang:Up(), clip_ang:Up():Dot(clip_pos))
							real_clip_count = real_clip_count + 1
						end
					end
				end

				if v.material == "" then
					model:SetMaterial("")
				elseif model:GetMaterial() ~= v.material then
					model:SetMaterial(v.material)
				end
				if v.renderoverride then
					v.renderoverride(model,self)
				else
					model:DrawModel()
				end
				if real_clip_count > 0 and v.nocull then
					render.CullMode(v.inversed and MATERIAL_CULLMODE_CCW or MATERIAL_CULLMODE_CW)
					if v.renderoverride then
						v.renderoverride(model,self)
					else
						model:DrawModel()
					end
					render.CullMode(v.inversed and MATERIAL_CULLMODE_CW or MATERIAL_CULLMODE_CCW)
				end

				if real_clip_count > 0 then
					for i = 1, real_clip_count do
						render.PopCustomClipPlane()
					end

					render.EnableClipping(false)
				end

				if v.inversed then render.CullMode(MATERIAL_CULLMODE_CCW) end
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				if v.surpresslightning then render.SuppressEngineLighting(false) end
			elseif v.type == "Sprite" and sprite then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif v.type == "Quad" and v.draw_func then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	SWEP.wRenderOrder = nil
	function SWEP:Anim_DrawWorldModel()
		if self.ShowWorldModel == nil or self.ShowWorldModel then self:DrawModel() end
		if not self.WElements then return end
		if not self.wRenderOrder then
			self.wRenderOrder = {}
			-- clean up cached clip planes
			for k, v in pairs(self.WElements) do
				if v.type == "Model" then
					v.clipplanes = nil
					v.clipcount = nil
				end
			end

			for k, v in pairs(self.WElements) do
				if v.type == "Model" then
					if v.highrender then
						table.insert(self.wRenderOrder, k)
					else
						table.insert(self.wRenderOrder, 1, k)
					end
				elseif v.type == "Sprite" or v.type == "Quad" then
					table.insert(self.wRenderOrder, k)
				elseif v.type == "ClipPlane" then
					if v.rel == "" or v.rel == nil then continue end
					if self.WElements[v.rel] and self.WElements[v.rel].type == "Model" then
						self.WElements[v.rel].clipplanes = self.WElements[v.rel].clipplanes or {}
						self.WElements[v.rel].clipcount = self.WElements[v.rel].clipcount or 0
						table.insert(self.WElements[v.rel].clipplanes, k)
						self.WElements[v.rel].clipcount = self.WElements[v.rel].clipcount + 1
						table.insert(self.wRenderOrder, k)
					end
				end
			end
		end

		local owner = getown(self)
		local bone_ent
		if IsValid(owner) then
			bone_ent = owner
		else
			-- when the weapon is dropped
			bone_ent = self
		end

		for k, name in pairs(self.wRenderOrder) do
			local v = self.WElements[name]
			if not v then
				self.wRenderOrder = nil
				break
			end

			if v.hide then continue end
			local pos, ang
			if v.bone then
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent)
			else
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand")
			end

			if not pos then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if v.type == "Model" and IsValid(model) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)
				if model.ModelMatrixScale ~= v.size then model.ModelMatrixScale = v.size end
				if v.bonemerge then
					if not model:IsEffectActive(EF_BONEMERGE) then
						model:SetParent(owner)
						model:AddEffects(EF_BONEMERGE)
					end
				else
					if model:IsEffectActive(EF_BONEMERGE) then
						model:SetParent(self)
						model:RemoveEffects(EF_BONEMERGE)
					end
				end

				if v.material == "" then
					model:SetMaterial("")
				elseif model:GetMaterial() ~= v.material then
					model:SetMaterial(v.material)
				end

				if v.skin and v.skin ~= model:GetSkin() then model:SetSkin(v.skin) end
				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if istable(v) then continue end
						if model:GetBodygroup(tonumber(k) or 0) ~= v then model:SetBodygroup(tonumber(k) or 0, v) end
					end
				end

				if v.surpresslightning then render.SuppressEngineLighting(true) end
				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)

				render.OverrideColorWriteEnable( true, false )
				if v.renderoverride then
					v.renderoverride(model,self)
				else
					model:DrawModel()
				end
				render.OverrideColorWriteEnable( false, false )

				render.SetBlend(v.color.a/255 * (v.alphamul or 1))
				local real_clip_count = 0
				if v.clipplanes and v.clipcount then
					render.EnableClipping(true)
					for i = 1, math.min(v.clipcount, 2) do
						local plane = v.clipplanes[i]
						if plane and self.WElements[plane] then
							local clip_data = self.WElements[plane]
							local clip_ang = ang * 1
							local clip_pos = model:GetPos() + clip_ang:Forward() * clip_data.pos.x + clip_ang:Right() * clip_data.pos.y + clip_ang:Up() * clip_data.pos.z
							clip_ang:RotateAroundAxis(clip_ang:Up(), clip_data.angle.y)
							clip_ang:RotateAroundAxis(clip_ang:Right(), clip_data.angle.p)
							clip_ang:RotateAroundAxis(clip_ang:Forward(), clip_data.angle.r)
							render.PushCustomClipPlane(clip_ang:Up(), clip_ang:Up():Dot(clip_pos))
							real_clip_count = real_clip_count + 1
						end
					end
				end

				if v.renderoverride then
					v.renderoverride(model,self)
				else
					model:DrawModel()
				end
				if real_clip_count > 0 and v.nocull then
					render.CullMode(MATERIAL_CULLMODE_CW)
					if v.renderoverride then
						v.renderoverride(model,self)
					else
						model:DrawModel()
					end
					render.CullMode(MATERIAL_CULLMODE_CCW)
				end

				if real_clip_count > 0 then
					for i = 1, real_clip_count do
						render.PopCustomClipPlane()
					end

					render.EnableClipping(false)
				end

				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				if v.surpresslightning then render.SuppressEngineLighting(false) end
			elseif v.type == "Sprite" and sprite then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif v.type == "Quad" and v.draw_func then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
		local bone, pos, ang
		if tab.rel and tab.rel ~= "" then
			local v = basetab[tab.rel]
			if not v then return end
			-- Technically, if there exists an element with the same name as a bone
			-- you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation(basetab, v, ent)
			if not pos then return end
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		else
			bone = ent:LookupBone(bone_override or tab.bone)
			if not bone then return end
			pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
			--if system.HasFocus() then
			--	ent:InvalidateBoneCache()
			--	ent:SetupBones()
			--end
			local m = ent:GetBoneMatrix(bone)
			if m then pos, ang = m:GetTranslation(), m:GetAngles() end
		local owner = getown(self)
		if IsValid(owner) and owner:IsPlayer() and ent == owner:GetViewModel() and self.ViewModelFlip then
				ang.r = -ang.r -- Fixes mirrored models
			end
		end
		return pos, ang
	end

	SWEP.SCK_CREATEDMODELS = {}
	function SWEP:CreateModels(tab)
		if not tab then return end
		-- Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs(tab) do
			if v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and string.find(v.model, ".mdl") and file.Exists(v.model, "GAME") then
				v.modelEnt = ClientsideModel(v.model, RENDERGROUP_TRANSLUCENT)
				if IsValid(v.modelEnt) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model

					table.insert(self.SCK_CREATEDMODELS,v.modelEnt)
				else
					v.modelEnt = nil
				end
			elseif v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) and file.Exists("materials/" .. v.sprite .. ".vmt", "GAME") then
				local name = v.sprite .. "-"
				local params = {
					["$basetexture"] = v.sprite
				}

				-- make sure we create a unique name based on the selected options
				for i = 1, #spriteParams do
					local j = spriteParams[i]
					if v[j] then
						params["$" .. j] = 1
						name = name .. "1"
					else
						name = name .. "0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
			end
		end
	end

	local hasGarryFixedBoneScalingYet = false
	local defaultBoneMod = { scale = vector_one, pos = vector_origin, angle = angle_zero }
	function SWEP:UpdateBonePositions(vm)
		if self.ViewModelBoneMods then
			if not vm:GetBoneCount() then return end
			-- !! WORKAROUND !! --
			-- We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if not hasGarryFixedBoneScalingYet then
				-- This table used to be rebuilt every frame and shared between weapons.
				-- Cache it per weapon/viewmodel; the bone layout and mod table are static
				-- for normal SWEP operation, while table replacement still rebuilds it.
				local cache = self._SCKAllBones
				if not cache or cache.vm ~= vm or cache.boneCount ~= vm:GetBoneCount() then
					cache = { vm = vm, boneCount = vm:GetBoneCount(), bones = {}, names = {} }
					self._SCKAllBones = cache
				end
				local allbones = cache.bones
				if not cache.ready then
					for i = 0, cache.boneCount do cache.names[i] = vm:GetBoneName(i) end
					cache.ready = true
				end
				-- Refresh references every frame so animated/mutated bone-mod tables
				-- retain their original behaviour without allocating default tables.
				for i = 0, cache.boneCount do
					local bonename = cache.names[i]
					allbones[bonename] = self.ViewModelBoneMods[bonename] or defaultBoneMod
				end

				loopthrough = allbones
			end

			-- !! ----------- !! --
			for k, v in pairs(loopthrough) do
				local bone = vm:LookupBone(k)
				if not bone then continue end
				-- !! WORKAROUND !! --
				local s = Vector(v.scale.x, v.scale.y, v.scale.z)
				local p = Vector(v.pos.x, v.pos.y, v.pos.z)
				local ms = Vector(1, 1, 1)
				if not hasGarryFixedBoneScalingYet then
					local cur = vm:GetBoneParent(bone)
					while cur >= 0 do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end

				s = s * ms
				-- !! ----------- !! --
				if vm:GetManipulateBoneScale(bone) ~= s then vm:ManipulateBoneScale(bone, s) end
				if vm:GetManipulateBoneAngles(bone) ~= v.angle then vm:ManipulateBoneAngles(bone, v.angle) end
				if vm:GetManipulateBonePosition(bone) ~= p then vm:ManipulateBonePosition(bone, p) end
			end
		else
			self:ResetBonePositions(vm)
		end
	end

	function SWEP:ResetBonePositions(vm)
		-- New code
		vm:SetColor(color_white)
		vm:SetMaterial("")
		--------
		if not vm:GetBoneCount() then return end
		for i = 0, vm:GetBoneCount() do
			vm:ManipulateBoneScale(i, vector_one)
			vm:ManipulateBoneAngles(i, angle_zero)
			vm:ManipulateBonePosition(i, vector_origin)
		end
	end
end
