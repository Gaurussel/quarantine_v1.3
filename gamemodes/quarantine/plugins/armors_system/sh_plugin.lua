local PLUGIN = PLUGIN
PLUGIN.name = "Outfit Plugin"
PLUGIN.author = "Gaurussel"
PLUGIN.description = "Armors item"

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.char.RegisterVar("masked", {
	field = "masked",
	fieldType = ix.type.bool,
	default = false,
    isLocal = false,
    bNoDisplay = true
})

function PLUGIN:GetCharacterName(talker)

    if (talker:GetCharacter():GetMasked()) then
        local SteamID = talker:SteamID64()

        SteamID = string.Left(SteamID, 5)
        SteamID = SteamID..talker:UserID()

        return ("Неизвестный "..SteamID)
    end
end