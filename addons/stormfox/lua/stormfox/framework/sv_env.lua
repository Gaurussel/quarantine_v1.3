--[[-------------------------------------------------------------------------
 	Handles mapentities and entity functions

 	Get entities
	 	StormFox.GetSkyPaint()	returns env_skypaint
	 	StormFox.GetSun()		returns env_sun

	Map Bloom
		StormFox.SetMapBloom(n)

	Shadow
		StormFox.SetShadowColor(col)
		StormFox.SetShadowAngle(ang,forceday)
		StormFox.SetShadowDistance(dis)
		StormFox.SetShadowDisable(bool)

	Sun
		StormFox.DebugSun() -- Returns sun position

	Maplight
		StormFox.SetMapLight(0-100)

 ---------------------------------------------------------------------------]]
local round,clamp = math.Round,math.Clamp

--[[ The entity is sadly broken after saving it.
-- Support unamed entities 

local con = GetConVar("sf_enable_mapsupport")
local con2 = GetConVar("sf_block_lightenvdelete")
local function SetNameFix( ent )
	if not IsValid(ent) then return end
	if ent:GetClass() == "light_environment" then
		if con and not con:GetBool() then return end
		if con2 and not con2:GetBool() then return end
		if (ent:GetName() or "") == "" then
			print("SF SET TARGET CAUSE NAME IS " .. ent:GetName())
			--ent:SetKeyValue("targetname", "lightenv")

			ent.targetname_set = true
		end
	end
end
hook.Add("OnEntityCreated", "SF-Unnamedentities compatibility", SetNameFix)]]

-- Scan/create mapentities
	local function GetOrCreate(str)
		local l = ents.FindByClass(str)
		local con = GetConVar("sf_enable_mapsupport")
		if #l > 0 then return l[1] end
		if not con:GetBool() then return end -- Disabled mapsupport
		local ent = ents.Create(str)
		ent:Spawn();
		ent:Activate();
		print("[StormFox] Creating " .. str)
		return ent
	end

	local function printEntFoundStatus( bFound, sEntClass )
		local created = bFound and bFound.targetname_set or false
		local sStatus = created and "Locked" or (bFound and "OK" or "Not Found")

		local cStatusColor = created and Color(155,155,255) or (bFound and Color( 0, 255, 0 ) or Color( 255, 0, 0 ))
	 	MsgC( "	", Color(255,255,255), sEntClass, " ", cStatusColor, sStatus, Color( 255, 255, 255), "\n" )
		StormFox.SetNetworkData( "has_" .. sEntClass, IsValid(bFound) )
	end

	local function FindEntities()
		print( "[StormFox] Scanning mapentities ..." )
		local con = GetConVar("sf_enable_mapsupport")
		if con and con:GetBool() then
			local tSunlist = ents.FindByClass( "env_sun" )
			for i = 1, #tSunlist do -- Remove any env_suns, there should be only one but who knows
				tSunlist[ i ]:Fire( "TurnOff" )
				SafeRemoveEntity( tSunlist[ i ] )
			end
		end
		StormFox.light_environment = ents.FindByClass( "light_environment" )[1] or nil-- ents.FindByName("lightenv")[1] or nil
		StormFox.light_environments = ents.FindByClass( "light_environment" ) or {}
		StormFox.env_fog_controller = StormFox.env_fog_controller or GetOrCreate( "env_fog_controller" ) or nil
		StormFox.shadow_control = StormFox.shadow_control or ents.FindByClass( "shadow_control" )[1] or nil
		StormFox.env_tonemap_controller = StormFox.env_tonemap_controller or ents.FindByClass("env_tonemap_controller")[1] or nil
		StormFox.env_wind = StormFox.env_wind or ents.FindByClass("env_wind")[1] or nil

		local con = GetConVar("sf_skybox")
		if con or con:GetBool() then
			StormFox.env_skypaint = GetOrCreate("env_skypaint") or nil
		end

		printEntFoundStatus( StormFox.light_environment, "light_environment" )
		printEntFoundStatus( StormFox.env_skypaint, "env_skypaint" )
		printEntFoundStatus( StormFox.env_fog_controller, "env_fog_controller" )
		printEntFoundStatus( StormFox.env_tonemap_controller, "env_tonemap_controller" )
		printEntFoundStatus( StormFox.shadow_control, "shadow_control" )

		hook.Call( "StormFox.PostEntityScan" )
	end
	hook.Add( "StormFox.PostEntity", "StormFox.ScanForEntities", FindEntities )

-- ConVar value
	local con = GetConVar("sf_sunmoon_yaw")
	function StormFox.GetSunMoonAngle()
		return con and con:GetFloat() or 270
	end

-- Shadow
	function StormFox.SetShadowColor( cColor )
		if not IsValid(StormFox.shadow_control) then return end
		StormFox.shadow_control:SetKeyValue( "color", cColor.r .. " " .. cColor.g .. " " .. cColor.b )
	end

	function StormFox.SetShadowAngle( nShadowPitch )
		if not StormFox.shadow_control then return end
		nShadowPitch = (nShadowPitch + 180) % 360
		-- min 190 max 350
		local sAngleString = ( nShadowPitch + 180 ) .. " " .. StormFox.GetSunMoonAngle() .. " " .. 0 .. " "
		StormFox.shadow_control:Fire( "SetAngles" , sAngleString , 0 )
	end

	function StormFox.SetShadowDistance( dis )
		if not StormFox.shadow_control then return end
		StormFox.shadow_control:SetKeyValue( "SetDistance", dis )
	end

	function StormFox.SetShadowDisable( bool )
		if not StormFox.shadow_control then return end
		StormFox.shadow_control:SetKeyValue( "SetShadowsDisabled", bool and 1 or 0 )
	end

-- MapBloom
	local nbloom
	local bloom = (GetConVar("sf_mapbloom") and GetConVar("sf_mapbloom"):GetFloat() or 0 ) or 0
	cvars.AddChangeCallback( "sf_mapbloom", function( _, _, sNewValue )
		bloom = tonumber( sNewValue ) or 0
	end, "StormFox_MapBloomChanged" )
	function StormFox.SetMapBloom(n)
		if bloom <= 0 or (nbloom and nbloom == n) then
			return
		end
		nbloom = n
		if not IsValid(StormFox.env_tonemap_controller) then return end
		StormFox.env_tonemap_controller:Fire("SetBloomScale",n)
	end
	local nbloom
	function StormFox.SetMapBloomAutoExposureMin(n)
		if bloom <= 0 or (nbloom and nbloom == n) then
			return
		end
		nbloom = n
		if not IsValid(StormFox.env_tonemap_controller) then return end
		StormFox.env_tonemap_controller:Fire("SetAutoExposureMin",n)
	end
	local nbloom
	function StormFox.SetMapBloomAutoExposureMax(n)
		if bloom <= 0 or (nbloom and nbloom == n) then
			return
		end
		nbloom = n
		if not IsValid(StormFox.env_tonemap_controller) then return end
		StormFox.env_tonemap_controller:Fire("SetAutoExposureMax",n)
	end
	local nbloom2
	function StormFox.SetBlendTonemapScale(target,duration)
		if bloom <= 0 then return end
		local str = target .. " " .. duration
		if nbloom2 and nbloom2 == str then
			return
		end
		if not IsValid(StormFox.env_tonemap_controller) then return end
		StormFox.env_tonemap_controller:Fire("BlendTonemapScale",str)
	end
	local nscale
	function StormFox.SetTonemapScale(n,dur)
		if bloom <= 0 then return end
		if nscale and nscale == n then
			return
		end
		nscale = n
		if not IsValid(StormFox.env_tonemap_controller) then return end
		StormFox.env_tonemap_controller:Fire("SetTonemapScale",n .. " " .. (dur or 0))
	end

-- Maplight
	local oldls = "-"
	local con = GetConVar("sf_enable_ekstra_lightsupport")
	local blockSpam = SysTime() + 30
	hook.Add("StormFox.PostEntityScan","StormFox - FixMapBlackness",function()
		blockSpam = SysTime() + 10
	end)
	local conc = GetConVar("sf_enable_ekstra_entsupport")
	local function WakeAllEntites()
		if not conc then return end
		if not conc:GetBool() then return end
		for k,v in pairs(ents.GetAll()) do
			local p = v:GetPhysicsObject()
			if IsValid(p) then
				p:Wake()
			end
		end
	end
	function StormFox.SetMapLight(light) -- 0-100
		if not light then return end
		if blockSpam > SysTime() then return end
		local getChar = string.char(97 + round(clamp(light,0,100) / 4)) -- a - z
		local getChar_rev = string.char(97 + round(clamp(100 - light,0,100) / 4)) -- a - z
		--oldls = getChar
		if oldls ~= getChar then
			if con:GetBool() then
				if light < 4 then
					engine.LightStyle(0,"b")
				else
					engine.LightStyle(0,getChar)
				end
				WakeAllEntites() -- Bad bad BAD hack. But entnties don't update their light for some odd reason.
			end
			for _,light in ipairs(StormFox.light_environments or {}) do
				light:Fire("FadeToPattern", getChar ,0)
				if getChar == "a" then
					light:Fire("TurnOff","",0)
				else
					light:Fire("TurnOn","",0)
				end
				light:Activate()
			end
			StormFox.SetNetworkData("MapLightChar",getChar)
			oldls = getChar
		end
	end

-- MapWind
	function StormFox.SetMinWind(n)
		if not StormFox.env_wind then return false end
		StormFox.env_wind:Fire("Min normal speed",n)
		return true
	end
	function StormFox.SetMaxWind(n)
		if not StormFox.env_wind then return false end
		StormFox.env_wind:Fire("Max normal speed",n)
		return true
	end

-- Support for envcitys sky-entity
	hook.Add("StormFox.PostEntity","StormFox.StopWhiteBoxes",function()
		local skyCam = ents.FindByClass("sky_camera")[1] or nil
		if not IsValid(skyCam) then return end
		local tr = util.QuickTrace(skyCam:GetPos(),Vector(0,0,-1000))
		if not tr.Entity or not IsValid(tr.Entity) then return end
		if tr.Entity:GetClass() == "func_brush" and not tr.Entity:IsWorld() then
			SafeRemoveEntity(tr.Entity) -- just to be safe
		end
	end)