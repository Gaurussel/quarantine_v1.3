local PLUGIN = PLUGIN
local fontTwo = "Roboto"
local format = "%H:%M"
local w, h = ScrW(), ScrH()
--[[local w, h = 220, 5
local health_icon = Material("plus.png")
local food_icon = Material("-apple.png")
local stm_icon = Material("running.png")
local water_icon = Material("water-bottle.png")
local bone_icon = Material("broken-bone.png")
local virus_icon = Material("virus.png")
local stomach_icon = Material("stomach.png")
local bleeding_icon = Material("water.png")
local morphine_icon = Material("pill.png")


local colors = {
    normal = Color(255, 255, 255),
    tolerable = Color(230, 230, 0),
    cold = Color(0, 230, 230),
    critical = Color(230, 0, 38),
}]]

local notWeapon = {
    ["ix_keys"] = true,
}

function PLUGIN:CharacterLoaded(char)
    for k, v in pairs(ix.bar.list) do
        ix.bar.Remove(v.identifier)
    end
end

surface.CreateFont("qSmallFont", {
    font = fontTwo,
    size = math.max(ScreenScale(6), 17),
    extended = true,
    weight = 500
})

surface.CreateFont("qMediumLightFont", {
    font = fontTwo,
    size = 22,
    extended = true,
    weight = 200
})

surface.CreateFont("qMediumFont", {
    font = fontTwo,
    size = 22,
    extended = true,
    weight = 1000
})

surface.CreateFont("qTitleFont", {
    font = fontTwo,
    size = ScreenScale(11),
    extended = true,
    weight = 60
})

surface.CreateFont("ixMainMenuFont", {
    font = fontTwo,
    size = ScreenScale(13),
    extended = true,
    weight = 60
})

surface.CreateFont("ixMainMenuTwoFont", {
    font = fontTwo,
    size = ScreenScale(13),
    extended = true,
    weight = 60
})

surface.CreateFont("ixHudFont", {
    font = "Roboto",
    size = ScreenScale(8),
    extended = true,
    weight = 60
})

surface.CreateFont("ixCaptureTitleFont", {
    font = fontTwo,
    size = ScreenScale(30),
    extended = true,
    weight = 100
})

surface.CreateFont("ixCaptureCharSelFont", {
    font = fontTwo,
    size = ScreenScale(10),
    extended = true,
    weight = 100
})

surface.CreateFont("qCaptureCharSelFont", {
    font = fontTwo,
    size = ScreenScale(10),
    extended = true,
    weight = 100
})

surface.CreateFont("ixCaptureMenuButtonLabelFont", {
    font = fontTwo,
    size = 28,
    extended = true,
    weight = 100
})

surface.CreateFont("qCaptureMenuButtonLabelFont", {
    font = fontTwo,
    size = 28,
    extended = true,
    weight = 100
})

surface.CreateFont("ixCaptureMenuButtonHugeFont", {
    font = fontTwo,
    size = ScreenScale(24),
    extended = true,
    weight = 100
})

surface.CreateFont("qCaptureMenuButtonHugeFont", {
    font = fontTwo,
    size = ScreenScale(24),
    extended = true,
    weight = 100
})

--[[do
    local ColorModify_Health = {
        [ "$pp_colour_addr" ] = 0,
        [ "$pp_colour_addg" ] = 0,
        [ "$pp_colour_addb" ] = 0,
        [ "$pp_colour_brightness" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 1,
        [ "$pp_colour_mulr" ] = 0,
        [ "$pp_colour_mulg" ] = 0,
        [ "$pp_colour_mulb" ] = 0
    }

    local color = 0
    function PLUGIN:RenderScreenspaceEffects()
        if (LocalPlayer():Alive()) then
            color = 1 - (LocalPlayer():Health() / LocalPlayer():GetMaxHealth())

            if (color > 0) then
                ColorModify_Health["$pp_colour_colour"] = math.Clamp(1 - color, 0, 1)

                DrawColorModify(ColorModify_Health)
            end
        end
    end
end]]


-- local mainMat = ix.util.GetMaterial("materials/hud/main.png")
-- local beamMat = ix.util.GetMaterial("materials/hud/beam.png")
-- local boneMat = ix.util.GetMaterial("materials/hud/bone.png")
-- local virusMat = ix.util.GetMaterial("materials/hud/virus.png")
-- local bleedingMat = ix.util.GetMaterial("materials/hud/blood.png")
-- local morphineMat = ix.util.GetMaterial("materials/hud/morphine.png")
-- local canvas = ix.util.GetMaterial("materials/menu/stroke-02.png")

local food_icon = Material("materials/hud/food.png")
local stm_icon = Material("materials/hud/run.png")
local water_icon = Material("materials/hud/water.png")
local micro_icon = Material("materials/hud/microphone.png")
local temp_icon = Material("materials/hud/temp.png")


function PLUGIN:HUDPaint()
    local ply = LocalPlayer()
    local char = ply:GetCharacter()

    if ply:InVehicle() then return end

    if ix.gui.menu then
        if ix.gui.menu:IsVisible() then return end
    end

    if ix.gui.characterMenu then
        if ix.gui.characterMenu:IsVisible() then return end
    end

    if IsValid(ply) and char and !ply:GetLocalVar("ragdoll", false) then

        if ply:Alive() then
            -- Боевая готовность оружия
            local weapon = ply:GetActiveWeapon()
            if !ply:IsWepRaised() and weapon:IsValid() and !notWeapon[weapon:GetClass()] then                
                surface.SetFont( "qSmallFont" )
                surface.SetTextColor( 255, 255, 255, 255 )
                surface.SetTextPos( w * 0.35, h * 0.97 ) 
                surface.DrawText( "Ваше оружие не приведено в боевую готовность. Задержите «R», чтобы сделать это." )
            end

            -- Худ патронов
            if IsValid(weapon) and !notWeapon[weapon:GetClass()] then
                local clip = weapon:Clip1()
                local clipMax = weapon:GetMaxClip1()
                local count = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())

                if clip != -1 or clipMax != -1 then 
                    -- surface.SetDrawColor( 0, 0, 0, 255 )
                    -- surface.SetMaterial( canvas )
                    -- surface.DrawTexturedRect( w * 0.925, h * 0.925, 128, 64 )

                    surface.SetFont( "ixMainMenuTwoFont" )
                    surface.SetTextColor( 255, 255, 255 )

                    if count >= 100 then
                        surface.SetDrawColor(Color(36, 36, 35, 210))
                        surface.DrawRect(w * 0.925, h * 0.93, 128, 64)
                        ix.util.DrawBlurAt(w * 0.925, h * 0.93, 128, 64)

                        surface.SetTextPos( w * 0.93, h * 0.94 ) 
                    else
                        surface.SetDrawColor(Color(51, 53, 51, 210))
                        surface.DrawRect(w * 0.925, h * 0.93, 104, 64)
                        ix.util.DrawBlurAt(w * 0.925, h * 0.93, 104, 64)

                        surface.SetTextPos( w * 0.93, h * 0.94 )
                    end

                    surface.DrawText( clip.."/"..count )
                end
            end
        end


       --[[ 
        //////////////////////////////////////////////////
                            DayZ Hud
        \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Стамина с иконкой
        surface.SetDrawColor(0, 0, 0, 66)
        surface.DrawRect(ScrW() / 12, ScrH() / 1.098, w, h + 5)

        surface.SetDrawColor(colors.normal)
        surface.DrawRect((ScrW() / 12) + 2.5, (ScrH() / 1.098) + 2.75, (ply:GetNetVar("stm", 100) / 100) * w - 5, h)

        surface.SetDrawColor(colors.normal) 
        surface.SetMaterial(stm_icon)
        surface.DrawTexturedRect( ScrW() / 15.5, ScrH() / 1.11, 32, 32 )

        -- Здоровье
        local health = ply:Health()

        if health >= 80 then
            surface.SetDrawColor(colors.normal) 
        elseif health >= 50 then
            surface.SetDrawColor(colors.tolerable) 
        else 
            surface.SetDrawColor(colors.critical) 
        end

        surface.SetMaterial(health_icon)
        surface.DrawTexturedRect( ScrW() / 1.11, ScrH() / 1.11, 36, 36 )

        -- Голод
        local food = char:GetFood()

        if food >= 80 then
            surface.SetDrawColor(colors.normal) 
        elseif food >= 50 then
            surface.SetDrawColor(colors.tolerable) 
        else 
            surface.SetDrawColor(colors.critical) 
        end

        surface.SetMaterial(food_icon)
        surface.DrawTexturedRect( ScrW() / 1.14, ScrH() / 1.11, 36, 36 )

        -- Жажда
        local water = char:GetWater()

        if water >= 80 then
            surface.SetDrawColor(colors.normal) 
        elseif water >= 50 then
            surface.SetDrawColor(colors.tolerable) 
        else 
            surface.SetDrawColor(colors.critical) 
        end

        surface.SetMaterial(water_icon)
        surface.DrawTexturedRect( ScrW() / 1.17, ScrH() / 1.11, 36, 36 )

        local pos = ScrW() / 1.18

        if char:GetData("Fracture", false) or char:IsPoisoned() or char:IsCold() or char:IsBleeding() or ply:IsMorphine() then
            -- Палочка
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(pos, ScrH() / 1.107, 5, 30)

            -- Косточка
            if char:GetData("Fracture", false) then
                pos = pos - 50
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(bone_icon)
                surface.DrawTexturedRect(pos, ScrH() / 1.109, 32, 32 )
            end

            -- Желудок
            if char:IsPoisoned() then
                pos = pos - 50
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(stomach_icon)
                surface.DrawTexturedRect(pos, ScrH() / 1.109, 32, 32 )
            end

            -- Вирус
            if char:IsCold() then
                pos = pos - 50
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(virus_icon)
                surface.DrawTexturedRect(pos, ScrH() / 1.109, 32, 32 )
            end

            -- Кровотечение
            if char:IsBleeding() then
                pos = pos - 50
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(bleeding_icon)
                surface.DrawTexturedRect(pos, ScrH() / 1.109, 32, 32 )
            end

            -- Морфин
            if ply:IsMorphine() then
                pos = pos - 50
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(morphine_icon)
                surface.DrawTexturedRect(pos, ScrH() / 1.109, 32, 32 )
            end
        end
        --[[//////////////////////////////////////////////////
                            Mine Hud
        \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\]]

        -- local posW, posH = 260, 60

        -- surface.SetDrawColor( 255, 255, 255, 255 )
        -- surface.SetMaterial( mainMat )
        -- surface.DrawTexturedRect( 0, 0, 512, 160 )

        -- hp = math.Round(hp / 5.88) / 17
        -- surface.SetMaterial( beamMat ) -- Health
        -- surface.SetDrawColor( Color(200, 0, 0, 255) )
        -- surface.DrawTexturedRectUV( 5, 12, 224 * hp, 40, 0, 0, hp, 1 )

        -- hunger = math.Round(hunger / 5.88) / 17
        -- surface.SetMaterial( beamMat ) -- Hunger
        -- surface.SetDrawColor( Color(0, 200, 0, 255) )
        -- surface.DrawTexturedRectUV( 5, 72, 224 * hunger, 32, 0, 0, hunger, 1 )

        -- water = math.Round(water / 5.88) / 17
        -- surface.SetMaterial( beamMat ) -- Water
        -- surface.SetDrawColor( Color(0, 0, 200, 255) )
        -- surface.DrawTexturedRectUV( 5, 120, 224 * water, 32, 0, 0, water, 1 )

        -- surface.SetFont( "ixHudFont" ) -- Time
        -- surface.SetTextColor( 0, 0, 0 )
        -- surface.SetTextPos( 260, 12 ) 
        -- surface.DrawText( ix.date.GetFormatted(format) )

        -- surface.SetFont( "ixHudFont" ) -- Temp
        -- surface.SetTextColor( 204, 132, 0 )
        -- surface.SetTextPos( 365, 12 ) 
        -- surface.DrawText( "+16 °C" )

        -- if char:GetData("Fracture", false) or char:IsPoisoned() or char:IsCold() or char:IsBleeding() or ply:IsMorphine() then

        --     -- Косточка
        --     if char:GetData("Fracture", false) then 
        --         surface.SetDrawColor(255,255,255,255)
        --         surface.SetMaterial(boneMat)
        --         surface.DrawTexturedRect(posW, posH, 64, 64 )
        --     end

        --     -- Вирус
        --     if char:IsPoisoned() or char:IsCold() then
        --         posW = posW + 65
        --         surface.SetDrawColor(255,255,255,255)
        --         surface.SetMaterial(virusMat)
        --         surface.DrawTexturedRect(posW, posH, 64, 64 )
        --     end

        --     -- Кровотечение
        --     if char:IsBleeding() then
        --         posW = posW + 65
        --         surface.SetDrawColor(255,255,255,255)
        --         surface.SetMaterial(bleedingMat)
        --         surface.DrawTexturedRect(posW, posH, 64, 64 )
        --     end

        --     -- Морфин
        --     if ply:IsMorphine() then
        --         posW = posW + 65
        --         surface.SetDrawColor(255,255,255,255)
        --         surface.SetMaterial(morphineMat)
        --         surface.DrawTexturedRect(posW, posH, 64, 64 )
        --     end
        -- end

        local ply = LocalPlayer()
		local char = ply:GetCharacter()
        local plusY = 32

		local stm = ply:GetLocalVar("stm", 0)
        local hunger = char:GetFood()
        local water = char:GetWater()

		local height = ScreenScale(4)
		local posX, posY = w * 0.05, h * 0.87

        surface.SetDrawColor(255, 255, 255, 90)
        surface.DrawRect(posX, posY, 200, height)

        surface.SetDrawColor(235, 77, 75, 255)
        surface.DrawRect(posX, posY, math.Clamp(char:GetWarmth(), 0, 100) * 2, height)

		-- surface.SetFont( "ixHudFont" )
		-- surface.SetTextColor( 255, 255, 255 )
		-- surface.SetTextPos( posX - 50, posY - 8 ) 
		-- surface.DrawText( "ТМР" )

        surface.SetDrawColor(235, 77, 75, 255)
        surface.SetMaterial(temp_icon)
        surface.DrawTexturedRect(posX - 40, posY - 12, 30, 30 )

        posY = posY + plusY
		surface.SetDrawColor(255, 255, 255, 90)
        surface.DrawRect(posX, posY, 200, height)

        surface.SetDrawColor(243, 156, 18, 255)
        surface.DrawRect(posX, posY, math.Clamp(stm, 0, 100) * 2, height)

		-- surface.SetFont( "ixHudFont" )
		-- surface.SetTextColor( 255, 255, 255 )
		-- surface.SetTextPos( posX - 50, posY - 8 ) 
		-- surface.DrawText( "СТМ" )

        surface.SetDrawColor(243, 156, 18, 255)
        surface.SetMaterial(stm_icon)
        surface.DrawTexturedRect(posX - 40, posY - 12, 32, 32 )

		posY = posY + plusY
		surface.SetDrawColor(255, 255, 255, 90)
        surface.DrawRect(posX, posY, 200, height)

        surface.SetDrawColor(39, 174, 96, 255)
        surface.DrawRect(posX, posY, math.Clamp(hunger, 0, 100) * 2, height)

		-- surface.SetFont( "ixHudFont" )
		-- surface.SetTextColor( 255, 255, 255 )
		-- surface.SetTextPos( posX - 50, posY - 8 ) 
		-- surface.DrawText( "ГЛД" )

		surface.SetDrawColor(39, 174, 96, 255)
        surface.SetMaterial(food_icon)
        surface.DrawTexturedRect(posX - 40, posY - 12, 30, 30 )

		posY = posY + plusY
		surface.SetDrawColor(255, 255, 255, 90)
        surface.DrawRect(posX, posY, 200, height)

        surface.SetDrawColor(41, 128, 185, 255)
        surface.DrawRect(posX, posY, math.Clamp(water, 0, 100) * 2, height)

		-- surface.SetFont( "ixHudFont" )
		-- surface.SetTextColor( 255, 255, 255 )
		-- surface.SetTextPos( posX - 55, posY - 8 ) 
		-- surface.DrawText( "ЖЖД" )

		surface.SetDrawColor(41, 128, 185, 255)
        surface.SetMaterial(water_icon)
        surface.DrawTexturedRect(posX - 40, posY - 12, 30, 30 )
    end
end