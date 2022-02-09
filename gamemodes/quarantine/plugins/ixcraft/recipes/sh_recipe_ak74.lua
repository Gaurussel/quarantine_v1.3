RECIPE.name = "AK-74"
RECIPE.description = "Автомат, принятый на вооружение в СССР в 1949 году. Был сконструирован в 1947 году М. Т. Калашниковым. АК и его модификации являются самым распространённым стрелковым оружием в мире."
RECIPE.model = "models/weapons/w_rif_ak47.mdl"
RECIPE.category = "Оружие"
RECIPE.requirements = {
	["weaponparts"] = 6;
    ["paracord"] = 2;
    ["bolts"] = 3;
    ["screwnuts"] = 2;
    ["screwpack"] = 3;
}
RECIPE.results = {
	["cw_ak74"] = 1,
}
RECIPE.tools = {
    "nabortools",
}
RECIPE.skills = {
	["crafter"] = 13,
}
RECIPE.fire = false