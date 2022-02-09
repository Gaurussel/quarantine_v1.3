local PLUGIN = PLUGIN
local PANEL = {}
local missions = PLUGIN.missions or {}

function PANEL:Init()
    ix.gui.missions = self
    local configColor = ix.config.Get("color")

	self:MakePopup()
	self:SetSize(ScrW(), ScrH())
    self:Center()

    local initPanel = self:Add("DPanel")
    initPanel:SetSize(ScrW() * 0.35, ScrH() * 0.5)
    initPanel:Center()
    initPanel.Paint = function(this, width, height)
        surface.SetDrawColor(30, 30, 30, 230)
        surface.DrawRect(0, 0, width, height)

        ix.util.DrawBlur(this)
        
        surface.SetDrawColor(configColor.r, configColor.g, configColor.b)
        surface.DrawOutlinedRect( 0, 0, width, height, 1 )
    end

    local closeButton = initPanel:Add("qMenuButton")
    closeButton:SetText("Закрыть")
    closeButton:DockMargin(5, 0, 5, 5)
    closeButton:Dock(BOTTOM)
    closeButton:SetTall(35)
    closeButton.DoClick = function()
        self:Remove()
    end

    local labelOne = initPanel:Add("DLabel")
    labelOne:Dock(TOP)
    labelOne:DockMargin(0, 15, 0, 10)
    labelOne:SetFont("qTitleFont")
    labelOne:SetText("Доступные миссии")
    labelOne:SetContentAlignment(5)
    labelOne:SizeToContents()

    local panel = initPanel:Add("DScrollPanel")
    panel:Dock(FILL)
    panel.Paint = function()
    end

    for k, v in pairs(missions) do
        for uniqueID, mission_data in SortedPairsByMemberValue(v, "name", true) do
            local missionPanel = panel:Add("DPanel")
            missionPanel:Dock(TOP)
            missionPanel:DockMargin(15, 0, 15, 5)
            missionPanel:SetTall(80)
            missionPanel.Paint = function(this, width, height)
                surface.SetDrawColor(30, 30, 30, 230)
                surface.DrawRect(0, 0, width, height)
                        
                surface.SetDrawColor(configColor.r, configColor.g, configColor.b)
                surface.DrawOutlinedRect( 0, 0, width, height, 1 )
            end

            local missionLabel = missionPanel:Add("DLabel")
            missionLabel:Dock(LEFT)
            missionLabel:DockMargin(25, 0, 0, 0)
            missionLabel:SetFont("qTitleFont")
            missionLabel:SetText(mission_data.name)
            --missionLabel:SetWrap(true)
            --missionLabel:SetContentAlignment(4)
            missionLabel:SizeToContents()
            
            local missionTake = missionPanel:Add("qMenuButton")
            missionTake:SetText("Начать")
            missionTake:Dock(RIGHT)
            missionTake:DockMargin(15, 15, 20, 15)
            missionTake.DoClick = function()
                netstream.Start(mission_data.hook, uniqueID)
                self:Remove()
            end

            if timer.Exists("mission."..k) then
                missionTake:SetText(math.ceil(timer.TimeLeft("mission."..k)).." секунд")
                missionTake:SetDisabled(true)

                missionTake.DoClick = function()
                    LocalPlayer():Notify("Миссия уже активна!")
                    self:Remove()
                end

                missionTake.Think = function()
                    missionTake:SetText(math.ceil(timer.TimeLeft("mission."..k)).." секунд")
                end
            end
            missionTake:SizeToContents()
        end
    end
end

function PANEL:Paint(width, height)
	if !ix.option.Get("cheapBlur", false) then
		derma.SkinFunc("PaintMenuBackground", self, width, height, self.currentBlur)
	end
end

vgui.Register("ixNpcMissions", PANEL, "DPanel")