FACTION.name = "C.D.F"
FACTION.description = "gnom gay"
FACTION.isDefault = false
FACTION.color = Color(1, 50, 32)

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

FACTION.bodygroups = {
	[0] = {
		[0] = 1,
		[1] = 2,
		[2] = 5,
		[3] = 6,
	},
	[1] = {
		[0] = 0,
		[1] = 2,
	},
}

FACTION.ranks = {
	[1] = "Рядовой",
	[2] = "Рядовой 1-го класса",
	[3] = "Специалист",
	[4] = "Капрал",
	[5] = "Сержант",
	[6] = "Штаб-сержант",
	[7] = "Сержант 1-го класса",
	[8] = "Мастер-сержант",
	[9] = "Первый сержант"
}

function FACTION:OnTransferred(char)
	char:SetRank(1)
	char:SetRankXP(0)
end

FACTION_ARMY = FACTION.index
