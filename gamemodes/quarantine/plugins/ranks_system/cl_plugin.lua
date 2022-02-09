local PLUGIN = PLUGIN


local function IsInRange(min, max, scale)
    local localPos = LocalPlayer():GetPos()

    local distance = min:Distance(max)

    if localPos:Distance(min + ((max - min) / 2)) <= distance * scale then
        return true
    end

    return false
end

function PLUGIN:PostDrawTranslucentRenderables()
    local ranksPositions = GetNetVar("ranksPositions") or {}

    if ranksPositions == nil then return end
    if !LocalPlayer():GetCharacter() then return end
    
    for _, rankBox in pairs(ranksPositions) do
        local min, max = rankBox.min, rankBox.max

        if !IsInRange(min, max, 3) then continue end

        local observerCvar = GetConVar("ix_toxicgas_observer")

        if LocalPlayer():IsAdmin()
        and LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP
        and observerCvar and observerCvar:GetBool() then
            render.DrawWireframeBox(min, Angle(), Vector(0, 0, 0), max - min, Color(255, 215, 0, 255), false)
            local startRank, endRank = GetBoxLine(min, max)
            render.DrawLine(startRank, endRank, Color(0, 255, 0), false)
        end
    end
end

function PLUGIN:PopulateCharacterInfo(client, char, tooltip)
    if char:GetFaction() == FACTION_SURV then return end
    if LocalPlayer():Team() != client:Team() then return end
    
    if char:GetRank() and ix.faction.indices[char:GetFaction()].ranks then
        local rowRanks = tooltip:AddRowAfter("name", "ranks")
        rowRanks:SetBackgroundColor(Color(255,165,0,255))
        rowRanks:SetText("Ранг: "..ix.faction.indices[char:GetFaction()].ranks[char:GetRank()])
        rowRanks:SizeToContents()
    end
end

function PLUGIN:CreateCharacterInfo(panel)
    if LocalPlayer():Team() == FACTION_SURV then return end
    self.infoRow = panel:Add("ixListRow")
    self.infoRow:SetList(panel.list)
    self.infoRow:Dock(TOP)

    self.expBox = panel:Add("ixListRow")
    self.expBox:SetList(panel.list)
    self.expBox:Dock(TOP)
end

function PLUGIN:UpdateCharacterInfo(panel, char)
    if LocalPlayer():Team() == FACTION_SURV then return end
    local faction = ix.faction.indices[char:GetFaction()]
    local rank = char:GetRank()

    if (self.infoRow) then
        self.infoRow:SetLabelText("Ранг фракции")
        self.infoRow:SetText(faction.ranks[rank])
        self.infoRow:SizeToContents()
    end

    if (self.expBox) then
        self.expBox:SetLabelText("Очки фракции")
        if rank < 8 then
            self.expBox:SetText(char:GetRankXP().."/"..PLUGIN.needExperience[rank + 1])
        elseif rank == 8 then
            self.expBox:SetText("MAXIMUM")
        end
        self.expBox:SizeToContents()
    end
end

netstream.Hook("ranks.MissionMenu", function()
    vgui.Create("ixNpcMissions")
end)