local plugin = PLUGIN

ITEM.name = "Стационарное радио"
ITEM.model = "models/props_lab/citizenradio.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.category = "Электроника"
ITEM.price = 50
ITEM.bDropOnDeath = true

local DESC = "Радио, которое позволяет вам слушать других людей на расстоянии.\n"
	.."Состояние: %s\n"
	.."Частота: %s"

function ITEM:GetDescription()
	return Format(
		DESC,
		self:GetData("power") and "On" or "Off",
		self:GetData("freq", "000.0")
	)
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

	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	local COLOR_ACTIVE = Color(0, 255, 0)
	local COLOR_INACTIVE = Color(255, 0, 0)

	function ITEM:DrawEntity(entity, item)
		entity:DrawModel()

		local position = entity:GetPos() + entity:GetForward() * 10 + entity:GetUp() * 11 + entity:GetRight() * 9.5
		local data = entity:GetData("power")

		render.SetMaterial(GLOW_MATERIAL)
		render.DrawSprite(position, 14, 14, data and COLOR_ACTIVE or COLOR_INACTIVE)
	end
else
	function ITEM:Think(entity)
		if entity.nextThink or 0 > CurTime() then return end
		entity.nextThink = CurTime() + 0.5
		entity.CanHear = {}
		if !entity:GetData("power", false) then return end
		for k,v in ipairs(ents.FindInSphere(entity:GetPos(), ix.config.Get("chatRange", 280))) do
			if v:IsPlayer() then
				entity.CanHear[v] = true
			end
		end
	end
end

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.Toggle = { -- sorry, for name order.
	name = "Переключить",
	tip = "useTip",
	icon = "icon16/connect.png",
	OnRun = function(item)
		item:SetData("power", not item:GetData("power", false))
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
