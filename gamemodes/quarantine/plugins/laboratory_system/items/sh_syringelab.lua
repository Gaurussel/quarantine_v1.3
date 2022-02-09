ITEM.name = "Шприц"
ITEM.model = Model("models/illusion/eftcontainers/medsyringe.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Медицинский инструмент, предназначенный для инъекций, диагностических пункций, отсасывания патологического содержимого из полостей."
ITEM.category = "Laboratory"
ITEM.price = 0
ITEM.noBusiness = true

ITEM.functions.Use = {
	name = "Взять кровь",
	tip = "useTip",
	icon = "icon16/accept.png",
    OnCanRun = function(item)
        local ply = item.player
        local tr = ply:GetEyeTrace()
        local ent = tr.Entity
        local colba = false

        local char = ply:GetCharacter()
        
        if (char) then
            local inv = char:GetInventory()

            if (inv) then
                local items = inv:GetItems()

                for k, v in pairs(items) do
                    if v.uniqueID == "colbablood" and v:GetData("virus", 0) >= 1 then
                        colba = true
                    end
                end
            end
        end

        if ent:IsPlayer() and colba then
            return true
        end

        return false
    end,
	OnRun = function(item)
        local ply = item.player
        local tr = ply:GetEyeTrace()
        local ent = tr.Entity

        local char = ply:GetCharacter()
        
        if (char) and ent:GetCharacter() then
            local inv = char:GetInventory()

            if (inv) then
                local items = inv:GetItems()

                for k, v in pairs(items) do
                    if v.uniqueID == "colbablood" and v:GetData("virus", 0) >= 1 then
                        v:SetData("virus", char:GetData("virus", 1))
                        v:SetData("nameV", ent:Name())
                        break
                    end
                end
            end
        end

		return true
	end,
}