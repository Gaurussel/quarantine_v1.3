local PLUGIN = PLUGIN
PLUGIN.name = "Ranks for faction"
PLUGIN.author = "Gaurussel"
PLUGIN.description = "..."

PLUGIN.missions = PLUGIN.missions or {}
PLUGIN.currentMissions =  PLUGIN.currentMissions or {}
PLUGIN.locker_items = PLUGIN.locker_items or {}
PLUGIN.lab_items = PLUGIN.lab_items or {}

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sh_configs.lua")

ix.util.Include("missions/sh_item_delivery.lua")
ix.util.Include("derma/cl_npc_missions.lua")

PLUGIN.positions = PLUGIN.positions or {}
PLUGIN.needExperience = {
    [1] = 0,
    [2] = 35,
    [3] = 65,
    [4] = 95,
    [5] = 125,
    [6] = 155,
    [7] = 185,
    [8] = 215,
}

function PLUGIN:LoadData()
    PLUGIN.positions = self:GetData()
    self:UpdateWorldData()
end

function PLUGIN:SaveData()
    self:SetData(PLUGIN.positions)
    self:UpdateWorldData()
end

ix.char.RegisterVar("rank", {
    field = "rank",
    fieldType = ix.type.number,
    default = 1,
    isLocal = false,
    bNoDisplay = true
})

ix.char.RegisterVar("rankXP", {
    field = "rank",
    fieldType = ix.type.number,
    default = 0,
    isLocal = true,
    bNoDisplay = true
})

function PLUGIN:UpdateWorldData()
    SetNetVar("ranksPositions", PLUGIN.positions)

    for _, ply in pairs(player.GetAll()) do
        ply:SyncVars()
    end
end

function GetBoxLine(min, max)
    local deltaX = math.abs(min.x - max.x)
    local deltaY = math.abs(min.y - max.y)

    local lineStart, lineEnd

    if deltaX < deltaY then
        lineStart = Vector(min.x + (max.x - min.x) / 2, min.y, min.z)
        lineEnd = Vector(min.x + (max.x - min.x) / 2, min.y + (max.y - min.y), min.z)
    else
        lineStart = Vector(min.x, min.y + (max.y - min.y) / 2, min.z)
        lineEnd = Vector(min.x + (max.x - min.x), min.y + (max.y - min.y) / 2, min.z)
    end

    return lineStart, lineEnd
end

concommand.Add("settableclean", function()
    if SERVER then
        PLUGIN.locker_items = {}
    else
        PLUGIN.locker_items = {}
    end
end)