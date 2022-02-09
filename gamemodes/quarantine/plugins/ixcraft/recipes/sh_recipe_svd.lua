RECIPE.name = "SVD"
RECIPE.description = "Самозарядная снайперская винтовка, разработанная в 1957-1963 годах группой конструкторов под руководством Евгения Драгунова и принятая на вооружение Советской Армии 3 июля 1963 года вместе с оптическим прицелом ПСО-1."
RECIPE.model = "models/weapons/w_snip_svd.mdl"
RECIPE.category = "Оружие"
RECIPE.requirements = {
	["weaponparts"] = 9;
    ["paracord"] = 2;
    ["bolts"] = 4;
    ["screwnuts"] = 3;
    ["screwpack"] = 2;
}
RECIPE.results = {
	["cw_svd_official"] = 1,
}
RECIPE.tools = {
    "nabortools",
}
RECIPE.skills = {
	["crafter"] = 9,
}
RECIPE.fire = false