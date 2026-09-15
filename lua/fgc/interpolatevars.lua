--from SWCS

local TICK_INTERVAL = engine.TickInterval()
local function TICK_TO_TIME(t)
	return t * TICK_INTERVAL
end

local floor = math.floor
local function TIME_TO_TICK(t)
	return floor(t / TICK_INTERVAL)
end


function FGCWEP_DefineInterpolatedVar(tab, keyName, getSetterName, defaultValue, bIsDTVar)
    local strGetUninterpolated = "GetUninterpolated" .. getSetterName
	local strSetUninterpolated = "SetUninterpolated" .. getSetterName
	local strGetLast = "GetLast" .. getSetterName
	local strSetLast = "SetLast" .. getSetterName
	local strSet = "Set" .. getSetterName
	local strGet = "Get" .. getSetterName

	-- handle DefineInterpolatedVar(tab, keyName, getSetterName, bIsDTVar)
	if bIsDTVar == nil then
		bIsDTVar = defaultValue
		defaultValue = nil
	end

	-- Get/Set Last val
	tab[strGetLast] = function(self)
		return self[keyName .. "Last"]
	end
	tab[strSetLast] = function(self, value)
		self[keyName .. "Last"] = value
	end

	-- Get/Set Uninterpolated val
	if bIsDTVar == true then
		tab[strGetUninterpolated] = tab[strGet]
		tab[strSetUninterpolated] = tab[strSet]
	else
		tab[strGetUninterpolated] = function(self)
			return self[keyName .. "Uninterpolated"]
		end
		tab[strSetUninterpolated] = function(self, value)
			self[keyName .. "Uninterpolated"] = value
		end
		tab[keyName .. "Last"] = defaultValue or tab[keyName]
		tab[keyName .. "Uninterpolated"] = defaultValue or tab[keyName]
	end

	local bIsSingleplayer = game.SinglePlayer()

	tab[strGet] = function(self, bInterpolated)
		if (bInterpolated == false or bIsSingleplayer or SERVER or true) then
			return self[strGetUninterpolated](self)
		end

		local flTimeNow = CurTime()
		local flClientTick = TICK_TO_TIME(TIME_TO_TICK(flTimeNow) + 1)
		local flBetweenTickPercentage = (flClientTick - flTimeNow) / TICK_INTERVAL

		local prevVal = self[strGetLast](self)
		local uninterpVal = self[strGetUninterpolated](self)

		local prevLerp = (prevVal * flBetweenTickPercentage)
		local uninterpLerp = (uninterpVal * (1.0 - flBetweenTickPercentage))

		local fullLerp = prevLerp + uninterpLerp

		return fullLerp
	end
	tab[strSet] = function(self, value)
		if CLIENT and IsFirstTimePredicted() then
			self[strSetLast](self, self[strGetUninterpolated](self))
		end

		self[strSetUninterpolated](self, value)
	end
end