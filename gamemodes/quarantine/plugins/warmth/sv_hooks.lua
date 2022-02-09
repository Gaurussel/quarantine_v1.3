local bodyparts = {
	"BODYPART_HEAD",
	"BODYPART_TORSO",
	"BODYPART_LEFTARM",
	"BODYPART_RIGHTARM",
	"BODYPART_LEFTLEG",
	"BODYPART_RIGHTLEG",
}

function PLUGIN:SetupTimer(client, character)
	local steamID = client:SteamID64()

	timer.Create("ixWarmth" .. steamID, ix.config.Get("warmthTickTime", 5), 0, function()
		if (IsValid(client) and character) then
			self:WarmthTick(client, character, ix.config.Get("warmthTickTime", 5))
		else
			timer.Remove("ixWarmth" .. steamID)
		end
	end)
end

function PLUGIN:SetupAllTimers()
	for _, v in ipairs(player.GetAll()) do
		local character = v:GetCharacter()

		if (character) then
			self:SetupTimer(v, character)
		end
	end
end

function PLUGIN:RemoveAllTimers()
	for _, v in ipairs(player.GetAll()) do
		timer.Remove("ixWarmth" .. v:SteamID64())
	end
end

function PLUGIN:WarmthEnabled()
	self:SetupAllTimers()
end

function PLUGIN:WarmthDisabled()
	self:RemoveAllTimers()
end

function PLUGIN:PlayerLoadedCharacter(client, character, lastCharacter)
	if (ix.config.Get("warmthEnabled", false)) then
		self:SetupTimer(client, character)
	end
end

function PLUGIN:PlayerDeath(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetWarmth(100)
	end
end

function PLUGIN:WarmthTick(client, character, delta)
	if (!client:Alive() or
		client:GetMoveType() == MOVETYPE_NOCLIP or
		hook.Run("ShouldTickWarmth", client) == false or
		self:GetTemperature() > ix.config.Get("warmthMinTemp", 5)) then
		return
	end

	local scale = 1

	if (self:PlayerIsInside(client)) then
		scale = -ix.config.Get("warmthRecoverScale", 0.5)
	end

	-- check to see if the player is near any warmth-generating entities
	local entities = ents.FindInSphere(client:GetPos(), self.warmthEntityDistance)

	for _, v in ipairs(entities) do
		if (self.warmthEntities[v:GetClass()]) then
			scale = -ix.config.Get("warmthFireScale", 2)
		end
	end

	local gorelkaItem = character:GetInventory():HasItem("gorelka")
	
	if gorelkaItem then
		local fuel = gorelkaItem:GetData("fuel", 100)

		if fuel > 0 then
			fuel = fuel - 1
			gorelkaItem:SetData("fuel", fuel)
			scale = -ix.config.Get("warmthFireScale", 2)
		end
	end

	-- update character warmth
	local health = client:Health()
	local warmth = character:GetWarmth()
	local newWarmth = math.Clamp(warmth - scale * (delta / ix.config.Get("warmthLossTime", 5)), 0, 100)

	character:SetWarmth(newWarmth)

	if (newWarmth == 0) then
		local damage = ix.config.Get("warmthDamage", 2)

		if (damage > 0 and health > 5) then
			-- damage the player if we've ran out of warmth
			for ID, v in pairs(bodyparts) do
				local HealthData = client.HealthData
				if !HealthData then return end
				local Limb = HealthData[ID]

				Limb:AddDebuff("cold", "Переохлождение")
			end
		end
	end
end
