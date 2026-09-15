-- from Zombie Survival
-- here i will paste it:
--[[
    JBGM LICENSE

    VERSION Xx420xX4, 05 May 2018

    Copyright � 2018 William Moodhe

    Anyone is allowed to copy, upload, or distribute copies of this license, but changing it is not allowed.

    Preamble

    The GNU license was garbage so I made my own. If you don't like it then feel free to delete the gamemode.
    A good portion of people have seen fit to modify stuff I've made, make it so people can "donate" for premium features, and subsequently generate revenue using things that I and others have created without permission. Then they ban members of my Steam groups, DDoS my own servers, openly insult me despite never having talked to me, and be jerks in general.

    So I will be issuing DMCA take down notices to server hosts and others who think that I'm joking. Server hosts have typically sided with me during the few times I've needed to do this. I don't plan on being 'that guy' and going after gmod servers trying to stay alive but I do plan on weeding out a few of the bigger jerks out there.

    tl;dr - I won't screw with you if you don't screw with me.

    The precise terms and conditions for copying, distribution and modification follow.

    TERMS AND CONDITIONS

    0. Definitions

    "License" refers to this file.

    "Author" refers to the person William Moodhe <williammoodhe@gmail.com> 

    "Content" refers to all files and folders that the license came with as well as the intellectual property and all derivitive works.

    "Copyright" refers to the laws on intellectual property and the legal rights automatically granted to the Author during the creation of the Content.

    "Modify" refers to editing the Content as well as creating programs or code which depends on the Content to run. For the purpose of this license, deleting things without deleting the entire Content is ALSO considered editing.

    1. For any conditions not outlined in the License, refer to your country or state laws for Copyright.
    [Host your server in Russia.]

    2. You may freely copy, distribute, create derivitive works and distribute derivitive works of the Content as long as you obey the License and the License is not Modified.
    [Feel free to make edits.]

    3. You will not Modify the Content in such a way that it will, directly or indirectly, generate revenue without explicit, written permission from the Author. CLARIFICATION: This clause does not include cosmetic features such as hats, PointShop, etc. as long as it is not possible to purchase gameplay advantages.
    [For example: it is not allowed to make it so you can pay to have extra health, points, speed, etc. It is allowed to have revenue-generating addons that offer only cosmetics or features that do not change the gameplay.]

    4. You will not deny access to the Author to anything in such a way that it would not allow the Author to see if the Gamemode was Modified.
    [For example: banning my Steam groups from your server.]

    5. If you do not agree to any of the above conditions you must delete the Content in its entirety as well as all copies of the Content and derivitive works of the Content that you have made.

    END TERMS AND CONDITIONS
--]]

local CONTENTS_LIQUID = bit.bor(CONTENTS_WATER, CONTENTS_SLIME)
local MASK_SHOT_HIT_WATER = bit.bor(MASK_SHOT, CONTENTS_LIQUID)
local MASK_MELEE = MASK_SHOT_HULL
local MASK_MELEE_HIT_WATER = bit.bor(MASK_SHOT_HULL, CONTENTS_LIQUID)

local bullet_tr = {}
local bullet_water_tr = {}
local bullet_trace = {mask = MASK_SHOT, output = bullet_tr}

local temp_vel_ents = {}

local function HandleShotImpactingWater(damage, melee)
	-- Trace again with water enabled
	bullet_trace.mask = melee and MASK_MELEE_HIT_WATER or MASK_SHOT_HIT_WATER
	bullet_trace.output = bullet_water_tr
	util.TraceLine(bullet_trace)
	bullet_trace.output = bullet_tr
	bullet_trace.mask = melee and MASK_MELEE or MASK_SHOT

	if bullet_water_tr.AllSolid then return false end

	local contents = util.PointContents(bullet_water_tr.HitPos - bullet_water_tr.HitNormal * 0.1)
	if bit.band(contents, CONTENTS_LIQUID) == 0 then return false end

	if IsFirstTimePredicted() then
		local effectdata = EffectData()
		effectdata:SetOrigin(bullet_water_tr.HitPos)
		effectdata:SetNormal(bullet_water_tr.HitNormal)
		effectdata:SetScale(math.Clamp(damage * 0.25, 5, 30))
		effectdata:SetFlags(bit.band(contents, CONTENTS_SLIME) ~= 0 and 1 or 0)
		util.Effect("gunshotsplash", effectdata)
	end

	return true
end

--[[
    Bullet Structure:
    bullet = {
        Src = Vector(),
        Dir = Vector(),
        Spread = Vector(),
        num = 1,
        Damage = 1,
        Force = 1,
        Attacker = 1,
        Callback = function() end,
        filter = function() end,
        HullSize = 1,
        Distance = 56756 or nil,
        Inflictor = self,
        CanHitWater = false,
        TracerSpeed = 5000 or nil
    }
--]]

local temp_angle = Angle()
function FGC_FireLuaBullets( self, bullet, callbackent )

	local f = table.Copy(bullet)
	f.Callback = nil
	if hook.Run("EntityFireBullets",self,f) then
		local ocallback = bullet.Callback
		local callback = f.Callback
		bullet = f
		bullet.Callback = ocallback
		bullet.SCallback = callback
	end

    local src = bullet.Src
    local dir = bullet.Dir
    local spread = bullet.Spread
    local num = bullet.Num or 1 
    local damage = bullet.Damage
    local force = bullet.Force
    local attacker = bullet.Attacker
    local callback = bullet.Callback
	local scallback = bullet.SCallback
    local filter = bullet.filter
    local hull_size = bullet.HullSize
    local max_distance = bullet.Distance or 56756
    local inflictor = bullet.Inflictor or self
    local canhitwater = bullet.CanHitWater
    local tracerspeed = bullet.TracerSpeed or 5000
	local tracer = bullet.Tracer or "Tracer"
	local melee = bullet.IsMelee
    local method_to_use

	bullet_trace.mask = melee and MASK_MELEE or MASK_SHOT

    bullet_trace.start = src
	if filter then
		bullet_trace.filter = filter
    else
        filter = {self}
	end

	local has_hull_size = false
    if hull_size then
		bullet_trace.maxs = Vector(hull_size, hull_size, hull_size) * 0.5
		bullet_trace.mins = bullet_trace.maxs * -1
		method_to_use = util.TraceHull
		has_hull_size = true
	else
		method_to_use = util.TraceLine
	end

    local base_ang = dir:Angle()
    local has_spread = spread > 0

    for i=0, num - 1 do
		if has_spread then
			temp_angle:Set(base_ang)
			temp_angle:RotateAroundAxis(
				temp_angle:Forward(),
				math.Rand(0, 360)
			)
			temp_angle:RotateAroundAxis(
				temp_angle:Up(),
				math.Rand(-spread, spread)
			)

			dir = temp_angle:Forward()
		end

		bullet_trace.endpos = src + dir * max_distance
		if melee then
			method_to_use = util.TraceLine
			bullet_tr = method_to_use(bullet_trace)
			if not bullet_tr.Hit then
				method_to_use = util.TraceHull
				bullet_tr = method_to_use(bullet_trace)
			end
		else
			bullet_tr = method_to_use(bullet_trace)
		end

		if has_hull_size then
			FGCWEP_FindHullIntersection(bullet_trace, bullet_tr)
		end

		local hitwater
        if bit.band(util.PointContents(bullet_tr.HitPos), CONTENTS_LIQUID) ~= 0 and canhitwater then
            hitwater = HandleShotImpactingWater(damage)
        end

		local damageinfo = DamageInfo()
		damageinfo:SetDamageType(DMG_BULLET)
		damageinfo:SetDamage(damage)
		damageinfo:SetDamagePosition(bullet_tr.HitPos)
		damageinfo:SetAttacker(attacker)
		damageinfo:SetInflictor(inflictor or self)
		if force then damageinfo:SetDamageForce(force * dir:GetNormalized()) else local damage = damage == math.huge and 1e9 or damage damageinfo:SetDamageForce(damage / 70 * dir:GetNormalized()) end

		local use_tracer = true
		local use_impact = true
		local use_ragdoll_impact = true
		local use_damage = true

		if scallback then
			local ret = scallback(attacker,bullet_tr,damageinfo)
			if ret then
				if ret.effects ~= nil then use_tracer = ret.effects use_impact = ret.effects end
				if ret.damage ~= nil then use_damage = ret.damage end
			end
		end

		if callback then
			local ret = callback(callbackent or self, attacker, bullet_tr, damageinfo)
			if ret then
				if ret.donothing then continue end

				if ret.tracer ~= nil then use_tracer = ret.tracer end
				if ret.impact ~= nil then use_impact = ret.impact end
				if ret.ragdoll_impact ~= nil then use_ragdoll_impact = ret.ragdoll_impact end
				if ret.damage ~= nil then use_damage = ret.damage end
			end
		end

		local ent = bullet_tr.Entity
		if IsValid(ent) and use_damage then
			if self:IsNPC() then
				temp_vel_ents[ent] = temp_vel_ents[ent] or ent:GetVelocity()
			end
			if ent:IsPlayer() then
				if SERVER then
					ent:SetLastHitGroup(bullet_tr.HitGroup)
				end
			elseif attacker:IsValid() and attacker:IsPlayer() then
				local phys = ent:GetPhysicsObject()
				if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
					ent:SetPhysicsAttacker(attacker)
					phys:ApplyForceOffset(damageinfo:GetDamageForce() * 4000,bullet_tr.HitPos)
				end
			end

			ent:DispatchTraceAttack(damageinfo, bullet_tr, dir)
		end

		if IsFirstTimePredicted() then
			local effectdata = EffectData()
			effectdata:SetOrigin(bullet_tr.HitPos)
			effectdata:SetStart(src)
			effectdata:SetNormal(bullet_tr.HitNormal)

			if hitwater then
				-- We may not impact, but we DO need to affect ragdolls on the client
				if use_ragdoll_impact then
					util.Effect("RagdollImpact", effectdata)
				end
			elseif use_impact and not bullet_tr.HitSky and bullet_tr.Fraction < 1 then
				effectdata:SetSurfaceProp(bullet_tr.SurfaceProps)
				effectdata:SetDamageType(DMG_BULLET)
				effectdata:SetHitBox(bullet_tr.HitBox)
				effectdata:SetEntity(ent)
				util.Effect("Impact", effectdata)
			end

			if use_tracer and tracer ~= "" then
				if (self:IsPlayer() or self:IsNPC()) and IsValid(self:GetActiveWeapon()) then
					effectdata:SetFlags( 0x0003 ) --TRACER_FLAG_USEATTACHMENT + TRACER_FLAG_WHIZ
					effectdata:SetEntity(self:GetActiveWeapon())
					effectdata:SetAttachment(1)
				else
					effectdata:SetEntity(self)
					effectdata:SetFlags( 0x0001 ) -- TRACER_FLAG_WHIZ
				end
				effectdata:SetScale(tracerspeed) -- Tracer travel speed
				util.Effect(tracer or "Tracer", effectdata)
			end
		end
	end

	for ent,vel in pairs(temp_vel_ents)do
		ent:SetLocalVelocity(vel)
	end
	table.Empty(temp_vel_ents)
end