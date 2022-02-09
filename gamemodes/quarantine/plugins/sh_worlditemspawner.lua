local PLUGIN = PLUGIN
PLUGIN.name = "World Item Spawner"
PLUGIN.author = "Black Tea (Nutscript) | Gaurussel (helix)"
PLUGIN.desc = "World Item Spawner."
PLUGIN.itempoints = PLUGIN.itempoints or {}
PLUGIN.spawngroups = {
	["pistols"] = {
		{"cw_fiveseven"},
		{"cw_deagle"},
		{"cw_m1911"},
		{"cw_mr96"},
		{"cw_p99"},
		{"cw_makarov"},
		{"axe"},
		{"pipe"},
		{"hook"},
		{"brokenbottle"},
	},
	["pp"] = {
		{"cw_ump45"},
		{"cw_mp5"},
		{"cw_mp7_official"},
		{"cw_mac11"},
		{"cw_mp7_official"},
		{"cw_mp7_official"},
	},
	["avtomati"] = {
		{"cw_ak74"},
		{"cw_ar15"},
		{"cw_famasg2_official"},
		{"cw_scarh"},
		{"cw_m14"},
		{"cw_g36c"},
		{"cw_g3a3"},
		{"cw_g3a3"},
	},
	["bolwieavt"] = {
		{"cw_m249_official"},
		{"cw_m3super90"},
		{"cw_saiga12k_official"},
		{"cw_svd_official"},
		{"cw_vss"},
	},
	["attachments"] = {
		{"att_elcan"},
		{"att_muzsup"},
		{"att_holo"},
		{"att_rdot"},
		{"att_laser"},
		{"att_scope8"},
		{"att_kobra"},
		{"att_foregrip"},
		{"att_bipod"},
		{"att_trit"},
		{"att_exmag"},
	},
	["armors"] = {
		{"torso_armor"},
		{"legs_armor"},
		{"facewrap"},
		{"gloves"},
		{"beanieandfacewrap"},
		{"gasmasks"},
		{"beanine"},
	},
	["build"] = {
		{"bolts"},
		{"screwnuts"},
		{"insulatingtape"},
		{"ducttape"},
		{"wires"},
		{"siliconetube"},
		{"nailpack"},
		{"screwpack"},
		{"siliconetube"},
		{"fuelconditioner"},
		{"expiditionaryfuel"},
		{"paracord"},
		{"plexiglass"},
		{"hose"},
		{"propanetank"},
		{"axe",}
	},
	["electronic"] = {
		{"lcd"},
		{"powersupplyunit"},
		{"graphicscard"},
		{"capacitors"},
		{"wires"},
		{"harddrive"},
		{"electricmotor"},
		{"lightbulb"},
		{"radio"},
		{"flashlight"},
		{"circuitboard"},
		{"airfilter"},
		{"gasanalyser"},
		{"gphone"},
		{"lcdbroken"},
		{"radiatorhelix"},
		{"geigercounter"},
		{"powercord"},
	},
	["tools"] = {
		{"wrench"},
		{"screwdriver"},
		{"electricdrill"},
		{"pliers"},
		{"axe"},
	},
	["military"] = {
		{"militarybattery"},
		{"militarycircuitboard"},
		{"controller"},
		{"flashstorage"},
		{"intel"},
		{"laptop"},
		{"dryfuel"},
		{"militarycable"},
		{"greengunpowder"},
		{"redgunpowder"},
		{"bluegunpowder"},
		{"pills_vir"},
	},
	["home"] = {
		{"propanetank"},
		{"aabattery"},
		{"lionstatue"},
		{"copypaper"},
		{"alkali"},
		{"bleach"},
		{"cameralens"},
		{"soap"},
		{"lightbulb"},
		{"powerbank"},
		{"toiletpaper"},
		{"magnet"},
		{"catstatue"},
		{"horsefigurine"},
		{"bitcoin"},
		{"chainlet"},
		{"powercord"},
		{"matches"},
		{"wrench"},
		{"screwdriver"},
		{"nailpack"},
		{"screwpack"},
		{"siliconetube"},
		{"cw_makarov"},
		{"chips1"},
		{"chocolate1"},
		{"purifiedwater"},
		{"axe"},
		{"pipe"},
		{"brokenbottle"},
	},
	["car"] = {
		{"gasoline"},
		{"sparkplug"},
	},
	["medics"] = {
		{"diagset"},
		{"drug_left_leg"},
		{"syringe_antidote"},
		{"medic_water"},
		{"syringe_poison"},
		{"bloodbag"},
		{"сalcium_left_leg"},
		{"drug_right_leg"},
		{"anhydride"},
		{"iodide"},
		{"bandage"},
		{"tylenol"},
		{"acid"},
		{"amiksin"},
		{"сalcium_right_leg"},
		{"ethanol"},
		{"first_aid_kit"},
		{"syringe_morphine"},
		{"сalcium_left_arm"},
		{"drug_right_arm"},
		{"aminophenol"},
		{"сalcium_right_arm"},
		{"drug_left_arm"},
		{"antivirall"},
	},
	["food"] = {
		{"granola"},
		{"chinese"},
		{"mre"},
		{"spam"},
		{"tuna"},
		{"oat"},
		{"sphagetti"},
		{"tsoup"},
		{"chips1"},
		{"chocolate1"},
		{"purifiedwater"},
		{"waters"},
		{"aquamari"},
		{"wateraqua"},
		{"waterl"},
	},
	["ammo"] = {
		{"shotgunammo"},
		{"ar2ammo"},
		{"pistolammo"},
		{"smg1ammo"},
		{"357ammo"},
	},
}
PLUGIN.black_list = {
	"keycard",
	"ak12",
	"ber_honey_badger",
	"labsnotes",
	"colbablood",
	"petri",
	"syringelab",
	"hackdoor",
	"sradio",
	"defib",
	"cw_extrema_ratio_official",
}

PLUGIN.spawnrate = 600
PLUGIN.maxitems = 300
PLUGIN.itemsperspawn = 60
PLUGIN.spawneditems = PLUGIN.spawneditems or {}

if SERVER then
	local spawntime = 1

	function PLUGIN:ItemShouldSave(entity)
		return (!entity.generated)
	end

	concommand.Add("getitemscategory", function()
		print("\n\n\n\n")
		for k, v in pairs(ix.item.list) do
			if PLUGIN.black_list[v] then return end
			
			if v.category == "Медикаменты" then
				print("{\""..k.."\"},")
			end
		end
	end)

	function PLUGIN:Think()
		if spawntime > CurTime() then return end
		spawntime = CurTime() + self.spawnrate
		for k, v in ipairs(self.spawneditems) do
			if !IsValid(v) then
				table.remove(self.spawneditems, k)
			end
		end

		if #self.spawneditems >= self.maxitems then return end

		for i = 1, self.itemsperspawn do
			if #self.spawneditems >= self.maxitems then
					//table.remove(self.spawneditems)
				return
			end

			local v = table.Random(self.itempoints)

			if (!v) then
				return
			end


			local data = {}
			data.start = v[1]
			data.endpos = data.start + Vector(0, 0, 1)
			data.filter = client
			data.mins = Vector(-16, -16, 0)
			data.maxs = Vector(16, 16, 16)
			local trace = util.TraceHull(data)

			if trace.Entity:IsValid() then
				continue
			end

			if self.spawngroups[v[2]] then
				local idat = table.Random(self.spawngroups[v[2]])

				ix.item.Spawn(idat[1], v[1] + Vector( math.Rand(-8,8), math.Rand(-8,8), 10 ), function(item, entity)
					table.insert(self.spawneditems, entity)
				end, AngleRand(), idat[2] or {})
			end
		end
	end

	function PLUGIN:LoadData()
		self.itempoints = self:GetData() or {}
	end

	function PLUGIN:SaveData()
		self:SetData(self.itempoints)
	end

else

	netstream.Hook("nut_DisplaySpawnPoints", function(data)
		for k, v in pairs(data) do
			local emitter = ParticleEmitter( v[1] )
			local smoke = emitter:Add( "sprites/glow04_noz", v[1] )
			smoke:SetVelocity( Vector( 0, 0, 1 ) )
			smoke:SetDieTime(10)
			smoke:SetStartAlpha(255)
			smoke:SetEndAlpha(255)
			smoke:SetStartSize(64)
			smoke:SetEndSize(64)
			smoke:SetColor(255,186,50)
			smoke:SetAirResistance(300)
		end
	end)

end

ix.command.Add("itemspawnadd", {
	adminOnly = true,
	arguments = ix.type.text,
	OnRun = function(self, client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local spawngroup = arguments or "default"
		table.insert( PLUGIN.itempoints, { hitpos, spawngroup } )
		client:Notify( "You added ".. spawngroup .. " item spawner." )
		PLUGIN:SaveData()
	end
})

ix.command.Add("itemspawnremove", {
	adminOnly = true,
	arguments = ix.type.text,
	OnRun = function(self, client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local range = arguments or 128
		local mt = 0
		for k, v in pairs( PLUGIN.itempoints ) do
			local distance = v[1]:Distance( hitpos )
			if distance <= tonumber(range) then
				PLUGIN.itempoints[k] = nil
				mt = mt + 1
			end
		end
		client:Notify( mt .. " item spawners has been removed.")
		PLUGIN:SaveData()
	end
})

ix.command.Add("itemspawndisplay", {
	adminOnly = true,
	OnRun = function(self, client)
		if SERVER then
			netstream.Start(client, "nut_DisplaySpawnPoints", PLUGIN.itempoints)
			client:Notify( "Displayed All Points for 10 secs." )
		end
	end
})