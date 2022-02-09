function Schema:SlapPlayer(client)
	if (IsValid(client) and client:IsPlayer()) then
		client:SetVelocity(Vector(math.random(-50, 50), math.random(-50, 50), math.random(0, 20)))
		client:TakeDamage(math.random(5, 10))
	end
end

function Schema:SearchPlayer(client, target)
	if (!target:GetCharacter() or !target:GetCharacter():GetInventory()) then
		return false
	end

	local name = hook.Run("GetDisplayedName", target) or target:Name()
	local inventory = target:GetCharacter():GetInventory()

	ix.storage.Open(client, inventory, {
		entity = target,
		name = name
	})

	return true
end