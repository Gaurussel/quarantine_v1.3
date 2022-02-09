ITEM.name = "Каталитическая грелка"
ITEM.model = Model("models/illusion/eftcontainers/powerbank.mdl")
ITEM.description = "Химическая грелка, предназначенная для индивидуального согревания человека за счёт беспламенного окисления паров бензина высокой очистки."
ITEM.category = "Junk"
ITEM.bDropOnDeath = true
ITEM.weight = 0.6
ITEM.quality = "Необычное"

function ITEM:PopulateTooltip(tooltip)
    local data = tooltip:AddRow("fuel")
    data:SetBackgroundColor(derma.GetColor("Warning", tooltip))
    data:SetText("Осталось: "..self:GetData("fuel", 100).."%")
    data:SetHeight(3)
    data:SetExpensiveShadow(0.5)
    data:SizeToContents()
end

ITEM.functions.Fuel = {
	name = "Залить топливо",
	tip = "useTip",
	icon = "icon16/cup_add.png",
    OnCanRun = function(item)
        local ply = item.player
        local fuelItem = ply:GetCharacter():GetInventory():HasItem("expiditionaryfuel")

        if fuelItem and fuelItem:GetData("fuel", 100) > 0 then
            return true
        end

        return false
    end,
	OnRun = function(item)
        local ply = item.player
        local expiditionaryfuel = ply:GetCharacter():GetInventory():HasItem("expiditionaryfuel")
        local fuelItem = expiditionaryfuel:GetData("fuel", 100)

        expiditionaryfuel:SetData("fuel", math.Clamp(fuelItem - 5, 0, 100))
        item:SetData("fuel", 100)
        ply:Say("/me залил в горелку топливо.")
        return false
	end,
}