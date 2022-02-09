ITEM.name = "Пачка сигарет"
ITEM.model = Model("models/props_junk/cigarettepack_001.mdl")
ITEM.description = "Пачка довоенных американских сигарет. Выглядит еще не открытой."
ITEM.category = "Сигареты"
ITEM.open = false
ITEM.totalcigs = 10
ITEM.price = 15
ITEM.quality = "Редкое"
ITEM.flag = "Y"
ITEM.new = true

ITEM.functions.TakeCigarette = {
    name = "Взять сигарету",
    tip = "Take a cigarette.",
    icon = "icon16/brick.png",
    OnCanRun = function(item)
        if item:GetData("open") then
            return true
        else
            return false
        end
    end,
    OnRun = function(item)
        local character = item.player:GetCharacter()
        local client = item.player

        if item:GetData("totalcigs", 0) > 1 and item:GetData("open") then
            item:SetData("totalcigs", item:GetData("totalcigs", 0) - 1 )

            return false
        else
            return true
        end
    end
}

ITEM.functions.OpenCigarettes = {
	name = "Открыть пачку",
	tip = "Открывает пачку сигарет.",
    icon = "icon16/door_open.png",
    OnCanRun = function(item)
        if item:GetData("open") == false then
            return true
        else
            return false
        end
    end,
    OnRun = function(item)
    	item:SetData("open", true)
    	return false
    end
}
ITEM.postHooks.TakeCigarette = function(item, result)
    local index = item:GetData("id")

    if !(item.player:GetCharacter():GetInventory():Add("cigarette", 1)) then
        ix.item.Spawn("cigarette", item.player)
    end
end