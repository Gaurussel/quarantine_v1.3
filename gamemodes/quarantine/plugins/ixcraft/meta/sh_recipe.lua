
local PLUGIN = PLUGIN
PLUGIN.meta = PLUGIN.meta or {}

local RECIPE = PLUGIN.meta.recipe or {}
RECIPE.__index = RECIPE
RECIPE.name = "undefined"
RECIPE.description = "undefined"
RECIPE.uniqueID = "undefined"
RECIPE.category = "Крафтинг"

function RECIPE:GetName()
	return self.name
end

function RECIPE:GetDescription()
	return self.description
end

function RECIPE:GetSkin()
	return self.skin
end

function RECIPE:GetModel()
	return self.model
end

function RECIPE:PreHook(name, func)
	if (!self.preHooks) then
		self.preHooks = {}
	end

	self.preHooks[name] = func
end

function RECIPE:PostHook(name, func)
	if (!self.postHooks) then
		self.postHooks = {}
	end

	self.postHooks[name] = func
end

function RECIPE:OnCanSee(client)
	local character = client:GetCharacter()

	if (!character) then
		return false
	end

	if self.skills then
		for k, v in pairs(self.skills) do
			if character:GetAttribute(k, 0) <= 0 then
				return false
			end
		end
	end

	if (self.preHooks and self.preHooks["OnCanSee"]) then
		local a, b, c, d, e, f = self.preHooks["OnCanSee"](self, client)

		if (a != nil) then
			return a, b, c, d, e, f
		end
	end

	if (self.flag and !character:HasFlags(self.flag)) then
		return false
	end

	if (self.postHooks and self.postHooks["OnCanSee"]) then
		local a, b, c, d, e, f = self.postHooks["OnCanSee"](self, client)

		if (a != nil) then
			return a, b, c, d, e, f
		end
	end

	return true
end

function RECIPE:OnCanCraft(client)
	local character = client:GetCharacter()

	if (!character) then
		return false
	end

	if (self.preHooks and self.preHooks["OnCanCraft"]) then
		local a, b, c, d, e, f = self.preHooks["OnCanCraft"](self, client)

		if (a != nil) then
			return a, b, c, d, e, f
		end
	end

	local inventory = character:GetInventory()
	local bHasItems, bHasTools, bHasSkills
	local missing = ""

	if (self.flag and !character:HasFlags(self.flag)) then
		return false, "@CraftMissingFlag", self.flag
	end

	for uniqueID, amount in pairs(self.requirements or {}) do
		if (inventory:GetItemCount(uniqueID) < amount) then
			local itemTable = ix.item.Get(uniqueID)
			bHasItems = false

			missing = missing..(itemTable and itemTable.name or uniqueID)..", "
		end
	end


	if (missing != "") then
		missing = missing:sub(1, -3)
	end

	if (bHasItems == false) then
		return false, "@CraftMissingItem", missing
	end

	for attName, attValue in pairs(self.skills) do
		if character:GetAttribute(attName, 0) != attValue or character:GetAttribute(attName, 0) < attValue then
			bHasSkills = false

			missing = missing..(attName.." - "..attValue)..", "
		end 
	end

	for _, uniqueID in pairs(self.tools or {}) do
		if (!inventory:HasItem(uniqueID)) then
			local itemTable = ix.item.Get(uniqueID)
			bHasTools = false

			missing = itemTable and itemTable.name or uniqueID

			break
		end
	end

	for _, v in pairs(ents.FindInSphere(client:GetPos(), 200)) do
		if self.fire then
			if v:GetClass() == "ix_barrel" and !v:IsOnFire() then
				print(v:GetClass())
				bHasFire = false
			end
		end
	end

	if (bHasSkills == false) then
		return false, "Требуемый навык отсутствует или не достиг нужного уровня.", missing
	end

	if (bHasTools == false) then
		return false, "@CraftMissingTool", missing
	end
	
	if (bHasFire == false) then
		return false, "Отсутствует огонь.", missing
	end

	if (self.postHooks and self.postHooks["OnCanCraft"]) then
		local a, b, c, d, e, f = self.postHooks["OnCanCraft"](self, client)

		if (a != nil) then
			return a, b, c, d, e, f
		end
	end

	return true
end

local qualities = {
	"Эпическое",
	"Редкое",
	"Необычное",
	"Обычное"
}

if (SERVER) then
	function RECIPE:OnCraft(client)
		local bCanCraft, failString, c, d, e, f = self:OnCanCraft(client)

		if (bCanCraft == false) then
			return false, failString, c, d, e, f
		end

		if (self.preHooks and self.preHooks["OnCraft"]) then
			local a, b, c, d, e, f = self.preHooks["OnCraft"](self, client)

			if (a != nil) then
				return a, b, c, d, e, f
			end
		end

		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		if (self.requirements) then
			local removedItems = {}

			for _, itemTable in pairs(inventory:GetItems()) do
				local uniqueID = itemTable.uniqueID

				if (self.requirements[uniqueID]) then
					local amountRemoved = removedItems[uniqueID] or 0
					local amount = self.requirements[uniqueID]

					if (amountRemoved < amount) then
						itemTable:Remove()

						removedItems[uniqueID] = amountRemoved + 1
					end
				end
			end
		end

		--character:AddFatigue(math.random(15, 25))

		local chance = math.random(0, 87)
		local xpGive = 0

		if chance >= 85 then
			set_quality = "Эпическое"
			xpGive = 90
		elseif chance >= 79 then
			set_quality = "Редкое"
			xpGive = 75
		elseif chance >= 70 then
			set_quality = "Необычное"
			xpGive = 55
		else
			set_quality = "Обычное"
			xpGive = 30
		end

		ix.XPSystem.AddXP(client, xpGive)

		for uniqueID, amount in pairs(self.results or {}) do
			if (istable(amount)) then
				if (amount["min"] and amount["max"]) then
					amount = math.random(amount["min"], amount["max"])
				else
					amount = amount[math.random(1, #amount)]
				end
			end

			if ix.plugin.list["items_rarting_system"].item_not_quality[k] then
				set_quality = "Обычное"
			end

			for i = 1, amount do
				if !inventory:Add(uniqueID, 1, {quality = set_quality}) then
					ix.item.Spawn(uniqueID, client)
				end
			end
		end

		if (self.postHooks and self.postHooks["OnCraft"]) then
			local a, b, c, d, e, f = self.postHooks["OnCraft"](self, client)

			if (a != nil) then
				return a, b, c, d, e, f
			end
		end

		--[[if client:GetUserGroup() != "User" then
			local count, item = table.Random(self.requirements)
			inventory:Add(item, 1)
		end]]

		return true, "@CraftSuccess", self.GetName and self:GetName() or self.name
	end
end

PLUGIN.meta.recipe = RECIPE
