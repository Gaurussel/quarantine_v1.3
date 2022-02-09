ITEM.name = "Львиное мясо"
ITEM.model = Model("models/props_junk/garbage_bag001a.mdl")
ITEM.description = "Мясо убитого льва, завёрнутое в пакет"
ITEM.quality = "Эпическое"
ITEM.category = "Hunter"
ITEM.bDropOnDeath = true
ITEM.food = 85
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