SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "male07"

SWEP.Category = "FGC_atom"
SWEP.Spawnable = true

SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = Model("models/weapons/c_arms.mdl")
SWEP.FGCDisplayModel = Model("models/player/group01/male_07.mdl")
SWEP.FGCAngleOffset = Angle(0,90,0)
SWEP.FGCUnhoverDisplayDistance = 500
SWEP.FGCUnhoverDisplayAngles = Angle(0,180,0)

SWEP.Primary = {
    Ammo = "nune",
    ClipSize = -1,
    Automatic = false
}
SWEP.Secondary = {
    Ammo = "nune",
    ClipSize = -1
}

SWEP.OriginalInfo = {
    category = "atom",
    name = "male07",
    server = "fgc", -- ofc from fgc
    description = "dr. freeman\nprimary: question\nsecondary: answer\nholding down various buttons uses different voicelines\n(alt, shift, use)\nreload for more voices"
}

SWEP.UseHands = false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.HoldType = "normal"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.NoAmmoDisplay = true

FGCWEP_NOTGUN()

function SWEP:KeyDown(IN)
    if not self:GetOwner():IsPlayer() then return end
    return self:GetOwner():KeyDown(IN)
end

function SWEP:CanPrimaryAttack() return self:GetNextPrimaryFire() <= CurTime() end
function SWEP:CanSecondaryAttack() return self:GetNextPrimaryFire() <= CurTime() end

do
    local use_sounds = {}
    for i = 1,17 do
        if i ~= 3 and i ~= 9 then -- 9 does not exist, 3 is split into 2 parts
            local digits = string.format("%02d",i)
            table.insert(use_sounds,"vo/npc/male01/gordead_ques" .. digits .. ".wav")
        end
    end

    table.insert(use_sounds,"vo/npc/male01/gordead_ques03a.wav")
    table.insert(use_sounds,"vo/npc/male01/gordead_ques03b.wav")

    function SWEP:PrimaryAttack()
        if not self:CanPrimaryAttack() then return end
        if CLIENT then return end

        -- walk will override use so i bet it is written like this
        if self:KeyDown(IN_WALK) then
            local digits = math.random(1,7)
            digits = string.format("%02d",digits)
            self:GetOwner():EmitSound("vo/npc/male01/vquestion" .. digits .. ".wav")
        elseif self:KeyDown(IN_USE) then
            local snd = table.Random(use_sounds)
            self:GetOwner():EmitSound(snd)
        else
            -- in my testing this only emits vo/npc/male01/questiondigit.wav sounds
            -- 1 - 31
            local digits = math.random(1,31)
            digits = string.format("%02d",digits)
            self:GetOwner():EmitSound("vo/npc/male01/question" .. digits .. ".wav")
        end

        self:SetNextPrimaryFire(CurTime() + 2)
        self:SetNextSecondaryFire(CurTime() + 2)
    end
end

do
    function SWEP:SecondaryAttack()
        if not self:CanSecondaryAttack() then return end
        if CLIENT then return end

        -- walk will override use so i bet it is written like this
        if self:KeyDown(IN_WALK) then
            local digits = math.random(1,14)
            digits = string.format("%02d",digits)
            self:GetOwner():EmitSound("vo/npc/male01/vanswer" .. digits .. ".wav")
        elseif self:KeyDown(IN_USE) then
            local digits = math.random(1,20)
            digits = string.format("%02d",digits)
            self:GetOwner():EmitSound("vo/npc/male01/gordead_ans" .. digits .. ".wav")
        else
            -- 1 - 40
            local digits = math.random(1,40)
            digits = string.format("%02d",digits)
            self:GetOwner():EmitSound("vo/npc/male01/answer" .. digits .. ".wav")
        end

        self:SetNextPrimaryFire(CurTime() + 2)
        self:SetNextSecondaryFire(CurTime() + 2)
    end
end

-- i have sorted the sounds path order so it looks like it's from wiki
do

    local hello_snds = {
        "vo/npc/male01/ahgordon01.wav",
        "vo/npc/male01/ahgordon02.wav",
        "vo/npc/male01/abouttime01.wav",
        "vo/npc/male01/abouttime02.wav",
        "vo/npc/male01/docfreeman01.wav",
        "vo/npc/male01/docfreeman02.wav",
        "vo/npc/male01/heydoc01.wav",
        "vo/npc/male01/heydoc02.wav",
        "vo/npc/male01/hellodrfm01.wav",
        "vo/npc/male01/hellodrfm02.wav",
        "vo/npc/male01/hi01.wav",
        "vo/npc/male01/hi02.wav",
        "vo/npc/male01/freeman.wav",
    }

    local sorry_snds = {
        "vo/npc/male01/sorry01.wav",
        "vo/npc/male01/sorry02.wav",
        "vo/npc/male01/sorry03.wav",
        "vo/npc/male01/sorrydoc01.wav",
        "vo/npc/male01/sorrydoc02.wav",
        "vo/npc/male01/sorrydoc04.wav",
        "vo/npc/male01/sorryfm01.wav",
        "vo/npc/male01/sorryfm02.wav",
        "vo/npc/male01/pardonme01.wav",
        "vo/npc/male01/pardonme02.wav",
    }

    function SWEP:Reload()
        if not self:CanPrimaryAttack() then return end
        if CLIENT then return end

        if self:KeyDown(IN_WALK) then
            if self:KeyDown(IN_USE) then
                local digits = math.random(1,2)
                digits = string.format("%02d",digits)
                self:GetOwner():EmitSound("vo/npc/male01/no" .. digits .. ".wav")
            elseif self:KeyDown(IN_SPEED) then
                self:GetOwner():EmitSound("vo/npc/male01/whoops01.wav")
            else
                local digits = math.random(1,5)
                digits = string.format("%02d",digits)
                self:GetOwner():EmitSound("vo/trainyard/male01/cit_hit" .. digits .. ".wav")
            end
        elseif self:KeyDown(IN_USE) then
            self:GetOwner():EmitSound("vo/npc/male01/yeah02.wav")
        elseif self:KeyDown(IN_SPEED) then
            local snd = table.Random(sorry_snds)
            self:GetOwner():EmitSound(snd)
        else
            local snd = table.Random(hello_snds)
            self:GetOwner():EmitSound(snd)
        end

        self:SetNextPrimaryFire(CurTime() + 2)
        self:SetNextSecondaryFire(CurTime() + 2)
    end
end