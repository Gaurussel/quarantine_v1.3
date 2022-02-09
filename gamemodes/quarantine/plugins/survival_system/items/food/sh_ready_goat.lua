ITEM.name = "Козлиное мясо"
ITEM.model = Model("models/props_junk/garbage_bag001a.mdl")
ITEM.description = "Мясо убитого козла, завёрнутое в пакет"
ITEM.quality = "Редкое"
ITEM.category = "Hunter"
ITEM.bDropOnDeath = true
ITEM.food = 75
ITEM.weight = 2.4

if CLIENT then
    function ITEM:PopulateTooltip(tooltip)
	    local data = tooltip:AddRowAfter("name", "data")
        data:SetBackgroundColor(derma.GetColor("Success", tooltip))
	    data:SetText("К употребление готово!")
	    data:SetHeight(3)
	    data:SetExpensiveShadow(0.5)
	    data:SizeToContents()
	end
end