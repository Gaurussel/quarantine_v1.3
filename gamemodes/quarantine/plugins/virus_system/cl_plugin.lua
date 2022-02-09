local PLUGIN = PLUGIN
local stages = PLUGIN.stages
local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

function PLUGIN:RenderScreenspaceEffects()
    local ply = LocalPlayer()

    if ply:GetCharacter() then
        local virus_data = ply:GetCharacter():GetData("Virus", 0)

        if virus_data == 3 then
            tab["$pp_colour_contrast"] = 1
            DrawColorModify( tab ) 
            DrawSobel( 0.5 ) 
        elseif virus_data == 4 then
            tab["$pp_colour_contrast"] = 1.5
            tab["$pp_colour_mulr"] = 10
            DrawColorModify( tab ) 
            DrawSobel( 0.5 )
        elseif virus_data == 5 then
            tab["$pp_colour_contrast"] = 1
            tab["$pp_colour_colour"] = 1
            tab["$pp_colour_mulr"] = 1
            DrawColorModify( tab ) 
            DrawSobel( 0.8 )
        end
    end
end