local PLUGIN = PLUGIN

function PLUGIN:CharacterCreated(char)
    if math.random(0, 100) <= 85 then
        char:SetData("Virus", 1)
    end
end

function PLUGIN:PlayerSwitchWeapon(ply, oldWeap, newWeap)
    local char = ply:GetCharacter()

    if char then
        local virus_data = char:GetData("Virus", 0)
        local random = math.random(5, 10)

        if virus_data == 3 then
            if random > 6 then
                return true
            end
        elseif virus_data == 4 then
            if random > 5 then
                return true
            end
        elseif virus_data > 4 then
            return true
        end
    end
end

function PLUGIN:PlayerTick(ply)
    if !ply:GetCharacter() then return end
    local char = ply:GetCharacter()
    local charid = char:GetID()
    local timer_name = "virusDeath."..ply:AccountID()

    if char:GetData("Virus", 0) == 5 then
        if !timer.Exists(timer_name) then
            timer.Create(timer_name, 10, 1, function()
                if ply:IsValid() and ply:GetCharacter() and ply:GetCharacter():GetID() == charid then 
                    if char:GetData("Virus", 0) == 5 then
                        ply:ForceSequence("headcrabbed", function()
                            ply:Kill()
                            char:SetData("permakilled", true)
                            char:Ban()
                        end, nil, true)
                    end
                end
            end)
        end
    end
end

concommand.Add("givestage", function(ply, _, args)
    if ply:IsSuperAdmin() then
        local char = ply:GetCharacter()
        char:SetData("Virus", tonumber(args[1]))
    end
end)

concommand.Add("getitems", function(ply)
    ply:Notify("Попався!")
    --PrintTable(ply:GetCharacter():GetInventory():GetItems())
end)

