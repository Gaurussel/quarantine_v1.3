ix.config.Add("factionXP", 5, "Сколько очков будет начислятся за охрану территории фракции?", nil, {
	data = {min = 0, max = 50},
	category = PLUGIN.name
})

ix.config.Add("factionXPGain", 300, "Как часто будут даваться очки?", nil, {
	data = {min = 0, max = 3000},
	category = PLUGIN.name
})