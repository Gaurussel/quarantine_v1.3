ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "Выдача миссий"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.ShowPlayerInteraction = true
ENT.canIgnite = true

if (SERVER) then
	function ENT:Initialize()
		self:SetModel( "models/player/hazmat/hazmat1980_npc.mdl" )
	    self:SetHullType(HULL_HUMAN);
	    self:SetHullSizeNormal();
	    self:SetNPCState(NPC_STATE_SCRIPT);
	    self:SetSolid(SOLID_BBOX);
	    self:SetUseType(SIMPLE_USE);
		self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))	
		self:SetMaxYawSpeed(90)
		self:SetSequence("idle")
	end

	function ENT:Use(ply)
		if ply:Team() == FACTION_ARMY then
			ply:PerformInteraction(ix.config.Get("itemPickupTime", 0.5), self, function(client)
				netstream.Start(ply, "ranks.MissionMenu")
				return false
			end)
		end
	end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
