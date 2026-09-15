if FGCWEP_CREDITPANEL and FGCWEP_CREDITPANEL:IsValid() then
    FGCWEP_CREDITPANEL:NeedRemove()
    FGCWEP_CREDITPANEL = nil
end

local images = {

}

local httpMaterial = FGCWEP_HTTPMAT
if not httpMaterial then
    images = nil
end

local FGCWEP_CREDITPANEL_PAINT = function(self,w,h)
    surface.SetDrawColor(0,0,0,255)
    self:DrawFilledRect()

    if LocalPlayer():KeyDown(IN_ATTACK2) or LocalPlayer():KeyDown(IN_ZOOM) then
        self.Zooming = true
    else
        self.Zooming = false
    end

    self.FOV = Lerp(FrameTime() * 7,self.FOV or 120,self.Zooming and 20 or 120)

    cam.Start3D(MainEyePos() - self.Pos, MainEyeAngles(), self.FOV, 0, 0, w, h, 1, 10000 )
        self:DrawModels()
    cam.End3D()
end

hook.Add("AdjustMouseSensitivity","fgcwep_credits_zoom",function()
    if FGCWEP_CREDITPANEL and FGCWEP_CREDITPANEL:IsValid() and FGCWEP_CREDITPANEL.Zooming then
        return 0.25
    end
end)

concommand.Add("fgcwep_credits",function()
    local main = vgui.Create("DFrame")
    main:Dock(FILL)
    main:ShowCloseButton(false)
    main:SetTitle("")
    main:SetSizable(false)
    main.Paint = FGCWEP_CREDITPANEL_PAINT
    FGCWEP_CREDITPANEL = main

    main.Pos = MainEyePos()

    main.models = {}

    function main:NeedRemove()
        for i,v in pairs(self.models) do
            if IsValid(v) then v:Remove() end
        end

        self:Remove()
    end

    function main:AddModel(mdl,velmul)
        velmul = velmul or 1
        local ent = ClientsideModel(mdl)
        if not IsValid(ent) then return nil end
        ent:SetPos(VectorRand(-200,200))
        ent:SetAngles(AngleRand(-180,180))
        ent:SetNoDraw(true)
        ent:SetModel(mdl)
        ent.CREDITS_VEL = VectorRand(-50,50) * velmul
        ent.CREDITS_ANGVEL = VectorRand(-180,180) * velmul
        table.insert(self.models,ent)
        return ent
    end

    if images then
        function main:AddImage(url)
            local ent = ClientsideModel("models/error.mdl")
            ent:SetNoDraw(true)
            ent.CREDITS_VEL = VectorRand(-10,10)
            ent.CREDITS_ANGVEL = VectorRand(-10,10)
            ent.CREDITS_IMAGE = httpMaterial(url, "mips")
            table.insert(self.models,ent)
            return ent
        end
    end

    function main:AddText(text,clr)
        local ent = ClientsideModel("models/error.mdl")
        ent:SetNoDraw(true)
        ent.CREDITS_VEL = VectorRand(-10,10)
        ent.CREDITS_ANGVEL = VectorRand(-60,60)
        ent.CREDITS_TEXT = text
        ent:SetColor(clr or color_white)
        table.insert(self.models,ent)
        return ent
    end

    for i,SWEP in pairs(FGCWEP_WEAPONS) do
        local ent = main:AddModel(SWEP.WorldModel)
        if ent then
            ent:SetMaterial("model_color")
            local author,authorclr = nil,Color(255,255,255)
            local hack = false
            local info = SWEP.OriginalInfo or SWEP.BaseClass.OriginalInfo
            if info.category and FGCWEP_KNOWNMEMBERS[info.category] then
                local e = FGCWEP_KNOWNMEMBERS[info.category]
                author = e.text
                authorclr = e.lclr
            elseif info.author and FGCWEP_KNOWNMEMBERS[info.author] then
                local e = FGCWEP_KNOWNMEMBERS[info.author]
                author = e.text
                authorclr = e.lclr
                hack = e.ishack
            end

            ent:SetModelScale(0.25)
            ent:SetColor(authorclr)
            if not hack then main:AddText(author,authorclr) end

            local plymdl = main:AddModel("models/player/group01/male_07.mdl")
            local vecclr = authorclr:ToVector()
            plymdl.GetPlayerColor = function() return vecclr end
            plymdl:SetModelScale(0.25)
        end
    end

    function main:DrawModels()
        for i,v in pairs(self.models) do
            if IsValid(v) then
                local img = v.CREDITS_IMAGE
                if img and not img.material then continue end

                local vel,angvel = v.CREDITS_VEL,v.CREDITS_ANGVEL
                local ft = RealFrameTime()

                local ang = v:GetAngles()
                local ap,ay,ar = angvel:Unpack()
                local p,y,r = ang:Unpack()
                ang:SetUnpacked(p + ap * ft,y + ay * ft,r + ar * ft)

                local pos = v:GetPos()
                pos:Add(vel * ft)

                if pos:DistToSqr(vector_origin) > 40000 then
                    local speed = vel:Length()
                    local dir = vector_origin - pos
                    dir:Normalize()
                    dir = dir + VectorRand(-1,1)
                    dir:Normalize()
                    v.CREDITS_VEL = dir * speed
                end

                v:SetPos(pos)
                v:SetAngles(ang)

                if img then
                    render.SetMaterial(img.material)
                    render.DrawSprite(pos, 32, 32, color_white)
                elseif v.CREDITS_TEXT then
                    --draw.SimpleText(v.CREDITS_TEXT, "Default", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    cam.Start3D2D(pos, ang, 0.2)
                        draw.SimpleText(v.CREDITS_TEXT, "ChatFont", 0, 0, v:GetColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
                    cam.End3D2D()
                else
                    local clr = v:GetColor()
                    local r,g,b,a = clr:Unpack()
                    render.SetBlend(a / 255)
                    render.SetColorModulation(r / 255,g / 255,b / 255)
                    v:DrawModel()
                    render.SetColorModulation(1,1,1)
                    render.SetBlend(1)
                end
            end
        end
    end


end)

hook.Add("PlayerBindPress","fgcwep_credits_cancel",function(ply,bind,pressed,c)
    if bind == "+attack" and FGCWEP_CREDITPANEL and FGCWEP_CREDITPANEL:IsValid() then
        FGCWEP_CREDITPANEL:NeedRemove()
        FGCWEP_CREDITPANEL = nil
    end
end)