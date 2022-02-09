local PLUGIN = PLUGIN
PLUGIN.name = "Friendliness System"
PLUGIN.author = "Gaurussel"
PLUGIN.description = ".."

ix.util.Include("sv_plugin.lua")

if CLIENT then

    function PLUGIN:CreateCharacterInfo(panel)
        self.infoRow = panel:Add("ixListRow")
        self.infoRow:SetList(panel.list)
        self.infoRow:Dock(TOP)
    end

    function PLUGIN:UpdateCharacterInfo(panel, char)
        if (self.infoRow) then
            self.infoRow:SetLabelText("Карма")
            self.infoRow:SetText(char:GetData("friendliness", 10))
            self.infoRow:SizeToContents()
        end
    end
end
