ITEM.name = "Устройство взлома"
ITEM.model = "models/props_lab/reciever01d.mdl"
ITEM.description = "Новейшая разработка ученых сил сопротивления, судя по всему, это устройство способно взламывать силовые поля и двери Альянса."
ITEM.price = 95
ITEM.quality = "Редкое"
ITEM.category = "Электроника"
ITEM.bDropOnDeath = true


ITEM.functions.Use = {
	name = "Взломать",
	OnRun = function(item)
		local tr = item.player:GetEyeTrace()
		print(tr.Entity)
		print("0")
		if IsValid(tr.Entity) then
			print("1")
			local button = tr.Entity
			local hackdevice = ents.Create("ix_hackdoor")
			hackdevice:SetPos(tr.HitPos)
			hackdevice:SetAngles(tr.HitNormal:Angle())
			hackdevice:Spawn()
			hackdevice:Activate()

			hackdevice:SetParent(button)
			hackdevice:Hack()
		end
	end,
	OnCanRun = function(item)
		local tr = item.player:GetEyeTrace()
		if IsValid(tr.Entity) then
			local button = tr.Entity

			if button:GetClass() == "class C_BaseEntity" or button:GetClass() == "func_button" then
				return true
			end
		end
		return false
	end,
	icon = "icon16/door.png",
}