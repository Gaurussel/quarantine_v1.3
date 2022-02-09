ITEM.name = "Экспедиционный топливный бак"
ITEM.model = Model("models/illusion/eftcontainers/kerosine.mdl")
ITEM.description = "Удивительно легкий пластиковый бак, наполненный различными бензинами и топливом, что делает его легко воспламеняющимся, но также бесценным для некоторых людей, будь то для удовлетворения энергетических потребностей или создания смертельного ада."
ITEM.category = "Junk"
ITEM.width = 2
ITEM.height = 2
ITEM.weight = 5
ITEM.bDropOnDeath = true

function ITEM:PopulateTooltip(tooltip)
    local data = tooltip:AddRow("fuel")
    data:SetBackgroundColor(derma.GetColor("Warning", tooltip))
    data:SetText("Осталось: "..self:GetData("fuel", 100).."%")
    data:SetHeight(3)
    data:SetExpensiveShadow(0.5)
    data:SizeToContents()
end