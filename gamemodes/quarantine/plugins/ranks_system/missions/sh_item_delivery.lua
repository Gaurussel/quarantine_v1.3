local PLUGIN = PLUGIN
local mission_time = 600
local vectors_loadings = {
    Vector(4823, -14214, -317),
    Vector(-12319, -8858, -399),
    Vector(-5346, -10366, -399),
}
local currentPos = Vector(0, 0, 0)
local missions_var = {
    ["m4a1"] = {
        name = "Доставка карабина «M4A1»",
        item = "m4a1",
        deliveryVehicle = "bm_M35",
        hook = "missions.itemDelivery",
    },
    --[[["iodide"] = {
        name = "Доставка йодида калия",
        item = "iodide",
        deliveryVehicle = "bm_M35",
        hook = "missions.itemDelivery",
    },
    ["acid"] = {
        name = "Доставка серной кислоты",
        item = "acid",
        deliveryVehicle = "bm_M35",
        hook = "missions.itemDelivery",
    },
    ["anhydride"] = {
        name = "Доставка уксусного ангигрида",
        item = "anhydride",
        deliveryVehicle = "bm_M35",
        hook = "missions.itemDelivery",
    },
    ["ethanol"] = {
        name = "Доставка этанола",
        item = "ethanol",
        deliveryVehicle = "bm_M35",
        hook = "missions.itemDelivery",
    },]]
}

local entities = {}

if SERVER then
    local currentMissionItem = "m4a1"
    local countItems = 0
    local missionEnts = {}

    local function missionStart(caller, uniqueID)
        if !caller:IsValid() then return end
        if !missions_var[uniqueID] then return end 

        currentMissionItem = uniqueID
        caller:Notify("Вы начали миссию.")
        for k, v in pairs(missions_var) do
            if k == uniqueID then
                if !timer.Exists("mission.item_delivery") then
                    if !v.deliveryVehicle then return end
                    local vehicleList = list.Get("Vehicles")[v.deliveryVehicle]
                    if !vehicleList then return end

                    local spawnedVehicle = ents.Create(vehicleList.Class)
                    if !spawnedVehicle then return end

                    spawnedVehicle:SetModel(vehicleList.Model)

                    if vehicleList.KeyValues then
                        for k, v in pairs(vehicleList.KeyValues) do
                            spawnedVehicle:SetKeyValue(k, v)
                        end
                    end

                    spawnedVehicle.VehicleTable = vehicleList

                    spawnedVehicle:SetPos(Vector(10835.050781, 10214.900391, 45.282440))
                    --spawnedVehicle:SetPos(Vector(-5323.263184, -10220.866211, -387.524231))
                    spawnedVehicle:SetAngles(Angle(1.031008, -89.657928, 0.000000))
                    spawnedVehicle:Spawn()
                    spawnedVehicle:Activate()
                    missionEnts[spawnedVehicle] = true

                    local container = ents.Create("ix_container")
                    container:SetModel("models/Items/ammocrate_smg1.mdl")
                    container:SetPos(spawnedVehicle:GetPos() + Vector( -100, 30, 95))
                    container:SetAngles(Angle(1.031008, -89.657928, 0.000000))
                    container:Spawn()
                    container.mission = currentMissionItem
                    missionEnts[container] = true

                    ix.inventory.New(0, "container:" .. container:GetModel():lower(), function(inventory)
                        inventory.vars.isBag = true
                        inventory.vars.isContainer = true

                        if (IsValid(container)) then
                            container:SetInventory(inventory)
                            ix.plugin.list["containers"]:SaveContainer()
                        end
                    end)

                    local container2 = ents.Create("ix_container")
                    container2:SetModel("models/Items/ammocrate_smg1.mdl")
                    container2:SetPos(spawnedVehicle:GetPos() + Vector( -100, -10, 95))
                    container2:SetAngles(Angle(1.031008, -89.657928, 0.000000))
                    container2:Spawn()
                    container2.mission = currentMissionItem
                    missionEnts[container2] = true

                    ix.inventory.New(0, "container:" .. container2:GetModel():lower(), function(inventory)
                        inventory.vars.isBag = true
                        inventory.vars.isContainer = true

                        if (IsValid(container2)) then
                            container2:SetInventory(inventory)
                            ix.plugin.list["containers"]:SaveContainer()
                        end
                    end)
                    
                    timer.Create("mission.item_delivery", mission_time, 1, function()
                        if spawnedVehicle:IsValid() then
                            spawnedVehicle:Remove()
                        end
            
                        if container:IsValid() then
                            container:Remove()
                        end
            
                        if container2:IsValid() then
                            container2:Remove()
                        end
                        missionEnts = {}
                    end)

                    currentPos = table.Random(vectors_loadings)
                    netstream.Start(ply, "missions.itemDelivery2", currentMissionItem, currentPos)
                    PLUGIN.currentMissions[currentMissionItem] = currentPos
                else
                    return
                end
            end
        end
    end

    netstream.Hook("missions.itemDelivery", function(ply, uniqueID)
        missionStart(ply, uniqueID)
    end)

    function PLUGIN:Think()
        if timer.Exists("mission.item_delivery") then
            for _, ply in pairs(player.GetAll()) do
                for _, ent in pairs(ents.FindInBox(Vector(10533.240234, 12043.595703, -13.107681), Vector(9900.823242, 11387.966797, 488.435577))) do
                    if ent:GetClass() == "ix_container" then
                        local inventory = ent:GetInventory():GetItems()
        
                        for _, item in pairs(inventory) do
                            if item then
                                if item.base == "base_cw20presets" or item.base == "base_cw20weapons" then
                                    local wep = PLUGIN.locker_items[item.uniqueID] or 0
                                    PLUGIN.locker_items[item.uniqueID] = wep + 1
                                    item:Remove()
                                    
                                    if !timer.Exists("mission.item_delivery.ents_delete") then
                                        timer.Create("mission.item_delivery.ents_delete", 1, 1, function()
                                            for ent2, l in pairs(missionEnts) do
                                                if IsValid(ent2) then
                                                    ent2:Remove()
                                                    missionEnts[ent2] = nil
                                                else
                                                    ply:Notify("Вы провалили миссию!")
                                                end
                                            end
                                            
                                            ix.XPSystem.AddXP(ply, 10)
                                            ply:GetCharacter():AddRankXP(math.random(3, 6))

                                            netstream.Start(ply, "missions.itemDelivery3", currentMissionItem)
                                            timer.Remove("mission.item_delivery")
                                        end)
                                    end
                                elseif item.category == "Медикаменты" then
                                    local itm = PLUGIN.lab_items[item.uniqueID] or 0
                                    PLUGIN.lab_items[item.uniqueID] = itm + 1
                                    item:Remove()
                                    
                                    if !timer.Exists("mission.item_delivery.ents_delete") then
                                        timer.Create("mission.item_delivery.ents_delete", 1, 1, function()
                                            for ent2, l in pairs(missionEnts) do
                                                if IsValid(ent2) then
                                                    ent2:Remove()
                                                    missionEnts[ent2] = nil
                                                else
                                                    ply:Notify("Вы провалили миссию!")
                                                end
                                            end
                                            
                                            ix.XPSystem.AddXP(ply, 10)
                                            ply:GetCharacter():AddRankXP(math.random(1, 4))

                                            netstream.Start(ply, "missions.itemDelivery3", currentMissionItem)
                                            timer.Remove("mission.item_delivery")
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
else
    netstream.Hook("missions.itemDelivery2", function(uniqueID, pos)
        PLUGIN.currentMissions[uniqueID] = pos

        timer.Create("mission.item_delivery", mission_time, 1, function()
            LocalPlayer():Notify("Вы провалили миссию!")
            PLUGIN.currentMissions[uniqueID] = nil
        end)
    end)

    netstream.Hook("missions.itemDelivery3", function(uniqueID)
        timer.Remove("mission.item_delivery")
        LocalPlayer():Notify("Вы успешно завершили миссию!")
        PLUGIN.currentMissions[uniqueID] = nil
    end)
end

PLUGIN.missions.item_delivery = missions_var

concommand.Add("getmodelent", function(ply)
    print(ply:GetEyeTrace().Entity:GetClass())
    print(ply:GetEyeTrace().Entity:IsDoor())
end)