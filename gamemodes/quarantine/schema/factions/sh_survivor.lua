FACTION.name = "Выживший"
FACTION.description = "Люди, оставшиеся в живых."
FACTION.isDefault = true
FACTION.color = Color(128, 128, 128)

FACTION.models = {
	"models/infection/female_01.mdl",
	"models/infection/female_02.mdl",
	"models/infection/female_03.mdl",
	"models/infection/female_04.mdl",
	"models/infection/female_06.mdl",
	"models/infection/female_07.mdl",
	"models/infection/male_01.mdl",
	"models/infection/male_02.mdl",
	"models/infection/male_03.mdl",
	"models/infection/male_04.mdl",
	"models/infection/male_05.mdl",
	"models/infection/male_06.mdl",
	"models/infection/male_07.mdl",
	"models/infection/male_08.mdl",
	"models/infection/male_09.mdl",
}

--[[function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
	inventory:Add("pistol")
end]]

FACTION.bodygroups = {
	[0] = {
		[0] = 0,
		[1] = 1,
		[2] = 3,
		[3] = 4,
	},
	[1] = {
		[0] = 0,
		[1] = 1,
	},
}

FACTION_SURV = FACTION.index
