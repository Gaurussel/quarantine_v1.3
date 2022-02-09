ITEM.name = "Хералотоциклин"
ITEM.description = "Используется для снижения действия вируса."
ITEM.model = "models/warz/consumables/painkillers.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.noBusiness = false
ITEM.price = 200
ITEM.quality = "Редкое"
ITEM.category = "Medics"
ITEM.bDropOnDeath = true

ITEM.functions.Use = {
	name = "Использовать",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()
        local virus_data = char:GetData("Virus", 1)

        if virus_data > 1 then
            virus_data = virus_data - 1
            char:SetData("Virus", virus_data)
        else
            return false
        end
	end
}