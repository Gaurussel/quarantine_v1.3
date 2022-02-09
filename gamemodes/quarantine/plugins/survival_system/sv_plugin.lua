local water_amount = 1 -- how much does it take up water/food
local food_amount = 1 -- how much does it take up water/food
local alcohol_amount = 0.05 --how much does it take up alcohol

local water_speed = 120 -- how many times it takes (in seconds)
local food_speed = 180 -- how many times it takes (in seconds)
local alcohol_speed = 30 -- how many times it takes (in seconds)

local playerMeta = FindMetaTable("Player")

function playerMeta:TickWater(amount)
    local char = self:GetCharacter()

    if (char) then
        local water = char:GetWater()
        char:SetWater(water - amount)
        self:SetLocalVar("Water", water - amount)

        if water < 0 then
            char:SetWater(0)
            self:TakeDamage(1)
            self:SetLocalVar("Water", 0)
        end

        if water > 100 then
            char:SetWater(100)
        end
    end
end

function playerMeta:TickFood(amount)
    local char = self:GetCharacter()

    if (char) then
        local food = char:GetFood()
        char:SetFood(food - amount)
        self:SetLocalVar("Food", food - amount)

        if food < 0 then
            char:SetFood(0)
            self:TakeDamage(1)
            self:SetLocalVar("Food", 0)
        end

        if food > 100 then
            char:SetFood(100)
        end
    end
end

function playerMeta:TickAlcohol(amount)
    local char = self:GetCharacter()

    if (char) then
        local alcohol = char:GetAlcohol()
        if alcohol > 0 then
            char:SetAlcohol(alcohol - amount)
            self:SetLocalVar("Alcohol", alcohol - amount)
        else
            if alcohol < 0 then
                char:SetAlcohol(0)
            end
        end
    end
end

local ticktime = 0

function PLUGIN:PlayerTick(ply)
    if ply:GetNetVar("Foodtick", 0) <= CurTime() then
        ply:SetNetVar("Foodtick", food_speed + CurTime())
        ply:TickFood(food_amount)
    end

    if ply:GetNetVar("Watertick", 0) <= CurTime() then
        ply:SetNetVar("Watertick", water_speed + CurTime())
        ply:TickWater(water_amount)
    end

    if ply:GetNetVar("Alcoholtick", 0) <= CurTime() then
        ply:SetNetVar("Alcoholtick", alcohol_speed + CurTime())
        ply:TickAlcohol(alcohol_amount)
    end
end

local playerMeta = FindMetaTable("Player")

concommand.Add("givemedata", function(ply)
    local char = ply:GetCharacter()
    print("food "..char:GetFood())
    print("water "..char:GetWater())
    print("alcohol "..char:GetAlcohol())
end)

concommand.Add("setalcohol", function(ply)
    local char = ply:GetCharacter()
    char:SetAlcohol(0)
end)