ITEM.name = "Фонарик"
ITEM.model = Model("models/Items/battery.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.6
ITEM.description = "Стандартный фонарик, который можно переключать."
ITEM.category = "Электроника"

ITEM:Hook("drop", function(item)
	item.player:Flashlight(false)
end)
ITEM.bDropOnDeath = true