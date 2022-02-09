local PLUGIN = PLUGIN
local historyItems = {
    ["Путешественник"] = {
        [1] = "passport",
        [2] = "map_city",
        [3] = "bandage",
        [4] = "matches",
    },
    ["Иммигрант"] = {
        [1] = "passport",
        [2] = "taynoe",
    },
    ["Коренной житель"] = {
        [1] = "passport",
        [2] = "flashlight",
    },
}

local jobs = {
    ["Полицейский"] = {
        [1] = "pjacket",
        [2] = "blackniz",
        [3] = "m1911",
        [4] = "radio",
        [5] = "pistolammo",
        [6] = "handcuffs",
    },
    ["Пожарный"] = {
        [1] = "ffjacket",
        [2] = "ffniz",
        [3] = "gasmasks",
        [4] = "fak",
    },
    ["Фермер"] = {
        [1] = "carbseed",
        [2] = "carseed",
        [3] = "showel",
    },
    ["Диггер"] = {
        [1] = "gasmasks",
        [2] = "gloves2",
        [3] = "americancigarettes",
        [4] = "matches",
    },
    ["Инженер"] = {
        [1] = "screwdriver",
        [2] = "wrench",
        [3] = "cigarette",
        [4] = "matches",
        [5] = "nabortools",
    },
}

function PLUGIN:OnCharacterCreated(ply, char)
    char:SetDescription("Рост "..char:GetHeight().." сантиметров | Национальность "..char:GetNational().." | Цвет глаз "..char:GetEye_color().." |")
    char:SetData("firstSpawn", false)
end

local tmale = {
    "zahar",
    "ermil"
}

local tfemale = {
    "oksana",
    "omazh",
    "alyss",
    "jane",
}

function PLUGIN:CharacterLoaded(char)
    local ply = char:GetPlayer()

    timer.Simple(0.2, function()
        ply:Say("/ActInjured")
    end)

    if !char:GetData("firstSpawn", false) then
        netstream.Start(ply, "interface.AcceptMenu")
        ply:SetLocalVar("firstSpawnMenu", true)

        timer.Simple(0.2, function()
            ply:Say("/ExitAct")
        end)
    end

    if ply:IsFemale() then
        local voice = table.Random(tfemale)
        ply:SetNetVar("voice_ver", voice)
    else
        local voice = table.Random(tmale)
        ply:SetNetVar("voice_ver", voice)
    end
end

netstream.Hook("interface.WheelFunctions", function(client, trChar, func, data)
    if func == 1 then
        trChar:GiveMoney(data)
        trChar:GiveMoney(-data)
        client:Notify("Вы передали человеку напротив "..data.."$")
    elseif func == 2 then
        if !ply:GetCharacter():DoesRecognize(trChar:GetID()) then
            client:Recognize(trChar:GetID())
        else
            client:Notify("Вы уже знакомы.")
        end
    elseif func == 3 then
        Schema:SearchPlayer(client, trChar:GetPlayer())
    end
end)

netstream.Hook("interface.WheelFunctions2", function(client, data, data2)
    if data2 == 1 then
        ix.command.Run(client, "Act"..data, {})
    elseif data2 == 2 then
        local character = client:GetCharacter()
        local inventory = character:GetInventory()

        if data == "bandage" then
            local item = inventory:HasItem(data)

            if item then
                item.functions.UseSelf.OnRun(item)
                item:Remove()
                return
            else
                client:Notify("У вас нет этого предмета!")
                return
            end
        elseif data == "drug_left_leg" then
            local item = inventory:HasItem(data)

            if item then
                item.functions.UseSelf.OnRun(item)
                item:Remove()
                return
            else
                client:Notify("У вас нет этого предмета!")
                return
            end        
        elseif data == "drug_right_leg" then
            local item = inventory:HasItem(data)

            if item then
                item.functions.UseSelf.OnRun(item)
                item:Remove()
                return
            else
                client:Notify("У вас нет этого предмета!")
                return
            end
        elseif data == "drug_right_arm" then
            local item = inventory:HasItem(data)

            if item then
                item.functions.UseSelf.OnRun(item)
                item:Remove()
                return
            else
                client:Notify("У вас нет этого предмета!")
                return
            end
        elseif data == "drug_left_arm" then
            local item = inventory:HasItem(data)

            if item then
                item.functions.UseSelf.OnRun(item)
                item:Remove()
                return
            else
                client:Notify("У вас нет этого предмета!")
                return
            end
        elseif data == "syringe_morphine" then
            local item = inventory:HasItem(data)

            if item then
                item.functions.UseSelf.OnRun(item)
                item:Remove()
                return
            else
                client:Notify("У вас нет этого предмета!")
                return
            end
        end
    end
end)

netstream.Hook("interface.AcceptMenu2", function(ply)
    local char = ply:GetCharacter()
    char:SetData("firstSpawn", true)
    ply:SetLocalVar("firstSpawnMenu", false)

    local history = char:GetHistory()

    for k, v in pairs(historyItems[history]) do
        char:GetInventory():Add(v, 1)
    end

    for k, v in pairs(table.Random(jobs)) do
        char:GetInventory():Add(v, 1)
    end
end)

netstream.Hook("interface.AddAttribute", function(ply, attrib, value)
    local char = ply:GetCharacter()
    local points = char:GetPoints()
    if points >= 1 then
        char:SetAttrib(attrib, value)
        char:SetPoints((points - 1))
        ply:Notify("Вы потратили очко атибута.")
    else
        ply:Notify("У вас нет доступных очков атрибута.")
    end
end)

concommand.Add("setmenu", function( ply )
    netstream.Start(ply, "interface.AcceptMenu")
end)

local deathAnims = {
    "death_02",
    "death_03",
    "death_04",
}
function PLUGIN:DoPlayerDeath(ply)
    ply:ForceSequence(table.Random(deathAnims))
end