local PLUGIN = PLUGIN

--[[local w, h = 500, 25
local barMaterial2 = Material("materials/menu/stroke-02.png")

function PLUGIN:HUDPaint()
    local ply = LocalPlayer()
    local char = ply:GetCharacter()

    if char then
        if ply:GetLocalVar("DrawHUD", false) then
            local needXP = 100 * (1.15 * char:GetLevel())
            local experience = char:GetXP()

            surface.SetDrawColor(30, 30, 30, 250)
            surface.DrawRect(ScrW() / 2.8, ScrH() / 30, w, h + 5)

            --[[surface.SetDrawColor(ix.config.Get("color"))
            surface.DrawRect((ScrW() / 2.8) + 2.5, (ScrH() / 30) + 2.75, (experience / needXP) * w - 5, h)

            surface.SetDrawColor(ix.config.Get("color"))
            surface.SetMaterial(barMaterial2)
            surface.DrawTexturedRect((ScrW() / 2.8) + 2.5, (ScrH() / 30) + 2.75, (experience / needXP) * w - 5, h)

            surface.SetTextColor( 255, 255, 255 )
            surface.SetTextPos( (ScrW() / 2.3) + 2.5, (ScrH() / 30) + 30 ) 
            surface.SetFont("qMediumFont")
            surface.DrawText( "Текущий уровень: "..char:GetLevel())
        end
    end
end]]

--[[netstream.Hook("Level.CreateMenu", function()
    local ply = LocalPlayer()
    local w1, h1 = 500, 25
    local char = ply:GetCharacter()
    local experience = char:GetData("Skill_Experience", 0)

    local DFrame = vgui.Create( "DFrame" )
    DFrame:SetPos( ScrW() / 2.8, ScrH() / 30 )
    DFrame:SetSize( w1, h1 + 5 )
    DFrame:SetTitle( "" )	
    DFrame.Paint = function()
    end

    local DPanel = vgui.Create( "DPanel", DFrame )
    DPanel:SetPos( ScrW() / 2.8, ScrH() / 30 )
    DPanel:SetSize( w1, h1 + 5 )
    DPanel.Paint = function(self, w, h)
    end

    local dprogress = vgui.Create("DPanel", DPanel)
    dprogress:Dock(TOP)
    dprogress:DockMargin(5, 0, 5, 0)
    --dprogress:SetTall(25)
    --dprogress:SetWide(30)
    dprogress.Paint = function(self, w, h)
        surface.SetDrawColor(0, 0, 0, 66)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(ix.config.Get("color"))
        surface.DrawRect(0, 0, (experience / 900) * w, h)
    end
end)]]