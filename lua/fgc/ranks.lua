FGCWEP_KNOWNMEMBERS = {
    cere = {
        text = "cere",
        clr = "<color=23,255,255,255>",
        lclr = Color(23,255,255),
        group = "user+",
    },
    atom = {
        text = "Atomix27",
        clr = "<color=0,216,250,255>",
        lclr = Color(0,216,250),
        group = "genie",
    },
    phil = {
        text = "NephilisThy1",
        clr = "<color=200,0,0,255>",
        lclr = Color(200,0,0),
        group = "admin"
    },
    twoface = {
        text = "TwoFace17",
        clr = "<color=13,13,171,255>",
        lclr = Color(13,13,171),
        group = "superadmin"
    },
    ["nil"] = {
        text = "nil",--"nan_nil_null_nullptr_2",
        clr = "<color=0,0,0,255>",
        lclr = Color(0,0,0),
        group = "veteran"
    },
    egg = {
        text = "egg",
        clr = "<color=200,0,0,255>",
        lclr = Color(200,0,0),
        group = "admin"
    },
}

FGCWEP_KNOWNMEMBERS.cere_admin = FGCWEP_KNOWNMEMBERS.cere
FGCWEP_KNOWNMEMBERS.atom_admin = FGCWEP_KNOWNMEMBERS.atom
FGCWEP_KNOWNMEMBERS.phil_admin = FGCWEP_KNOWNMEMBERS.phil

FGCWEP_KNOWNMEMBERS["twoface, Atomix27"] = table.Copy(FGCWEP_KNOWNMEMBERS.twoface)
FGCWEP_KNOWNMEMBERS["twoface, Atomix27"].text = "twoface, Atomix27"
FGCWEP_KNOWNMEMBERS["twoface, Atomix27"].ishack = true

FGCWEP_KNOWNMEMBERS["DRP Developers / cere"] = table.Copy(FGCWEP_KNOWNMEMBERS.cere)
FGCWEP_KNOWNMEMBERS["DRP Developers / cere"].text = "DRP Devs / cere"
FGCWEP_KNOWNMEMBERS["DRP Developers / cere"].ishack = true

FGCWEP_KNOWNRANKS = util.JSONToTable([[{"tmod":{"r":137,"b":240,"a":255,"g":207},"member":{"r":47,"b":214,"a":255,"g":189},"veteran":{"r":255,"b":0,"a":255,"g":123},"user":{"r":255,"b":100,"a":255,"g":255},"mod":{"r":30,"b":255,"a":255,"g":30},"admin":{"r":255,"b":0,"a":255,"g":0},"donator":{"r":237,"b":249,"a":255,"g":59},"superadmin":{"r":161,"b":255,"a":255,"g":0},"trusted":{"r":38,"b":50,"a":255,"g":224}}]])