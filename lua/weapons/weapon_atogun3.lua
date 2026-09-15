SWEP.Base = "weapon_fgcbase"

SWEP.PrintName = "atogun3"

FGCWEP_NOTGUN()

SWEP.Category = "FGC_atom_admin"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.UseHands = true

SWEP.Primary = {
    Ammo = "nune",
    ClipSize = -1,
    Automatic = true,
    Delay = 0.01
}
SWEP.Secondary = {
    Ammo = "nune",
    ClipSize = -1,
    Automatic = true,
    Delay = 0.01
}

SWEP.OriginalInfo = {
    category = "atom_admin",
    name = "atogun3",
    server = "fgc", -- ofc from fgc
    description = "slams and frags\ndue to server limit only 5 slams at a time"
}

SWEP.HoldType = "normal"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.NoAmmoDisplay = true

function SWEP:SendWeaponAnimation() end

function SWEP:PrimaryAttack()
    if not self:IsMod() then
        self:PrintMessage(HUD_PRINTTALK,"you may not")
        return
    end
    self.BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
    if not self:IsMod() then
        self:PrintMessage(HUD_PRINTTALK,"you may not")
        return
    end
    self:SecondaryAttack_Shoot()
end

FGCWEP_ATOGUN3_GRENADEEXPLODE = FGCCONVAR_SH("fgcwep_sv_atogun3_grenadelive","0",0,"atogun3: grenades spawned will detonate",0,1)

function SWEP:ShootBullets(dmg,num,cone,secondary)
    if CLIENT then return end

    if secondary then
        local ent = ents.Create("npc_grenade_frag")
        ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 75)
        ent:SetAngles(self:GetBulletDir():Angle())
        ent:SetOwner(self:GetOwner())
        ent:Spawn()
        local phy = ent:GetPhysicsObject()
        if IsValid(phy) then
            phy:ApplyForceCenter(self:GetBulletDir() * phy:GetMass() * 100 + VectorRand(-10,10))
        end

        ent:SetSaveValue("m_hThrower",self:GetOwner())
        ent:SetSaveValue("m_hOriginalThrower",self:GetOwner())

        cleanup.Add(self:GetOwner(),"sents",ent)
        undo.Create("atogun3_Frag")
		undo.AddEntity(ent)
		undo.SetPlayer(self:GetOwner())
	    
        if FGCWEP_ATOGUN3_GRENADEEXPLODE:GetBool() then
            ent:Fire("SetTimer",10)
            ent.FGCWEP_ForceWeapon = self
        else
            SafeRemoveEntityDelayed(ent,10)
        end
    else
        local ent = ents.Create("npc_satchel")
        ent:SetPos(self:GetBulletSrc() + self:GetBulletDir() * 75)
        ent:SetAngles(self:GetBulletDir():Angle())
        ent:SetOwner(self:GetOwner())
        ent:Spawn()
        local phy = ent:GetPhysicsObject()
        if IsValid(phy) then
            phy:ApplyForceCenter(self:GetBulletDir() * phy:GetMass() * 100 + VectorRand(-10,10))
        end

        ent:SetSaveValue("m_hThrower",self:GetOwner())
        ent:SetSaveValue("m_hOriginalThrower",self:GetOwner())
        ent:SetSaveValue("m_bIsLive",true)
        --ent.FGCWEP_ForceWeapon = self

        cleanup.Add(self:GetOwner(),"sents",ent)
        undo.Create("atogun3_SLAM")
		undo.AddEntity(ent)
		undo.SetPlayer(self:GetOwner())

        if self:GetOwner():IsPlayer() then
            if IsValid(self:GetOwner():GetWeapon("weapon_slam")) then
                self:GetOwner():GetWeapon("weapon_slam"):SetSaveValue("m_bDetonatorArmed",true)
                self:GetOwner():GetWeapon("weapon_slam"):SetSaveValue("m_bNeedDetonatorDraw",true)
            end
        end
	    
        SafeRemoveEntityDelayed(ent,10)
    end
end