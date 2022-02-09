ITEM.name = "Наручники"
ITEM.model = Model("models/Items/CrossbowRounds.mdl")
ITEM.description = "Устройство в виде двух колец с замками, соединённых между собой."
ITEM.category = "Junk"
ITEM.quality = "Необычное"
ITEM.width = 1
ITEM.height = 1
ITEM.weight = 1.2
ITEM.bDropOnDeath = true


ITEM.functions.PlaceBox = {
	name = "Заковать человека спереди",
	tip = "equipTip",
	OnRun = function(item)
        local ply = item.player
        local tr = ply:GetEyeTrace()
        if tr.StartPos:Distance(tr.HitPos) < 150 then
            if tr.Entity:IsValid() then
                local ent = tr.Entity
                if ent:IsPlayer() then
                    ply:SetAction("Заковываю в наручники", 5)
                    ent:SetAction("На вас надевают наручники", 5)

			        ply:DoStaredAction(ent, function()
                        if !ent:IsRestricted() then
                            ent:SelectWeapon("ix_keys")
                            ent:SetNetVar("tied", true)

                            item:Remove()
                        end
                    end, 5, function()
                        if ent:IsValid() then
                            if (IsValid(ent)) then
                                ent:SetAction()
                                ply:SetAction()
                            end
                
                            if (IsValid(ply)) then
                                ply:SetAction()
                                ent:SetAction()
                            end

				            item.bBeingUsed = false
                        end
                    end)
                end
            end
        end

        return false
	end
}

concommand.Add("gettied", function(ply)
    print(ply:GetEyeTrace().Entity:GetNetVar("tied", false))
end)