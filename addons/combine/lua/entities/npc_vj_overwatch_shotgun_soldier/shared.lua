ENT.Base 			= "npc_vj_human_base" -- Full list of bases is in the base, or go back to this link and read the list: https://saludos.sites.google.com/site/vrejgaming/makingvjbaseaddon
ENT.Type 			= "ai"
ENT.PrintName 		= "Overwatch Shotgun Soldier"
ENT.Author 			= "SOMEBODY SAY HO!"
ENT.Contact 		= "http://steamcommunity.com/profiles/76561198180831682/"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Combine"

if (CLIENT) then
	local Name = "Overwatch Shotgun Soldier"
	local LangName = "npc_vj_overwatch_shotgun_soldier"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end