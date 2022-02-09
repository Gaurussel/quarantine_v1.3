local PLUGIN = PLUGIN
--local ticktime = 0

--[[function PLUGIN:Tick()
    if ticktime > CurTime() then return end
    ticktime = CurTime() + 1
    for k, v in ipairs(player.GetAll()) do
        local char = v:GetCharacter()
        if !char then return end
        local inventory = char:GetInventory()

        for k2, v2 in ipairs(inventory:GetItems()) do
            --[[if v2:GetData("protectgas", false) and v2:GetData("equip", false) then
                v2:SetData("timeprotect", v2:GetData("timeprotect", 0) - 5)
            end

            if v2:GetData("protectgas", false) and v2:GetData("equip", false) and v2:GetData("timeprotect", 0) <= 0 then
                ply:SetAction("I take off my gas mask..", 2, function()
                    v2:SetData("equip", false)
                    v2:SetData("protectgas", false)
                    v2:SetData("timeprotect", 0)
                end)
            end
        end
    end
end]]