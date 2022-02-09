local PLUGIN = PLUGIN
PLUGIN.name = "Postprocessing"
PLUGIN.author = "Gaurussel"
local color = {}
color["$pp_colour_addr"] = 0
color["$pp_colour_addg"] = 0
color["$pp_colour_addb"] = 0
color["$pp_colour_brightness"] = -0.01
color["$pp_colour_contrast"] = 1.35
color["$pp_colour_colour"] = 0.65
color["$pp_colour_mulr"] = 0
color["$pp_colour_mulg"] = 0
color["$pp_colour_mulb"] = 0

ix.config.Add("postprocessing", true, "Применять функцию DrawColorModify.", nil, {
	category = "postprocessing"
})

ix.config.Add("pp_colour_brightness", -0.1, "Яркость.", function(oldValue, newValue)
	if CLIENT then
		hook.Run("ac.update", "postprocessing", "pp_colour_brightness", newValue)
	end
end, {
	category = "postprocessing",
	data = {min = -1, max = 1, decimals = 1}
})

ix.config.Add("pp_colour_contrast", 1.35, "Контраст.", function(oldValue, newValue)
	if CLIENT then
		hook.Run("ac.update", "postprocessing", "pp_colour_contrast", newValue)
	end
end, {
	category = "postprocessing",
	data = {min = 0, max = 2, decimals = 1}
})

ix.config.Add("pp_colour_colour", 0.65, "Насыщенность цвета.", function(oldValue, newValue)
	if CLIENT then
		hook.Run("ac.update", "postprocessing", "pp_colour_colour", newValue)
	end
end, {
	category = "postprocessing",
	data = {min = 0, max = 2, decimals = 1}
})

if CLIENT then
    hook.Add("ac.update", "ac.RenderScreenspaceEffects.update", function(category, param, value)
        if category == "postprocessing" then
            if color["$"..param] then
                color["$"..param] = value
            end
        end
    end)
    
    function PLUGIN:RenderScreenspaceEffects()
        if ix.config.Get("postprocessing") then
            DrawColorModify(color)
        end
    end
end