local plugin = PLUGIN

ITEM.name = "Рация"
ITEM.model = "models/themask/sbmp/electronics_items/walkie_talkies/walkie_talkie.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Электроника"
ITEM.price = 30
ITEM.bDropOnDeath = true

function ITEM:GetDescription()
	local str
	
	if (!self.entity or !IsValid(self.entity)) then
		str = "Рация, которая позволяет посылать сигнал другим людям на расстоянии.\nСостояние: %s\nЧастота: %s"
		return Format(str, (self:GetData("power") and "On" or "Off"), self:GetData("freq", "000.0"))
	else
		local data = self.entity:GetData()
		
		str = "Функциональная рация. Состояние: %s Частота: %s"
		return Format(str, (self.entity:GetData("power") and "On" or "Off"), self.entity:GetData("freq", "000.0"))
	end
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("power", false)) then
			surface.SetDrawColor(110, 255, 110, 100)
		else
			surface.SetDrawColor(255, 110, 110, 100)
		end

		surface.DrawRect(w - 14, h - 14, 8, 8)
	end

	function ITEM:PopulateTooltip(tooltip)
	    local data = tooltip:AddRowAfter("name", "data")
	    data:SetBackgroundColor(Color(100, 0, 0, 255))
	    data:SetText("Подсказка: чтобы говорить по рации, пропишите: /r; нажмите «T» и говорите.")
	    data:SetHeight(3)
	    data:SetExpensiveShadow(0.5)
	    data:SizeToContents()
	end

	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	local COLOR_ACTIVE = Color(0, 255, 0)
	local COLOR_INACTIVE = Color(255, 0, 0)

	function ITEM:DrawEntity(entity, item)
		entity:DrawModel()
		local rt = RealTime()*100
		local position = entity:GetPos() + entity:GetForward() * 0 + entity:GetUp() * 2 + entity:GetRight() * 0

		if (entity:GetData("power", false) == true) then
			if (math.ceil(rt/14)%10 == 0) then
				render.SetMaterial(GLOW_MATERIAL)
				render.DrawSprite(position, rt % 14, rt % 14, entity:GetData("power", false) and COLOR_ACTIVE or COLOR_INACTIVE)
			end
		end
	end
else
	/*
	function ITEM:OnRestored(item, invID)
		print("OnRestored", item.player)
		if IsValid(item.player) then
			local toggle = item:GetData("power", false)
			local freq = item:GetData("freq", "000.0")

			plugin.CanSay[freq] = plugin.CanSay[freq] or {}
			if toggle then
				plugin.CanSay[freq][item.player] = true
			end
		end
	end*/

	ITEM:Hook("drop", function(item)
		if IsValid(item.player) then
			local freq = item:GetData("freq", "000.0")

			plugin.CanSay[freq] = plugin.CanSay[freq] or {}
			plugin.CanSay[freq][item.player] = nil
		end
	end)
	ITEM:Hook("take", function(item)
		if IsValid(item.player) then
			local toggle = item:GetData("power", false)
			local freq = item:GetData("freq", "000.0")

			plugin.CanSay[freq] = plugin.CanSay[freq] or {}
			if toggle then
				plugin.CanSay[freq][item.player] = true
			end
		end
	end)

end

ITEM.functions.Toggle = {
	name = "Переключить",
	tip = "useTip",
	icon = "icon16/connect.png",
	OnRun = function(item)
		local toggle = !item:GetData("power", false)
		item:SetData("power", toggle, player.GetAll(), false, true)
		item.player:EmitSound("buttons/button14.wav", 70, 150)

		local freq = item:GetData("freq", "000.0")

		plugin.CanSay[freq] = plugin.CanSay[freq] or {}
		if toggle then
			plugin.CanSay[freq][item.player] = true
		else
			plugin.CanSay[freq][item.player] = nil
		end

		return false
	end,
}

ITEM.functions.Frequency = {
	name = "Частота",
	tip = "useTip",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		local freq = item:GetData("freq", "000.0")
		netstream.Start(item.player, "radioAdjust", freq, item.id)

		return false
	end,
}
