RECIPE.name = "Стационарное радио"
RECIPE.description = "Радио, которое позволяет слушать других людей на расстоянии"
RECIPE.model = "models/props_lab/citizenradio.mdl"
RECIPE.category = "Электроника"
RECIPE.requirements = {
    ["carbattery"] = 1,
    ["powersupplyunit"] = 1,
    ["graphicscard"] = 1, 
    ["gasanalyser"] = 2,
    ["capacitors"] = 3,
    ["lightbulb"] = 1,
    ["wires"] = 2,
    ["powercord"] = 1,
    ["lcdbroken"] = 1,
    ["gphone"] = 1,
    ["circuitboard"] = 1
    
}
RECIPE.results = {
	["sradio"] = 1,
}
RECIPE.tools = {
    "nabortools",
}
RECIPE.skills = {
	["crafter"] = 4,
}
RECIPE.fire = false