local PLUGIN = PLUGIN

function PLUGIN:RenderScreenspaceEffects()
    local ply = LocalPlayer()
    local character = ply:GetCharacter()

    if IsValid(ply) and character then
        for k, v in pairs(character:GetInventory():GetItems()) do
            if v:GetData("protectgas", false) and v:GetData("equip", false) then
                DrawMaterialOverlay("jessev92/ui/overlays/mask_gas01", 1)
            end
        end
    end
end