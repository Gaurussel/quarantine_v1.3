local PLUGIN = PLUGIN
PLUGIN.name = "Personnalisation menu"
PLUGIN.author = "Gaurussel"
PLUGIN.description = "Edit character create menu"

ix.util.Include("sv_plugin.lua")

do
    ix.char.RegisterVar("personnalisation", {
		field = "personnalisation",
		fieldType = ix.type.text,
		default = {},
		index = 3,
		OnPostSetup = function(self, panel, payload)
		end,
		OnDisplay = function(self, container, payload)
			local faction = ix.faction.indices[payload.faction]
			if !faction.bodygroups then return end

			local personnalisation_pl = {
				["head"] = 0,
				["torso"] = 0,
				["legs"] = 0,
			}

			local panel = container:Add("DPanel")
			panel:Dock(TOP)
			panel:SetSize( 200, 110 )
			panel.Paint = function()
			end

			local face = panel:Add( "ixSettingsRowNumber" )
			face:SetText("ЛИЦО:")
			face:SetMin(0)
			face:SetZPos(1)
			face:SetMax(ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetEntity():SkinCount())
			face:SetDecimals(0)
			face:SetValue(0)
			face:Dock(TOP)
			--slider.Label:SetFont("ixMenuButtonLabelFont")
			face.OnValueChanged = function()
				personnalisation_pl["head"] = face:GetValue()
				ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetEntity():SetSkin(face:GetValue())
				ix.gui.characterMenu.newCharacterPanel.detalesModel:GetEntity():SetSkin(face:GetValue())
				ix.gui.characterMenu.newCharacterPanel.attributesModel:GetEntity():SetSkin(face:GetValue())
				payload:Set("personnalisation", personnalisation_pl)
			end

			local torso = panel:Add( "ixSettingsRowNumber" )
			torso:SetText("ТОРС:")
			torso:SetMin(0)
			torso:SetZPos(2)
			torso:SetMax(table.Count(faction.bodygroups[0]) - 1)
			torso:SetDecimals(0)
			torso:SetValue(0)
			torso:Dock(TOP)
			torso.OnValueChanged = function()
				personnalisation_pl["torso"] = torso:GetValue()
				ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetEntity():SetBodygroup(1, faction.bodygroups[0][torso:GetValue()])
				ix.gui.characterMenu.newCharacterPanel.detalesModel:GetEntity():SetBodygroup(1, faction.bodygroups[0][torso:GetValue()])
				ix.gui.characterMenu.newCharacterPanel.attributesModel:GetEntity():SetBodygroup(1, faction.bodygroups[0][torso:GetValue()])
				payload:Set("personnalisation", personnalisation_pl)
			end

			local legs = panel:Add( "ixSettingsRowNumber" )
			legs:SetText("НОГИ:")	
			legs:SetMin(0)
			legs:SetZPos(3)
			legs:SetMax(table.Count(faction.bodygroups[1]) - 1)
			legs:SetDecimals(0)
			legs:SetValue(0)
			legs:Dock(TOP)
			legs.OnValueChanged = function()
				personnalisation_pl["legs"] = legs:GetValue()
				ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetEntity():SetBodygroup(2, faction.bodygroups[1][legs:GetValue()])
				ix.gui.characterMenu.newCharacterPanel.detalesModel:GetEntity():SetBodygroup(2, faction.bodygroups[1][legs:GetValue()])
				ix.gui.characterMenu.newCharacterPanel.attributesModel:GetEntity():SetBodygroup(2, faction.bodygroups[1][legs:GetValue()])
				payload:Set("personnalisation", personnalisation_pl)
			end

			local currentModel = ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetModel()
			panel.Think = function()
				if currentModel != ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetModel() then
					currentModel = ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetModel()
					face:SetValue(0)
					face:SetMax(ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetEntity():SkinCount())

					torso:SetValue(0)
					torso:SetMax(table.Count(faction.bodygroups[0]) - 1)

					legs:SetValue(0)
					legs:SetMax(table.Count(faction.bodygroups[1]) - 1)
				end
			end

			return panel
		end,
		--[[OnAdjust = function(self, client, payload, value, newPayload)
			local faction = ix.faction.indices[data.faction]
			if (faction) then
				local currentModel = ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetEntity():GetModel()
				local currentBodyGroups = currentModel:GetBodyGroups()

			end
		end,]]
		ShouldDisplay = function(self, container, payload)
			local currentModel = ix.gui.characterMenu.newCharacterPanel.descriptionModel:GetEntity()
			local faction = ix.faction.indices[payload.faction]
			return currentModel:SkinCount() > 1 or faction.bodygroups
		end,
		alias = ""
	})

	ix.char.RegisterVar("model", {
		field = "model",
		fieldType = ix.type.string,
		default = "models/error.mdl",
		index = 4,
		OnSet = function(character, value)
			local client = character:GetPlayer()

			if (IsValid(client) and client:GetCharacter() == character) then
				client:SetModel(value)
			end

			character.vars.model = value
		end,
		OnGet = function(character, default)
			return character.vars.model or default
		end,
		OnDisplay = function(self, container, payload)
			local scroll = container:Add("DScrollPanel")
			scroll:Dock(FILL) -- TODO: don't fill so we can allow other panels
			scroll.Paint = function(panel, width, height)
				derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
			end

			local layout = scroll:Add("DIconLayout")
			layout:Dock(FILL)
			layout:SetSpaceX(1)
			layout:SetSpaceY(1)

			local faction = ix.faction.indices[payload.faction]

			if (faction) then
				local models = faction:GetModels(LocalPlayer())

				for k, v in SortedPairs(models) do
					local icon = layout:Add("SpawnIcon")
					icon:SetSize(64, 128)
					icon:InvalidateLayout(true)
					icon.DoClick = function(this)
						payload:Set("model", k)
					end
					icon.PaintOver = function(this, w, h)
						if (payload.model == k) then
							local color = ix.config.Get("color", color_white)

							surface.SetDrawColor(color.r, color.g, color.b, 200)

							for i = 1, 3 do
								local i2 = i * 2
								surface.DrawOutlinedRect(i, i, w - i2, h - i2)
							end
						end
					end

					if (isstring(v)) then
						icon:SetModel(v)
					else
						icon:SetModel(v[1], v[2] or 0, v[3])
					end
				end
			end

			return scroll
		end,
		OnValidate = function(self, value, payload, client)
			local faction = ix.faction.indices[payload.faction]

			if (faction) then
				local models = faction:GetModels(client)

				if (!payload.model or !models[payload.model]) then
					return false, "needModel"
				end
			else
				return false, "needModel"
			end
		end,
		OnAdjust = function(self, client, data, value, newData)
			local faction = ix.faction.indices[data.faction]

			if (faction) then
				local model = faction:GetModels(client)[value]

				if (isstring(model)) then
					newData.model = model
				elseif (istable(model)) then
					newData.model = model[1]

					-- save skin/bodygroups to character data
					local bodygroups = {}

					for i = 1, #model[3] do
						bodygroups[i - 1] = tonumber(model[3][i]) or 0
					end

					newData.data = newData.data or {}
					newData.data.skin = model[2] or 0
					newData.data.groups = bodygroups
				end
			end
		end,
		ShouldDisplay = function(self, container, payload)
			local faction = ix.faction.indices[payload.faction]
			return #faction:GetModels(LocalPlayer()) > 1
		end
	})
end