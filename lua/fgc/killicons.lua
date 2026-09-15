FGCWEP_OldkilliconRender = FGCWEP_OldkilliconRender or killicon.Render
killicon.Render = function(x,y,name,alpha,deh,...)
    local wep = FGCWEP_WEAPONS_LOOKUP[name]
    if wep then
        if wep.FGCWEP_KilliconRender then
            return wep.FGCWEP_killiconRender(x,y,name,alpha,deh,...)
        end
        local info = wep.OriginalInfo

        local author,authorclr = nil,Color(255,255,255)
        if info.category and FGCWEP_KNOWNMEMBERS[info.category] then
            local e = FGCWEP_KNOWNMEMBERS[info.category]
            author = e.text
            authorclr = e.lclr
        elseif info.author and FGCWEP_KNOWNMEMBERS[info.author] then
            local e = FGCWEP_KNOWNMEMBERS[info.author]
            author = e.text
            authorclr = e.lclr
        end

        surface.SetTextPos(x, y + 7)
		surface.SetFont("ChatFont")
		surface.SetTextColor(authorclr.r,authorclr.g,authorclr.b,alpha)
		surface.DrawText(wep.FGCWEP_KilliconPrintName or wep.PrintName)

        return
    end
    return FGCWEP_OldkilliconRender(x,y,name,alpha,deh,...)
end

FGCWEP_OldkilliconGetSize = FGCWEP_OldkilliconGetSize or killicon.GetSize
killicon.GetSize = function(name,deh,...)
    local wep = FGCWEP_WEAPONS_LOOKUP[name]
    if wep then
		surface.SetFont("ChatFont")
        local w,h = surface.GetTextSize(wep.PrintName)
        h = h * 2
        return w,h
    end
    return FGCWEP_OldkilliconGetSize(name,deh,...)
end