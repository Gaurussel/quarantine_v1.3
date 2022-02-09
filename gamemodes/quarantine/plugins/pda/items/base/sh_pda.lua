ITEM.name = "Radio Base"
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl"
ITEM.description = "A PDA used for communicating with other people."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Communication"
ITEM.price = 150
ITEM.isPDA = true

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip", false)) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		return false
	end

	return true
end

ITEM.functions.Equip = { -- sorry, for name order.
	name = "Прикрепить к поясу",
	tip = "useTip",
	icon = "icon16/add.png",
	OnRun = function(item)
		local client = item.player
		local char = client:GetCharacter()
		local items = char:GetInventory():GetItems()


		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (!itemTable) then
					client:NotifyLocalized("tellAdmin", "wid!xt")

					return false
				else
					if (itemTable.isPDA and itemTable:GetData("equip")) then
						client:NotifyLocalized("У вас уже прикреплён другой КПК.")

						return false
					end
				end
			end
		end

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (v.uniqueID == item.uniqueID and itemTable:GetData("equip")) then
					client:Notify("У вас уже прикреплён другой КПК.")
					return false
				end
			end
		end

		item.player:GetCharacter():SetData("pdanickname", item:GetData("nickname", item.player:GetName()))
		item:SetData("equip", true)
		item.player:GetCharacter():SetData("pdaequipped", true)
		item:OnEquipped()

		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Снять с пояса",
	tip = "equipTip",
	icon = "icon16/delete.png",
	OnRun = function(item)
		local client = item.player
		item:SetData("equip", false)
		item.player:GetCharacter():SetData("pdaequipped", false)
		item:OnUnEquipped()

		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:OnEquipped()

end

function ITEM:OnUnEquipped()

end