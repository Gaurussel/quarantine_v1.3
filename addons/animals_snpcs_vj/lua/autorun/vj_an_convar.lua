/*--------------------------------------------------
	=============== Flesh Zombies ConVars ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load ConVars for Flesh Zombies
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
-------------------------------------------------------------------
local AddConvars = {}

AddConvars["vj_crocodile_h"] = 860
AddConvars["vj_crocodile_d"] = 75

AddConvars["vj_anaconda_h"] = 950
AddConvars["vj_anaconda_d"] = 60

AddConvars["vj_bear_h"] = 650
AddConvars["vj_bear_d"] = 55

AddConvars["vj_lion_h"] = 360
AddConvars["vj_lion_d"] = 60

AddConvars["vj_el_h"] = 1660
AddConvars["vj_el_d"] = 110

AddConvars["vj_jaguar_h"] = 140
AddConvars["vj_jaguar_d"] = 50

AddConvars["vj_leopard_h"] = 170
AddConvars["vj_leopard_d"] = 55

AddConvars["vj_rhino_h"] = 900
AddConvars["vj_rhino_d"] = 120

AddConvars["vj_monkey_h"] = 20
AddConvars["vj_monkey_d"] = 3

AddConvars["vj_turtle_h"] = 240

AddConvars["vj_puma_h"] = 280
AddConvars["vj_puma_d"] = 52

AddConvars["vj_turtle_h"] = 240

AddConvars["vj_ttiger_h"] = 760
AddConvars["vj_ttiger_d"] = 82

AddConvars["vj_cobra_h"] = 76
AddConvars["vj_cobra_d"] = 20

AddConvars["vj_goat_h"] = 45
AddConvars["vj_goat_d"] = 18

AddConvars["vj_lynx_h"] = 40
AddConvars["vj_lynx_d"] = 15

AddConvars["vj_lionf_h"] = 180
AddConvars["vj_lionf_d"] = 50

AddConvars["vj_an_deer_h"] = 70


for k, v in pairs(AddConvars) do
	if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_NONE} ) end
end