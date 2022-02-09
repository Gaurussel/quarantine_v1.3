if CLIENT then return end

fastfarm3 = fastfarm3 || {}

function fastfarm3.SaveSimple(ply, cmd, args)    
    if ply:IsSuperAdmin() then   
        local fastfarm = {}       
        for k,v in pairs( ents.FindByClass("fm_npc") ) do
            fastfarm[k] = { type = v:GetClass(), pos = v:GetPos(), ang = v:GetAngles() }
        end	      
        local convert_data = util.TableToJSON( fastfarm )		   
        file.Write( "fastfarm/farm.txt", convert_data ) 
    end
end
concommand.Add("save_farm", fastfarm3.SaveSimple)
 
function fastfarm3.DeleteSimple(ply, cmd, args)   
    if ply:IsSuperAdmin() then       
        file.Delete( "fastfarm/farm.txt" )       
    end    
end
concommand.Add("delete_farm", fastfarm3.DeleteSimple)
 
function fastfarm3.SpawnSimple(ply, cmd, args)
    if ply:IsSuperAdmin() then	
        local spawnvault = ents.Create( "fm_npc" )
        if ( !IsValid( spawnvault ) ) then return end
        spawnvault:SetPos( ply:GetPos() + (ply:GetForward() * 100) )
        spawnvault:Spawn()		
    end    
end
concommand.Add("spawn_farm", fastfarm3.SpawnSimple)
 
function fastfarm3.RespawnSimple()
    if !file.IsDir( "fastfarm", "DATA" ) then 
        file.CreateDir( "fastfarm", "DATA" )  
    end	
	if !file.Exists("fastfarm/farm.txt","DATA") then return end
    local ImportData = util.JSONToTable(file.Read("fastfarm/farm.txt","DATA"))
    for k, v in pairs(ImportData) do      
        local npc = ents.Create( v.type )
        npc:SetPos( v.pos )
        npc:SetAngles( v.ang )
        npc:Spawn()   
	end
end
hook.Add( "InitPostEntity", "farm_respawnsys", fastfarm3.RespawnSimple )