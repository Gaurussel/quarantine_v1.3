local PLUGIN = PLUGIN
local notes = {
	[1] = "Под микроскопом не видно ни-че-го опасного для организма. Возможные симптомы: недосып, кашель. ",
	[2] = "Под микроскопом видны тонкие слои так называемой «пленки» на клетках лейкоцитах, эритроциты в норме. Возможные симптомы: недосып, кашель, покраснения глаз.",
	[3] = "Под микроскопом видны толстые слои пленки на клетках лейкоцитах, эритроциты сгущаются в массы и стопорят движения клеток в теле. Возможные симптомы: недосып, громкий и влажный кашель с отхаркиванием, покраснение глаз, затруднительная реакция.",
	[4] = "Под микроскопом видны тела вируса обхватившие лейкоциты и эритроциты, полностью останавливается движение клеток в теле. Возможные симптомы: Все что было до. + появление синяков на теле, онемение конечностей."
}
PLUGIN.buttons = {
    [3286] = true,
    [3285] = true,
    [3284] = true,
    [3283] = true,
    [3287] = true,
    [3288] = true,
}

concommand.Add("getindex", function(ply)
    local data = {}
        data.start = ply:GetShootPos()
        data.endpos = data.start + ply:GetAimVector() * 96
        data.filter = ply
    local target = util.TraceLine(data).Entity

    ply:Notify(target:MapCreationID())
    ply:Notify(target:GetClass())
end)

netstream.Hook("Lab.Petritake", function(ply, entity, data)
    ply:GetCharacter():GetInventory():Add("petri", 1, entity:GetNetVar("petri", {}))
    entity:SetNetVar("petri", {})
end)

netstream.Hook("Lab.NotesReady", function(ply, data)
    ply:GetCharacter():GetInventory():Add("labsnotes", 1, {text = notes[data.virus]})
end)

local timeActivate = 0

function PLUGIN:FindUseEntity(ply, ent)   
    if IsValid(ent) then
        if PLUGIN.buttons[ent:MapCreationID()] then
            if CurTime() < timeActivate then return false end
            timeActivate = CurTime() + 1
            
            if !ply:GetCharacter():GetInventory():HasItem("keycard") then
                ply:Notify("Доступ запрещён.")
                return false
            end

            ply:Notify("Доступ разрешён.")
            return ent
        end
    end
end