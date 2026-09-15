function SWEP:GetRandomSeed()
    local owner = self:GetOwner()
    if owner:IsNPC() then return math.random(1,2e9) end
    local cmd = owner:GetCurrentCommand()
    local seed = util.CRC(tostring(owner) .. cmd:CommandNumber() .. tostring(self))
    return seed
end

function SWEP:GetRand(min,max)
    return util.SharedRandom( "fgcrand_" .. self:GetRandomSeed(), min, max, CurTime())
end