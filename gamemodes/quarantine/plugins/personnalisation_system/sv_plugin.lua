function PLUGIN:CharacterLoaded(char)
    local personnalisation = char:GetPersonnalisation()
    local player = char:GetPlayer()

    if (personnalisation and personnalisation != "") then
        local faction = ix.faction.indices[char:GetFaction()]

        if faction.bodygroups and !char:GetData("firstSpawn", false) then
            player:SetSkin(personnalisation["head"] or 0)
            player:SetBodygroup(1, faction.bodygroups[0][personnalisation["torso"]] or 0)
            player:SetBodygroup(2, faction.bodygroups[1][personnalisation["legs"]] or 0)
        end
    end
end