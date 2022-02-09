PLUGIN.name = "Anti systems"
PLUGIN.author = "Steve Jobs"
PLUGIN.description = "Random things"

local CharacterDeathTime = {}

function PLUGIN:CanPlayerUseCharacter(client, character)
	if IsValid(client.ixRagdoll) and client:Alive() then
		return false, "Вы не можете это сделать будучи без сознания."
	end
	local id = character:GetID()
	if CharacterDeathTime[id] then
		if CharacterDeathTime[id] > CurTime() then
			return false, "У персонажа "..character:GetName().." еще не прошло время смерти."
		else
			CharacterDeathTime[id] = nil
		end
	end
end

function PLUGIN:PlayerDeath(client, inflictor, attacker)
	timer.Simple(0.2, function()
		if IsValid(client) then
			local character = client:GetCharacter()
			if character then
				CharacterDeathTime[character:GetID()] = client:GetNetVar("deathTime", CurTime() + ix.config.Get("spawnTime", 5))
			end
		end
	end)
end

if (SERVER) then
	function PLUGIN:EntityTakeDamage(target, dmginfo)
		if dmginfo:GetDamageType() == DMG_CRUSH then
			dmginfo:ScaleDamage(0)
		end
	end

	timer.Create( "itemcleanup", 1200, 0, function()
		for k, itm in ipairs( ents.FindByClass( "ix_item" ) ) do
			if ( itm.lifetime ) then
				if ( itm.lifetime == true ) then
					itm:TakeDamage(0, game.GetWorld(), game.GetWorld())
					itm:Remove()
				end
			else
				itm.lifetime = true
			end
		end
	end)
end

function PLUGIN:CanCharacterDelete(client, character)
	local defaultMoney = ix.config.Get("defaultMoney", 0)
	if character:GetMoney() < defaultMoney then
		return false, "Для удаление персонажа "..character:GetName().." он должен иметь "..defaultMoney.." "..ix.currency.plural
	end
end

function PLUGIN:ShouldCollide(ent1, ent2)
	if ent1:GetClass() == "ix_item" and ent2:GetClass() == "ix_item" then
		return false
	end
end

function PLUGIN:OnPlayerHitGround( pl )
    local vel = pl:GetVelocity()
    pl:SetVelocity( Vector( - ( vel.x * 0.45 ), - ( vel.y * 0.45 ), 0) )
end

function PLUGIN:OnGamemodeLoaded()
	ix.allowedHoldableClasses["recorder"] =  true
	ix.allowedHoldableClasses["fm_crop3"] =  true
	ix.allowedHoldableClasses["fm_seed3"] =  true
	ix.allowedHoldableClasses["fm_crop4"] =  true
	ix.allowedHoldableClasses["fm_plant2"] =  true
	ix.allowedHoldableClasses["fm_crop4"] =  true
	ix.allowedHoldableClasses["fm_seed4"] =  true
	ix.allowedHoldableClasses["fm_crop1"] =  true
	ix.allowedHoldableClasses["fm_seed1"] =  true
	ix.allowedHoldableClasses["fm_crate"] =  true
	ix.allowedHoldableClasses["fm_crop2"] =  true
	ix.allowedHoldableClasses["fm_seed2"] =  true
	ix.allowedHoldableClasses["fm_crop5"] =  true
	ix.allowedHoldableClasses["fm_seed5"] =  true
end

function PLUGIN:CharacterLoaded(char)
	char:GetPlayer():ConCommand("mqs_fail")
end