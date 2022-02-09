local PLUGIN = PLUGIN

PLUGIN.name = "Quarantine Interface"
PLUGIN.author = "Gaurussel"
PLUGIN.description = "..."

--[[PLUGIN.languages = {
    [1] = "Русский",
    [2] = "Немецкий",
    [3] = "Английский",
    [4] = "Испанский",
    [5] = "Итальянский",
    [6] = "Китайский"
}]]

local buttonMaterial = ix.util.GetMaterial("materials/menu/stroke-09.png")

PLUGIN.stories = {
    ["Путешественник"] = {desc = "Блуждание по миру с целью изучения или познавания. \n«Тот кто совершает путешествие, тот путешествует с целью».", logo = ix.util.GetMaterial("materials/traveler.png")},
    ["Иммигрант"] = {desc = "Только судьба даст путь к жизни лучше, чем переселение в Минессоту. ", logo = ix.util.GetMaterial("materials/visa.png")},
    ["Коренной житель"] = {desc = "Смельчак, знающий все о жизни города и его прошлом. Знания о прошлом, дают нам взгляд на будущее.", logo = ix.util.GetMaterial("materials/native.png")},
}

PLUGIN.eye_color = {
    [1] = "Синий",
    [2] = "Серый",
    [3] = "Зелёный",
    [4] = "Карий",
    [5] = "Голубой",
    [6] = "Буро-зелёный"
}

PLUGIN.nationals = {
    [1] = "Русский",
    [2] = "Немец",
    [3] = "Американец",
    [4] = "Испанец",
    [5] = "Итальянец",
}

PLUGIN.items = {
    ["aquamari"] = {name = "Бутылка с фильтрованной водой", points = 15},
    ["tsoup"] = {name = "Томатный суп", points = 20},
    ["radio"] = {name = "Рация", points = 35},
    ["cw_ber_usp"] = {name = "Пистолет USP", points = 100},
    ["cw_ber_uzi"] = {name = "ПМП UZI", points = 200},
    ["gasmasks"] = {name = "Противогаз", points = 50},
    ["filter"] = {name = "Фильтр", points = 15},
    ["morphine"] = {name = "Инъектор с морфином", points = 25},
    ["pistolammo"] = {name = "Пистолетные патроны", points = 25},
    ["smgammo"] = {name = "ПМП патроны", points = 25}
}

ix.util.Include("cl_hud.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

function PLUGIN:CanDrawAmmoHUD()
    return false
end

do 
    ix.char.RegisterVar("name", {
		field = "name",
		fieldType = ix.type.string,
		default = "John Doe",
		index = 1,
		OnValidate = function(self, value, payload, client)
			if (!value) then
				return false, "invalid", "name"
			end

			value = tostring(value):gsub("\r\n", ""):gsub("\n", "")
			value = string.Trim(value)

			local minLength = ix.config.Get("minNameLength", 4)
			local maxLength = ix.config.Get("maxNameLength", 32)

			if (value:utf8len() < minLength) then
				return false, "nameMinLen", minLength
			elseif (!value:find("%S")) then
				return false, "invalid", "name"
			elseif (value:gsub("%s", ""):utf8len() > maxLength) then
				return false, "nameMaxLen", maxLength
			end

			return hook.Run("GetDefaultCharacterName", client, payload.faction) or value:utf8sub(1, 70)
		end,
		OnPostSetup = function(self, panel, payload)
			local faction = ix.faction.indices[payload.faction]
			local name, disabled = hook.Run("GetDefaultCharacterName", LocalPlayer(), payload.faction)

			if (name) then
				panel:SetText(name)
				payload:Set("name", name)
			end

			if (disabled) then
				panel:SetDisabled(true)
				panel:SetEditable(false)
			end

			--panel:SetBackgroundColor(faction.color or Color(255, 255, 255, 25))
		end
	})

    ix.char.RegisterVar("description", {
        field = "description",
        fieldType = ix.type.text,
        default = "",
        index = 2,
        bNoDisplay = true,
        --[[OnValidate = function(self, value, payload)
            value = string.Trim((tostring(value):gsub("\r\n", ""):gsub("\n", "")))
            local minLength = ix.config.Get("minDescriptionLength", 16)

            if (value:utf8len() < minLength) then
                return false, "descMinLen", minLength
            elseif (!value:find("%s+") or !value:find("%S")) then
                return false, "invalid", "description"
            end

            return value
        end,
        OnPostSetup = function(self, panel, payload)
            panel:SetMultiline(true)
            panel:SetFont("ixMenuButtonFont")
            panel:SetTall(panel:GetTall() * 2 + 6) -- add another line
            panel.AllowInput = function(_, character)
                if (character == "\n" or character == "\r") then
                    return true
                end
            end
        end,]]
        alias = "Desc"
    })
    
    ix.char.RegisterVar("height", {
        field = "height",
        fieldType = ix.type.text,
		category = "detales",
        default = "",
        index = 1,
        OnDisplay = function(self, container, payload)
            local height_table = container:Add("ixSettingsRowArray")
            height_table:Dock(TOP)
            height_table:DockMargin(5, -25, 5, 5)
            height_table:SetText("РОСТ")
            height_table.setting:SetFont("ixCaptureCharSelFont")
            height_table.setting:SetValue("ВЫБЕРИТЕ")
            height_table.setting:SizeToContents()
            height_table:SizeToContents()
            payload:Set("height", "ВЫБЕРИТЕ")

            for k, v in pairs(ix.plugin.list["model_scale"].HeightTable) do
                height_table.setting:AddChoice(k, k)
            end
        
            height_table.setting.OnSelect = function(this, index, value)
                payload:Set("height", height_table:GetValue())
                print(height_table:GetValue())
            end

            return height_table, DLabel
        end,
        OnValidate = function(self, value, payload, client)
            if payload.height == "ВЫБЕРИТЕ" then
                return false, "needHeight"
            else
                return value
            end
		end
    })

    ix.char.RegisterVar("history", {
        field = "history",
        fieldType = ix.type.text,
		category = "history",
        default = "",
        index = 1,
        OnDisplay = function(self, container, payload)
            local historyPanel = container:Add("DPanel")
            --self.historyPanel:SetWide(halfWidth + padding * 2)
            historyPanel:Dock(FILL)
            historyPanel.Paint = function()
            end
            local sizeW, sizeH = 0.2, 0.5
            local w, h = 0.11, 0.05

            for k, v in pairs(PLUGIN.stories) do
                local story = historyPanel:Add("DPanel")
                story:SetPos(ScrW() * w, ScrH() * h)
                story:SetSize(ScrW() * sizeW, ScrH() * sizeH)
                story:SetWrap(true)
                story.Paint = function()
                end

                w = w + 0.25
                payload:Set("history", "")

                local image = story:Add("DPanel")
                image:Dock(TOP)
                image.Paint = function(this, width, height)
                    surface.SetDrawColor( 230, 230, 230, 255 )
                    surface.SetMaterial( v.logo )
                    surface.DrawTexturedRect( width * 0.35, height * 0.35, 128, 128 )
                end
                image:SetTall(256)
                
                local title = story:Add( "DLabel" )
                title:Dock(TOP)
                title:DockMargin(5, 5, 5, 5)
                title:SetText( k )
                title:SetFont("qTitleFont")
                title:SetContentAlignment(5)
                title:SizeToContents()

                local description = story:Add( "DLabel" )
                description:Dock(TOP)
                description:DockMargin(5, 5, 5, 5)
                description:SetText( v.desc )
                description:SetFont("qMediumLightFont")
                description:SetTall(80)
                description:SetWrap(true)
                --description:SizeToContents()

                local select = story:Add("qMenuButton")
                select:SetMaterial(buttonMaterial)
                select:SetMaterialColor(Color(0, 0, 0))
                select:SetText("Выбрать")
                select:SetContentAlignment(5)
                select:SizeToContents()
                select:Dock(BOTTOM)
                select.DoClick = function()
                    payload:Set("history", k)
                    ix.gui.characterMenu.newCharacterPanel:SetActiveSubpanel("description")
                end
                select:SizeToContents()

                story:SizeToContents()
            end

            return historyPanel
        end,
        OnValidate = function(self, value, payload, client)
            if payload.history == "" then
                return false
            else
                return value
            end
		end
    })


    ix.char.RegisterVar("language", {
        field = "language",
        fieldType = ix.type.text,
        category = "detales",
        default = "",
        index = 2, 
        OnDisplay = function(self, container, payload)
            local language_table = container:Add("ixSettingsRowArray")
            language_table:Dock(TOP)
            language_table:DockMargin(5, -45, 5, 5)
            language_table:SetText("ВТОРОЙ ЯЗЫК")
            language_table.setting:SetValue("ВЫБЕРИТЕ")
            language_table.setting:SizeToContents()
            language_table:SizeToContents()
            payload:Set("language", "ВЫБЕРИТЕ")

            for k, v in pairs(ix.RPLanguages:GetAll()) do
                language_table.setting:AddChoice(v.name, k)
            end
        
            language_table.setting.OnSelect = function(this, index, value)
                payload:Set("language", language_table:GetValue())
                language_table.setting:SizeToContents()
            end

            return language_table
        end,
        OnValidate = function(self, value, payload, client)
            if payload.language == "ВЫБЕРИТЕ" then
                return false, "needLanguage"
            else
                return value
            end
		end
    })

    ix.char.RegisterVar("eye_color", {
        field = "eye_color",
        fieldType = ix.type.text,
        category = "detales",
        default = "",
        index = 3, 
        OnDisplay = function(self, container, payload)
            local eye_table = container:Add("ixSettingsRowArray")
            eye_table:Dock(TOP)
            eye_table:DockMargin(5, -45, 5, 5)
            eye_table:SetText("ЦВЕТ ГЛАЗ")
            eye_table.setting:SetValue("ВЫБЕРИТЕ")
            eye_table.setting:SizeToContents()
            eye_table:SizeToContents()
            payload:Set("eye_color", "ВЫБЕРИТЕ")

            for k, v in pairs(PLUGIN.eye_color) do
                eye_table.setting:AddChoice(v, v)
            end
        
            eye_table.setting.OnSelect = function(this, index, value)
                payload:Set("eye_color", eye_table:GetValue())
                eye_table.setting:SizeToContents()
            end

            return eye_table
        end,
        OnValidate = function(self, value, payload, client)
            if payload.eye_color == "ВЫБЕРИТЕ" then
                return false, "needEye_Color"
            else
                return value
            end
		end
    })

    ix.char.RegisterVar("national", {
        field = "national",
        fieldType = ix.type.text,
        category = "detales",
        default = "",
        index = 4, 
        OnDisplay = function(self, container, payload)
            local national_table = container:Add("ixSettingsRowArray")
            national_table:Dock(TOP)
            national_table:DockMargin(5, -45, 5, 5)
            national_table:SetText("НАЦИОНАЛЬНОСТЬ")
            national_table.setting:SetValue("ВЫБЕРИТЕ")
            national_table.setting:SizeToContents()
            national_table:SizeToContents()
            payload:Set("national", "ВЫБЕРИТЕ")

            for k, v in pairs(PLUGIN.nationals) do
                national_table.setting:AddChoice(v, v)
            end
        
            national_table.setting.OnSelect = function(this, index, value)
                payload:Set("national", national_table:GetValue())
                national_table.setting:SizeToContents()
            end

            return national_table
        end,
        OnValidate = function(self, value, payload, client)
            if payload.national == "ВЫБЕРИТЕ" then
                return false, "needNational"
            else
                return value
            end
		end
    })

    ix.char.RegisterVar("strItems", {
        field = "strItems",
        fieldType = ix.type.text,
        category = "detales",
        default = {},
        index = 5,
        isLocal = true,
        OnDisplay = function(self, container, payload)
            local max_points = 300

            local dpanel1 = container:Add("DPanel")
            dpanel1:Dock(TOP)
            dpanel1:SetZPos(999)
            dpanel1:SetTall(2)
            dpanel1:DockMargin(5, 0, 5, 0)
            dpanel1.Paint = function(this, w, h)
                surface.SetDrawColor(ix.config.Get("color"))
                surface.DrawRect(0, 0, w, h)
            end

            local strPanel = container:Add("DPanel")
            strPanel:Dock(FILL)
            strPanel:DockMargin(5, 45, 5, 0)
            strPanel:SizeToContents()
            strPanel.Paint = function(this, w, h)
            end
            strPanel.OnRemove = function()
                dpanel1:Remove()
            end

            local text = strPanel:Add( "DLabel" )
            text:Dock(TOP)
            text:DockMargin(5, 5, 5, 0)
            text:SetText( "Начальные предметы ("..max_points.."):" )
            text:SetFont("ixMainMenuFont")
            text:SizeToContents()
            text:SetContentAlignment(5)

            local DScrollPanel = strPanel:Add("DScrollPanel")
                DScrollPanel:Dock(FILL)
                DScrollPanel.Paint = function()
            end

            payload.strItems = {}

            for k, v in SortedPairsByMemberValue(PLUGIN.items, name) do
                local item = DScrollPanel:Add("ixSettingsRowBool")
                item:Dock(TOP)
                item:DockMargin(5, 5, 5, 0)
                item:SetText(v.name.." ("..v.points.." очков)")
                item.OnValueChanged = function(num)
                    if item:GetValue() then
                        if (max_points - v.points) >= 0 then
                            max_points = max_points - v.points
                            payload.strItems[k] = true
                        else
                            item:SetValue(false)
                        end
                    else
                        max_points = max_points + v.points
                        payload.strItems[k] = nil
                    end
                    text:SetText( "Начальные предметы ("..max_points.."):" )
                end
            end

            return strPanel
        end
        --[[OnValidate = function(self, value, payload, client)
            if payload.strItems == {} then
                return false, "needstrItems"
            else
                return true
            end
		end]]
    })

    ix.char.RegisterVar("attributes", {
        field = "attributes",
        fieldType = ix.type.text,
        default = {},
        index = 4,
        category = "attributes",
        isLocal = true,
        OnDisplay = function(self, container, payload)
            local maximum = hook.Run("GetDefaultAttributePoints", LocalPlayer(), payload) or 10

            if (maximum < 1) then
                return
            end

            local attributes = container:Add("DPanel")
            attributes:Dock(TOP)

            local y
            local total = 0

            payload.attributes = {}

            -- total spendable attribute points
            local totalBar = attributes:Add("ixAttributeBar")
            totalBar:SetMax(maximum)
            totalBar:SetValue(maximum)
            totalBar:Dock(TOP)
            totalBar:DockMargin(2, 2, 2, 2)
            totalBar:SetText(L("attribPointsLeft"))
            totalBar:SetReadOnly(true)
            totalBar:SetColor(Color(20, 120, 20, 255))

            y = totalBar:GetTall() + 4

            for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
                payload.attributes[k] = 0
                if v.special then continue end

                local bar = attributes:Add("ixAttributeBar")
                bar:SetMax(maximum)
                bar:Dock(TOP)
                bar:DockMargin(2, 2, 2, 2)
                bar:SetText(L(v.name))
                bar.OnChanged = function(this, difference)
                    if ((total + difference) > maximum) then
                        return false
                    end

                    total = total + difference
                    payload.attributes[k] = payload.attributes[k] + difference

                    totalBar:SetValue(totalBar.value - difference)
                end

                if (v.noStartBonus) then
                    bar:SetReadOnly()
                end

                y = y + bar:GetTall() + 4
            end

            attributes:SetTall(y)
            return attributes
        end,
        OnValidate = function(self, value, data, client)
            if (value != nil) then
                if (istable(value)) then
                    local count = 0

                    for _, v in pairs(value) do
                        count = count + v
                    end

                    local maximum = (hook.Run("GetDefaultAttributePoints", client, count) or 10)
                    maximum = maximum + 1
                    if (count > maximum) then
                        return false, "unknownError"
                    end
                else
                    return false, "unknownError"
                end
            end
        end,
        ShouldDisplay = function(self, container, payload)
            return !table.IsEmpty(ix.attributes.list)
        end
    })

        ix.char.RegisterVar("SpecialAttribute", {
        field = "attributes",
        fieldType = ix.type.text,
        default = {},
        index = 5,
        category = "attributes",
        isLocal = true,
        OnDisplay = function(self, container, payload)
            local maximum = 1

            if (maximum < 1) then
                return
            end

            local SPattributes = container:Add("DPanel")
            SPattributes:Dock(TOP)

            local y
            local total = 0

            payload.SPattributes = {}

            -- total spendable attribute points
            local totalBar = SPattributes:Add("ixAttributeBar")
            totalBar:SetMax(maximum)
            totalBar:SetValue(maximum)
            totalBar:Dock(TOP)
            totalBar:DockMargin(2, 2, 2, 2)
            totalBar:SetText(L("attribPointsLeft"))
            totalBar:SetReadOnly(true)
            totalBar:SetColor(Color(20, 120, 20, 255))

            y = totalBar:GetTall() + 4

            for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
                payload.SPattributes[k] = 0
                if !v.special then continue end

                local bar = SPattributes:Add("ixAttributeBar")
                bar:SetMax(maximum)
                bar:Dock(TOP)
                bar:DockMargin(2, 2, 2, 2)
                bar:SetText(L(v.name))
                bar.OnChanged = function(this, difference)
                    if ((total + difference) > maximum) then
                        return false
                    end

                    total = total + difference
                    payload.attributes[k] = payload.attributes[k] + difference

                    totalBar:SetValue(totalBar.value - difference)
                end

                if (v.noStartBonus) then
                    bar:SetReadOnly()
                end

                y = y + bar:GetTall() + 4
            end

            SPattributes:SetTall(y)
            return SPattributes
        end,
        OnValidate = function(self, value, data, client)
            if (value != nil) then
                if (istable(value)) then
                    local count = 0

                    for _, v in pairs(value) do
                        count = count + v
                    end

                    local maximum = (hook.Run("GetDefaultAttributePoints", client, count) or 10)
                    maximum = maximum + 1
                    if (count > maximum) then
                        return false, "unknownError"
                    end
                else
                    return false, "unknownError"
                end
            end
        end
    })
end

concommand.Add("getattributes", function( )
    PrintTable(ix.attributes.list)
end)
