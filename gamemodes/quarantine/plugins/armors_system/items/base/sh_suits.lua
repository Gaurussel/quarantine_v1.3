ITEM.name = "Suit"
ITEM.model = Model("models/tnb/items/shirt_rebelbag.mdl")
ITEM.width = 2
ITEM.height = 2
ITEM.description = "Бла-бла."
ITEM.price = 25
ITEM.outfitCategory = "suit"
ITEM.IsArmor = true
ITEM.bDropOnDeath = true
ITEM.protectProcent = 15
ITEM.standartDurability = 100
ITEM.modelEquipFem = Model("models/tnb/items/shirt_rebelbag.mdl")
ITEM.modelEquipMal = Model("models/tnb/items/shirt_rebelbag.mdl")
ITEM.protectgas = true
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

ITEM.functions.Equip = {
	name = "Экипировать",
    icon = "icon16/tick.png",
    OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
    end,
	OnRun = function(item)
        local ply = item.player
        local char = ply:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (v.outfitCategory == "suit" and item:GetData("equip")) then
					ply:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
					return false
				end
			end
		end

        item:SetData("oldPM", char:GetModel())
        item:SetData("equip", true)

        if ply:IsFemale() then
            char:SetModel(item.modelEquipFem)
        else
            char:SetModel(item.modelEquipMal)
        end

        ply:EmitSound("gas_mask_on.wav", 25)

        return false
	end
}

ITEM.functions.EquipUn = {
	name = "Снять",
    icon = "icon16/cross.png",
    OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
    end,
	OnRun = function(item)
        local ply = item.player
        local item = item
        local char = ply:GetCharacter()

        item:SetData("equip", false)
        char:SetModel(item:GetData("oldPM"))
        item:SetData("oldPM", "")

        local faction = ix.faction.indices[char:GetFaction()]
        local personnalisation = char:GetPersonnalisation()
        
        ply:SetSkin(personnalisation["head"] or 0)
        ply:SetBodygroup(1, faction.bodygroups[0][personnalisation["torso"]] or 0)
        ply:SetBodygroup(2, faction.bodygroups[1][personnalisation["legs"]] or 0)
        
        ply:EmitSound("gas_mask_off.wav", 25)
        return false
	end
}

ITEM.functions.ChangeFilter = {
	name = "Сменить фильтр",
	--sound = "npc/barnacle/barnacle_gulp1.wav",
    icon = "icon16/arrow_refresh.png",
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
                    ply:Notify("Фильтр успешно сменён.")
                    break
                elseif v.uniqueID == "filter" and v:GetData("timeprotect", v.timeprotect) <= 0 then
                    ply:Notify("Этот фильтр более не способен защитить.")
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
            char:SetModel(item:GetData("oldPM"))
            item:SetData("oldPM", "")
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

    data:SetText("Способен защитить ещё "..self:GetData("timeprotect", 0).." секунд.")
    data:SetExpensiveShadow(0.5)
    data:SizeToContents()

    local durability = tooltip:AddRow("data")
    local durabilityy = self:GetData("durability", self.standartDurability)
    durability:SetText("Качество: "..durabilityy.."%.")
    durability:SetBackgroundColor(derma.GetColor("Warning", tooltip))
    durability:SetExpensiveShadow(0.5)
    durability:SizeToContents()
end

function ITEM:OnRemoved()
	local inventory = ix.item.inventories[self.invID]
	local owner = inventory.GetOwner and inventory:GetOwner()

	if (IsValid(owner) and owner:IsPlayer()) then
		if (self:GetData("equip")) then
            self:SetData("equip", false)
            self:SetData("oldPM", "")
		end
	end
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
        local ply = item.player
        local item = item
        local char = ply:GetCharacter()

        item:SetData("equip", false)
        char:SetModel(item:GetData("oldPM"))
        item:SetData("oldPM", "")

        local faction = ix.faction.indices[char:GetFaction()]
        local personnalisation = char:GetPersonnalisation()

        ply:SetSkin(personnalisation["head"])
        ply:SetBodygroup(1, faction.bodygroups[0][personnalisation["torso"]])
        ply:SetBodygroup(2, faction.bodygroups[1][personnalisation["legs"]])
	end
end)

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip", false)) then
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			owner:Notify("Чтобы выкинуть эту вещь, вам нужно снять её с себя!")
		end

		return false
	end

	return true
end