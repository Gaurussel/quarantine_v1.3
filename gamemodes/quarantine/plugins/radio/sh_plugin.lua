local plugin = PLUGIN

PLUGIN.name = "Radio"
PLUGIN.author = "Black Tea | Koyomi Araragi for Helix (G-Vector)"
PLUGIN.desc = "You can communicate with other people in distance."

if SERVER then
	PLUGIN.CanHear = {}
	PLUGIN.CanSay = {}

	function PLUGIN:PlayerLoadedCharacter(client, char)
		for k,v in pairs(self.CanHear) do
			if v[client] then
				v[client] = nil
			end
		end
		for k,v in pairs(self.CanSay) do
			if v[client] then
				v[client] = nil
			end
		end

		for k,item in pairs(char:GetInventory():GetItems()) do
			if item.uniqueID == "radio" and item:GetData("power", false) then
				local freq = item:GetData("freq", "000.0")
				self.CanSay[freq] = self.CanSay[freq] or {}
				self.CanSay[freq][client] = true
			end
		end
	end
end

local RADIO_CHATCOLOR = Color(100, 255, 50)

ix.lang.AddTable("english", {
	radioFreq = "Frequency",
	radioSubmit = "Submit",
	radioNoRadio = "You don't have any radio to adjust.",
	radioNoRadioComm = "You don't have any radio to communicate",
	radioFormat = "%s radios in \"%s\"",
})

ix.lang.AddTable("russian", {
	radioFreq = "Частота",
	radioSubmit = "Подтвердить",
	radioNoRadio = "У вас нет радио для настройки.",
	radioNoRadioComm = "У вас нет радио, что бы общаться",
	radioFormat = "%s сказал по рации \"%s\"",
})

if (CLIENT) then
	local PANEL = {}
	function PANEL:Init()
		self.number = 0
		self:SetWide(70)

		local up = self:Add("DButton")
		up:SetFont("Marlett")
		up:SetText("t")
		up:Dock(TOP)
		up:DockMargin(2, 2, 2, 2)
		up.DoClick = function(this)
			self.number = (self.number + 1)% 10
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		local down = self:Add("DButton")
		down:SetFont("Marlett")
		down:SetText("u")
		down:Dock(BOTTOM)
		down:DockMargin(2, 2, 2, 2)
		down.DoClick = function(this)
			self.number = (self.number - 1)% 10
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		local number = self:Add("Panel")
		number:Dock(FILL)
		number.Paint = function(this, w, h)
			draw.SimpleText(self.number, "ixDialFont", w/2, h/2, color_white, 1, 1)
		end
	end

	vgui.Register("ixRadioDial", PANEL, "DPanel")

	PANEL = {}

	function PANEL:Init()
		self:SetTitle(L("radioFreq"))
		self:SetSize(330, 220)
		self:Center()
		self:MakePopup()

		self.submit = self:Add("DButton")
		self.submit:Dock(BOTTOM)
		self.submit:DockMargin(0, 5, 0, 0)
		self.submit:SetTall(25)
		self.submit:SetText(L("radioSubmit"))
		self.submit.DoClick = function()
			local str = ""
			for i = 1, 5 do
				if (i != 4) then
					str = str .. tostring(self.dial[i].number or 0)
				else
					str = str .. "."
				end
			end
			netstream.Start("radioAdjust", str, self.itemID)

			self:Close()
		end

		self.dial = {}
		for i = 1, 5 do
			if (i != 4) then
				self.dial[i] = self:Add("ixRadioDial")
				self.dial[i]:Dock(LEFT)
				if (i != 3) then
					self.dial[i]:DockMargin(0, 0, 5, 0)
				end
			else
				local dot = self:Add("Panel")
				dot:Dock(LEFT)
				dot:SetWide(30)
				dot.Paint = function(this, w, h)
					draw.SimpleText(".", "ixDialFont", w/2, h - 10, color_white, 1, 4)
				end
			end
		end
	end

	function PANEL:Think()
		self:MoveToFront()
	end

	vgui.Register("ixRadioMenu", PANEL, "DFrame")

	surface.CreateFont("ixDialFont", {
		font = "Agency FB",
		size = 100,
		weight = 1000
	})

	surface.CreateFont("ixRadioFont", {
		font = "Lucida Sans Typewriter",
		size = math.max(ScreenScale(7), 17),
		weight = 100
	})

	netstream.Hook("radioAdjust", function(freq, id)
		local adjust = vgui.Create("ixRadioMenu")

		if (id) then
			adjust.itemID = id
		end

		if (freq) then
			for i = 1, 5 do
				if (i != 4) then
					adjust.dial[i].number = tonumber(freq[i])
				end
			end
		end
	end)

	local keyTPressed = false
	function PLUGIN:Tick()
		if !keyTPressed then
			if input.IsKeyDown(KEY_T) and !ix.gui.chat:GetActive() then
				local power_on = false
				local char = LocalPlayer():GetCharacter()
				if char then
					for k,v in pairs(char:GetInventory():GetItems()) do
						if v.uniqueID == "radio" and v:GetData("power", false) then
							power_on = true
							break
						end
					end
				end
				if power_on then
					keyTPressed = true
					netstream.Start("radio.toggle", true)
					permissions.EnableVoiceChat(true)
				else
					keyTPressed = false
					netstream.Start("radio.toggle", false)
					permissions.EnableVoiceChat(false)
				end
			end
		elseif !input.IsKeyDown(KEY_T) then
			keyTPressed = false
			netstream.Start("radio.toggle", false)
			permissions.EnableVoiceChat(false)
		end
	end
else
	netstream.Hook("radioAdjust", function(client, freq, id)
		local inv = (client:GetCharacter() and client:GetCharacter():GetInventory() or nil)

		if (inv) then
			local item

			if (id) then
				item = ix.item.instances[id]
			else
				item = inv:HasItem("radio")
			end

			local ent = item:GetEntity()

			if (item and (IsValid(ent) or item:GetOwner() == client)) then
				(ent or client):EmitSound("buttons/combine_button1.wav", 50, 170)
				local oldfreq = item:GetData("freq", "000.0")
				item:SetData("freq", freq)

				plugin.CanSay[oldfreq] = plugin.CanSay[oldfreq] or {}
				plugin.CanSay[oldfreq][client] = nil

				local toggle = item:GetData("power", false)
				// item.player

				if !freq then
					ErrorNoHalt("freq nil value.")
				end

				if toggle then
					plugin.CanSay[freq][client] = true 
				end
			else
				client:NotifyLocalized("radioNoRadio")
			end
		end
	end)

	local inradio = {}

	netstream.Hook("radio.toggle", function(ply, bool)
		inradio[ply] = bool
	end)

	function PLUGIN:ixPlayerCanHearPlayersVoice(listener, speaker)
		if !inradio[speaker] then return end

		for k,v in pairs(self.CanSay) do
			if v[speaker] and v[listener] then
				return true, false
			end
		end
	end

	local nextTick = 0
	function PLUGIN:Tick()
		if nextTick > CurTime() then return end
		nextTick = CurTime() + 0.5

		self.CanHear = {}
		
		for k,v in ipairs(ents.FindByClass("ix_item")) do
			if v:GetItemID() == "sradio" then
				local frenq = v:GetData("freq", "000.0")
				self.CanHear[frenq] = self.CanHear[frenq] or {}
				table.Merge(self.CanHear[frenq], v.CanHear or {})
			end
		end
		table.Merge(self.CanHear, self.CanSay)
	end
end

-- Yelling out loud.
local find = {
	["radio"] = false,
	["sradio"] = true
}
local function endChatter(listener)
	timer.Simple(1, function()
		if (!listener:IsValid() or !listener:Alive() or hook.Run("ShouldRadioBeep", listener) == false) then
			return false
		end

		listener:EmitSound("npc/metropolice/vo/off"..math.random(1, 3)..".wav", math.random(60, 70), math.random(80, 120))
	end)
end

ix.chat.Register("radio", {
	format = "%s говорит в рацию: \"%s\"",
	font = "ixRadioFont",
	GetColor = function(self, speaker, text)
		return RADIO_CHATCOLOR
	end,
	CanHear = function(self, speaker, listener)
		local dist = speaker:GetPos():Distance(listener:GetPos())
		local speakRange = ix.config.Get("chatRange", 280)

		if (dist <= speakRange) then
			return true
		end

		for k,v in pairs(plugin.CanHear) do
			if v[speaker] and v[listener] then
				return true
			end
		end

		return false
	end,
	CanSay = function(self, speaker, text)
		for k,v in pairs(plugin.CanSay) do
			if v[speaker] then
				return true
			end
		end
		
		return false
	end,
	prefix = {"/r", "/radio"},
	deadCanChat = false,
	indicator = "Speak in radio",
})
