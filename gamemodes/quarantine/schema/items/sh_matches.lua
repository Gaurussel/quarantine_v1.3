ITEM.name = "Коробка спичек"
ITEM.model = Model("models/illusion/eftcontainers/matches.mdl")
ITEM.description = "Спичечный коробок, полный безопасных спичек. Зажигалки надежнее и проще в использовании, но именно поэтому все стараются их спрятать, когда просят прикурить."
ITEM.category = "Junk"
ITEM.bDropOnDeath = true
ITEM.weight = 0.1

ITEM.functions.Toggle = {
	name = "Поджечь",
	tip = "useTip",
	icon = "icon16/lightbulb.png",
    OnCanRun = function(item)
        local ply = item.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if target:GetClass() == "stormfox_campfire" then
            return true
        end

        if target.canIgnite then
            return true
        end

        return false
    end,
	OnRun = function(item)
        local delete = false
        local ply = item.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity
        
        if target:GetClass() == "stormfox_campfire" then
            if target:WaterLevel() < 1 and not target:IsOn() then
                target:SetOn(true)
            end

            timer.Simple(160, function()
                if IsValid(target) then
                    target:SetOn(false)
                end
            end)
        else
            target:Ignite(160)
        end

        return false
	end,
}