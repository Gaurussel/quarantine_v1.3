ITEM.name = "Фильтр для противогаза"
ITEM.model = Model("models/teebeutel/metro/objects/gasmask_filter.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.2
ITEM.description = "Фильтр предназначен для очистки загрязненного воздуха различных отраслей промышленности от вредных химических веществ, радиоактивной пыли и биологических аэрозолей."
ITEM.price = 25
ITEM.category = "Остальное"
ITEM.timeprotect = 300
local quality_table = {
    ["Легендарное"] = Color(250, 210, 1, 150),
    ["Эпическое"] = Color(234, 141, 247, 150),
    ["Редкое"] = Color(17, 100, 180, 150),
    ["Необычное"] = Color(70, 130, 180, 150),
    ["Обычное"] = Color(100, 154, 158, 150), 
}

function ITEM:OnInstanced()
    local quality = self:GetData("quality", "")
    if quality == "" then return end

    if quality == "Обычное" then
        self:SetData("timeprotect", math.random(10, 30))
    elseif quality == "Необычное" then
        self:SetData("timeprotect", math.random(31, 59))
    elseif quality == "Редкое" then
        self:SetData("timeprotect", math.random(60, 120))
    elseif quality == "Эпическое" then
        self:SetData("timeprotect", math.random(121, 180))
    elseif quality == "Легендарное" then
        self:SetData("timeprotect", math.random(180, 300))
    end
end

function ITEM:PopulateTooltip(tooltip)
    local data = tooltip:AddRow("data")
    local timeprotect = self:GetData("timeprotect") or self.timeprotect
    if self.timeprotect > 0 then
        data:SetBackgroundColor(derma.GetColor("Success", tooltip))
    else
        data:SetBackgroundColor(derma.GetColor("Error", tooltip))
    end
    data:SetText("Способен защитить в течении "..timeprotect.." секунд")
    data:SetExpensiveShadow(0.5)
    data:SizeToContents()
end