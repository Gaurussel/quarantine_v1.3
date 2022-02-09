ITEM.name = "Противогаз"
ITEM.model = Model("models/tnb/items/gasmask.mdl")
ITEM.width = 2
ITEM.height = 2
ITEM.weight = 0.8
ITEM.description = "Это средство защиты органов дыхания, зрения и кожи лица; Средство защиты от токсичных веществ."
ITEM.price = 25
ITEM.protectgas = true
ITEM.timeprotect = 0
ITEM.category = "Одежда"
ITEM.outfitCategory = "headgear"
ITEM.mask = true

if (CLIENT) then
	-- Draw camo if it is available.
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

ITEM.functions.EquipGs = {
	name = "Экипировать",
	--sound = "npc/barnacle/barnacle_gulp1.wav",
    icon = "icon16/tick.png",
    OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
    end,
	OnRun = function(itemTable)
        local ply = itemTable.player
        local item = itemTable
        local char = ply:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if ((v.outfitCategory == item.outfitCategory or v.outfitCategory == "suit") and itemTable:GetData("equip")) then
					ply:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
					return false
				end
			end
		end

		if itemTable:GetData("timeprotect", 0) <= 0 then
            ply:Notify("Отсутствует фильтр!")
        else
            item:SetData("protectgas", true)
            item:SetData("equip", true)

            ply:SetBodygroup(5, 2)
            ply:EmitSound("gas_mask_on.wav", 25)
        end
        return false
	end
}

ITEM.functions.UnEquipGs = {
	name = "Снять",
    icon = "icon16/cross.png",
	--sound = "npc/barnacle/barnacle_gulp1.wav",
    OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
    end,
	OnRun = function(itemTable)
        local ply = itemTable.player
        local item = itemTable

        item:SetData("protectgas", false)
        item:SetData("equip", false)

        ply:SetBodygroup(5, 0)
        ply:EmitSound("gas_mask_off.wav", 25)

        return false
	end
}

ITEM.functions.ChangeFilter = {
	name = "Сменить фильтр",
    icon = "icon16/arrow_refresh.png",
	--sound = "npc/barnacle/barnacle_gulp1.wav",
    OnCanRun = function(itemTable)
        for k, v in pairs(itemTable.player:GetCharacter():GetInventory():GetItems()) do
            if v.uniqueID == "filter" and v:GetData("timeprotect", v.timeprotect) > 0 then
                return true
            end
        end

        return false
    end,
	OnRun = function(itemTable)
        local ply = itemTable.player
        local item = itemTable

        if IsValid(ply) then
            for k, v in pairs(ply:GetCharacter():GetInventory():GetItems()) do
                if v.uniqueID == "filter" and v:GetData("timeprotect", v.timeprotect) > 0 then
                    item:SetData("timeprotect", v:GetData("timeprotect", v.timeprotect))
                    item:SetData("protectgas", true)

                    v:Remove()
                    ply:Notify("Вы успешно сменили фильтр.")

                    break
                elseif v.uniqueID == "filter" and v:GetData("timeprotect", v.timeprotect) <= 0 then
                    ply:Notify("Фильтр более не способен защитить!")
                end
            end
        end
        return false
	end
}

ITEM.functions.RemoveFilter = {
	name = "Снять фильтр",
	--sound = "npc/barnacle/barnacle_gulp1.wav",
    icon = "icon16/arrow_out.png",
    OnCanRun = function(itemTable)
        if itemTable:GetData("timeprotect", 0) > 0 then
            return true
        end
        return false
    end,
	OnRun = function(itemTable)
        local ply = itemTable.player
        local item = itemTable
        if IsValid(ply) then
            local data = {
                ["timeprotect"] = item:GetData("timeprotect", 0),
            }
            
            if data["timeprotect"] < 0 then
                data["timeprotect"] = 0
            end

            ply:GetCharacter():GetInventory():Add("filter", 1, data)
            item:SetData("protectgas", false)
            item:SetData("equip", false)
            item:SetData("timeprotect", 0)
            ply:Notify("Фильтр успешно снят.")
        end

        return false
	end
}

function ITEM:PopulateTooltip(tooltip)
    local data = tooltip:AddRow("data")
    if self:GetData("timeprotect", 0) > 0 then
        data:SetBackgroundColor(derma.GetColor("Success", tooltip))
    else
        data:SetBackgroundColor(derma.GetColor("Error", tooltip))
    end
    data:SetText("Способен защитить в течении "..self:GetData("timeprotect", 0).." секунд")
    data:SetExpensiveShadow(0.5)
    data:SizeToContents()
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
        item:SetData("equip", false)
    end
end)

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			owner:Notify("Чтобы выкинуть эту вещь, вам нужно снять её с себя!")
		end

		return false
	end

	--[[if (newInventory and !newInventory.vars.isBag) then
		return false
	end]]

	return true
end