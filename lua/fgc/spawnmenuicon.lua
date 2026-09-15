FGCWEP_OldspawnmenuCreateContentIcon = FGCWEP_OldspawnmenuCreateContentIcon or spawnmenu.CreateContentIcon

surface.CreateFont("FGCWEP_DermaDefault13", {
    font = "Verdana",
    size = 15,
    weight = 1000,
    extended = true,
    shadow = false
})

surface.CreateFont("FGCWEP_DermaDefault", {
    font = "Verdana",
    size = 16,
    weight = 1000,
    extended = true,
    shadow = true
})

surface.CreateFont("FGCWEP_DermaDefaultBigger", {
    font = "Verdana",
    size = 20,
    weight = 1000,
    extended = true,
    shadow = true
})


surface.CreateFont("FGCWEP_DermaDefaultBold", {
    font = "Verdana",
    size = 25,
    weight = 10000,
    extended = true,
    shadow = true
})

surface.CreateFont("FGCWEP_DermaLarge", {
    font = "Verdana",
    size = 32,
    weight = 100,
    extended = true,
    shadow = true
})

local matOverlay_Normal = Material( "gui/ContentIcon-normal.png" )
local matOverlay_Hovered = Material( "gui/ContentIcon-hovered.png" )

local matOverlay_AdminOnly = Material( "icon16/shield.png" )
local matOverlay_NPCWeapon = Material( "icon16/monkey.png" )
local matOverlay_NPCWeaponSelected = Material( "icon16/monkey_tick.png" )

local gradup = Material("gui/gradient_up")

spawnmenu.CreateContentIcon = function(type,parent,data)
    local panel,a,a2 = FGCWEP_OldspawnmenuCreateContentIcon(type,parent,data)

    if type == "weapon" and data.spawnname then
        local wep = weapons.Get( data.spawnname )
        if wep and wep.FGC then
            panel.strTooltipText = nil

            hook.Add("PostRenderVGUI",panel,function(self)
                if not self:IsHovered() then return end
                local w,h = self:GetSize()
                local x,y = self:LocalToScreen(0,0)
                FGCWEP_PrintWeaponInfo(wep,x + 4, y + 4 + h + 5,255,self,false, math.min(ScrW() / 2,700))
            end)

            panel.Image:Remove()

            local admin = wep.AdminOnly or not wep.Spawnable

            local info = wep.OriginalInfo

            local author,authorclr = nil,Color(255,255,255)
            if info.category and FGCWEP_KNOWNMEMBERS[info.category] then
                author = FGCWEP_KNOWNMEMBERS[info.category].text
                authorclr = FGCWEP_KNOWNMEMBERS[info.category].lclr
            elseif info.author and FGCWEP_KNOWNMEMBERS[info.author] then
                author = FGCWEP_KNOWNMEMBERS[info.author].text
                authorclr = FGCWEP_KNOWNMEMBERS[info.author].lclr
            end

            if wep.ShowWorldModel == false and not wep.FGCDisplayModel then
                panel.Image = panel:Add("DLabel")
                panel.Image:SetPos(3, 3)
                panel.Image:SetSize(128 - 6, 128 - 6)
                panel.Image:SetVisible(true)
                panel.Image:SetText(wep.PrintName)
                panel.Image:SetFont("FGCWEP_DermaDefaultBigger")
                panel.Image:SetMouseInputEnabled(false)
                panel.Image:SetContentAlignment(5)
                panel.Image:SetTextColor(authorclr)
            else
                panel.Image = panel:Add("DModelPanel")
                panel.Image:SetPos(3, 3)
                panel.Image:SetSize(128 - 6, 128 - 6)
                panel.Image:SetVisible(true)
                panel.Image:SetModel(wep.FGCDisplayModel or wep.WorldModel)
                panel.Image:SetMouseInputEnabled(false)

                panel.Image.Distance = 30
                panel.Image.Lerp = 0

                function panel.Image.Entity:GetPlayerColor()
                    return authorclr:ToVector()
                end

                function panel.Image.Entity:GetWeaponColor()
                    return authorclr:ToVector()
                end

                function panel.Image:Paint(w, h)
                    if not IsValid(self.Entity) then return end
                    local x, y = self:LocalToScreen(0, 0)
                    self:LayoutEntity(self.Entity)
                    local ang = self.aLookAngle
                    if not ang then ang = (self.vLookatPos - self.vCamPos):Angle() end
                    cam.Start3D(self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ)
                    render.SuppressEngineLighting(true)
                    render.SetLightingOrigin(self.Entity:GetPos())
                    render.ResetModelLighting(1,1,1)
                    render.SetColorModulation(1,1,1)
                    render.SetBlend(1)
                    for i = 0, 5 do
                        if admin then
                            local clr = HSVToColor(RealTime() * 360 % 360 + (i + 1) / 6 * 360,1,1)
                            render.SetModelLighting(i, 2 + clr.r / 255 * 4,2 + clr.g / 255 * 4,2 + clr.b / 255 * 4)
                        else
                            render.SetModelLighting(i, 1,1,1)
                        end
                    end

                    self:DrawModel()
                    render.SuppressEngineLighting(false)
                    cam.End3D()
                    self.LastPaint = RealTime()
                end

                function panel.Image:LayoutEntity(ent)
                    local ct = RealTime() * 0.1

                    local ease = math.ease.InBack
                    if not self.IN then ease = function(x) return x end end
                    local lerp = ease(self.Lerp)
                    ent:SetAngles(LerpAngle(lerp,wep.FGCUnhoverDisplayAngles or Angle(0,0,90),Angle(0,0,0)) + (wep.FGCAngleOffset or Angle(0,0,0)))
                    local center = ent:OBBCenter()
                    center:Rotate(ent:GetAngles())
                    local size = ent:OBBMaxs() - ent:OBBMins()
                    --size:Rotate(ent:GetAngles())

                    local distance = wep.FGCDisplayDistance or math.max(size.x,size.y,size.z) * 1.1

                    if not wep.FGCUnhoverDisplayDistance then
                        self.Distance = distance
                    else
                        self.Distance = Lerp(lerp,wep.FGCUnhoverDisplayDistance,distance)
                    end

                    local from = center + Vector(math.cos(ct) * self.Distance,math.abs(math.sin(ct) * self.Distance), 1.7 * self.Distance)
                    local to = center + Vector(0,1 * self.Distance,0)
                    panel.Image:SetCamPos(LerpVector(lerp,from,to))
                    panel.Image:SetFOV(50 + lerp * 3)
                    panel.Image:SetLookAt(center)
                    return
                end

                function panel.Image:Think()
                    local parent = self:GetParent()
                    if (parent:IsHovered() or parent.Depressed or parent:IsChildHovered()) then
                        self.Lerp = Lerp(FrameTime() * 10,self.Lerp,1)
                        self.IN = true
                    else
                        self.Lerp = Lerp(FrameTime() * 10,self.Lerp,0)
                        self.IN = false
                    end
                end
            end

            local shadowColor = Color(0, 0, 0, 200)
            local function DrawTextShadow(text, x, y, clr)
                --draw.SimpleText(text, "FGCWEP_DermaDefault", x + 1, y + 1, shadowColor)
                draw.SimpleText(text, "FGCWEP_DermaDefault", x, y, clr or color_white)
            end

            function panel:Paint(w, h)
                if self.Depressed and not self.Dragging then
                    if self.Border ~= 8 then
                        self.Border = 8
                        self:OnDepressionChanged(true)
                    end
                else
                    if self.Border ~= 0 then
                        self.Border = 0
                        self:OnDepressionChanged(false)
                    end
                end

                self.Image:SetPos(3 + self.Border, 3 + self.Border / 2)
                self.Image:SetSize(128 - 6 - self.Border, 128 - 6 - self.Border)

                surface.SetDrawColor(255, 255, 255, 255)
                local drawText = false
                if not dragndrop.IsDragging() and (self:IsHovered() or self.Depressed or self:IsChildHovered()) then
                    surface.SetMaterial(matOverlay_Hovered)
                else
                    surface.SetMaterial(matOverlay_Normal)
                    drawText = true
                end

                surface.DrawTexturedRect(self.Border, self.Border, w - self.Border * 2, h - self.Border * 2)

                local authorx = self.Border + 8

                if admin then -- Admin only icon
                    surface.SetMaterial(matOverlay_AdminOnly)
                    --surface.DrawTexturedRect(self.Border + 8, self.Border + 8, 16, 16)
                    surface.DrawTexturedRect(w - self.Border - 24, self.Border + 8, 16, 16)
                    --authorx = authorx + 16 + 2
                end

                if author then
                    draw.SimpleTextOutlined(author,"FGCWEP_DermaDefault13",authorx,self.Border + 8,authorclr,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(45,45,45))
                end

                --[[
                if self:GetIsNPCWeapon() then -- Draw NPC weapon support icon -- This whole thing could be more dynamic
                    surface.SetMaterial(matOverlay_NPCWeapon)
                    if self:GetSpawnName() == GetConVarString("gmod_npcweapon") then surface.SetMaterial(matOverlay_NPCWeaponSelected) end
                    surface.DrawTexturedRect(w - self.Border - 24, self.Border + 8, 16, 16)
                end
                ]]

                self:ScanForNPCWeapons()
                if drawText then
                    local buffere = self.Border + 10
                    local px, py = self:LocalToScreen(buffere, 0) -- Set up smaller clipping so cut text looks nicer
                    local pw, ph = self:LocalToScreen(w - buffere, h)
                    render.SetScissorRect(px, py, pw, ph, true)
                    surface.SetFont("FGCWEP_DermaDefault") -- Calculate X pos
                    local tW, tH = surface.GetTextSize(self.m_NiceName)
                    local x = w / 2 - tW / 2

                    if tW > (w - buffere * 2) then
                        local diff = tW - w + buffere * 2
                        diff = diff * 0.5 + 7
                        x = x + diff * math.sin(RealTime() * math.pi)
                    end

                    DrawTextShadow(self.m_NiceName, x, h - tH - 6) -- Draw

                    render.SetScissorRect(0, 0, 0, 0, false)
                end
            end
        end
    end

    return panel,a,a2
end