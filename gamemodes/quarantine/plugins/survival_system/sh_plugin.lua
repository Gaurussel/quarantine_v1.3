local PLUGIN = PLUGIN
PLUGIN.name = "Survival System"
PLUGIN.author = "Gaurussel"
PLUGIN.description = ".."

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")


ix.char.RegisterVar("food", {
    field = "food",
    fieldType = ix.type.number,
    default = 100,
    isLocal = true,
    bNoDisplay = true
})

ix.char.RegisterVar("water", {
    field = "water",
    fieldType = ix.type.number,
    default = 100,
    isLocal = true,
    bNoDisplay = true
})

ix.char.RegisterVar("alcohol", {
    field = "alcohol",
    fieldType = ix.type.number,
    default = 0,
    isLocal = true,
    bNoDisplay = true
})