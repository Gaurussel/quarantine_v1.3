ITEM.name = "Ключ-карта"
ITEM.model = Model("models/props_corruption/keycard_001.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Пластиковая карта со встроенной микросхемой."
ITEM.category = "Laboratory"
ITEM.price = 0
ITEM.noBusiness = true

function ITEM:OnInstanced()
    local ply = self:GetOwner()

    if IsValid(ply) then
        self:SetData("ownerName", ply:Name() or "John Doe")
        self:SetData("uniqueKey", ply:AccountID() or "#########")
    else
        self:SetData("ownerName", "John Doe")
        self:SetData("uniqueKey", "#########")
    end
end

function ITEM:PopulateTooltip(tooltip)
    local userData = {
        name = "Владелец: "..self:GetData("ownerName", "John Doe"),
        uniqueKey = "Уникальный ключ: "..self:GetData("uniqueKey", "#########"),
    }

    for k, v in pairs(userData) do
        local data = tooltip:AddRow("data")
        data:SetBackgroundColor(Color(0, 128, 128, 255))
        data:SetText(v)
        data:SetExpensiveShadow(0.5)
        data:SizeToContents()
    end
end