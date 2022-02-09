ITEM.name = "Бинт"
ITEM.model = Model("models/illusion/eftcontainers/armybandage.mdl")
ITEM.description = "Полоска ткани, используемая для перевязки ран, наложения повязки."
ITEM.category = "Medics"
ITEM.quality = "Необычное"
ITEM.bDropOnDeath = true
ITEM.giveHP = 5
ITEM.weight = 0.2

ITEM.functions.Heal = {
	name = "Использовать",
	tip = "equipTip",
	icon = "icon16/heart_add.png",
	OnRun = function(item)
        local pPlayer = item.player

        for _, Limb in ipairs( pPlayer.HealthData ) do
            pPlayer:Heal( item.giveHP, _, true )
    
            for _, Debuff in pairs( Limb.effects ) do
                if Debuff.ID != "bleed" or Debuff:IsExpired() then continue end
    
                Limb:RemoveDebuff( Debuff )
            end
        end
        
        pPlayer:RLOCNetworkChanges()
	end
}