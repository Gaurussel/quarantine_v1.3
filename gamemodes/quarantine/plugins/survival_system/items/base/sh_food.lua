ITEM.name = "Food"
ITEM.model = Model("models/tnb/items/shirt_rebelbag.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Бла-бла."
ITEM.price = 25
ITEM.food = 1
ITEM.category = "Еда"
ITEM.bDropOnDeath = true
ITEM.raw = false
--ITEM.flag = "C"

ITEM.functions.Eat = {
	name = "Использовать",
    icon = "icon16/bullet_green.png",
    --[[OnCanRun = function(item)
        if !item.factionEat[item.player:GetCharacter():GetFaction()] then
            return true
        end

        return false
    end,]]
	OnRun = function(item)
        local ply = item.player
        local item = item
        local char = ply:GetCharacter()

        if (char:GetFood() + item.food) > 100 then
            char:SetFood(100)
        else
            char:SetFood(char:GetFood() + item.food)
        end

        if item.raw then
            char:SetPoisoned(true)
        end
	end
}