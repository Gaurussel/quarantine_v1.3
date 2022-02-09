PLUGIN.name = "commands"
PLUGIN.author = "Gaurussel"
PLUGIN.description = ""

ix.command.Add("GiveMoney", {
    alias = {"GiveMoney"},
    description = "@cmdGiveMoney",
    arguments = ix.type.number,
    OnRun = function(self, client, amount)
        amount = math.floor(amount)

        if (amount <= 0) then
            return L("invalidArg", client, 1)
        end

        local data = {}
            data.start = client:GetShootPos()
            data.endpos = data.start + client:GetAimVector() * 96
            data.filter = client
        local target = util.TraceLine(data).Entity

        if (IsValid(target) and target:IsPlayer() and target:GetCharacter()) then
            if (!client:GetCharacter():HasMoney(amount)) then
                return
            end

            target:GetCharacter():GiveMoney(amount)
            client:GetCharacter():TakeMoney(amount)

            target:NotifyLocalized("moneyTaken", ix.currency.Get(amount))
            client:NotifyLocalized("moneyGiven", ix.currency.Get(amount))
        end
    end
})

ix.command.Add("SetAttPoints", {
    alias = {"SetAttPoints"},
    description = "Устанавливает Points персонажу",
    adminOnly = true,
    arguments = ix.type.number,
    OnRun = function(self, client, number)
        client:GetCharacter():SetPoints(number)
    end
})


ix.command.Add("CharSetMoney", {
    alias = {"CharSetMoney"},
    description = "@cmdCharSetMoney",
    superAdminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.number
    },
    OnRun = function(self, client, target, amount)
        amount = math.Round(amount)

        if (amount <= 0) then
            return "@invalidArg", 2
        end

        target:SetMoney(amount)
        client:NotifyLocalized("setMoney", target:GetName(), ix.currency.Get(amount))
    end
})

ix.command.Add("DropMoney", {
    alias = {"DropMoney"},
    description = "@cmdDropMoney",
    arguments = ix.type.number,
    OnRun = function(self, client, amount)
        amount = math.Round(amount)

        if (amount <= 0) then
            return "@invalidArg", 1
        end

        if (!client:GetCharacter():HasMoney(amount)) then
            return "@insufficientMoney"
        end

        client:GetCharacter():TakeMoney(amount)

        local money = ix.currency.Spawn(client, amount)
        money.ixCharID = client:GetCharacter():GetID()
        money.ixSteamID = client:SteamID()
    end
})

PLUGIN.promocodes = {
    ["IDP2NGnRb6cDCPH"] = {
        active = false,
        money = 500,
        items = {
            "light_armor1",
            "fak",
            "waterl",
            "spam",
            "pda",
        }
    }
}

ix.command.Add("Promocode", {
    alias = {"Promocode"},
    description = "Команда для активации промокодов.",
    arguments = ix.type.string,
    OnRun = function(self, client, promocode)
        local PLUGIN = ix.plugin.list["sh_commands"]

        if PLUGIN.promocodes[promocode] then
            for k, v in pairs(PLUGIN.promocodes) do
                if k == promocode and v.active then
                    local char = client:GetCharacter()
                    local activProm = char:GetData("promocodes", {})

                    if activProm[k] then
                        client:Notify("Вы уже активировали эти промокод!")
                        break
                    end

                    if v.money then
                        char:GiveMoney(v.money)
                    end

                    if v.items then
                        for _, item in pairs(v.items) do
                            char:GetInventory():Add(item, 1)
                        end
                    end

                    client:Notify("Вы активировали промокод.")
                    activProm[k] = true
                    char:SetData("promocodes", activProm)
                    break
                else
                    client:Notify("Промокод более неактивен!")
                    break
                end
            end
        else
            client:Notify("Такого промокода не существует!")
        end
    end
})

ix.command.Add("SetPos", {
    description = "Sets player pos",
    adminOnly = true,
    arguments = {
        ix.type.number,
        ix.type.number,
        ix.type.number,
    },
    OnRun = function(self, client, x, y, z)
        client:SetPos(Vector(x, y, z))
    end
})

ix.command.Add("ForceSeq", {
    description = "Force sequence",
    adminOnly = true,
    arguments = ix.type.string,
    OnRun = function(self, client, anim)
        client:ForceSequence(anim)
    end
})

--[[
    g_presentapexarms
    g_plead_01_leftapexarms
    g_plead_01_leftlooparms
    g_palm_up_high_lapexarms
]]

-- -- pant
-- ix.act.Register("Нет пути", {"citizen_male", "citizen_female"}, {
--     sequence = {"g_noway_big"},
-- })

-- ix.act.Register("Лежать 2", {"citizen_male", "citizen_female"}, {
--     sequence = {"d1_town05_winston_down"},
-- })

-- ix.act.Register("Лежать 3", {"citizen_male", "citizen_female"}, {
--     sequence = {"d1_town05_winston_idle1"},
-- })

-- ix.act.Register("Лежать 4", {"citizen_male", "citizen_female"}, {
--     sequence = {"d1_town05_winston_idle2"},
-- })

-- ix.act.Register("Полегче", {"citizen_male", "citizen_female"}, {
--     sequence = {"g_lhandease"},
-- })

-- ix.act.Register("Руки вверх", {"citizen_male", "citizen_female"}, {
--     sequence = {"g_armsupapexarms"},
-- })

-- ix.act.Register("Хлопать", {"citizen_male", "citizen_female"}, {
--     sequence = {"g_armsupapexarms"},
-- })

-- ix.act.Register("Стоять", {"citizen_male", "citizen_female"}, {
--     sequence = {"g_palm_out_high_l"},
-- })

-- ix.act.Register("Отдать честь", {"citizen_male", "citizen_female"}, {
--     sequence = {"g_salute"},
-- })

-- ix.act.Register("Отлично", {"citizen_male", "citizen_female"}, {
--     sequence = {"g_thumbsup"},
-- })