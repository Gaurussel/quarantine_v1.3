
local PLUGIN = PLUGIN

local gradientUp = surface.GetTextureID("vgui/gradient-u")
local color_green = Color(39, 174, 96)
local color_red = Color(231, 76, 60)

local PANEL = {}

function PANEL:Init()
	self:Dock(TOP)
	self:SetTall(64)

	self:SetText("")
end

function PANEL:SetRecipe(recipeTable)
	self.recipeTable = recipeTable

	self.icon = self:Add("SpawnIcon")
	self.icon:InvalidateLayout(true)
	self.icon:Dock(LEFT)
	self.icon:DockMargin(10, 0, 0, 0)
	self.icon:SetMouseInputEnabled(false)
	self.icon:SetModel(recipeTable:GetModel(), recipeTable:GetSkin())
	self.icon.PaintOver = function(this) end

	self.name = self:Add("DLabel")
	self.name:Dock(FILL)
	self.name:SetContentAlignment(4)
	self.name:SetTextColor(color_white)
	self.name:SetFont("ixMenuButtonFont")
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))
	self.name:SetText(recipeTable.GetName and recipeTable:GetName() or L(recipeTable.name))

	self:SetBackgroundColor(recipeTable:OnCanCraft(LocalPlayer()) and color_green or color_red)
end

function PANEL:DoClick()
	if (self.recipeTable) then
		net.Start("ixCraftRecipe")
			net.WriteString(self.recipeTable.uniqueID)
		net.SendToServer()
	end
end

function PANEL:PaintBackground(width, height)
	local alpha = self.currentBackgroundAlpha

	derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, ColorAlpha(self.backgroundColor, alpha))
end

vgui.Register("ixCraftingRecipe", PANEL, "ixMenuButton")

PANEL = {}

function PANEL:Init()
	ix.gui.crafting = self

	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:Center()

	self.categories = self:Add("DScrollPanel")
	self.categories:Dock(LEFT)
	self.categories:SetWide(ScrW() * 0.15)
	self.categories:SetTall(ScrH())
	self.categoryPanels = {}

	self.scroll = self:Add("DScrollPanel")
	self.scroll:Dock(FILL)
	self.scroll:DockMargin(15, 0, 0, 0)

	-- self.search = self:Add("ixIconTextEntry")
	-- self.search:SetEnterAllowed(false)
	-- self.search:Dock(TOP)

	-- local leftMargin = self.search:GetDockMargin()
	-- self.search:DockMargin(leftMargin, 0, 0, 0)

	-- self.search.OnChange = function(this)
	-- 	local text = self.search:GetText():lower()

	-- 	if (self.selected) then
	-- 		self:LoadRecipes(self.selected.category, text:find("%S") and text or nil)
	-- 		self.scroll:InvalidateLayout()
	-- 	end
	-- end

	local first = true

	for k, v in pairs(PLUGIN.craft.recipes) do
		if (v:OnCanSee(LocalPlayer()) == false) then
			continue
		end

		if (!self.categoryPanels[L(v.category)]) then
			self.categoryPanels[L(v.category)] = v.category
		end
	end

	for category, realName in SortedPairs(self.categoryPanels) do
		local button = self.categories:Add("qCraftingMenuButton")
		button:Dock(TOP)
		button:SetText(category)
		button:SizeToContents()
		button.DoClick = function(this)
			if (self.selected != this) then
				self.selected = this
				this.selected = true
				self:LoadRecipes(realName)
				timer.Simple(0.01, function()
					self.scroll:InvalidateLayout()
				end)
			end
		end
		button.category = realName

		if (first) then
			self.selected = button
			button.selected = true 
			first = false
		end

		self.categoryPanels[realName] = button
	end

	local exit = self.categories:Add("qMenuButton")
	exit:SetText("Закрыть")
	exit:SizeToContents()
	exit:SetWide(self.categories:GetWide())
	exit:SetPos(0, ScrH() - exit:GetTall())
	exit.DoClick = function()
		self:Remove()
	end

	if (self.selected) then
		self:LoadRecipes(self.selected.category)
	end
end

function PANEL:Think()
	for k, v in pairs(self.categoryPanels) do
		if k != self.selected.category then
			v.selected = false
		end
	end
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(45, 52, 54, 255)
	surface.DrawRect(0, 0, width, height)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.SetTexture(gradientUp)
	surface.DrawTexturedRect(0, 0, width, height)

	derma.SkinFunc("PaintMenuBackground", self, width, height, self.currentBlur)

	surface.SetDrawColor(ix.config.Get("color"))
	surface.DrawRect((width * 0.15) + 5, 0, 2, height)
end

function PANEL:LoadRecipes(category, search)
	category = category	or "Crafting"
	local recipes = PLUGIN.craft.recipes

	self.scroll:Clear()
	self.scroll:InvalidateLayout(true)

	for uniqueID, recipeTable in SortedPairsByMemberValue(recipes, "name") do
		if (recipeTable:OnCanSee(LocalPlayer()) == false) then
			continue
		end

		if (recipeTable.category == category) then
			-- if (search and search != "" and !L(recipeTable.name):lower():find(search, 1, true)) then
			-- 	continue
			-- end

			local recipeButton = self.scroll:Add("ixCraftingRecipe")
			recipeButton:SetRecipe(recipeTable)
			recipeButton:SetHelixTooltip(function(tooltip)
				PLUGIN:PopulateRecipeTooltip(tooltip, recipeTable)
			end)
		end
	end
end

vgui.Register("ixCrafting", PANEL, "EditablePanel")

-- net.Receive("ixCraftRefresh", function()
-- 	local craftPanel = ix.gui.crafting

-- 	if (IsValid(craftPanel)) then
-- 		craftPanel.search:OnChange()
-- 	end
-- end)
