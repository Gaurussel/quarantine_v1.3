ITEM.name = "Сумка для вещей"
ITEM.model = Model("models/illusion/eftcontainers/ifak.mdl")
ITEM.description = "Разместив где либо, вы можете спрятать в ней вещи. Своего рода хабар."
ITEM.category = "Junk"
ITEM.weight = 1.2
ITEM.bDropOnDeath = true
ITEM.quality = "Редкое"

ITEM.functions.PlaceBox = {
	name = "Разместить",
	tip = "equipTip",
	icon = "icon16/package.png",
	OnRun = function(item)
        local ply = item.player
        local tr = ply:GetEyeTrace()
        if tr.StartPos:Distance(tr.HitPos) < 150 then
            local emplacement = ents.Create("ix_container")
            emplacement:SetModel("models/illusion/eftcontainers/ifak.mdl")
            emplacement:SetPos(tr.HitPos + Vector(0, 0, 2))
            emplacement:SetAngles(Angle(0,ply:GetAngles().y,0))
            emplacement:Spawn()
            emplacement.health = 100

            ix.inventory.New(0, "container:" .. emplacement:GetModel():lower(), function(inventory)
				-- we'll technically call this a bag since we don't want other bags to go inside
				inventory.vars.isBag = true
				inventory.vars.isContainer = true

				if (IsValid(emplacement)) then
					emplacement:SetInventory(inventory)
					ix.plugin.list["containers"]:SaveContainer()
				end
			end)
        else
            ply:Notify("Вы не можете разместить так далеко!")
            return false
        end
	end
}