
ITEM.name = "Outfit"
ITEM.description = "A Outfit Base."
ITEM.category = "Outfit"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bDropOnDeath = true
ITEM.outfitCategory = "model"
ITEM.noInventory = false
ITEM.pacData = {}
local quality_table = {
    ["Легендарное"] = Color(250, 210, 1, 150),
    ["Эпическое"] = Color(234, 141, 247, 150),
    ["Редкое"] = Color(17, 100, 180, 150),
    ["Необычное"] = Color(70, 130, 180, 150),
    ["Обычное"] = Color(100, 154, 158, 150), 
}
local gradient = Material("materials/gradient2.png")


ITEM.functions.View = {
	icon = "icon16/briefcase.png",
	OnClick = function(item)
		local index = item:GetData("id", "")

		if (index) then
			local panel = ix.gui["inv"..index]
			local inventory = ix.item.inventories[index]
			local parent = IsValid(ix.gui.menuInventoryContainer) and ix.gui.menuInventoryContainer or ix.gui.openedStorage

			if (IsValid(panel)) then
				panel:Remove()
			end

			if (inventory and inventory.slots) then
				panel = vgui.Create("ixInventory", IsValid(parent) and parent or nil)
				panel:SetInventory(inventory)
				panel:ShowCloseButton(true)
				panel:SetTitle(item.GetName and item:GetName() or L(item.name))

				if (parent != ix.gui.menuInventoryContainer) then
					panel:Center()

					if (parent == ix.gui.openedStorage) then
						panel:MakePopup()
					end
				else
					panel:MoveToFront()
				end

				ix.gui["inv"..index] = panel
			else
				ErrorNoHalt("[Helix] Attempt to view an uninitialized inventory '"..index.."'\n")
			end
		end

		return false
	end,
	OnCanRun = function(item)
		return !item.noInventory and !IsValid(item.entity) and item:GetData("id") and !IsValid(ix.gui["inv" .. item:GetData("id", "")])
	end
}

-- Inventory drawing
if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end

		if item:GetData("quality", "") != "" then
			surface.SetDrawColor(quality_table[item:GetData("quality", "")]) 
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
end

function ITEM:OnInstanced()
	self:SetData("quality", self.quality)

	if self.noInventory then return end

	local inventory = ix.item.inventories[invID]

	ix.inventory.New(inventory and inventory.owner or 0, self.uniqueID, function(inv)
		local client = inv:GetOwner()

		inv.vars.isBag = self.uniqueID
		self:SetData("id", inv:GetID())

		if (IsValid(client)) then
			inv:AddReceiver(client)
		end
	end)
end

function ITEM:GetInventory()
	local index = self:GetData("id")

	if (index) then
		return ix.item.inventories[index]
	end
end

ITEM.GetInv = ITEM.GetInventory

function ITEM:RemoveOutfit(client)
	local character = client:GetCharacter()

	self:SetData("equip", false)

	if (character:GetData("oldModel" .. self.outfitCategory)) then
		character:SetModel(character:GetData("oldModel" .. self.outfitCategory))
		character:SetData("oldModel" .. self.outfitCategory, nil)
	end

	if (self.newSkin) then
		if (character:GetData("oldSkin" .. self.outfitCategory)) then
			client:SetSkin(character:GetData("oldSkin" .. self.outfitCategory))
			character:SetData("oldSkin" .. self.outfitCategory, nil)
		else
			client:SetSkin(0)
		end
	end

	for k, _ in pairs(self.bodyGroups or {}) do
		local index = client:FindBodygroupByName(k)

		if (index > -1) then
			client:SetBodygroup(index, 0)

			local groups = character:GetData("groups", {})

			if (groups[index]) then
				groups[index] = nil
				character:SetData("groups", groups)
			end
		end
	end

	-- restore the original bodygroups
	/*
	if (character:GetData("oldGroups" .. self.outfitCategory)) then
		for k, v in pairs(character:GetData("oldGroups" .. self.outfitCategory, {})) do
			client:SetBodygroup(k, v)
		end

		character:SetData("groups", character:GetData("oldGroups" .. self.outfitCategory, {}))
		character:GetData("oldGroups" .. self.outfitCategory, nil)
	end
	*/

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			character:RemoveBoost(self.uniqueID, k)
		end
	end

	for k, _ in pairs(self:GetData("outfitAttachments", {})) do
		self:RemoveAttachment(k, client)
	end

	self:OnUnequipped()
end

-- makes another outfit depend on this outfit in terms of requiring this item to be equipped in order to equip the attachment
-- also unequips the attachment if this item is dropped
function ITEM:AddAttachment(id)
	local attachments = self:GetData("outfitAttachments", {})
	attachments[id] = true

	self:SetData("outfitAttachments", attachments)
end

function ITEM:RemoveAttachment(id, client)
	local item = ix.item.instances[id]
	local attachments = self:GetData("outfitAttachments", {})

	if (item and attachments[id]) then
		item:OnDetached(client)
	end

	attachments[id] = nil
	self:SetData("outfitAttachments", attachments)
end

ITEM.postHooks.drop = function(item, result)
	local index = item:GetData("id")

	local query = mysql:Update("ix_inventories")
		query:Update("character_id", 0)
		query:Where("inventory_id", index)
	query:Execute()

	net.Start("ixBagDrop")
		net.WriteUInt(index, 32)
	net.Send(item.player)
end

if (CLIENT) then
	net.Receive("ixBagDrop", function()
		local index = net.ReadUInt(32)
		local panel = ix.gui["inv"..index]

		if (panel and panel:IsVisible()) then
			panel:Close()
		end
	end)
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:RemoveOutfit(item:GetOwner())
	end

	if (item:GetData("equip")) then
        local ply = item.player
        local item = item
        local char = ply:GetCharacter()

        item:SetData("equip", false)
        for k, v in pairs(item.bodygroup) do
            local faction = ix.faction.indices[char:GetFaction()]
            local personnalisation = char:GetPersonnalisation()
            
            if item.outfitCategory == "torso" then
                ply:SetBodygroup(1, faction.bodygroups[0][personnalisation["torso"]] or 0)
            elseif item.outfitCategory == "legs" then
                ply:SetBodygroup(2, faction.bodygroups[1][personnalisation["legs"]] or 0)
            end

            break
        end
	end
end)

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Снять",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:RemoveOutfit(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.Equip = {
	name = "Экипировать",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		local client = item.player
		local char = client:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
					client:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
					return false
				end
			end
		end

		item:SetData("equip", true)

		if (isfunction(item.OnGetReplacement)) then
			char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))
			char:SetModel(item:OnGetReplacement())
		elseif (item.replacement or item.replacements) then
			char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))

			if (istable(item.replacements)) then
				if (#item.replacements == 2 and isstring(item.replacements[1])) then
					char:SetModel(item.player:GetModel():gsub(item.replacements[1], item.replacements[2]))
				else
					for _, v in ipairs(item.replacements) do
						char:SetModel(item.player:GetModel():gsub(v[1], v[2]))
					end
				end
			else
				char:SetModel(item.replacement or item.replacements)
			end
		end

		if (item.newSkin) then
			char:SetData("oldSkin" .. item.outfitCategory, item.player:GetSkin())
			item.player:SetSkin(item.newSkin)
		end

		local groups = char:GetData("groups", {})

		--[[if (!table.IsEmpty(groups)) then
			char:SetData("oldGroups" .. item.outfitCategory, groups)

			client:ResetBodygroups()
		end]]

		if (item.bodyGroups) then
			groups = {}

			for k, value in pairs(item.bodyGroups) do
				local index = item.player:FindBodygroupByName(k)

				if (index > -1) then
					groups[index] = value
				end
			end

			local newGroups = char:GetData("groups", {})

			for index, value in pairs(groups) do
				newGroups[index] = value
				item.player:SetBodygroup(index, value)
			end

			if (!table.IsEmpty(newGroups)) then
				char:SetData("groups", newGroups)
			end
		end

		if (item.attribBoosts) then
			for k, v in pairs(item.attribBoosts) do
				char:AddBoost(item.uniqueID, k, v)
			end
		end

		item:OnEquipped()
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and item:CanEquipOutfit() and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

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

	local index = self:GetData("id")

	if (newInventory) then
		if (newInventory.vars and newInventory.vars.isBag) then
			return false
		end

		local index2 = newInventory:GetID()

		if (index == index2) then
			return false
		end

--[[		for _, v in pairs(self:GetInventory():GetItems()) do
			if (v:GetData("id") == index2) then
				return false
			end
		end]]
	end

	return !newInventory or newInventory:GetID() != oldInventory:GetID() or newInventory.vars.isBag
end

function ITEM:OnSendData()
	local index = self:GetData("id")

	if (index) then
		local inventory = ix.item.inventories[index]

		if (inventory) then
			inventory.vars.isBag = self.uniqueID
			inventory:Sync(self.player)
			inventory:AddReceiver(self.player)
		else
			local owner = self.player:GetCharacter():GetID()

			ix.inventory.Restore(self:GetData("id"), self.invWidth, self.invHeight, function(inv)
				inv.vars.isBag = self.uniqueID
				inv:SetOwner(owner, true)

				if (!inv.owner) then
					return
				end

				for client, character in ix.util.GetCharacters() do
					if (character:GetID() == inv.owner) then
						inv:AddReceiver(client)
						break
					end
				end
			end)
		end
	else
		ix.inventory.New(self.player:GetCharacter():GetID(), self.uniqueID, function(inv)
			self:SetData("id", inv:GetID())
		end)
	end
end

function ITEM:OnRemoved()
	if (self.invID != 0 and self:GetData("equip")) then
		self.player = self:GetOwner()
			self:RemoveOutfit(self.player)
		self.player = nil
	end

	local inventory = ix.item.inventories[self.invID]
	local owner = inventory.GetOwner and inventory:GetOwner()
    local index = self:GetData("id")

	if (index) then
		local query = mysql:Delete("ix_items")
			query:Where("inventory_id", index)
		query:Execute()

		query = mysql:Delete("ix_inventories")
			query:Where("inventory_id", index)
		query:Execute()
	end

	if (IsValid(owner) and owner:IsPlayer()) then
		if (self:GetData("equip")) then
            self:SetData("equip", false)
		end
	end
end

function ITEM:OnTransferred(curInv, inventory)
	local bagInventory = self:GetInventory()

	if (isfunction(curInv.GetOwner)) then
		local owner = curInv:GetOwner()

		if (IsValid(owner)) then
			bagInventory:RemoveReceiver(owner)
		end
	end

	if (isfunction(inventory.GetOwner)) then
		local owner = inventory:GetOwner()

		if (IsValid(owner)) then
			bagInventory:AddReceiver(owner)
			bagInventory:SetOwner(owner)
		end
	else
		-- it's not in a valid inventory so nobody owns this bag
		bagInventory:SetOwner(nil)
	end
end

function ITEM:OnEquipped()
end

function ITEM:OnUnequipped()
end

function ITEM:CanEquipOutfit()
	return true
end

function ITEM:OnRegistered()
	if self.noInventory then return end

	ix.inventory.Register(self.uniqueID, self.invWidth, self.invHeight, true)
end