--https://github.com/MechanicalMind/murder/blob/master/gamemodes/murder/gamemode/sv_chattext.lua

if SERVER then
    util.AddNetworkString("fgc_chattext_msg")

    local meta = {}
    meta.__index = meta

    function meta:Add(string, color)
        local t = {}
        t.text = string
        t.color = color or self.default_color or color_white
        table.insert(self.msgs, t)
        return self
    end

    function meta:AddPart(msg)
        table.insert(self.msgs, msg)
        return self
    end

    function meta:AddParts(msgs)
        for k, msg in pairs(msgs) do
            table.insert(self.msgs, msg)
        end
        return self
    end

    function meta:SetDefaultColor(color)
        self.default_color = color
        return self
    end

    function meta:SendAll()
        self:NetConstructMsg()
        net.Broadcast()
        return self
    end

    function meta:Send(players)
        self:NetConstructMsg()
        if players == nil then
            net.Broadcast()
        else
            net.Send(players)
        end
        return self
    end

    function meta:NetConstructMsg()
        net.Start("fgc_chattext_msg")
        for k, msg in pairs(self.msgs) do
            net.WriteUInt(1,8)
            net.WriteString(msg.text)
            if !msg.color then
                msg.color = self.default_color or color_white
            end
            net.WriteVector(Vector(msg.color.r, msg.color.g, msg.color.b))
        end
        net.WriteUInt(0,8)
        return self
    end

    function FGCWEP_ChatText(msgs)
        local t = {}
        t.msgs = msgs or {}
        setmetatable(t, meta)
        return t
    end

    -- local t = ChatText()
    -- t:Add("pants down", Color(255,0,0))
    -- t:Add(" pants up")
    -- t:SendAll()

    util.AddNetworkString("fgc_msg_clients")

    local meta = table.Copy(meta)

    function meta:NetConstructMsg()
        net.Start("fgc_msg_clients")
        for k, line in pairs(self.msgs) do
            net.WriteUInt(1, 8)
            net.WriteUInt(line.color.r, 8)
            net.WriteUInt(line.color.g, 8)
            net.WriteUInt(line.color.b, 8)
            net.WriteString(line.text)
        end
        net.WriteUInt(0, 8)
        return self
    end

    function meta:Print()
        for k, line in pairs(self.msgs) do
            MsgC(line.color, line.text)
        end
        return self
    end

    function FGCWEP_MsgClients(msgs)
        local t = {}
        t.msgs = msgs or {}
        setmetatable(t, meta)
        return t
    end
else
    net.Receive("fgc_chattext_msg", function (len)
        local msgs = {}
        while true do
            local i = net.ReadUInt(8)
            if i == 0 then break end
            local str = net.ReadString()
            local col = net.ReadVector()
            table.insert(msgs, Color(col.x, col.y, col.z))
            table.insert(msgs, str)
        end

        chat.AddText(unpack(msgs))
    end)

    net.Receive("fgc_msg_clients", function (len)
        local lines = {}
        while net.ReadUInt(8) != 0 do
            local r = net.ReadUInt(8)
            local g = net.ReadUInt(8)
            local b = net.ReadUInt(8)
            local text = net.ReadString()
            table.insert(lines, {color = Color(r, g, b), text = text})
        end
        for k, line in pairs(lines) do
            MsgC(line.color, line.text)
        end
    end)
end
