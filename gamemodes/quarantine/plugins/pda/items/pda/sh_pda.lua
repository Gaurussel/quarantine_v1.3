ITEM.name = "КПК"
ITEM.model = "models/illusion/eftcontainers/gphone.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.5
ITEM.category = "Электроника"
ITEM.price = 1000
function ITEM:GetDescription()
	return "КПК, который позволяет общаться на больших расстоянии между отдельными людьми. Будучи новейшей версией серии КПК, это позволяет пользователю выбрать свое собственное имя пользователя." .. "\nТекущее имя пользователя: " .. self:GetData("nickname", "meme")
end

-- ITEM.functions.setavatar = { -- sorry, for name order.
-- 	name = "Select Avatar",
-- 	tip = "useTip",
-- 	icon = "icon16/stalker/customize.png",
-- 	OnRun = function(item)
-- 		item.player:RequestString("Set Avatar", "What avatar do you want this PDA to use? Select any material path.", function(text)
-- 			if text != "" then
-- 				item:SetData("avatar", text)
-- 				item:GetOwner():GetCharacter():SetData("pdaavatar", text)
-- 			end
-- 		end, item:GetData("avatar", "vgui/icons/face_31.png"))
-- 		return false
-- 	end,
-- 	OnCanRun = function(item)
-- 		local client = item.player

-- 		return !IsValid(item.entity) and IsValid(client)
-- 	end
-- }

ITEM.functions.setnickname = { -- sorry, for name order.
	name = "Установить имя пользователя",
	tip = "useTip",
	icon = "icon16/user_edit.png",
	OnRun = function(item)
		item.player:RequestString("Set Nickname", "Какое имя пользователя вы хотите использовать в этом КПК?", function(text)
			item:SetData("nickname", text)
			item:GetOwner():GetCharacter():SetData("pdanickname", text)
		end, item:GetData("nickname", item.player:Name()))
		return false
	end,
}

function ITEM:OnEquipped()
	self.player:GetCharacter():SetData("pdanickname", self:GetData("nickname", "lutz"))
end

function ITEM:OnUnEquipped()

end

function ITEM:OnInstanced()
	self:SetData("nickname", "NEW_USER")
end
