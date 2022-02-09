/*--------------------------------------------------
	=============== Dummy Autorun ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load autorun file for Dummy
--------------------------------------------------*/
-- Addon Information(Important!):
	local PublicAddonName = "Combine Soldiers and Metro-Cops on VJ Base"
	local AddonName = "Combine Soldiers and Metro-Cops on VJ Base"
	local AddonType = "SNPC"
-- Don't edit anything below this! ------------------------------------------------

local VJExists = "lua/autorun/vj_base_autorun.lua"

if( file.Exists( VJExists, "GAME" ) ) then
	include('autorun/vj_controls.lua')
	AddCSLuaFile("autorun/vj_fo3_autorun.lua")
	AddCSLuaFile("autorun/vj_fo3_convar.lua")
	AddCSLuaFile("autorun/vj_fo3_spawn.lua")
	VJ.AddAddonProperty(AddonName,AddonType)
end

if CLIENT then
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then
	chat.AddText(Color(0,200,200),PublicAddonName,
	Color(0,255,0)," was unable to install, you are missing ",
	Color(255,100,0),"VJ Base!"
	)
	end
end

timer.Simple(1,function()
	if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then
	if not VJF then
	if CLIENT then
	VJF = vgui.Create('DFrame')
	VJF:SetTitle("VJ Base is not installed")
	VJF:SetSize(900, 800)
	VJF:SetPos((ScrW() - VJF:GetWide()) / 2, (ScrH() - VJF:GetTall()) / 2)
	VJF:MakePopup()
	VJF.Paint = function()
	draw.RoundedBox( 8, 0, 0, VJF:GetWide(), VJF:GetTall(), Color( 200, 0, 0, 150 ) )
	end
	local VJURL = vgui.Create('DHTML')
	VJURL:SetParent(VJF)
	VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
	local x,y = VJF:GetSize()
	VJURL:SetSize(x*0.99,y*0.96)
	VJURL:SetAllowLua(true)
	VJURL:OpenURL('https://sites.google.com/site/vrejgaming/vjbasemissing')
	elseif SERVER then
	timer.Create("VJBASEMissing", 5, 0, function() print("VJ Base is Missing! Download it from the workshop!") end)
   end
  end
 end
end)

if SERVER then
	hook.Add("EntityFireBullets", "VJ.ShootsAngry", function(ent)
		if ent:IsPlayer() then
			if ent:GetCharacter():GetFaction() == FACTION_ARMY then return end
			for k, v in pairs(ents.FindInSphere(ent:GetPos(), 700)) do
				if v:GetClass() == "npc_vj_overwatch_shotgun_prison_guard" then
					v:VJ_DoSetEnemy(ent, true, false)

					timer.Create("resetenemy"..v:EntIndex(), 1, 300, function()
						if v:IsValid() then
							v:ResetEnemy(true)
						end
					end)
				end
			end
		end
	end)

	concommand.Add( "setvirus", function(ply)
		local items = ply:GetCharacter():GetInventory():GetItems()

        for k, v in pairs(items) do
            if v.uniqueID == "colbablood" and v:GetData("virus", 0) >= 1 then
                v:SetData("virus", ply:GetEyeTrace().Entity:GetData("virus", 1))
                v:SetData("nameV", ply:GetEyeTrace().Entity:Name())
                break
            end
        end
	end)

	concommand.Add( "setvirus2", function(ply)
		ply:GetEyeTrace().Entity:GetCharacter():SetData("Virus", 1)
	end)

	concommand.Add( "getclass", function(ply)
		local tr = ply:GetEyeTrace()
		print(tr.Entity:GetClass())
	end)

	concommand.Add( "getanimindex", function(ply)
		print(ply:GetSequence())
	end)

	concommand.Add( "setlevelchar", function(ply)
		if !ply:IsSuperAdmin() then return end
		ply:GetCharacter():SetLevel(10)
	end)

	concommand.Add("getitemspawnpoints", function(ply)
		local itempoints = (ix.plugin.list["sh_worlditemspawner"].itempoints)
		for k, v in pairs(itempoints) do
			print("["..k.."] = {")
			for _, v2 in pairs(v) do
				print("		[1] = Vector("..v2[1].."),")
				print("		[2] = "..v2[2])
				print("}\n")
			end
		end
		--PrintTable(ix.plugin.list)
	end)

	concommand.Add("givexp1", function(ply, cmd, args)
    	ix.XPSystem.AddXP(ply:GetEyeTrace().Entity, args[1])
	end)

	concommand.Add("giveattpoints", function(ply, cmd, args)
    	ply:GetEyeTrace().Entity:GetCharacter():SetPoints(ply:GetEyeTrace().Entity:GetCharacter():GetPoints() + args[1])
	end)

	hook.Add("PlayerDeath", "VJ.ResetEnemyArm", function(ply)
		for k, v in pairs(ents.FindByClass("npc_vj_overwatch_shotgun_prison_guard")) do
			if v:GetEnemy() == ply then
				v:ResetEnemy(true)
			end
		end
	end)

	hook.Add("CharacterLoaded", "VJ.ResetEnemyChar", function(char)
		for k, v in pairs(ents.FindByClass("npc_vj_overwatch_shotgun_prison_guard")) do
			if v:GetEnemy() == char:GetPlayer() then
				v:ResetEnemy(true)
			end
		end
	end)

	hook.Add("EntityTakeDamage", "VJ.AttackAngry", function(ent, dmginfo)
		local attacker = dmginfo:GetAttacker()

		if attacker:GetClass() == "npc_vj_overwatch_shotgun_prison_guard" then return end

		if (ent:IsPlayer() or ent:IsNPC()) and (attacker:IsPlayer() or attacker:IsNPC()) then
			if attacker:IsPlayer() and attacker:GetCharacter():GetFaction() == FACTION_ARMY then return end
			for k, v in pairs(ents.FindInSphere(ent:GetPos(), 700)) do
				if v:GetClass() == "npc_vj_overwatch_shotgun_prison_guard" then
					v:VJ_DoSetEnemy(attacker, true, false)

					timer.Create("resetenemy"..v:EntIndex(), 1, 300, function()
						if v:IsValid() then
							v:ResetEnemy(true)
						end
					end)
				end
			end
		end
	end)
end