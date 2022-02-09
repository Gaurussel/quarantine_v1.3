ITEM.name = "Аптечка первой помощи"
ITEM.model = Model("models/illusion/eftcontainers/salewa.mdl")
ITEM.description = "Набор перевязочных материалов, инструментов и приспособлений, предназначенных для оказания первой помощи."
ITEM.category = "Medics"
ITEM.quality = "Редкое"
ITEM.bDropOnDeath = true
ITEM.weight = 1.4
ITEM.giveHP = 0.5

ITEM.functions.Heal = {
	name = "Использовать",
	tip = "equipTip",
	icon = "icon16/heart_add.png",
	OnRun = function(item)
        local pPlayer = item.player

        for _, Limb in ipairs( pPlayer.HealthData ) do
            pPlayer:Heal( Limb.MaxHP * item.giveHP, _, true )
    
            for _, Debuff in pairs( Limb.effects ) do
                if Debuff.ID != "bleed" or Debuff:IsExpired() then continue end
    
                Limb:RemoveDebuff( Debuff )
            end
        end

        pPlayer:RLOCNetworkChanges()
	end
}

ITEM.functions.Revive = {
	name = "Поднять",
	icon = "icon16/heart_add.png",
	OnRun = function(item)
		local ply = item.player
		local traceRes = ply:GetEyeTrace()

		if ( IsValid( traceRes.Entity ) and traceRes.Entity:GetClass( ) == "prop_ragdoll" ) then
			local traceEnt = traceRes.Entity

			if (!traceEnt.ixInventory and traceEnt.player) then
				traceEnt.player:Spawn()
				traceEnt.player:Spawn()
				traceEnt.player:SetHealth( 1 ) 
				traceEnt.player:SetPos(traceEnt:GetPos())	
				traceEnt:Remove()		
			end
		end
		return true
	end,
	OnCanRun = function(item)
		return item.player:GetEyeTrace().Entity and item.player:GetEyeTrace().Entity:GetClass() == "prop_ragdoll"
	end
}