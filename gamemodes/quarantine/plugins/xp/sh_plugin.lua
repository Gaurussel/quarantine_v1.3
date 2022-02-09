
local PLUGIN = PLUGIN
PLUGIN.name = "XP System"
PLUGIN.author = "Bilwin | Added level by gaurussel"
PLUGIN.description = "Adds XP whitelisted system"

do
    ix.char.RegisterVar("XP", {
        field = "XP",
        fieldType = ix.type.number,
        isLocal = true,
        bNoDisplay = true,
        default = 0
    })

    ix.char.RegisterVar("level", {
        field = "level",
        fieldType = ix.type.number,
        isLocal = true,
        bNoDisplay = true,
        default = 0
    })

    ix.char.RegisterVar("points", {
        field = "points",
        fieldType = ix.type.number,
        isLocal = true,
        bNoDisplay = true,
        default = 0
    })
end

ix.XPSystem = {}
ix.XPSystem.whitelists = {
    --[FACTION_CITIZEN] = {
    --    [CLASS_CITIZEN] = 0,
    --    [CLASS_CWU]     = 5
    --},
    --[FACTION_MPF] = {
    --    [CLASS_MPR]     = 50,
    --    [CLASS_MPU]     = 75,
    --    [CLASS_EMP]     = 100
    --},
    --[FACTION_OTA] = {
    --    [CLASS_OWS]     = 200,
    --    [CLASS_EOW]     = 300
    --},
    --[FACTION_ADMIN] = {
    --    [CLASS_ADMIN]   = 600
    --}
}

ix.util.Include("cl_plugin.lua")
ix.util.Include("sh_config.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_language.lua")