hook.Add( "SetupWorldFog", "FoxController", function()
	if globalFogDed then 
		render.FogMode( 1 ) 
		render.FogStart( globalFogDed-600 )
		render.FogEnd( globalFogDed -200 )
		render.FogMaxDensity( 1 )

		if StormFox.IsNight() then
			render.FogColor(30, 30, 30)
		else
			render.FogColor(200, 200, 200)
		end

		--local col = Vector(0.8,0.8,0.8)
		--render.FogColor( col.x * 255, col.y * 255, col.z * 255 )

		return true
	end
end )

hook.Add( "SetupSkyboxFog", "FoxControllerSky", function()
	if globalFogDed then 
		render.FogMode(MATERIAL_FOG_LINEAR)
		render.FogStart( (globalFogDed-600)/16-(200/16) )
		render.FogEnd( globalFogDed/16-(200/16)  )
		render.FogMaxDensity( 1 )

		if StormFox.IsNight() then
			render.FogColor(30, 30, 30)
		else
			render.FogColor(200, 200, 200)
		end

		-- local col = Vector(0.8,0.8,0.8)
		-- render.FogColor( col.x * 255, col.y * 255, col.z * 255 )

		return true
	end
end )