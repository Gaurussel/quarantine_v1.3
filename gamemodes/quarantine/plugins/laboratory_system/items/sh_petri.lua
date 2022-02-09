ITEM.name = "Чашка петри"
ITEM.model = Model("models/props_lab/petridish01a.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Прозрачный лабораторный сосуд в форме невысокого плоского цилиндра, закрываемого прозрачной крышкой подобной формы, но несколько большего диаметра."
ITEM.category = "Laboratory"
ITEM.price = 0
ITEM.noBusiness = true

ITEM.functions.Use = {
	name = "Использовать",
	tip = "useTip",
	icon = "icon16/accept.png",
    OnCanRun = function(item)
        local ply = item.player
        local tr = ply:GetEyeTrace()
        local ent = tr.Entity

        if !table.IsEmpty(item:GetData("petri", {})) then
            if IsValid(ent) and ent:GetClass() == "ix_microscope" then
                return true
            end
        end

        return false
    end,
	OnRun = function(item)
        local ply = item.player
        local tr = ply:GetEyeTrace()
        local ent = tr.Entity

        ent:SetNetVar("petri", item:GetData("petri", {}))

		return true
	end,
}

ITEM.functions.UseInPut = {
	name = "Налить",
	tip = "useTip",
	icon = "icon16/bug_add.png",
    isMulti = true,
    multiOptions = function(item, client)
        local targets = {}
        local char = client:GetCharacter()
        
        if (char) then
            local inv = char:GetInventory()

            if (inv) then
                local items = inv:GetItems()

                for k, v in pairs(items) do
                    if (v.petri) then
                        table.insert(targets, {
                            name = L( v.name ),
                            data = { v:GetID() },
                        })
                    else
                        continue
                    end
                end
            end
        end

        return targets
    end,
    OnCanRun = function(item)
        local client = item.player

        return !IsValid(item.entity) and IsValid(client) and item.invID == client:GetCharacter():GetInventory():GetID()
    end,
    OnRun = function(item, data)
        local itemOur = item.player:GetCharacter():GetInventory():GetItemByID(data[1])

        if itemOur then
            item:SetData("petri", { 
                haveBlood = true,
                virus = itemOur:GetData("virus", 0),
            })
            itemOur:Remove()
        end

        return false
    end,
}

