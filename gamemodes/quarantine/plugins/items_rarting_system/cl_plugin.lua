local PLUGIN = PLUGIN
local ITEM = ix.meta.item or {}
local quality_table = {
    ["Легендарное"] = Color(250, 210, 1, 150),
    ["Эпическое"] = Color(234, 141, 247, 150),
    ["Редкое"] = Color(17, 100, 180, 150),
    ["Необычное"] = Color(70, 130, 180, 150),
    ["Обычное"] = Color(100, 154, 158, 150), 
}
local gradient = Material("materials/gradient2.png")


function ITEM:PaintOver(item, w, h)
    local quality = item:GetData("quality", "")
    if quality != "" then
        surface.SetDrawColor(quality_table[quality]) 
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect( 0, 0, w, h )
    end
end

function ITEM:PopulateTooltip(tooltip)
    local quality = self:GetData("quality", "")
    if quality == "" then return end

    local data = tooltip:AddRowAfter("name", "data")
    data:SetBackgroundColor(quality_table[quality])
    data:SetText(quality)
    data:SetHeight(3)
    data:SetExpensiveShadow(0.5)
    data:SizeToContents()
end