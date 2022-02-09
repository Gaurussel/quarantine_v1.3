ITEM.name = "Удостоверение личности"
ITEM.description = "Официальный документ, удостоверяющий личность."
ITEM.model = Model("models/gibs/metal_gib4.mdl")
ITEM.category = "Junk"
ITEM.quality = "Обычное"
ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.1
ITEM.bDropOnDeath = false
local format = "%B %d, %Y"

function ITEM:OnInstanced()
    local ply = self:GetOwner()

    if IsValid(ply) then
        self:SetData("ownerName", ply:Name() or "НЕ УКАЗАНО")
        self:SetData("uniqueKey", ply:AccountID() or "НЕ УКАЗАНО")
        self:SetData("national", ply:GetCharacter():GetNational() or "НЕ УКАЗАНО")
        self:SetData("date", ix.date.GetFormatted(format))
        self:SetData("ownerCity", "Миннесота")
    else
        self:SetData("ownerName", "НЕ УКАЗАНО")
        self:SetData("national", "НЕ УКАЗАНО")
        self:SetData("uniqueKey", "НЕ УКАЗАНО")
        self:SetData("ownerCity", "НЕ УКАЗАНО")
        self:SetData("date", "НЕ УКАЗАНО")
    end
end

ITEM.functions.Prisvoit = {
	name = "Присвоить",
    icon = "icon16/pencil.png",
	--sound = "npc/barnacle/barnacle_gulp1.wav",
    OnCanRun = function(item)
        local ply = item.player

        if item:GetData("ownerName", "НЕ УКАЗАНО") == "НЕ УКАЗАНО" and ply:Team() == FACTION_ARMY then
            return true
        end

        return false
    end,
	OnRun = function(item)
        local ply = item.player
        local ent = ply:GetEyeTrace().Entity

        if ent:IsValid() and ent:IsPlayer() then
            local entChar = ent:GetCharacter()

            if !entChar:GetInventory():HasItem("passport") then
                if !entChar:GetInventory():Add("passport", 1, {ownerName = entChar:GetName(), uniqueKey = ent:AccountID(), national = entChar:GetNational(), date = ix.date.GetFormatted(format), ownerCity = "Миннесота"}) then
                    ply:Notify("Вы не смогли выдать пропуск!")
                    return false
                end
                ent:Notify("Вам был выдан пропуск.")

                return true
            else
                ply:Notify("У этого человека уже есть пропуск.")
            end
        end

        return false
	end
}


function ITEM:PopulateTooltip(tooltip)
    local userData = {
        [1] = "Гражданское имя: "..self:GetData("ownerName", "John Doe"),
        [2] = "Национальность: "..self:GetData("national", "John Doe"),
        [3] = "Серийный номер: "..self:GetData("uniqueKey", "#########"),
        [4] = "Город проживания: "..self:GetData("ownerCity", "Миннесота"),
        [5] = "Дата выдачи: "..self:GetData("date", "data"),
    }

    for k, v in SortedPairs(userData, false) do
        local data = tooltip:AddRow("data")
        data:SetBackgroundColor(Color(0, 0, 0, 0))
        data:SetText(v)
        data:SetExpensiveShadow(0.5)
        data:SizeToContents()
    end

    local warning = tooltip:AddRow("warning")
    warning:SetBackgroundColor(derma.GetColor("Warning", tooltip))
    warning:SetText("Пропуск действителен 1 неделю. Для продления обратитесь к военнослужащим.")
    warning:SetHeight(3)
    warning:SetExpensiveShadow(0.5)
    warning:SizeToContents()
end