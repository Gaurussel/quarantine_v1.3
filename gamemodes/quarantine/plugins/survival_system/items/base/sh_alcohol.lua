ITEM.name = "Alcohol"
ITEM.model = Model("models/tnb/items/shirt_rebelbag.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Бла-бла."
ITEM.price = 25
ITEM.category = "Вода"
ITEM.strength = 0
ITEM.water = 1
ITEM.bDropOnDeath = true
--ITEM.flag = "C"

ITEM.functions.Drink = {
	name = "Использовать",
    icon = "icon16/bullet_purple.png",
    --[[OnCanRun = function(item)
    end,]]
	OnRun = function(item)
        local ply = item.player
        local item = item
        local char = ply:GetCharacter()

        if (char:GetWater() + item.water) > 100 then
            char:SetWater(100)
        else
            char:SetWater(char:GetWater() + item.water)
        end

        char:SetAlcohol(char:GetAlcohol() + item.strength)
	end
}