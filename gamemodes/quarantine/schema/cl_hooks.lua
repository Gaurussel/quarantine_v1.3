function Schema:PopulateCharacterInfo(client, character, tooltip)
	if (client:IsRestricted()) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText("Этот человек находится в наручниках")
		panel:SizeToContents()
	end
end

function Schema:CanPlayerJoinClass(client, class, info)
	return false
end

local gasmaskOverlay = ix.util.GetMaterial("jessev92/ui/overlays/mask_gas01")
local scannerFirstPerson = false

-- local ColorModify_Menu = {
--     [ "$pp_colour_addr" ] = 0,
--     [ "$pp_colour_addg" ] = 0,
--     [ "$pp_colour_addb" ] = 0,
--     [ "$pp_colour_brightness" ] = 0,
--     [ "$pp_colour_contrast" ] = 1,
--     [ "$pp_colour_colour" ] = 0,
--     [ "$pp_colour_mulr" ] = 0,
--     [ "$pp_colour_mulg" ] = 0,
--     [ "$pp_colour_mulb" ] = 0
-- }

function Schema:RenderScreenspaceEffects()
	local ply = LocalPlayer()
	if ply:GetCharacter() then

		-- if ix.gui.menu then
		-- 	if ix.gui.menu:IsVisible() then  
		-- 		DrawColorModify( ColorModify_Menu ) 
		-- 		DrawSobel( 0.8 )
		-- 	end
		-- end
	
		-- if ix.gui.crafting then
		-- 	if ix.gui.crafting:IsVisible() then
		-- 		DrawColorModify( ColorModify_Menu ) 
		-- 		DrawSobel( 0.8 )
		-- 	end
		-- end
	
		-- if ix.gui.buyMenu then
		-- 	if ix.gui.buyMenu:IsVisible() then
		-- 		DrawColorModify( ColorModify_Menu ) 
		-- 		DrawSobel( 0.8 )
		-- 	end
		-- end
	
		-- if ix.gui.business then
		-- 	if ix.gui.business:IsVisible() then
		-- 		DrawColorModify( ColorModify_Menu ) 
		-- 		DrawSobel( 0.8 )
		-- 	end
		-- end
	
		-- if ix.gui.recorder then
		-- 	if ix.gui.recorder:IsVisible() then
		-- 		DrawColorModify( ColorModify_Menu ) 
		-- 		DrawSobel( 0.8 )
		-- 	end
		-- end

		-- if ix.gui.characterMenu then
		-- 	if ix.gui.characterMenu:IsVisible() then
		-- 		DrawColorModify( ColorModify_Menu ) 
		-- 		DrawSobel( 0.8 )
		-- 	end
		-- end

		-- if ix.gui.missions then
		-- 	if ix.gui.missions:IsVisible() then
		-- 		DrawColorModify( ColorModify_Menu ) 
		-- 		DrawSobel( 0.8 )
		-- 	end
		-- end

		-- if LocalPlayer():GetLocalVar("firstSpawnMenu", false) then
		-- 	DrawColorModify( ColorModify_Menu ) 
		-- 	DrawSobel( 0.8 )
		-- end

		for k, v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems()) do
			if v.uniqueID == "gasmask" and v:GetData("equip", false) then
				render.UpdateScreenEffectTexture()

				combineOverlay:SetFloat("$alpha", 0.5)
				combineOverlay:SetInt("$ignorez", 1)

				render.SetMaterial(gasmaskOverlay)
				render.DrawScreenQuad()
			end
		end
	end
end

function Schema:HUDPaintBackground()
	local client = LocalPlayer()
	if client:GetNetVar("tied", false) then
		ix.util.DrawText("Вы были связаны", ScrW() * 0.5, ScrH() * 0.33, nil, 1, 1, "ixCaptureTitleFont")
	end
end