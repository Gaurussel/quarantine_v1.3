
local PLUGIN = PLUGIN

ITEM.name = "Записи"
ITEM.description = "Лабораторные записи, %s."
ITEM.price = 2
ITEM.model = Model("models/props_office/folder.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.classes = {CLASS_CWU_TORG}
ITEM.factions = {FACTION_CWU}
ITEM.bDropOnDeath = true

ITEM.category = "Laboratory"
ITEM.bAllowMultiCharacterInteraction = true

function ITEM:GetDescription()
	return self:GetData("owner", 0) == 0
		and string.format(self.description, "он весь в лохмотьях и грязи.")
		or string.format(self.description, "на нем написано..")
end

function ITEM:SetText(text, character)
	text = tostring(text):sub(1, PLUGIN.maxLength)

	self:SetData("text", text, false, false, true)
	self:SetData("owner", character and character:GetID() or 0)
end

ITEM.functions.View = {
	name = "Прочитать",
    icon = "icon16/book.png",
	OnRun = function(item)
		netstream.Start(item.player, "ixViewPaper", item:GetID(), item:GetData("text", ""), 0)
		return false
	end,

	--[[OnCanRun = function(item)
		local owner = item:GetData("owner", 0)

		return owner != 0
	end]]
}

ITEM.functions.Edit = {
	name = "Редактировать",
    icon = "icon16/book_edit.png",
	OnRun = function(item)
		netstream.Start(item.player, "ixViewPaper", item:GetID(), item:GetData("text", ""), 1)
		return false
	end,

	OnCanRun = function(item)
		local owner = item:GetData("owner", 0)

		return owner == 0 or owner == item.player:GetCharacter():GetID() and item:GetData("text", "") == ""
	end
}

ITEM.functions.take.OnCanRun = function(item)
	local owner = item:GetData("owner", 0)

	return IsValid(item.entity) and (owner == 0 or owner == item.player:GetCharacter():GetID())
end
