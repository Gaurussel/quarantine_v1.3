RECIPE.name = "M249"
RECIPE.description = "Вариант ручного пулемёта FN Minimi для армии США калибра 5,56×45 мм американского производства, серийное производство началось в 1980-х годах."
RECIPE.model = "models/weapons/w_mach_m249para.mdl"
RECIPE.category = "Оружие"
RECIPE.requirements = {
	["weaponparts"] = 9;
    ["paracord"] = 4;
    ["bolts"] = 4;
    ["screwnuts"] = 5;
    ["screwpack"] = 6;
}
RECIPE.results = {
	["cw_m249_official"] = 1,
}
RECIPE.tools = {
    "nabortools",
}
RECIPE.skills = {
	["crafter"] = 15,
}
RECIPE.fire = false