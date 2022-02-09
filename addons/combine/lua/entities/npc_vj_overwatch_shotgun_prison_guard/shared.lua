ENT.Base 			= "npc_vj_human_base" -- Full list of bases is in the base, or go back to this link and read the list: https://saludos.sites.google.com/site/vrejgaming/makingvjbaseaddon
ENT.Type 			= "ai"
ENT.PrintName 		= "Soldier"
ENT.Author 			= "SOMEBODY SAY HO!"
ENT.Contact 		= "http://steamcommunity.com/profiles/76561198180831682/"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Combine"

if (CLIENT) then
	local Name = "Overwatch Shotgun Prison Guard"
	local LangName = "npc_vj_overwatch_shotgun_prison_guard"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local text = container:AddRow("name")
		text:SetImportant()
		text:SetText("Солдат")
		text:SizeToContents()

		local text2 = container:AddRow("description")
		text2:SetText("Военнослужащий в черной форме с надписью 'C.D.F'. ПМК-противогаз. Баллистический шлем 'Спартанец' с защитой ушей, мягкими вкладышами. Пояс с многочисленными карманами. На спине прибор очистителя воздуха закрытого типа.")
		text2:SizeToContents()
	end
end