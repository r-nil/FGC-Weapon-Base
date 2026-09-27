function SWEP:PrintWeaponInfo(x, y, alpha)
    FGCWEP_PrintWeaponInfo(self,x,y,alpha)
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
    y = y + 10
    x = x + 10
    wide = wide - 20

    local w,h = killicon.GetSize(self:GetClass())
    killicon.Render(x + wide / 2 - w / 2,y + tall / 2 - h / 2,self:GetClass(),alpha)

    self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
end
