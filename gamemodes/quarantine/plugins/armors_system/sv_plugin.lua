local PLUGIN = PLUGIN

function PLUGIN:ScalePlayerDamage(target, hitgroup, dmg)
    local char = target:GetCharacter()

    if char then
        local itemSuits = char:GetInventory():HasItemOfBase("base_suits", {["equip"] = true})

        if itemSuits then
            local durability = itemSuits:GetData("durability", 100)

            if durability > 1 then
                dmg:ScaleDamage(itemSuits.protect)
                
                if math.random(1, 16) < 3 and durability > 0 then
                    itemSuits:SetData("durability", durability - 1)
                end
            end
        end
    end
end

function PLUGIN:PlayerInteractItem(client, action, item)
    if ( action == "Equip" and item.mask==true)then
        client:GetCharacter():SetMasked(true)
    elseif (action == "EquipUn" and item.mask == true) then
        client:GetCharacter():SetMasked(false)
    end
end

function PLUGIN:CanPlayerDropItem(ply, itemID)
    local inventory = ply:GetCharacter():GetInventory()
    local item = inventory:GetItemByID(itemID)

    if IsValid(ply) and item then
        if item:GetData("equip", false) or item:GetData("equip", false) then
            ply:Notify("Вы не можете выкинуть этот предмет, пока он экипирован!")
            return false
        end
    end
end