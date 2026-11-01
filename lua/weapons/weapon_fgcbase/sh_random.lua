function SWEP:GetRandomSeed()
    if CLIENT and game.SinglePlayer() then
        local owner = self:GetOwner()
        if owner:IsNPC() then return math.random(1,2e9) end
        local seed = util.CRC(tostring(owner) .. math.random(1,1e9) .. tostring(self))
        return seed
    end
    local owner = self:GetOwner()
    if owner:IsNPC() then return math.random(1,2e9) end
    local cmd = owner:GetCurrentCommand()
    local seed = util.CRC(tostring(owner) .. cmd:CommandNumber() .. tostring(self))
    return seed
end

function SWEP:GetRand(min,max,s)
    s = s or 0
    return util.SharedRandom( "fgcrand_" .. self:GetRandomSeed(), min, max, CurTime() + s)
end