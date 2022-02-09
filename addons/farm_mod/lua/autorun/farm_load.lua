/*-----------------------------------------------------------
Leak by Famouse
https://www.youtube.com/c/Famouse
https://discord.gg/N6JpA29 - More leaks
-------------------------------------------------------------*/
local function LoadAllFiles( fdir )

	local files,dirs = file.Find( fdir.."*", "LUA" )
	
	for _,file in ipairs( files ) do
		if string.match( file, ".lua" ) then

			if SERVER then AddCSLuaFile( fdir..file ) end
			include( fdir..file )
		end	
	end
	
	for _,dir in ipairs( dirs ) do
		LoadAllFiles( fdir..dir.."/" )
	
	end
	
end

LoadAllFiles( "farming/" )



/*-----------------------------------------------------------
Leak by Famouse
https://www.youtube.com/c/Famouse
https://discord.gg/N6JpA29 - More leaks
-------------------------------------------------------------*/