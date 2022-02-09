ITEM.name = "Набор инструментов"
ITEM.model = Model("models/props_clutter/geo_cache_001.mdl")
ITEM.width = 2
ITEM.height = 2
ITEM.description = "Контейнер, содержащий в себе набор инструментов необходимых для создания вещей"
ITEM.category = "Junk"
ITEM.price = 0

ITEM.functions.Use = {
	name = "Использовать",
	OnRun = function(item)
		netstream.Start(item.player, "Crafting.OpenMenu")
		return false
	end,
	icon = "icon16/wrench.png",
}