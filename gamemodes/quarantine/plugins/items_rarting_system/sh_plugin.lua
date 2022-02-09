local PLUGIN = PLUGIN
PLUGIN.name = "Items Rating System"
PLUGIN.author = "Gaurussel"
PLUGIN.description = "Items Rating System"
PLUGIN.quality_table = {
    ["Легендарное"] = Color(250, 210, 1, 150),
    ["Эпическое"] = Color(234, 141, 247, 150),
    ["Редкое"] = Color(17, 100, 180, 150),
    ["Необычное"] = Color(70, 130, 180, 150),
    ["Обычное"] = Color(100, 154, 158, 150), 
}

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

local ITEM = ix.meta.item or {}

--- Removes the item.
-- @realm shared
-- @bool bNoReplication Whether or not the item's removal should not be replicated.
-- @bool bNoDelete Whether or not the item should not be fully deleted
-- @treturn number The X position that the item was removed from
-- @treturn number The Y position that the item was removed from
function ITEM:Remove(bNoReplication, bNoDelete)
    local inv = ix.inventory.Get(self.invID)
    local x2, y2

    if (inv) then
        if (self.invID != 0) then
            local invW, invH = inv:GetSize()

            for x = 1, invW do
                if (inv.slots[x]) then
                    for y = 1, invH do
                        local item = inv.slots[x][y]

                        if (item and item.id == self.id) then
                            inv.slots[x][y] = nil

                            x2 = x2 or x
                            y2 = y2 or y
                        end
                    end
                end
            end 
        else
            ix.item.inventories[self.invID][self.id] = nil
        end
    end

    if (SERVER and !bNoReplication) then
        local entity = self:GetEntity()

        if (IsValid(entity)) then
            entity:Remove()
        end

        if (inv and inv.GetReceivers) then
            local receivers = inv:GetReceivers()

            if (self.invID != 0 and istable(receivers) and #receivers > 0) then
                net.Start("ixInventoryRemove")
                    net.WriteUInt(self.id, 32)
                    net.WriteUInt(self.invID, 32)
                net.Send(receivers)
            end
        end

        if (!bNoDelete) then
            local item = ix.item.instances[self.id]

            if (item and item.OnRemoved) then
                item:OnRemoved()
            end

            local query = mysql:Delete("ix_items")
                query:Where("item_id", self.id)
            query:Execute()

            ix.item.instances[self.id] = nil
        end
    end

    return x2, y2
end

ix.meta.item = ITEM