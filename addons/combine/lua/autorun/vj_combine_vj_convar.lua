/*--------------------------------------------------
	=============== Dummy ConVars ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load ConVars for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
-------------------------------------------------------------------
local AddConvars = {}
AddConvars["npc_vj_overwatch_soldier_h"] = 100
AddConvars["npc_vj_overwatch_elite_soldier_h"] = 120
AddConvars["npc_vj_metro-cop_h"] = 80
AddConvars["npc_vj_elite_metro-cop_h"] = 85
AddConvars["npc_vj_overwatch_soldier_d"] = 20

for k, v in pairs(AddConvars) do
	if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_NONE} ) end
end