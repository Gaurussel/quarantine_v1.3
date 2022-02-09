
local PLUGIN = PLUGIN

ix.config.Add("maxXPgain", 5, "Очки начисляются при игре на сервере", nil, {
	data = {min = 0, max = 50},
	category = PLUGIN.name
})

ix.config.Add("maxXPKill", 5, "Сколько очков будет дано за убийство игрока", nil, {
	data = {min = 0, max = 30},
	category = PLUGIN.name
})

ix.config.Add("maxXPKilled", 5, "Сколько очков будет дано за смерть игрока", nil, {
	data = {min = 0, max = 30},
	category = PLUGIN.name
})

ix.config.Add("XPgainEnabled", true, "Будет ли включена система автоматической выдачи XP?.", nil, {
	category = PLUGIN.name
})