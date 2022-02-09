ITEM.name = "Шина"
ITEM.model = Model("models/illusion/eftcontainers/splint.mdl")
ITEM.description = "Фиксатор для различных частей тела, предназначенный для профилактики и лечения травм и заболеваний костной системы."
ITEM.category = "Medics"
ITEM.quality = "Редкое"
ITEM.weight = 0.4
ITEM.bDropOnDeath = true
ITEM.giveHP = 0.3

ITEM.functions.Heal = {
	name = "Использовать",
	tip = "equipTip",
	icon = "icon16/heart_add.png",
	OnRun = function(item)
        local pPlayer = item.player

        local HealthData = pPlayer.HealthData
        for i = 5, 6 do
            local Limb = HealthData[ i ]
    
            pPlayer:Heal( Limb.MaxHP * item.giveHP, i, true )
    
            for _, Effect in pairs( Limb.effects ) do
                if Effect.ID ~= "broken" or Effect:IsExpired() then continue end
    
                Limb:RemoveDebuff( Effect )
            end
        end

        pPlayer:RLOCNetworkChanges()
	end
}