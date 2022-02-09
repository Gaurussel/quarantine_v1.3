local PLUGIN = PLUGIN
ENT.Type = "anim"
ENT.PrintName = "Лаборантская"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.ShowPlayerInteraction = true
ENT.canIgnite = false

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/gta_prop_michou/v_med_lab_fridge.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()

	end

	function ENT:Use(ply)
        ply:PerformInteraction(ix.config.Get("itemPickupTime", 0.5), self, function(client)
            local char = ply:GetCharacter()
            local inventory = char:GetInventory()
            local items = PLUGIN.lab_items

            if inventory:HasItem("keycard") then
                netstream.Start(ply, "ranks.WeaponLocker", self, items)
            end
            return false
        end)
	end
    
    local time = 0
    function ENT:Touch(ent)
        if time > CurTime() then return end
        if (ent:IsValid() and ent:GetClass() == "ix_item") then
            time = CurTime() + 1
            local itemTable = ent:GetItemTable()

            if itemTable.base == "base_cw20presets" or itemTable.base == "base_cw20weapons" then
                local wep = PLUGIN.lab_items[itemTable.uniqueID] or 0
                PLUGIN.lab_items[itemTable.uniqueID] = wep + 1
                ent:Remove()
            end
        end
    end

    netstream.Hook("ranks.GiveWeapon", function(ply, weap, ent)
        local char = ply:GetCharacter()
        local inventory = char:GetInventory()

        if !inventory:HasItem(weap) then
            inventory:Add(weap, 1, {quality = "Обычное"})
            ply:Notify("Вы взяли из амуниции "..string.upper(weap)..".")
            items[weap] = items[weap] - 1

            if items[weap] <= 0 then
                items[weap] = nil
            end
        else
            ply:Notify("У вас уже есть это!")
        end
    end)
else
    function ENT:Draw()
        self:DrawModel()
    end

    netstream.Hook("ranks.WeaponLocker", function(ent, table)
        local ply = LocalPlayer()
        local configColor = ix.config.Get("color")

        local DPanel = vgui.Create( "DPanel" )
        DPanel:MakePopup()
        DPanel:SetSize( ScrW() * 0.3, ScrH() * 0.4 )
        DPanel:Center()
        DPanel.Paint = function(this, weight, height)
            surface.SetDrawColor(30, 30, 30, 230)
            surface.DrawRect(0, 0, width, height)
            
            surface.SetDrawColor(configColor.r, configColor.g, configColor.b)
            surface.DrawOutlinedRect( 0, 0, width, height, 1 )
        end

        local exit = DPanel:Add("qMenuButton")
        exit:SetMaterialColor(Color(0, 0, 0))
        exit:SetMaterial(buttonMaterial)
        exit:SetText("Закрыть")
        exit:SetFont("qMediumFont")
        exit:SetTall(30)
        exit:DockMargin(0, 0, 0, 15)
        exit:Dock(BOTTOM)
        exit.DoClick = function()
            DPanel:Remove()
        end
    
        local DPanel2 = vgui.Create( "DScrollPanel", DPanel )
        DPanel2:Dock(FILL)
        DPanel2:DockMargin(5, 10, 5, 5)
        DPanel2.Paint = function()
        end

        for k, v in pairs(table) do
            local weapon = DPanel2:Add("qMenuButton")
            weapon:SetMaterialColor(Color(0, 0, 0))
            weapon:SetMaterial(buttonMaterial)
            weapon:SetText(string.upper(k).." (".."x"..v..")")
            weapon:DockMargin(5, 5, 5, 0)
            weapon:Dock(TOP)
            weapon:SetFont("qMediumFont")
            weapon:SetTall(30)
            weapon.DoClick = function()
                netstream.Start("ranks.GiveWeapon", k, ent)
            end
        end
    end)
end
