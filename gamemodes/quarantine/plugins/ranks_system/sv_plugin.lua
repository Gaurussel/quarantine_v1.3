local PLUGIN = PLUGIN
local factions = {
    [FACTION_ARMY] = true,
    [FACTION_BAND] = true,
}

local character = ix.meta.character

function character:AddRankXP(amount)
    local exp = self:GetRankXP()
    local factionIndice = ix.faction.indices[self:GetFaction()]
    exp = exp + amount

    if exp >= PLUGIN.needExperience[self:GetRank() + 1] then
        if factionIndice.ranks[self:GetRank() + 1] then
            local rank = self:GetRank()
            rank = rank + 1

            self:SetRank(rank)
            self:SetRankXP(0)
            return
        end
    end

    self:SetRankXP(exp)
end

function PLUGIN:Think()
    for k, rankBox in pairs(PLUGIN.positions) do
        local min, max, factionZone = rankBox.min, rankBox.max, rankBox.faction

        for _, ply in pairs(player.GetAll()) do
            if !ply:GetCharacter() then return end
            local faction = ply:GetCharacter():GetFaction()
            if faction == factionZone and factions[faction] then
                local pos = ply:EyePos()

                if pos:WithinAABox(rankBox.min, rankBox.max) then
                    local char = ply:GetCharacter()
                    local charid = char:GetID()
                    local timername = charid..".factionXPGain"

                    if timer.Exists(timerName) then
                        timer.Create(timerName, ix.config.Get("factionXPGain"), 0, function()
                            if IsValid(ply) and ply:GetCharacter():GetID() == charid and ply:EyePos():WithinAABox(rankBox.min, rankBox.max) then
                                char = ply:GetCharacter()
                                local exp = char:GetRankXP()
                                local factionIndice = ix.faction.indices[faction]
                                exp = exp + ix.config.Get("factionXP")

                                if ply:GetUserGroup() != "User" then
                                    exp = exp + 5
                                end
                                
                                char:SetRankXP(exp)

                                if exp >= PLUGIN.needExperience[char:GetRank()] then
                                    char:SetRank(factionIndice.ranks[char:GetRank() + 1])
                                    char:SetRankXP(0)
                                end
                            else
                                timer.Destroy(timerName)
                            end
                        end)
                    end
                end
            end
        end
    end
end