local posShipments = {
	{pos = Vector(-13195, -3812, 629), description = "Посылка находится сзади мэрии города, на горе, в одном из кустов."},
	{pos = Vector(-12764, -3090, 427), description = "Посылка находится сзади мэрии города, на горе, в одном из кустов."},
	{pos = Vector(-8103, -2531, 197), description = "Посылка находится в радиусе ста метров рядом с заброшенным поездом у фабрики."},
	{pos = Vector(-7627, 1738, 560), description = "Посылка находится в радиусе пятидесяти метров рядом с заброшенным поездом у фабрики."},
	{pos = Vector(7611, 1670, 252), description = "Посылка находится в радиусе пятидесяти метров рядом с заброшенным поездом у деревушки."},
	{pos = Vector(9393, -5465, 222), description = "Посылка находится рядом со въездом в деревушку."},
	{pos = Vector(8864, -10209, 190), description = "Посылка находится рядом с рельсами у моста."},
	{pos = Vector(12267, 6739, 197), description = "Посылка находится у въезда на военную базу."},
	{pos = Vector(13049, 9267, 417), description = "Посылка находится у въезда на военную базу."},
	{pos = Vector(7668, 11771, 231), description = "Посылка находится рядом с рельсами у военной базы."},
	{pos = Vector(-2265, 7607, 194), description = "Посылка находится рядом с военным КПП, в радиусе ста метров."},
}


if (SERVER) then
	util.AddNetworkString("ixBusinessBuy")
	util.AddNetworkString("ixBusinessResponse")
	util.AddNetworkString("ixShipmentUse")
	util.AddNetworkString("ixShipmentOpen")
	util.AddNetworkString("ixShipmentClose")

	net.Receive("ixBusinessBuy", function(length, client)
		if (client.ixNextBusiness and client.ixNextBusiness > CurTime()) then
			client:NotifyLocalized("businessTooFast")
			return
		end

		local char = client:GetCharacter()

		if (!char) then
			return
		end

		local indicies = net.ReadUInt(8)
		local items = {}

		for _ = 1, indicies do
			items[net.ReadString()] = net.ReadUInt(8)
		end

		if (table.IsEmpty(items)) then
			return
		end

		local cost = 0

		for k, v in pairs(items) do
			local itemTable = ix.item.list[k]

			if (itemTable and hook.Run("CanPlayerUseBusiness", client, k) != false) then
				local amount = math.Clamp(tonumber(v) or 0, 0, 10)
				items[k] = amount

				if (amount == 0) then
					items[k] = nil
				else
					cost = cost + (amount * (itemTable.price or 0))
				end
			else
				items[k] = nil
			end
		end

		if (table.IsEmpty(items)) then
			return
		end

		if (char:HasMoney(cost)) then
			local posShipment = table.Random(posShipments)
			char:TakeMoney(cost)

			local entity = ents.Create("ix_shipment")
			entity:Spawn()
			entity:SetPos(posShipment.pos)
			entity:SetItems(items)
			entity:SetNetVar("owner", char:GetID())

			local shipments = char:GetVar("charEnts") or {}
			table.insert(shipments, entity)
			char:SetVar("charEnts", shipments, true)

			net.Start("ixBusinessResponse")
			net.Send(client)

			hook.Run("CreateShipment", client, entity)

			client:GetCharacter():GetInventory():Add("paper", 1, {text = posShipment.description})

			client.ixNextBusiness = CurTime() + 0.5
		end
	end)

	net.Receive("ixShipmentUse", function(length, client)
		local uniqueID = net.ReadString()
		local drop = net.ReadBool()

		local entity = client.ixShipment
		local itemTable = ix.item.list[uniqueID]

		if (itemTable and IsValid(entity)) then
			if (entity:GetPos():Distance(client:GetPos()) > 128) then
				client.ixShipment = nil

				return
			end

			local amount = entity.items[uniqueID]

			if (amount and amount > 0) then
				if (entity.items[uniqueID] <= 0) then
					entity.items[uniqueID] = nil
				end

				if (drop) then
					ix.item.Spawn(uniqueID, entity:GetPos() + Vector(0, 0, 16), function(item, itemEntity)
						if (IsValid(client)) then
							itemEntity.ixSteamID = client:SteamID()
							itemEntity.ixCharID = client:GetCharacter():GetID()
						end
					end)
				else
					local status, _ = client:GetCharacter():GetInventory():Add(uniqueID)

					if (!status) then
						return client:NotifyLocalized("noFit")
					end
				end

				hook.Run("ShipmentItemTaken", client, uniqueID, amount)

				entity.items[uniqueID] = entity.items[uniqueID] - 1

				if (entity:GetItemCount() < 1) then
					entity:GibBreakServer(Vector(0, 0, 0.5))
					entity:Remove()
				end
			end
		end
	end)

	net.Receive("ixShipmentClose", function(length, client)
		local entity = client.ixShipment

		if (IsValid(entity)) then
			entity.ixInteractionDirty = false
			client.ixShipment = nil
		end
	end)
else
	net.Receive("ixShipmentOpen", function()
		local entity = net.ReadEntity()
		local items = net.ReadTable()

		ix.gui.shipment = vgui.Create("ixShipment")
		ix.gui.shipment:SetItems(entity, items)
	end)
end
