local PLUGIN = PLUGIN
local ticktime = 0

function PLUGIN:OnCharacterCreated(char)
    char:SetData("friedliness", 10)
end

local function TakeFriendliness(targChar, attackerChar)
    if targChar:GetData("friendliness", 0) >= 5 then
        attackerChar:SetData("friendliness", attackerChar:GetData("friendliness", 0) - 1)
        attackerChar:GetPlayer():Notify("За свою враждебность вы потеряли 1 очко кармы!")
    elseif targChar:GetData("friendliness", 0) <= 0 then
        attackerChar:SetData("friendliness", attackerChar:GetData("friendliness", 0) + 1)
        attackerChar:GetPlayer():Notify("За убийство опасного человека вы получили 1 очко кармы!")
    end
end

function PLUGIN:CharacterLoaded(char)
    local ply = char:GetPlayer()
    if char:GetFaction() == FACTION_BAND then return end
    if timer.Exists(ply:SteamID()..".karmaPluse") then
        timer.Remove(ply:SteamID()..".karmaPluse")
    end

    timer.Create(ply:SteamID()..".karmaPluse", 300, 0, function()
        if IsValid(ply) and char then
            local karma = char:GetData("friendliness", 0)
            karma = karma + 1

            char:SetData("friendliness", karma)
        end
    end)
end

function PLUGIN:DoPlayerDeath(target, attacker)
    if target:IsPlayer() and attacker:IsPlayer() then
        local targChar = target:GetCharacter()
        local attackerChar = attacker:GetCharacter()

        if attackerChar:GetFaction() == FACTION_BAND then 
            attackerChar:AddRankXP(math.random(1, 3))
            TakeFriendliness(targChar, attackerChar)
            return 
        end
        
        TakeFriendliness(targChar, attackerChar)
        if targChar:GetData("friendliness", 0) < 0 then
            if attacker:Team() != FACTION_ARMY then

                if attackerChar:GetFaction() != FACTION_BAND then
                    attacker:Notify("За свою низкую карму вас нарекли бандитом!")
                end
                
                attackerChar:SetFaction(FACTION_BAND)
            end
        end
    end
end

function PLUGIN:OnNPCKilled(npc, attacker, inflictor)
    if npc:GetClass() == "npc_vj_overwatch_shotgun_prison_guard" and inflictor:IsPlayer() then
        local char = inflictor:GetCharacter()
        local faction = char:GetFaction()

        if faction == FACTION_BAND then
           char:AddRankXP(math.random(1, 3))
        end
    end
end