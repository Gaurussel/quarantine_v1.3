
local PLUGIN = PLUGIN

PLUGIN.name = "Better Crafting"
PLUGIN.author = "wowm0d"
PLUGIN.description = "Adds a better crafting solution to helix."

ix.util.Include("cl_hooks.lua", "client")
ix.util.Include("sh_hooks.lua", "shared")

ix.util.Include("meta/sh_recipe.lua", "shared")
ix.util.Include("meta/sh_station.lua", "shared")


netstream.Hook("Crafting.OpenMenu", function()
	vgui.Create("ixCrafting")
end)
