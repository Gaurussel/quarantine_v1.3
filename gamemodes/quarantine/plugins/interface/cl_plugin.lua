local PLUGIN = PLUGIN
local buttonMaterial = Material("materials/menu/stroke-07.png")
local backgroundMaterial = Material("materials/menu/canvas-3.png")

netstream.Hook("interface.OpenWheel", function(entity)
	if ix.gui.wheel then
		if ix.gui.wheel:IsVisible() then
			return 
		end
	end

    local ply = LocalPlayer()
    local fWheelSize = ScrH() * 0.6

	local dPanel = vgui.Create( "qButtonWheel" )
	dPanel:SetPos( ScrW() / 2, ScrH() / 2 )
	dPanel:SetWheelSize( fWheelSize )
	dPanel:SetFontSize( ScreenScale( 9 ) )
	dPanel:SetFontName( "qMediumLightFont" )
	dPanel:MakePopup()
	dPanel:MoveTo( ( ScrW() - fWheelSize  ) / 2, ( ScrH() - fWheelSize  ) / 2,  0.4 )
    
    dPanel:AddButton("Представиться", function( dPanel )
        if entity:IsValid() and entity:IsPlayer() then
            netstream.Start("interface.WheelFunctions", entity:GetCharacter(), 2, entity:GetCharacter())
            dPanel:Remove()
        end
    end, false )

    if entity:IsValid() and entity:IsPlayer() and entity:IsRestricted() then
        dPanel:AddButton("Обыскать", function( dPanel )
            netstream.Start("interface.WheelFunctions", entity:GetCharacter(), 3, entity:GetCharacter())
            dPanel:Remove()
        end, false )
    end

    dPanel:AddButton("Передать деньги", function( dPanel )
        local moneyPanel = vgui.Create( "DPanel" )
        moneyPanel:MakePopup()
        moneyPanel:SetSize( ScrW() * 0.2, ScrH() * 0.11 )
        moneyPanel:Center()
        moneyPanel.Paint = function(this, width, height)
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawRect(0, 0, width, height)
        
            surface.SetDrawColor(25, 25, 25, 200)
            surface.SetMaterial(backgroundMaterial) 
            surface.DrawTexturedRect(0, 0, width - 5, height - 5)
        
            surface.SetDrawColor(200, 200, 200, 255)
            surface.DrawOutlinedRect( 0, 0, width, height, 10 )
        end

        local moneyEntry = vgui.Create("DNumberWang", moneyPanel)
        moneyEntry:SetMin(0)
        moneyEntry:SetMax(100)
        moneyEntry:Dock(TOP)
        moneyEntry:DockMargin(15, 15, 15, 0)

        local moneyGive = vgui.Create("qMenuButton", moneyPanel)
        moneyGive:SetMaterial(buttonMaterial)
        moneyGive:SetText("Передать")
        moneyGive:SetMaterialColor(Color(0, 0, 0, 255))
        moneyGive:SizeToContents()
        moneyGive:Dock(LEFT)
        moneyGive:SetFont("qMediumFont")
        moneyGive.DoClick = function(this)
            local numbers = moneyEntry:GetValue()

            if numbers <= 0 then
                ply:Notify("Число меньше и ровно нулю!")
                return
            end

            if entity:IsValid() and entity:GetCharacter() then
                netstream.Start("interface.WheelFunctions", entity:GetCharacter(), 1, numbers)
            end
        end

        local moneyClose = vgui.Create("qMenuButton", moneyPanel)
        moneyClose:SetMaterial(buttonMaterial)
        moneyClose:SetText("Закрыть")
        moneyClose:SetMaterialColor(Color(0, 0, 0, 255))
        moneyClose:Dock(RIGHT)
        moneyClose:SizeToContents()
        moneyClose:SetFont("qMediumFont")
        moneyClose.DoClick = function()
            moneyPanel:Remove()
        end

        dPanel:Remove()
    end, false )
end)

function PLUGIN:PlayerButtonDown(ply, iKey)
    if iKey == KEY_O then
        if ix.gui.wheel then
            if ix.gui.wheel:IsVisible() then
                return 
            end
        end
    
        local fWheelSize = ScrH() * 0.6
    
        local dPanel = vgui.Create( "qButtonWheel" )
        dPanel:SetPos( ScrW() / 2, ScrH() / 2 )
        dPanel:SetWheelSize( fWheelSize )
        dPanel:SetFontSize( ScreenScale( 9 ) )
        dPanel:SetFontName( "qMediumLightFont" )
        dPanel:MakePopup()
        dPanel:MoveTo( ( ScrW() - fWheelSize  ) / 2, ( ScrH() - fWheelSize  ) / 2,  0.4 )

        dPanel:AddButton("Действия", function( dPanel )
            dPanel:ClearButtons()

            for k, v in pairs(ix.act.stored) do
                dPanel:AddButton(k, function( dPanel )
                    netstream.Start("interface.WheelFunctions2", k, 1)
                    dPanel:Remove()
                end, false )
            end
        end, false )

        dPanel:AddButton("Медицина", function( dPanel )
            dPanel:ClearButtons()

            dPanel:AddButton("Использовать «бинт»", function( dPanel )
                netstream.Start("interface.WheelFunctions2", "bandage", 2)
                dPanel:Remove()
            end, false)

            dPanel:AddButton("Использовать «гипс на правую ногу»", function( dPanel )
                netstream.Start("interface.WheelFunctions2", "drug_right_leg", 2)
                dPanel:Remove()
            end, false)

            dPanel:AddButton("Использовать «гипс на левую ногу»", function( dPanel )
                netstream.Start("interface.WheelFunctions2", "drug_left_leg", 2)
                dPanel:Remove()
            end, false)

            dPanel:AddButton("Использовать «гипс на правую руку»", function( dPanel )
                netstream.Start("interface.WheelFunctions2", "drug_right_arm", 2)
                dPanel:Remove()
            end, false)

            dPanel:AddButton("Использовать «гипс на левую руку»", function( dPanel )
                netstream.Start("interface.WheelFunctions2", "drug_left_arm", 2)
                dPanel:Remove()
            end, false)

            dPanel:AddButton("Использовать «морфин»", function( dPanel )
                netstream.Start("interface.WheelFunctions2", "syringe_morphine", 2)
                dPanel:Remove()
            end, false)
        end, false )
    end
end

local information_texts = {
    [1] = {
        title = "Режим карантина",
        textOne = "Уважаемый игрок, от всего сердца просим прочитать данную информацию. На сервере имеются две фракции – выживший и C.D.F. В каждой из них свои законы и правила.",
        textTwo = "Выживший – вы полностью свободны в этом городе. Дебоширьте, устраивайте засады, убивайте всех, кого увидите на пути. Но также, есть вторая сторона медали, не исключается в полном праве подружиться с проверенными личностями и создать целый отряд. И не забудь пристегнуть противогаз, слишком опасно находится в большой компании людей.",
        textThree = "C.D.F. – военнообязанные люди. Есть свои законы, типичны армии. Основные задачи - охранять военный штат, выполнять миссии, исполнять приказы вышестоящих чинов. Это краткое описание, не имеющее спойлеров к сути геймплея и RP. Остальные детали следует узнать, как только возьмете данную фракцию.",
    },
    [2] = {
        title = "«Лут»",
        textOne = "По всей карте разбросаны вещи, которые могут помочь вам. Имеется большое количество разного качества предметы, начиная от обычного, заканчивая легендарным. Каждый предмет имеет качество, кроме вместилищ. Также, данные вещи можно подобрать с метрового человека.",
    },
    [3] = {
        title = "«Крафт»",
        textOne = "Обычная функция сервера, для создания вещей, вашего выживания. Абсолютно идентично с «лутом», может выпасть случайное качество оружия при его создании.",
    },
    [4] = {
        title = "«NPC-квесты»",
        textOne = "Не трудно найти данного представителя, создающий цепочки заданий. Он может просто с вами поговорить или дать подсказку, где найти хороший «лут», а также создать для вас задание, разгадать тайну военных сил и тому подобное. Все задания, выданные им, имеют ценную награду.",
    },
    [5] = {
        title = "«Вирус»",
        textOne = "Невозможно полностью вылечиться. Существуют препараты, возможно которые, понизят вашу стадию заражения. Стадии всего четыре, на каждой из которых, вы чувствуете себя хуже, начиная с начальной стадии.",
    }
}

netstream.Hook("interface.AcceptMenu", function()
    local ply = LocalPlayer()
    local time = 30
    local configColor = ix.config.Get("color")

    local DPanel = vgui.Create( "DPanel" )
    --DPanel:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
    DPanel:MakePopup()
    DPanel:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
    DPanel:Center()
    DPanel.Paint = function(this, width, height)
        surface.SetDrawColor(30, 30, 30, 230)
        surface.DrawRect(0, 0, width, height)

        ix.util.DrawBlur(this)
        
        surface.SetDrawColor(configColor.r, configColor.g, configColor.b)
        surface.DrawOutlinedRect( 0, 0, width, height, 1 )
    end

    local DPanel2 = vgui.Create( "DScrollPanel", DPanel )
    DPanel2:Dock(FILL)
    DPanel2:DockMargin(5, 5, 5, 5)
    DPanel2.Paint = function()
    end

    for k, v in SortedPairs(information_texts) do
        local category = vgui.Create( "DLabel", DPanel2 )
        category:SetFont("qTitleFont")
        category:SetText(v.title)
        category:Dock(TOP)
        category:SetTextColor(color_white)
        category:SetContentAlignment(5)
        category:SetAutoStretchVertical(true)
        category:SizeToContents()
        category:DockMargin(0, 10, 0, 8)

        local onetext = vgui.Create( "DLabel", DPanel2 )
        onetext:SetFont("qMediumLightFont")
        onetext:SetText(v.textOne)
        onetext:Dock(TOP)
        onetext:SetWrap(true)
        onetext:SetContentAlignment(5)
        onetext:SetTextColor(color_white)
        onetext:SetAutoStretchVertical(true)
        onetext:DockMargin(15, -10, 15, 0)
        onetext:SizeToContents()

        if v.textTwo then
            local twotext = vgui.Create( "DLabel", DPanel2 )
            twotext:SetFont("qMediumLightFont")
            twotext:SetText(v.textTwo)
            twotext:Dock(TOP)
            twotext:SetWrap(true)
            twotext:SetContentAlignment(5)
            twotext:SetTextColor(color_white)
            twotext:SetAutoStretchVertical(true)
            twotext:DockMargin(15, 0, 15, 0)
            twotext:SizeToContents()
        end

        if v.textThree then
            local threetext = vgui.Create( "DLabel", DPanel2 )
            threetext:SetFont("qMediumLightFont")
            threetext:SetText(v.textThree)
            threetext:Dock(TOP)
            threetext:SetWrap(true)
            threetext:SetContentAlignment(5)
            threetext:SetTextColor(color_white)
            threetext:SetAutoStretchVertical(true)
            threetext:DockMargin(15, 0, 15, 0)
            threetext:SizeToContents()
        end
    end

    local dbuttonLeave = vgui.Create( "qMenuButton", DPanel )
    -- dbuttonLeave:SetMaterialColor(Color(0, 0, 0))
    -- dbuttonLeave:SetMaterial(buttonMaterial)
    dbuttonLeave:SetFont("qMediumLightFont")
    dbuttonLeave:SetText( "Принять ("..time..")" )
    dbuttonLeave:Dock(BOTTOM)
    dbuttonLeave:DockMargin(15, 15, 15, 15)
    dbuttonLeave:SizeToContents()
    dbuttonLeave.DoClick = function()
        if !timer.Exists(ply:SteamID()..".AcceptMenu") then
            DPanel:Remove()
            netstream.Start("interface.AcceptMenu2", ply)
        else
            ply:Notify("Принять можно будет через "..time.." секунд!")
        end
    end

    timer.Create(ply:SteamID()..".AcceptMenu", 1, 30, function() 
        if DPanel and DPanel:IsVisible() then
            time = time - 1
            dbuttonLeave:SetText( "Принять ("..time..")" )
        end
    end)

    DPanel2:SizeToContents()
    DPanel:SizeToContents()
end)