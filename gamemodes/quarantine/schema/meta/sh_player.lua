
local PLAYER = FindMetaTable("Player")

function PLAYER:IsRestricted()
    if self:GetNetVar("tied", false) then
        return true
    end
end