/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "Quarantine" -- Category


VJ.AddNPC_HUMAN("Overwatch Soldier","npc_vj_overwatch_soldier",{"weapon_vj_ar2","weapon_vj_smg1"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Overwatch Shotgun Soldier","npc_vj_overwatch_shotgun_soldier",{"weapon_vj_spas12"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Overwatch Elite Soldier","npc_vj_overwatch_elite_soldier",{"weapon_vj_ar2"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Overwatch Prison Guard","npc_vj_overwatch_prison_guard",{"weapon_vj_ar2","weapon_vj_smg1"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("C.D.F. Soldier","npc_vj_overwatch_shotgun_prison_guard",{"weapon_vj_m16a1"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Metro-Cop","npc_vj_metro-cop",{"weapon_vj_9mmpistol","weapon_vj_smg1"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Bandit","npc_vj_elite_metro-cop",{"weapon_vj_glock17","weapon_vj_m16a1"},vCat) -- Add a human SNPC to the spawnlist