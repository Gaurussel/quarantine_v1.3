if CLIENT then return end

if fastfarm2.EnableResourceAddfile then

	fastfarm3 = fastfarm3 || {}

	function fastfarm3.AddDir( path )
        local files, folders = file.Find( path .. "/*", "GAME" )
        for k, v in pairs( files ) do
            resource.AddFile( path .. "/" .. v )
        end
        for k, v in pairs( folders ) do
            fastfarm3.AddDir( path .. "/" .. v )
        end
	end

	fastfarm3.AddDir("models/oldbill")
	fastfarm3.AddDir("models/custom_models/sterling")
	fastfarm3.AddDir("materials/models/oldbill")
	fastfarm3.AddDir("materials/models/custom_models/sterling")
	fastfarm3.AddDir("materials/models/sterling")	
else
	resource.AddWorkshop( "1163268752" )
end