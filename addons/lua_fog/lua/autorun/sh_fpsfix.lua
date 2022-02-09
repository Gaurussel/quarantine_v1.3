globalFogDed = 4000
local TableCountFps = {
	[40]	=	4000,
	[41]	=	3950,
	[42]	=	3900,
	[43]	=	3850,
	[44]	=	3800,
	[45]	=	3750,
	[46]	=	3700,
	[47]	=	3650,
	[48]	=	3600,
	[49]	=	3550,
	[50]	=	3500,
	[51]	=	3450,
	[52]	=	3400,
	[53]	=	3350,
	[54]	=	3300,
	[55]	=	3250,
	[56]	=	3200,
	[57]	=	3150,
	[58]	=	3100,
	[59]	=	3050,
	[60]	=	3000,
	[61]	=	2950,
	[62]	=	2900,
	[63]	=	2850,
	[64]	=	2800,
	[65]	=	2750,
	[66]	=	2700,
	[67]	=	2650,
	[68]	=	2600,
	[69]	=	2550,
	[70]	=	2500,
	[71]	=	2450,
	[72]	=	2400,
	[73]	=	2350,
	[74]	=	2300,
	[75]	=	2250,
	[76]	=	2200,
	[77]	=	2150,
	[78]	=	2100,
	[79]	=	2050,
	[80]	=	2000,
}
timer.Create( "fpsoptdix", 2, 0, function()  
	if #player.GetAll()>40 and #player.GetAll()<80 then 
		globalFogDed = TableCountFps[#player.GetAll()]
	elseif #player.GetAll()>80 then
		globalFogDed = 2000
	elseif #player.GetAll()<40 then
		globalFogDed = 4000
	end
	if SERVER then 
		SetFpsFix(globalFogDed)
	end 
end )