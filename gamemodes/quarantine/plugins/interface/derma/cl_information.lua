local PANEL = {}

function PANEL:Init()
	local configColor = ix.config.Get("color")
	local parent = self:GetParent()

	self:Dock(RIGHT)
	self:SetWide(parent:GetWide() * 0.4)

	self.Paint = function(this, width, height)
		surface.SetDrawColor(30, 30, 30, 230)
		surface.DrawRect(0, 0, width, height)
		
		surface.SetDrawColor(configColor.r, configColor.g, configColor.b)
		surface.DrawOutlinedRect( 0, 0, width, height, 1 )
	end

	self.VBar:SetWide(0)

	-- entry setup
	local suppress = {}
	hook.Run("CanCreateCharacterInfo", suppress)

	if (!suppress.time) then
		local format = "%A, %B %d, %Y. %H:%M:%S"

		self.time = self:Add("DLabel")
		self.time:SetFont("qCaptureCharSelFont")
		self.time:SetTall(28)
		self.time:SetContentAlignment(5)
		self.time:Dock(TOP)
		self.time:SetTextColor(color_white)
		self.time:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.time:DockMargin(0, 15, 0, 26)
		self.time:SetText(StormFox.GetRealTime().." "..StormFox.GetRealDate())
		self.time.Think = function(this)
			if ((this.nextTime or 0) < CurTime()) then
				this:SetText(StormFox.GetRealTime().." "..StormFox.GetRealDate())
				this.nextTime = CurTime() + 0.5
			end
		end
	end

	if (!suppress.name) then
		-- container panel so we can center the label horizontally without colouring the entire background
		local namePanel = self:Add("Panel")
		namePanel:Dock(TOP)
		namePanel:DockMargin(0, 0, 0, 8)
		namePanel.PerformLayout = function(_, width, height)
			self.name:SetPos(width * 0.5 - self.name:GetWide() * 0.5, height * 0.5 - self.name:GetTall() * 0.5)
		end

		self.name = namePanel:Add("DLabel")
		self.name.backgroundColor = Color(0, 0, 0, 150)
		self.name:SetFont("qCaptureMenuButtonHugeFont")
		self.name:SetContentAlignment(5)
		self.name:SetTextColor(color_white)
		self.name.Paint = function(this, width, height)
		end

		self.name.SizeToContents = function(this)
			local width, height = this:GetContentSize()
			width = width + 16
			height = height + 16

			this:SetSize(width, height)
			namePanel:SetTall(height)
		end
	end

	if (!suppress.description) then
		local descriptionPanel = self:Add("Panel")
		descriptionPanel:Dock(TOP)
		descriptionPanel:DockMargin(10, 0, 10, 8)
		descriptionPanel.PerformLayout = function(_, width, height)
			if (!self.description.bWrap) then
				self.description:SetPos(width * 0.5 - self.description:GetWide() * 0.5, height * 0.5 - self.description:GetTall() * 0.5)
			end
		end

		self.description = descriptionPanel:Add("DLabel")
		self.description:SetFont("qCaptureCharSelFont")
		self.description:SetTextColor(color_white)
		self.description:SetContentAlignment(5)
		self.description:SetMouseInputEnabled(true)
		--self.description:SetCursor("hand")

		self.description.Paint = function(this, width, height)
		end

		--[[self.description.OnMousePressed = function(this, code)
			if (code == MOUSE_LEFT) then
				ix.command.Send("CharDesc")

				if (IsValid(ix.gui.menu)) then
					ix.gui.menu:Remove()
				end
			end
		end]]

		self.description.SizeToContents = function(this)
			if (this.bWrap) then
				-- sizing contents after initial wrapping does weird things so we'll just ignore (lol)
				return
			end

			local width, height = this:GetContentSize()

			if (width > self:GetWide()) then
				this:SetWide(self:GetWide())
				this:SetTextInset(16, 8)
				this:SetWrap(true)
				this:SizeToContentsY()
				this:SetTall(this:GetTall() + 16) -- eh

				-- wrapping doesn't like middle alignment so we'll do top-center
				self.description:SetContentAlignment(8)
				this.bWrap = true
			else
				this:SetSize(width + 16, height + 16)
			end

			descriptionPanel:SetTall(this:GetTall())
		end
	end

	self.expPanel = self:Add("Panel")
	self.expPanel:Dock(TOP)
	self.expPanel:SetTall(75)
	self.expPanel:DockMargin(15, 0, 15, 20)
	self.expPanel.Paint = function(this, width, height)
		surface.SetDrawColor(configColor.r, configColor.g, configColor.b)
		surface.DrawOutlinedRect( 0, 0, width, height, 1 )
	end

	self.expLabel2 = self.expPanel:Add("DLabel")
	self.expLabel2:SetFont("qMediumLightFont")
	self.expLabel2:Dock(TOP)
	self.expLabel2:SetContentAlignment(5)
	self.expLabel2:SetTextColor(color_white)

	self.expBar = self.expPanel:Add("Panel")
	self.expBar:Dock(TOP)
	self.expBar:DockMargin(5, 5, 5, 5)
	self.expBar:SizeToContents()

	self.expLabel1 = self.expPanel:Add("DLabel")
	self.expLabel1:SetFont("qMediumLightFont")
	self.expLabel1:Dock(TOP)
	self.expLabel1:SetContentAlignment(5)
	self.expLabel1:SetTextColor(color_white)

	if (!suppress.characterInfo) then
		self.characterInfo = self:Add("Panel")
		self.characterInfo.list = {}
		self.characterInfo:Dock(TOP) -- no dock margin because this is handled by ixListRow
		self.characterInfo:DockMargin(15, 0, 15, 20)
		self.characterInfo.Paint = function(this, width, height)
			surface.SetDrawColor(configColor.r, configColor.g, configColor.b)
			surface.DrawOutlinedRect( 0, 0, width, height, 1 )
		end
		self.characterInfo.SizeToContents = function(this)
			local height = 0

			for _, v in ipairs(this:GetChildren()) do
				if (IsValid(v) and v:IsVisible()) then
					local _, top, _, bottom = v:GetDockMargin()
					height = height + v:GetTall() + top + bottom
				end
			end

			this:SetTall(height)
		end

		if (!suppress.faction) then
			self.faction = self.characterInfo:Add("ixListRow")
			self.faction:SetList(self.characterInfo.list)
			self.faction:Dock(TOP)
			self.faction.Paint = function()
			end
		end

		if (!suppress.class) then
			self.class = self.characterInfo:Add("ixListRow")
			self.class:SetList(self.characterInfo.list)
			self.class:Dock(TOP)
			self.class.Paint = function()
			end
		end

		if (!suppress.money) then
			self.money = self.characterInfo:Add("ixListRow")
			self.money:SetList(self.characterInfo.list)
			self.money:Dock(TOP)
			self.money:SizeToContents()
			self.money.Paint = function()
			end
		end

		hook.Run("CreateCharacterInfo", self.characterInfo)
		self.characterInfo:SizeToContents()
	end

	-- no need to update since we aren't showing the attributes panel
	if (!suppress.attributes) then
		local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		if (character) then
			self.attributes = self:Add("qCategoryPanel")
			self.attributes:Dock(TOP)
			self.attributes:DockMargin(15, 0, 15, 20)
			self.attributes.Paint = function(this, width, height)
				surface.SetDrawColor(configColor.r, configColor.g, configColor.b)
				surface.DrawOutlinedRect( 0, 0, width, height, 1 )
			end

			self.attrPoints = self.attributes:Add("DLabel")
			self.attrPoints:SetFont("qMediumLightFont")
			self.attrPoints:Dock(TOP)
			self.attrPoints:SetContentAlignment(5)
			self.attrPoints:SetTextColor(color_white)


			local boost = character:GetBoosts()
			local bFirst = true

			for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
				if v.special and LocalPlayer():GetCharacter():GetAttribute(k, 0) <= 0 then continue end
				local attributeBoost = 0

				if (boost[k]) then
					for _, bValue in pairs(boost[k]) do
						attributeBoost = attributeBoost + bValue
					end
				end

				local bar = self.attributes:Add("ixAttributeBar")
				bar:Dock(TOP)

				if (!bFirst) then
					bar:DockMargin(0, 3, 0, 0)
				else
					bFirst = false
				end

				local value = character:GetAttribute(k, 0)

				if (attributeBoost) then
					bar:SetValue(value - attributeBoost or 0)
				else
					bar:SetValue(value)
				end

				local maximum = v.maxValue or ix.config.Get("maxAttributes", 100)
				bar:SetMax(maximum)
				bar:SetReadOnly()
				bar:SetText(Format("%s [%.1f/%.1f] (%.1f%%)", L(v.name), value, maximum, value / maximum * 100))

				if character:GetPoints() >= 1 then
					self.add = bar:Add("DImageButton")
					self.add:SetSize(16, 16)
					self.add:Dock(RIGHT)
					self.add:DockMargin(2, 2, 2, 2)
					self.add:SetImage("icon16/add.png")
					self.add.OnMousePressed = function()
						self.pressing = 1
						bar:SetValue((bar:GetValue() + 1))
						netstream.Start("interface.AddAttribute", k, bar:GetValue())
					end
				end

				if (attributeBoost) then
					bar:SetBoost(attributeBoost)
				end
			end

			self.attributes:SizeToContents()
		end
	end

	hook.Run("CreateCharacterInfoCategory", self)
end

function PANEL:Update(character)
	if (!character) then
		return
	end

	local faction = ix.faction.indices[character:GetFaction()]
	local class = ix.class.list[character:GetClass()]

	if (self.name) then
		self.name:SetText(character:GetName())

		if (faction) then
			self.name.backgroundColor = ColorAlpha(faction.color, 150) or Color(0, 0, 0, 150)
		end

		self.name:SizeToContents()
	end

	if (self.description) then
		self.description:SetText(character:GetDescription())
		self.description:SizeToContents()
	end

	if (self.expPanel) then
		self.expBar.Paint = function(this, width, height)
	        surface.SetDrawColor(30, 30, 30, 66)
	        surface.DrawRect(0, 0, width, height)

    		surface.SetDrawColor(ix.config.Get("color"))
			surface.DrawRect(2, 2, (character:GetXP() / (30 * (1.05 * character:GetLevel()))) * width, height)
		end
		self.expBar:SizeToContents()

		self.expLabel1:SetText("Опыт: "..character:GetXP().."/"..(30 * (1.05 * character:GetLevel())))
		self.expLabel2:SetText("Текущий уровень: "..character:GetLevel())
		self.expPanel:SizeToContents()
	end

	if (self.faction) then
		self.faction:SetLabelText(L("faction"))
		self.faction:SetText(L(faction.name))
		self.faction:SizeToContents()
	end

	if (self.class) then
		-- don't show class label if the class is the same name as the faction
		if (class and class.name != faction.name) then
			self.class:SetLabelText(L("class"))
			self.class:SetText(L(class.name))
			self.class:SizeToContents()
		else
			self.class:SetVisible(false)
		end
	end

	if (self.attributes) then
		self.attrPoints:SetText("Очки атрибутов: "..character:GetPoints())
	end

	if (self.money) then
		self.money:SetLabelText(L("money"))
		self.money:SetText(ix.currency.Get(character:GetMoney()))
		self.money:SizeToContents()
	end

	hook.Run("UpdateCharacterInfo", self.characterInfo, character)

	self.characterInfo:SizeToContents()

	hook.Run("UpdateCharacterInfoCategory", self, character)
end

function PANEL:OnSubpanelRightClick()
	properties.OpenEntityMenu(LocalPlayer())
end

vgui.Register("ixCharacterInfo", PANEL, "DScrollPanel")

local DrawPartsModel = {
	[BODYPART_HEAD] = {
		BarStartX = 0.57,
		BarStartY = 0.15,
		Name = "Голова"
	},
	[BODYPART_TORSO] = {
		BarStartX = 0.435,
		BarStartY = 0.4,
		Name = "Торс"
	},
	[BODYPART_LEFTARM] = {
		BarStartX = 0.625,
		BarStartY = 0.37,
		Name = "Левая рука"
	},
	[BODYPART_RIGHTARM] = {
		BarStartX = 0.25,
		BarStartY = 0.37,
		Name = "Правая рука"
	},
	[BODYPART_LEFTLEG] = {
		BarStartX = 0.265,
		BarStartY = 0.7,
		Name = "Правая нога"
	},
	[BODYPART_RIGHTLEG] = {
		BarStartX = 0.60,
		BarStartY = 0.7,
		Name = "Левая нога"
	},	
}

hook.Add("CreateMenuButtons", "ixCharInfo", function(tabs)
	tabs["you"] = {
		Create = function(info, container)
			container.infoPanel = container:Add("ixCharacterInfo")
			local ply = LocalPlayer()

			container.playerModel = container:Add("ixModelPanel")
			container.playerModel:Dock(RIGHT)
			container.playerModel:SetSize(ScrW() * 0.6, ScrH() * 0.8)
			container.playerModel:SetModel(ply:GetModel())

			local playerModelEnt = container.playerModel:GetEntity()
			playerModelEnt:SetSequence("lineidle02")
			container.playerModel:DrawModel()

			local HealthData = ply.HealthData
			if HealthData then
				local color_dead, color_critical, color_hurt, color_ok = Color( 34, 47, 62 ), Color( 231, 76, 60 ), Color( 241, 196, 15 ), color_white
				local color_green = Color( 39, 174, 96 )
				container.playerModel.PaintOver = function(this, width, height)

					for ID, Data in pairs(DrawPartsModel) do
						local Limb = HealthData[ID]
						local LimbHealth = Limb:GetHealth()
						local desiredColor = LimbHealth == 0 && color_dead || LimbHealth < ( 100 * 0.4 ) && color_critical || LimbHealth < ( 100 * 0.9 ) && color_hurt || color_green

						surface.SetDrawColor( 30, 30, 30, 250 )
						surface.DrawRect(width * Data.BarStartX, height * Data.BarStartY, 150, 25)

						surface.SetDrawColor(desiredColor)
						surface.DrawRect(width * Data.BarStartX, height * Data.BarStartY, (150 * (LimbHealth / 100)), 25 )

						surface.SetFont("qMediumLightFont")
						surface.SetTextColor( 230, 230, 230 )
						surface.SetTextPos(width * Data.BarStartX, height * (Data.BarStartY - 0.025)) 
						surface.DrawText(Data.Name)

						-- surface.SetFont("qMediumLightFont")
						-- surface.SetTextColor( 230, 230, 230 )
						-- surface.SetTextPos(width * (Data.BarStartX + 0.023), height * (Data.BarStartY + 0.01)) 
						-- surface.DrawText(LimbHealth.." / 100")

						local iCount = 0

						for _, Debuff in pairs( Limb.effects ) do
							if Debuff:IsExpired() then continue end
							local DebuffPrototype = RLOC.RegisteredDebuffs[ Debuff.ID ]
							local expireTime = Debuff:GetExpiry( )

							surface.SetFont("qSmallFont")
							surface.SetTextColor( 230, 230, 230 )
							surface.SetTextPos(width * Data.BarStartX, height * ((Data.BarStartY + 0.03) + (0.025 * iCount))) 
							surface.DrawText(" - "..DebuffPrototype.Name.." : "..math.max(0, math.ceil(expireTime - CurTime())).." сек.")
							iCount = iCount + 1
						end
					end
				end
			end
		end,
		OnSelected = function(info, container)
			local ply = LocalPlayer()
			container.infoPanel:Update(ply:GetCharacter())

			local playerModelEnt = container.playerModel:GetEntity()

			playerModelEnt:SetSkin(ply:GetSkin())
			for i = 0, #ply:GetBodyGroups() do
				playerModelEnt:SetBodygroup(i, ply:GetBodygroup(i))
			end
		end,
	}
end)
