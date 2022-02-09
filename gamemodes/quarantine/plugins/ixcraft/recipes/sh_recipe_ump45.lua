RECIPE.name = "UMP-45"
RECIPE.description = "Пистолет-пулемёт, разработанный немецкой компанией Heckler & Koch в 1990-х годах в качестве дополнения к семейству пистолетов-пулемётов HK MP5. Устройство нового оружия было упрощено, но вместе с тем были использованы более современные материалы."
RECIPE.model = "models/weapons/w_smg_ump45.mdl"
RECIPE.category = "Оружие"
RECIPE.requirements = {
	["weaponparts"] = 5;
    ["paracord"] = 3;
    ["insulatingtape"] = 2;
    ["screwnuts"] = 2;
    ["screwpack"] = 2;
}
RECIPE.results = {
	["cw_ump45"] = 1,
}
RECIPE.tools = {
    "nabortools",
}
RECIPE.skills = {
	["crafter"] = 3,
}
RECIPE.fire = false