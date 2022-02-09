PLUGIN.name = "Global map"
PLUGIN.author = "STEAM_0:1:29606990"
PLUGIN.description = ""
if (SERVER) then return end

local draw, surface, TEXT_ALIGN_CENTER = draw, surface, TEXT_ALIGN_CENTER
local SH_SZ = SH_SZ

ix.map = ix.map or {
	texture = Material("game/rp_quarantine_v2.jpg"),
	objects = {},
	gui = {
		map = nil,
		label = nil
	},
	signs = { "➕", "☣", "☢", "ϟ", "☦", "☠", "☭", "⚠", "✖", "✔" },
	default_color = Color(255, 255, 255)
}

local map = {}
function map.Generate()
	-- Thanks Dakota0001

	local mapBoundsMax = select(2, game.GetWorld():GetModelBounds())
	local uptrace = util.TraceLine({
		start = vector_origin,
		endpos = vector_origin + Vector(0,0,mapBoundsMax.z),
		mask = MASK_NPCWORLDSTATIC
	}).HitPos

	local startpos = Vector(0, 0, uptrace.z)
	local endX, endY = Vector(mapBoundsMax.x, 0, 0), Vector(0, mapBoundsMax.y, 0)

	local rTrace = util.TraceLine({
		start = startpos,
		endpos = startpos + endY,
		mask = MASK_NPCWORLDSTATIC
	}).HitPos

	local lTrace = util.TraceLine({
		start = startpos,
		endpos = startpos - endY,
		mask = MASK_NPCWORLDSTATIC
	}).HitPos

	-- local fTrace = util.TraceLine({
		-- start = startpos,
		-- endpos = startpos + endX,
		-- mask = MASK_NPCWORLDSTATIC
	-- }).HitPos

	-- local bTrace = util.TraceLine({
		-- start = startpos,
		-- endpos = startpos - endX,
		-- mask = MASK_NPCWORLDSTATIC
	-- }).HitPos

	-- map.Center = (rTrace + lTrace + fTrace + bTrace) * 0.25
	-- map.Center.z = LocalPlayer():GetPos().z + 2500

	local MapSize = rTrace:Distance(lTrace) / 2

	map.SizeW = -MapSize
	map.SizeE = MapSize
	map.SizeS = -MapSize
	map.SizeN = MapSize

	map.SizeX = math.abs(map.SizeE + math.abs(map.SizeW))
	map.SizeY = math.abs(map.SizeN + math.abs(map.SizeS))

	ix.map.iconSize = math.Round((tonumber(32) / 2160) * ScrH(), 0)
	ix.map.ringSize = math.Round((tonumber(74) / 2160) * ScrH(), 0)

	-- pre-cache
	surface.SetFont("MapFont")
	local tw, th = surface.GetTextSize(ix.map.signs[1])

	ix.map.signSize = {tw*0.5, th*0.5}

	startpos, endX, endY, MapSize = nil, nil, nil, nil
	rTrace, lTrace = nil, nil--, fTrace, bTrace = nil, nil, nil, nil
	uptrace, mapBoundsMax = nil, nil
	tw, th = nil, nil

	collectgarbage()
end

function map.Save()
	timer.Create("ixGlobalMap", 5, 1, function()
		ix.data.Set("global_map", ix.map.objects)
	end)
end

function map.ToScreen(pos, w, h)
	local x = (map.SizeW > 0 and pos.x + map.SizeE or pos.x - map.SizeW)
	local y = (map.SizeS > 0 and pos.y + map.SizeN or pos.y - map.SizeS)

	-- Map borders
	return math.Clamp(x / map.SizeX * w, 0, w), h - math.Clamp(y / map.SizeY * h, 0, h)
end

function map.ToWorld(x, y, w, h)
	x = x * map.SizeX / w
	y = y * map.SizeY / h

	x = (map.SizeW > 0 and x - map.SizeE or x + map.SizeW)
	y = (map.SizeS > 0 and y - map.SizeN or y + map.SizeS)

	return Vector(x, -y, 0)
end

function map.Open()
	if (!map.SizeX) then map.Generate() end
	if (!LocalPlayer():GetCharacter() or !LocalPlayer():Alive()) then return end
	if (!LocalPlayer():GetCharacter():GetInventory():HasItem("map_city")) then return end
	if (IsValid(ix.map.gui.map)) then ix.map.gui.map:Remove() end

	local clr = nil
	local useText = "[ALT]"

	local frame = vgui.Create('DFrame')
	ix.map.gui.map = frame

	frame:SetSize(ScrH(), ScrH())
	frame:Center()
	frame:SetTitle(L("globalMapCursor", useText, L'globalMapCursorEnable'))

	frame:MakePopup()
	frame:SetMouseInputEnabled(false)
	frame:SetKeyboardInputEnabled(false)

	frame.lblTitle:SetFont("MapFont")
	frame.lblTitle.UpdateColours = function(label)
		return label:SetTextStyleColor(color_white)
	end

	frame.OnKeyCodeReleased = function(t, key_code)
		if (input.LookupKeyBinding(key_code) == "gm_showteam") then
			ix.map.gui.map = nil
			t:Remove()
		end
	end

	frame.Think = function(t)
		if (input.IsKeyDown(81) or input.IsKeyDown(82)) then
			if (!t.ctrl_pressed) then
				if (IsValid(t.dmenu)) then t.dmenu:Remove() t.dmenu = nil end

				t:SetMouseInputEnabled(!t:IsMouseInputEnabled())
				--t:SetKeyboardInputEnabled(!t:IsKeyboardInputEnabled())
				t.map:SetMouseInputEnabled(!t.map:IsMouseInputEnabled())
				t.map:SetKeyboardInputEnabled(!t.map:IsKeyboardInputEnabled())

				t:SetTitle(L("globalMapCursor", useText,
					t:IsMouseInputEnabled() and L'globalMapCursorDisable' or L'globalMapCursorEnable'))

				t.ctrl_pressed = true
			end
		elseif t.ctrl_pressed then
			t.ctrl_pressed = nil
		end
	end

	frame.map = frame:Add("EditablePanel")
	frame.map:Dock(FILL)
	frame.map.Paint = function(self, w, h)
		if (!self.current_index) then self:SetCursor("arrow") end

		surface.SetMaterial(ix.map.texture)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(0, 0, w, h)

		--draw.SimpleTextOutlined("Press ctrl to enable the mouse cursor", "MapFont", 5, 5, ColorAlpha(Color("gray"), 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black)

		y, x = map.ToScreen(LocalPlayer():GetPos(), w, h)
		y = h - y

		clr = ix.map.default_color

		draw.SimpleTextOutlined(L("globalMapYOU"), "MapFont", x, y - ix.map.iconSize, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined(ix.map.signs[1], "MapFont", x, y, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)

		for _, v in ipairs(ix.map.objects) do
			clr = v[2]
			x, y = map.ToScreen(v[3], w, h)

			if (self:MouseInRect(x, y, ix.map.signSize[1], ix.map.signSize[2])) then
				self:SetCursor(self.current_index and "blank" or "hand")

				clr = ix.color.Darken(clr, 25)
			end

			--local x1, y1 = map.ToScreen(LocalPlayer():GetPos(), w, h)
			--local dist = math.Round(math.Distance(x, y, x1, y1), 2)
			--if dist < 35 then
				draw.SimpleTextOutlined(v[1], "MapFont", x, y - ix.map.iconSize, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				draw.SimpleTextOutlined(ix.map.signs[1], "MapFont", x, y, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			--end
		end

		-- Отряд
		-- for _, v in ipairs(player.GetAll()) do
		-- 	if (IsValid(v) and v != LocalPlayer() and v:GetCharacter() and v:Alive()) then
		-- 		local sq = ix.squad.list[LocalPlayer():GetCharacter():GetSquadID()]
		-- 		if (sq and sq.members[v:SteamID64()]) then
		-- 			x, y = map.ToScreen(v:GetPos(), w, h)
		-- 			clr = ix.option.Get("squadTeamColor", Color(51, 153, 255))

		-- 			draw.SimpleTextOutlined(v:Name(), "MapFont", x, y - ix.map.iconSize, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		-- 		end
		-- 	end
		-- end

		-- зеленая зона
		y, x = map.ToScreen(Vector(-4554.852051, -9750.981445, -407.968750), w, h)
		y = h - y

		clr = Color("green")

		draw.SimpleTextOutlined("Зелёная Зона", "MapFont", x, y - (ix.map.iconSize/2), clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)

		-- миссии
		local missions = ix.plugin.list["ranks_system"].currentMissions
		for k, v in pairs(missions) do
			y, x = map.ToScreen(v, w, h)
			y = h - y

			clr = Color("orange")

			draw.SimpleTextOutlined("Доставка "..string.upper(k), "MapFont", x, y - ix.map.iconSize, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			draw.SimpleTextOutlined(ix.map.signs[1], "MapFont", x, y, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		end
	end

	function frame.map:MouseInRect(x, y, w, h)
		local mx, my = self:CursorPos()
		return (mx >= x - w and mx <= (x + w) and my >= y - h and my <= (y + h))
	end

	function frame.map:OnCursorMoved(mx, my)
		if (input.IsMouseDown(MOUSE_LEFT)) then
			local w, h = self:GetSize()
			self.current_index = self.current_index or nil

			if (!self.current_index) then
				for k, v in ipairs(ix.map.objects) do
					x, y = map.ToScreen(v[3], w, h)

					if (self:MouseInRect(x, y, ix.map.signSize[1], ix.map.signSize[2])) then
						self.current_index = k
						break
					end
				end
			else
				ix.map.objects[self.current_index][3] = map.ToWorld(mx, my, w, h)
				map.Save()
			end
		end
	end

	function frame.map:OnMouseReleased()
		self.current_index = nil
	end

	function frame.map:OnMousePressed(code)
		if (code == MOUSE_RIGHT) then
			local w, h = self:GetSize()
			local x, y = 0, 0

			local current_index

			for k, v in ipairs(ix.map.objects) do
				x, y = map.ToScreen(v[3], w, h)
				if (self:MouseInRect(x, y, ix.map.signSize[1], ix.map.signSize[2])) then
					current_index = k
					break
				end
			end

			local dmenu = DermaMenu()
			frame.dmenu = dmenu

			x, y = self:CursorPos()

			if (current_index) then
				dmenu:AddOption(L("Редактировать"), function()
					if (IsValid(ix.map.gui.label)) then ix.map.gui.label:Remove() end
					local data = ix.map.objects[current_index]

					ix.map.gui.label = vgui.Create("ixMapSetLabel")
					ix.map.gui.label:SetData(data[1], data[2], current_index)

					function ix.map.gui.label:DoneClick(text, color, index)
						ix.map.objects[index] = {text, color, map.ToWorld(x, y, w, h)}
						map.Save()
					end

					ix.map.gui.label = nil
				end):SetImage("icon16/wand.png")
				dmenu:AddSpacer()

				dmenu:AddOption(L("Удалить"), function()
					table.remove(ix.map.objects, current_index)
					current_index = nil
					map.Save()
				end):SetImage("icon16/exclamation.png")
			elseif (!IsValid(ix.map.gui.label)) then
				dmenu:AddOption(L("globalMapLabel"), function()
					ix.map.gui.label = vgui.Create("ixMapSetLabel")

					function ix.map.gui.label:DoneClick(text, color)
						ix.map.objects[#ix.map.objects + 1] = {text, color, map.ToWorld(x, y, w, h)}
						map.Save()
					end

					ix.map.gui.label = nil
				end):SetImage("icon16/attach.png")

				if (#ix.map.objects > 0) then
					dmenu:AddSpacer()

					dmenu:AddOption(L("Удалить?"), function()
						Derma_Query(L("globalMapDeleteLabelsConfirm", id), L("globalMapDeleteLabels"),
							L("no"), nil,
							L("yes"), function()
								ix.map.objects = {}
								map.Save()
							end
						)
					end):SetImage("icon16/bomb.png")
				end
			end

			dmenu:Open()
		end
	end
end

-- HOOKS
function PLUGIN:LoadFonts()
	surface.CreateFont("MapFont", {
		font = "Roboto",
		size = ix.util.ScreenScaleH(10),
		weight = 500,
	})

	surface.CreateFont("MapFont1", {
		font = "Roboto",
		size = ix.util.ScreenScaleH(9),
		weight = 100,
	})
end

function PLUGIN:ScreenResolutionChanged()
	map.SizeX = nil
end

function PLUGIN:InitPostEntity()
	map.Generate()
	ix.map.objects = ix.data.Get("global_map", {})
end

function PLUGIN:PlayerBindPress(_, bind, pressed)
	if (bind:find("gm_showteam") and pressed) then
		if (!IsValid(ix.map.gui.map)) then
			map.Open()
		else
			ix.map.gui.map:Remove()
		end

		return true
	end
end