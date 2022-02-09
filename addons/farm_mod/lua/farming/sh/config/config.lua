---------------------------------------------------------------------------------
---------------------------Do not edit below here--------------------------------
---------------------------------------------------------------------------------
fastfarm2 = {}
fastfarm2.GrassMaterials  = {}
---------------------------------------------------------------------------------
---------------------------------Force Download----------------------------------
---------------------------------------------------------------------------------

-- If enabled it will use resource.addfile, if not workshop.
fastfarm2.EnableResourceAddfile = true

---------------------------------------------------------------------------------
-----------------------------------Hungermod------------------------------------
---------------------------------------------------------------------------------

-- If hungermod is enabled, set this to true.
 fastfarm2.EnableHungermod = false
 
---------------------------------------------------------------------------------
----------------------------------Crop Prices------------------------------------
---------------------------------------------------------------------------------

-- Price of a single corn.
fastfarm2.CornPrice = 1000
-- Price of a single Tomato.
fastfarm2.TomatoPrice = 1000
-- Price of a single Cabage.
fastfarm2.CabagePrice = 3000
-- Price of a single Carrot.
fastfarm2.CarrotPrice = 1000
-- Price of a single Wheat.
fastfarm2.WheatPrice = 1000

---------------------------------------------------------------------------------
--------------------------------Crop Growtime------------------------------------
---------------------------------------------------------------------------------

-- Growtime for the Corn plant.
fastfarm2.CornGrowTime = 5
-- Growtime for the Tomato plant.
fastfarm2.TomatoGrowTime = 5
-- Growtime for the Cabage plant.
fastfarm2.CabageGrowTime = 5
-- Growtime for the Carrot plant.
fastfarm2.CarrotGrowTime = 5
-- Growtime for the Wheat plant.
fastfarm2.WheatGrowTime = 5

---------------------------------------------------------------------------------
-----------------------------------Main Config------------------------------------
---------------------------------------------------------------------------------

-- The Size of the dirt hole you dig with the shovel.
fastfarm2.DirtSize = 0.25
-- The start size of the plant, when you add a seed to the dirt.
fastfarm2.PlantStartSize = 0.10
-- The collision group of the plant, if you don't know what this is, then leave it alone.
fastfarm2.PlantCollisionGroup = 11

---------------------------------------------------------------------------------
-----------------------------------NPC Config------------------------------------
---------------------------------------------------------------------------------

-- The model of the npc.
fastfarm2.NpcModel = "models/gman_high.mdl"
-- How far away can the dealer purchase your crates from.
fastfarm2.NpcSellDistance = 250

---------------------------------------------------------------------------------
---------------------------------Grass Config------------------------------------
---------------------------------------------------------------------------------

-- To get a grass material on the map, take out the shovel as superadmin & right click on the grass you found. (then add to the list below)
fastfarm2.GrassMaterials = {
	["CS_HAVANA/GROUND01GRASS"] = true,
	["DE_TRAIN/TRAIN_GRASS_FLOOR_01"] = true,
	["NATURE/GRASSFLOOR002A"] = true,	
	["NATURE/BLENDGRASSGRAVEL001A"] = true,
	["BLEND/BLEND_CONF_DIRTGRAS"] = true,
}

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------