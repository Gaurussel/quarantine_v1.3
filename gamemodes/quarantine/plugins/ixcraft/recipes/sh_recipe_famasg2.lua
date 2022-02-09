RECIPE.name = "FAMAS G2"
RECIPE.description = "Штурмовая винтовка разработки оружейного предприятия MAS в Сент-Этьене, французский автомат калибра 5,56 мм, имеющий компоновку «булл-пап». Неофициальное название — «клерон»."
RECIPE.model = "models/weapons/w_rif_famas.mdl"
RECIPE.category = "Оружие"
RECIPE.requirements = {
	["weaponparts"] = 4;
    ["paracord"] = 3;
    ["bolts"] = 2;
    ["screwnuts"] = 1;
    ["screwpack"] = 1;
}
RECIPE.results = {
	["cw_famasg2_official"] = 1,
}
RECIPE.tools = {
    "nabortools",
}
RECIPE.skills = {
	["crafter"] = 4,
}
RECIPE.fire = false