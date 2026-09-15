local function insh(name)
    AddCSLuaFile(name)
    include(name)
end
local function incl(name)
    AddCSLuaFile(name)
    if CLIENT then
        include(name)
    end
end
local function insv(name)
    if CLIENT then return end
    include(name)
end

fgc_insh = insh
fgc_incl = incl
fgc_insv = insv

local dir = "fgc/"

FGCWEP_KNOWNSERVERS = {
    fgc = "https://discord.gg/K8eQYDKV5"
}

FGCCONVAR_SH = function(name,value,flags,...)
    flags = flags or 0
    flags = bit.bor(flags,FCVAR_ARCHIVE)
    flags = bit.bor(flags,FCVAR_REPLICATED)
    return CreateConVar(name,value,flags,...)
end

FGCCONVAR_SV = function(name,value,flags,...)
    if CLIENT then return end
    flags = flags or 0
    flags = bit.bor(flags,FCVAR_ARCHIVE)
    return CreateConVar(name,value,flags,...)
end


FGCCONVAR_CL = function(name,value,flags,...)
    if SERVER then return end
    flags = flags or 0
    flags = bit.bor(flags,FCVAR_ARCHIVE)
    flags = bit.bor(flags,FCVAR_USERINFO)
    return CreateConVar(name,value,flags,...)
end

insh(dir .. "tags.lua")
insh(dir .. "colors.lua")
insh(dir .. "ranks.lua")
insh(dir .. "luabullet.lua")
insh(dir .. "interpolatevars.lua")

FGCWEP_HTTPMAT = incl(dir .. "http_material.lua")
incl(dir .. "info.lua")
incl(dir .. "spawnmenuicon.lua")
incl(dir .. "killicons.lua")
incl(dir .. "credits.lua")
--incl(dir .. "cool_tracer.lua")

insh(dir .. "chat.lua")
insh(dir .. "doors.lua")

FGCWEP_c_isadmin = function(ply)
    if c_isadmin then return c_isadmin(ply) end
    return ply:IsAdmin() or ply:GetUserGroup() == "mod" or ply:GetUserGroup() == "tmod"
end

--from gs_lib
local util_TraceLine = util.TraceLine
local table_CopyFromTo = table.CopyFromTo
local Vector = Vector
function FGCWEP_FindHullIntersection(tbl, tr)
	local iDist = 1e12
	tbl.output = nil
	local vSrc = tbl.start
	local vHullEnd = vSrc + (tr.HitPos - vSrc) * 2
	tbl.endpos = vHullEnd
	local tBounds = {tbl.mins, tbl.maxs}
	local trTemp = util_TraceLine(tbl)

	if (trTemp.Fraction ~= 1) then
		table_CopyFromTo(trTemp, tr)

		return tr
	end

	local trOutput

	for i = 1, 2 do
		for j = 1, 2 do
			for k = 1, 2 do
				tbl.endpos = Vector(vHullEnd[1] + tBounds[i][1],
					vHullEnd[2] + tBounds[j][2],
					vHullEnd[3] + tBounds[k][3])

				trTemp = util_TraceLine(tbl)

				if (trTemp.Fraction ~= 1) then
					local iHitDistSqr = (trTemp.HitPos - vSrc):LengthSqr()

					if (iHitDistSqr < iDist) then
						trOutput = trTemp
						iDist = iHitDistSqr
					end
				end
			end
		end
	end

	if (trOutput) then
		table_CopyFromTo(trOutput, tr)
	end

	return tr
end

function FGCWEP_NOTGUN()
    SWEP.BaseCone = 0

    SWEP.AimExpandUnit = 0
    SWEP.AimExpandStayDuration = 0
    SWEP.AimCollapseUnit = 0

    SWEP.MaxAimExpand = 0
    SWEP.MinAimExpand = 0

    SWEP.MaxRecoil = 0
    SWEP.MinRecoil = 0

    SWEP.RecoilExpandUnit = 0
    SWEP.RecoilStayDuration = 0
    SWEP.RecoilCollapseUnit = 0

    function SWEP:EmitFireSound(secondary) end


    function SWEP:TakeAmmo() end
    function SWEP:CanPrimaryAttack() return true end

    function SWEP:DoRecoil() end
end

local function ADD_NPC_WEAPON(class,printname)
	list.Add("NPCUsableWeapons",{class = class, title = printname, category = Category})
end

FGCWEP_WEAPONS = {}
FGCWEP_WEAPONS_LOOKUP = {}
FGCWEP_REFRESH_WEAPONS = function()
    table.Empty(FGCWEP_WEAPONS)
    for i, SWEP in ipairs(weapons.GetList()) do
        SWEP = weapons.Get(SWEP.ClassName)
        if SWEP and SWEP.FGC and SWEP.Spawnable then
            table.insert(FGCWEP_WEAPONS,SWEP)
            FGCWEP_WEAPONS_LOOKUP[SWEP.ClassName] = SWEP

            ADD_NPC_WEAPON(SWEP.ClassName, SWEP.PrintName)
        end
    end
end

if CLIENT then
    -- copied from TacRP Weapon Base
    hook.Add("PopulateMenuBar", "FGC_NPCWeaponMenu", function (menubar)
        timer.Simple(0.1, function()
            local wpns = menubar:AddOrGetMenu("FGC NPC Weapons")

            wpns:AddCVar( "#menubar.npcs.defaultweapon", "gmod_npcweapon", "" )
            wpns:AddCVar( "#menubar.npcs.noweapon", "gmod_npcweapon", "none" )

            wpns:AddSpacer()

            wpns:SetDeleteSelf(false)

            local catdict = {}
            local catnames = {}
            local catcontents = {}

            local cats = {}

            for _, weptbl in pairs(FGCWEP_WEAPONS) do
                if weptbl and weptbl.FGC and weptbl.Spawnable then
                    local cat = weptbl.Category
                    if !catdict[cat] then
                        catdict[cat] = true
                        table.insert(catnames, cat)
                    end
                    catcontents[cat] = catcontents[cat] or {}
                    table.insert(catcontents[cat], {weptbl.PrintName, weptbl.ClassName})
                end
            end

            for _, cat in SortedPairsByValue(catnames) do
                cats[cat] = wpns:AddSubMenu(cat)
                cats[cat]:SetDeleteSelf(false)

                cats[cat]:AddSpacer()

                for _, info in SortedPairsByMemberValue(catcontents[cat], 1) do
                    cats[cat]:AddCVar(info[1], "gmod_npcweapon", info[2])
                end
            end
        end)
    end)
end

timer.Simple(0,FGCWEP_REFRESH_WEAPONS)

FGCWEP_ROUND_TO_TICKINTERVAL = function(num)
    return num--math.Round(num / engine.TickInterval()) * engine.TickInterval()
end

hook.Add( "PopulateToolMenu", "fgcwep settings", function()
    spawnmenu.AddToolMenuOption( "Utilities", "r-nil stuff", "fgc_wepcl", "FGC weapons(CLIENT)", "", "", function(panel)
        panel:ControlHelp("Crosshair Settings")
        panel:CheckBox( "Enable Crosshair", "fgcwep_cl_crosshair")
        panel:CheckBox( "No Lines", "fgcwep_cl_crosshair_onlydot")

        panel:ControlHelp("Dot Color")
        local color = vgui.Create("DColorMixer")
        color:SetConVarR("fgcwep_cl_crosshair_dot_r")
        color:SetConVarG("fgcwep_cl_crosshair_dot_g")
        color:SetConVarB("fgcwep_cl_crosshair_dot_b")
        color:SetConVarA("fgcwep_cl_crosshair_dot_a")
        panel:AddItem(color)

        panel:ControlHelp("Line Color")
        local color = vgui.Create("DColorMixer")
        color:SetConVarR("fgcwep_cl_crosshair_line_r")
        color:SetConVarG("fgcwep_cl_crosshair_line_g")
        color:SetConVarB("fgcwep_cl_crosshair_line_b")
        color:SetConVarA("fgcwep_cl_crosshair_line_a")
        panel:AddItem(color)

        panel:NumSlider("Thickness","fgcwep_cl_crosshair_thickness",0.1,1.5,2)
    end)

    spawnmenu.AddToolMenuOption( "Utilities", "r-nil stuff", "fgc_wepsv", "FGC weapons(SERVER)", "", "", function(panel)
        panel:ControlHelp("Global settings")
        panel:CheckBox("All Automatic(Makes every weapon automatic)", "fgcwep_sv_allautomatic")
        panel:CheckBox("Enable Aimpunch", "fgcwep_sv_aimpunch")
        panel:CheckBox("Add ViewPunch to shoot direction", "fgcwep_sv_viewpunch")
        panel:CheckBox("Use correct killicon on projectile weapons", "fgcwep_sv_projectile_killicon")

        panel:ControlHelp("Weapons settings")
        panel:CheckBox("atogun3: Grenades will detonate instead of removing", "fgcwep_sv_atogun3_grenadelive")
        panel:CheckBox("boltgun: Allow shooting nail bomb with secondary attack", "fgcwep_sv_boltgun_nailbomb")

        panel:ControlHelp("Cone settings")
        panel:NumSlider("Set weapon spread increase multiplier", "fgcwep_sv_aconeincreasemul", 0, 10, 2)
        panel:NumSlider("Set weapon spread decrease multiplier", "fgcwep_sv_aconedecreasemul", 0, 10, 2)
        panel:NumSlider("Set weapon spread multiplier", "fgcwep_sv_aconemul", 0, 10, 3)
    end)
end)