FGCWEP_DOORSYSTEM = FGCCONVAR_SH("fgcwep_sv_doorsystem","0",0,"enable door system, keys uses door system. **AUTOMATICALLY TURNS OFF IN DARKRP**",0,1)

local enabled = function()
    return FGCWEP_DOORSYSTEM:GetBool() and not (DarkRP and DarkRP.registerDoorVar)
end

if CLIENT then
    hook.Add("HUDPaint", "FGCsh_doorspaint", function()
        if not enabled() then return end

        local ent = LocalPlayer():GetEyeTrace().Entity
        if IsValid(ent) and (ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door_rotating" or ent:GetClass() == "func_door") then
            local d = LocalPlayer():GetPos():Distance(ent:GetPos())
            if d < 200 then
                local owner = ent:GetNWString("door_owner", "")
                local text = "unowned door - press F2 to claim"
                if owner ~= "" then
                    text = player.GetBySteamID64(owner):Nick()
                end
                if not IsValid(LocalPlayer()) then return end
                if not IsValid(LocalPlayer():GetActiveWeapon()) then return end
                if not IsValid(ent) then return end
                if (ent:GetClass() == "prop_door_rotating") or (LocalPlayer():GetActiveWeapon():GetClass() == "weapon_keys") then
                    draw.DrawText(text, "Trebuchet18", ScrW() * 0.5, ScrH() * 0.45, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                end
            end
        end
    end)
elseif SERVER then
    hook.Add("InitPostEntity", "FGCsv_doorsunlock", function()
        if not enabled() then return end

        for _, v in pairs(ents.GetAll()) do
            local class = v:GetClass()
            if class == "prop_door_rotating" or class == "func_door_rotating" or class == "func_door" then
                v:Fire("unlock", "", 0)
            end
        end
    end)

    local doors = FGCWEP_doors or {}
    FGCWEP_doors = doors

    local function SetDoorOwner(door, owner)
        local o = owner and owner:SteamID64() or ""
        if owner then
            doors[o] = doors[o] or {}
            doors[o][door] = true
        else
            local oo = door:GetNWString("door_owner","")
            if oo ~= "" then
                doors[oo] = doors[oo] or {}
                doors[oo][door] = nil
            end
        end
        door:SetNWString("door_owner", o)
    end

    local function GetDoorCount(steamid)
        if not doors[steamid] then return 0 end

        local c = 0
        for i,v in pairs(doors[steamid]) do
            if IsValid(i) and v then
                c = c + 1
            end
        end
        return c
    end

    hook.Add("PlayerDisconnected", "FGCsv_doorsunown", function(ply)
        local steamid = ply:SteamID64()
        for i,v in pairs(doors[steamid]) do
            if IsValid(i) and v then
                SetDoorOwner(i, nil)
            end
        end
    end)

    hook.Add("PlayerButtonDown", "FGCsv_owningdoor", function(ply, button)
        if (button == KEY_F2) then
            local door = ply:GetEyeTrace().Entity
            if not IsValid(door) then return end
            local class = door:GetClass()
            if not (class == "prop_door_rotating" or class == "func_door_rotating" or class == "func_door") then return end
            if (ply:GetPos():Distance(door:GetPos()) > 200) then return end
            
            local owner = door:GetNWString("door_owner", "")
            if owner == "" then
                if (GetDoorCount(ply:SteamID64()) < 8) then
                    SetDoorOwner(door, ply)
                else
                    local text = FGCWEP_ChatText()
                    text:Add(FGCWEP_SERVERS, FGCWEP_SERVERLCLR)
                    text:Add("you own too many doors", FGCWEP_TEXTLCLR)

                    text:Send(ply)
                end
            elseif owner == ply:SteamID64() or FGCWEP_c_isadmin(ply) then
                SetDoorOwner(door, nil)
            end
        end
    end)
end