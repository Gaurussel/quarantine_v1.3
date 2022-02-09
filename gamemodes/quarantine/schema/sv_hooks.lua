
-- Here is where all of your serverside hooks should go.

-- Change death sounds of people in the police faction to the metropolice death sound.

function Schema:PlayerSwitchFlashlight(client, bEnabled)
	local character = client:GetCharacter()
	local inventory = character and character:GetInventory()

	if (inventory and inventory:HasItem("flashlight")) then
		return true
	end
end

function Schema:PlayerSpawnObject(client)
	if client:IsRestricted() then
		return false
	end
end

function Schema:PlayerSwitchWeapon(client, oldWeapon)
	if client:IsRestricted() then
		return true
	end
end

function Schema:CharacterLoaded(character)
	local client = character:GetPlayer()
	if client:IsRestricted() then
		client:SetNetVar("tied", false)
	end
end

function Schema:PlayerUse(client, entity)
	if (!client:IsRestricted() and entity:IsPlayer() and entity:IsRestricted()) then
		entity:SetAction("С вас снимают наручники", 5)
		client:SetAction("Вы снимаете наручники", 5)

		client:DoStaredAction(entity, function()
			if entity:IsRestricted() then
				entity:SetNetVar("tied", false)
			end
		end, 5, function()
			if (IsValid(entity)) then
				entity:SetAction()
				client:SetAction()
			end

			if (IsValid(ply)) then
				entity:SetAction()
				client:SetAction()
			end
		end)
	end
end

function Schema:PlayerTick(client)
	if client:IsRestricted() then
		if client:IsWepRaised() then
			client:SetWepRaised(false, client:GetActiveWeapon():GetClass())
		end
	end
end