ITEM.name = "Пэйджер"
ITEM.model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Электроника"
ITEM.price = 15
ITEM.bDropOnDeath = true

function ITEM:GetDescription()
	local str
	
	if (!self.entity or !IsValid(self.entity)) then
		str = "Пэйджер позволяет вам переписываться с другими людьми на расстоянии.\nСостояние: %s\nЧастота: %s"
		return Format(str, (self:GetData("power") and "On" or "Off"), self:GetData("freq", "000.0"))
	else
		local data = self.entity:GetData()
		
		str = "Пэйджер позволяет вам переписываться с другими людьми на расстоянии. Состояние: %s Частота: %s"
		return Format(str, (self.entity:GetData("power") and "On" or "Off"), self.entity:GetData("freq", "000.0"))
	end
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("power")) then
			surface.SetDrawColor(110, 255, 110, 100)
		else
			surface.SetDrawColor(255, 110, 110, 100)
		end

		surface.DrawRect(w - 14, h - 14, 8, 8)
	end
end

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.Toggle = { -- sorry, for name order.
	name = "Переключить",
	tip = "useTip",
	icon = "icon16/connect.png",
	OnRun = function(item)
		item:SetData("power", !item:GetData("power", false), nil, nil, true)
		item.player:EmitSound("buttons/button14.wav", 70, 150)

		return false
	end,
}

ITEM.functions.Use = { -- sorry, for name order.
	name = "Частота",
	tip = "useTip",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		netstream.Start(item.player, "radioAdjust", item:GetData("freq", "000,0"), item.id)

		return false
	end,
}
