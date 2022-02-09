local PLUGIN = PLUGIN
local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 0,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

function PLUGIN:RenderScreenspaceEffects()
    local ply = LocalPlayer()
    local char = ply:GetCharacter()

    if char then
        local AlcoholData = char:GetAlcohol()

        if AlcoholData > 0 then
            DrawMotionBlur(0.05 / AlcoholData, 1, FrameTime() * AlcoholData)
        end
    end
end