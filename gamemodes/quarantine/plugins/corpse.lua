local PLUGIN = PLUGIN

PLUGIN.name = "Persistent Corpses"
PLUGIN.author = "`impulse"
PLUGIN.description = "Makes player corpses stay on the map after the player has respawned."
PLUGIN.hardCorpseMax = 64

ix.lang.AddTable("english", {
	searchingCorpse = "Searching corpse..."
})

ix.lang.AddTable("russian", {
	searchingCorpse = "Обыскиваю тело..."
})


ix.config.Add("persistentCorpses", true, "Whether or not corpses remain on the map after a player dies and respawns.", nil, {
	category = "Persistent Corpses"
})

ix.config.Add("corpseMax", 8, "Maximum number of corpses that are allowed to be spawned.", nil, {
	data = {min = 0, max = PLUGIN.hardCorpseMax},
	category = "Persistent Corpses"
})

ix.config.Add("corpseDecayTime", 60, "How long it takes for a corpse to decay in seconds. Set to 0 to never decay.", nil, {
	data = {min = 0, max = 1800},
	category = "Persistent Corpses"
})

ix.config.Add("corpseSearchTime", 1, "How long it takes to search a corpse.", nil, {
	data = {min = 0, max = 60},
	category = "Persistent Corpses"
})

ix.config.Add("dropItemsOnDeath", false, "Whether or not to drop specific items on death.", nil, {
	category = "Persistent Corpses"
})

if (SERVER) then
	PLUGIN.corpses = {}

	-- disable the regular hl2 ragdolls
	function PLUGIN:ShouldSpawnClientRagdoll(client)
		return false
	end

	function PLUGIN:PlayerSpawn(client)
		client:SetLocalVar("ragdoll", nil)
	end

	function PLUGIN:ShouldRemoveRagdollOnDeath(client)
		return false
	end

	function PLUGIN:PlayerInitialSpawn(client)
		self:CleanupCorpses()
	end

	function PLUGIN:CleanupCorpses(maxCorpses)
		maxCorpses = maxCorpses or ix.config.Get("corpseMax", 8)
		local toRemove = {}

		if (#self.corpses > maxCorpses) then
			for k, v in ipairs(self.corpses) do
				if (!IsValid(v)) then
					toRemove[#toRemove + 1] = k
				elseif (#self.corpses - #toRemove > maxCorpses) then
					v:Remove()
					toRemove[#toRemove + 1] = k
				end
			end
		end

		for k, _ in ipairs(toRemove) do
			table.remove(self.corpses, k)
		end
	end

	function PLUGIN:RemoveEquippableItem(client, item)
		if (item.Unequip) then
			item:Unequip(client)
		elseif (item.RemoveOutfit) then
			item:RemoveOutfit(client)
		elseif (item.RemovePart) then
			item:RemovePart(client)
		end
	end

	function PLUGIN:DoPlayerDeath(client, attacker, damageinfo)
		if (!ix.config.Get("persistentCorpses", true)) then
			return
		end

		if (hook.Run("ShouldSpawnPlayerCorpse") == false) then
			return
		end

		-- remove old corpse if we've hit the limit
		local maxCorpses = ix.config.Get("corpseMax", 8)

		if (maxCorpses == 0) then
			return
		end

		local entity = IsValid(client.ixRagdoll) and client.ixRagdoll or client:CreateServerRagdoll()
		local decayTime = ix.config.Get("corpseDecayTime", 60)
		local uniqueID = "ixCorpseDecay" .. entity:EntIndex()

		entity:RemoveCallOnRemove("fixer")
		entity:CallOnRemove("ixPersistentCorpse", function(ragdoll)
			if (ragdoll.ixInventory) then
				ix.storage.Close(ragdoll.ixInventory)
			end

			if (IsValid(client) and !client:Alive()) then
				client:SetLocalVar("ragdoll", nil)
			end

			local index

			for k, v in ipairs(PLUGIN.corpses) do
				if (v == ragdoll) then
					index = k
					break
				end
			end

			if (index) then
				table.remove(PLUGIN.corpses, index)
			end

			if (timer.Exists(uniqueID)) then
				timer.Remove(uniqueID)
			end
		end)

		-- start decay process only if we have a time set
		if (decayTime > 0) then
			timer.Create(uniqueID, decayTime, 1, function()
				if (IsValid(entity)) then
					entity:Remove()
				else
					timer.Remove(uniqueID)
				end
			end)
		end

		-- remove reference to ragdoll so it isn't removed on spawn when SetRagdolled is called
		--client.ixRagdoll = nil
		-- remove reference to the player so no more damage can be dealt
		--entity.ixPlayer = nil

		self.corpses[#self.corpses + 1] = entity

		-- clean up old corpses after we've added this one
		if (#self.corpses >= maxCorpses) then
			self:CleanupCorpses(maxCorpses)
		end

		hook.Run("OnPlayerCorpseCreated", client, entity)
	end

	function PLUGIN:OnPlayerCorpseCreated(client, entity)
		if (!ix.config.Get("dropItemsOnDeath", false) or !client:GetCharacter()) then
			return
		end

		client:SetLocalVar("ragdoll", entity:EntIndex())

		local character = client:GetCharacter()
		local charInventory = character:GetInventory()
		local width, height = charInventory:GetSize()
		entity.player = client
		entity:SetNWFloat("Time", CurTime() + ix.config.Get("spawnTime", 10))

		timer.Simple(ix.config.Get("spawnTime", 10), function()
			-- create new inventory
			local inventory = ix.inventory.Create(width, height, os.time())
			inventory.noSave = true

			if (ix.config.Get("dropItemsOnDeath")) then
				for _, slot in pairs(charInventory.slots) do
					for _, item in pairs(slot) do
						if (item.bDropOnDeath) then
							if (item:GetData("equip")) then
								continue
							end

							item:Transfer(inventory:GetID(), item.gridX, item.gridY)
						end
					end
				end
			end

			entity.ixInventory = inventory
		end)
	end

	function PLUGIN:PlayerUse(client, entity)
		if (entity:GetClass() == "prop_ragdoll" and entity.ixInventory and !ix.storage.InUse(entity.ixInventory)) then
			ix.storage.Open(client, entity.ixInventory, {
				entity = entity,
				name = "Corpse",
				searchText = "@searchingCorpse",
				searchTime = ix.config.Get("corpseSearchTime", 1)
			})

			return false
		end
	end
else
	surface.CreateFont( "ReviveText", {
		font = "Roboto",
		size = 25,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true
	   } )
   
	   hook.Add("HUDPaint", "DrawDeadPlayers", function()
		   if (LocalPlayer():GetChar()) then
			   for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
				local player = v:GetNetVar("player")
				   if IsValid(v) and !v.ixInventory and IsValid(player) and !player:Alive() then
						if v:GetNWFloat("Time") - CurTime() < 0 then return end
						if LocalPlayer():GetPos():Distance(v:GetPos()) > 512 then return end
						if player == LocalPlayer() then return end

						local Pos = v:GetPos():ToScreen()
						
						draw.RoundedBox(0, Pos.x, Pos.y, 10, 40, Color(220, 20, 60))
						draw.RoundedBox(0, Pos.x - 15, Pos.y + 15, 40, 10, Color(220, 20, 60))
   
						draw.SimpleText("Умрёт через: "..math.Round(v:GetNWFloat("Time") - CurTime()), "ReviveText", Pos.x, Pos.y - 20, Color(249, 255, 239), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				   end
			   end
		   end
	   end)
end