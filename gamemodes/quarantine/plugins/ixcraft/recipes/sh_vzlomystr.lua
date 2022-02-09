RECIPE.name = "Устройство взлома"
RECIPE.description = "Разработка одного из ученых города. Способен взломать любые электронные ключи военных сил."
RECIPE.model = "models/props_lab/reciever01d.mdl"
RECIPE.category = "Электроника"
RECIPE.requirements = {
    ["aabattery"] = 2,
    ["gasanalyser"] = 1,
    ["carbattery"] = 1,
    ["powersupplyunit"] = 1,
    ["militarycircuitboard"] = 1,
    ["lcd"] = 1,
    ["flashstorage"] = 1,
    ["militarycable"] = 1,
    ["powercord"] = 1,
    ["circuitboard"] = 1
    
}
RECIPE.results = {
	["hackdoor"] = 1,
}
RECIPE.tools = {
    "nabortools",
}
RECIPE.skills = {
	["crafter"] = 5,
}
RECIPE.fire = false