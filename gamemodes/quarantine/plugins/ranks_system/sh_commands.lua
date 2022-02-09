concommand.Add("getcurrank", function( ply, cmd, args )
    local char = ply:GetCharacter()
    print(char:GetRank())
    print(char:GetRankXP())
end)

ix.command.Add("UpRank", {
    description = "Повышает текущее звание на 1.",
	arguments = ix.type.character,
    OnRun = function(self, ply, target)
        local plyChar = ply:GetCharacter()
        local plyFaction = plyChar:GetFaction()
        local targetFaction = target:GetFaction()

        if plyFaction == targetFaction then
            local faction = ix.faction.indices[plyFaction]

            if faction.ranks then
                local rank = target:GetRank()
                rank = rank + 1

                target:SetRank(rank)
                ply:Notify("Вы повысили звание игрока "..target:GetName().." до «"..faction.ranks[rank].."».")
            end
        else
            return "Вы состоите в разных фракциях!"
        end
    end
})

ix.command.Add("SetRank", {
    description = "Установить звание.",
	arguments = {
        ix.type.character,
        ix.type.number
    },
    adminOnly = true,
    OnRun = function(self, ply, targetChar, rank)
        local targetFaction = targetChar:GetFaction()
        local faction = ix.faction.indices[targetFaction]

        if faction.ranks then
            if faction.ranks[rank] then
                targetChar:SetRank(rank)

                ply:Notify("Вы установили игроку "..ply:GetName().." звание «"..faction.ranks[rank].."».")
            else
                return ply:Notify("Такого звания не существует!")
            end
        else
            return ply:Notify("У данной фракции нет званий!")
        end
    end
})

ix.command.Add("AddRankZone", {
	description = "Добавляет зону, в которой зарабатываются очки фракции",
	adminOnly = true,
    arguments = ix.type.string,
    OnRun = function(self, client, type)
        local pos = client:GetPos()
        
        local tr = client:GetEyeTrace()
        if not tr then return end
        
        local hitPos = tr.HitPos

        table.insert(PLUGIN.positions, {
            min = pos, max = hitPos,
            faction = type,
        })

        PLUGIN:SaveData()

        return "Added zone."
    end
})

ix.command.Add("RemoveRankZone", {
	description = "Убирает ближайшую зону, в которой зарабатываются очки фракции",
	adminOnly = true,
    OnRun = function(self, client)
        local closestDistance = -1
        local closestIndex = -1
        
        for idx, gasBox in pairs(PLUGIN.positions) do
            local min, max = gasBox.min, gasBox.max

            local center = min + ((max - min) / 2)

            local distance = client:GetPos():Distance(center) 
            if closestDistance == -1 or distance < closestDistance then
                closestDistance = distance
                closestIndex = idx
            end
        end

        if closestIndex ~= -1 then
            table.remove(PLUGIN.positions, closestIndex)
            PLUGIN:SaveData()

            return "1 зона убрана"
        else
            return "Не найдено"
        end
    end
})