local rankcolors = {}
for i,v in pairs(FGCWEP_KNOWNRANKS) do
    table.insert(rankcolors,Color(v.r,v.g,v.b))
end

local gradup = Material("gui/gradient_up")
local graddown = Material("gui/gradient_down")
local gradright = Material("gui/gradient")
local gradleft = Material("vgui/gradient-r")

local currentcolor = rankcolors[1]
local targetcolor = rankcolors[2]

local currentcolor2 = rankcolors[1]
local targetcolor2 = rankcolors[2]

local nexttarget = 0

local dur = 2

function FGCWEP_PrintWeaponInfo(self,x,y,alpha,store,center,max)

	if not self.OriginalInfo then return end

    store = store or self

    local o = surface.GetAlphaMultiplier()
    surface.SetAlphaMultiplier(alpha / 255)

	if not store.InfoMarkup then
        local info = self.OriginalInfo
        local str = "<font=ChatFont>"

        if info.name then
            str = 
                str .. FGCWEP_SERVERCLR
                .. FGCWEP_SERVERS
                .. FGCWEP_TEXTCLR
                --.. "weapon name: "
                .. info.name
                .. "</color>\n"
        end

        str = 
            str .. FGCWEP_SERVERCLR
            .. FGCWEP_SERVERS
            .. FGCWEP_TEXTCLR
            --.. "weapon name: "
            .. self.ClassName or self.GetClass and self:GetClass() or "invalid weapon lol"
            .. "</color>"

        str = str .. "\n"

        if info.category then
            local known = FGCWEP_KNOWNMEMBERS[info.author] or FGCWEP_KNOWNMEMBERS[info.category] or {
                text = info.category,
                clr = "<color=255,255,111,255>"
            }

            store.InfoTopColor = known.lclr or Color(255,255,111)
            store.InfoTopColorB = store.InfoTopColor:Copy()
            store.InfoTopColorB.a = 80

            str = 
                str .. FGCWEP_SERVERCLR
                .. FGCWEP_SERVERS
                .. FGCWEP_TEXTCLR
                .. info.category
                .. " by "
                .. known.clr
                .. known.text
                .. "</color>\n"
        elseif info.author then
            local known = FGCWEP_KNOWNMEMBERS[info.author] or {
                text = info.author,
                clr = "<color=255,255,111,255>"
            }

            store.InfoTopColor = known.lclr or Color(255,255,111)
            store.InfoTopColorB = store.InfoTopColor:Copy()
            store.InfoTopColorB.a = 80

            str = 
                str .. FGCWEP_SERVERCLR
                .. FGCWEP_SERVERS
                .. FGCWEP_TEXTCLR
                .. "by "
                .. known.clr
                .. known.text
                .. "</color>\n"
        end

        if info.description then
            for i,desc in pairs(string.Explode("\n",info.description,false)) do
                if desc == "" then
                    str = str .. "\n"
                    continue
                end
                str = 
                    str .. FGCWEP_SERVERCLR
                    .. FGCWEP_SERVERS
                    .. FGCWEP_TEXTCLR
    --                .. "description: "
                    .. desc
                    .. "</color>\n"
            end
        end

        if info.server and FGCWEP_KNOWNSERVERS[info.server] then
            str = 
                str .. FGCWEP_DISCORDCLR
                .. FGCWEP_DISCORDS
                .. FGCWEP_COCONUTCLR
                .. info.server .. ": "
                ..  FGCWEP_TEXTCLR
                .. FGCWEP_KNOWNSERVERS[info.server]
                .. "</color>\n"
        end

        str = str .. "</font>"
		store.InfoMarkup = markup.Parse(str,max or 400)
	end

    if nexttarget < RealTime() then
        nexttarget = RealTime() + dur

        currentcolor = targetcolor
        targetcolor = table.Random(rankcolors)

        currentcolor2 = targetcolor2
        targetcolor2 = table.Random(rankcolors)
    end

    local color = currentcolor:Lerp(targetcolor,RealTime() + dur - nexttarget)
    color.a = 25

    local color2 = currentcolor2:Lerp(targetcolor2,RealTime() + dur - nexttarget)
    color2.a = 25

    local wid,hei = store.InfoMarkup:Size()
    wid = wid + 16
    hei = hei + 8

    x = x - (center and wid / 2 or 0)

    surface.SetDrawColor(store.InfoTopColor or color_white)
    surface.DrawRect(x - 4 - 2,y - 4 - 2,wid + 4,hei + 4)

    surface.SetDrawColor(15,15,15,245)
    surface.DrawRect(x - 4,y - 4,wid,hei)

    surface.SetMaterial(graddown)
    surface.SetDrawColor(store.InfoTopColorB or color_white)
    surface.DrawTexturedRect(x - 4,y - 4,wid,hei)

    surface.SetMaterial(gradleft)
    surface.SetDrawColor(color)
    surface.DrawTexturedRect(x - 4 + wid - wid * 0.8,y - 4,wid * 0.8,hei)

    surface.SetMaterial(gradright)
    surface.SetDrawColor(color2)
    surface.DrawTexturedRect(x - 4,y - 4,wid * 0.8,hei)

    if self.AdminOnly or not self.Spawnable then
        surface.SetMaterial(gradup)
        surface.SetDrawColor(HSVToColor(RealTime() * 360 % 360,0.2,0.4))
        surface.DrawTexturedRect(x - 4,y - 4,wid,hei)
    end

    --surface.SetDrawColor(255,132,0,200)
    --[[
    surface.SetDrawColor(store.InfoTopColor)
    surface.DrawOutlinedRect(x - 4,y - 4,wid,hei)
    ]]

	store.InfoMarkup:Draw(x,y,nil,nil,alpha)
    surface.SetAlphaMultiplier(o)
end
