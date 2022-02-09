local PLUGIN = PLUGIN
local ITEM = ix.meta.item or {}
ITEM.postHooks = ITEM.postHooks or {}
PLUGIN.item_not_quality = {
    ["bitcoin"] = "Легендарное",
    ["zip_tie"] = "Обычное",
    ["radio"] = "Обычное",
    ["pager"] = "Обычное",
    ["filter"] = "Обычное",
    ["gasmasks"] = "Обычное",
    ["labsnotes"] = "Обычное",
    ["paper"] = "Обычное",
    ["petri"] = "Обычное",
    ["colbablood"] = "Обычное",
    ["syringelab"] = "Обычное",
    ["bandage"] = "Обычное",
    ["bloodbag"] = "Обычное",
    ["syringe_antidote"] = "Обычное",
    ["syringe_morphine"] = "Обычное",
    ["syringe_poison"] = "Обычное",
    ["bolts"] = "Обычное",
    ["bluegunpowder"] = "Редкое",
    ["copypaper"] = "Обычное",
    ["insulatingtape"] = "Обычное",
    ["militarybattery"] = "Эпическое",
    ["militarycable"] = "Редкое",
    ["militarycircuitboard"] = "Эпическое",
    ["nailpack"] = "Обычное",
    ["zip_tie"] = "Необычное",
    ["weaponparts"] = "Редкое",
    ["redgunpowder"] = "Эпическое",
}

function ITEM:OnInstanced()
    for k, v in pairs(PLUGIN.item_not_quality) do
        if k == self.uniqueID then
            self:SetData("quality", v)
            break
        end
    end

    if self.quality != nil then
        self:SetData("quality", self.quality)
    end

    --[[if PLUGIN.item_not_quality[self.uniqueID] then 
        self:SetData("quality", "Обычное")
        return
    end]]

    if self:GetData("quality", "") == "" then
        local chance = math.random(0, 90)
        local set_quality

        if chance >= 87 then
            set_quality = "Легендарное"
        elseif chance >= 82 then
            set_quality = "Эпическое"
        elseif chance >= 78 then
            set_quality = "Редкое"
        elseif chance >= 75 then
            set_quality = "Необычное"
        else
            set_quality = "Обычное"
        end
        self:SetData("quality", set_quality)
    end
end
