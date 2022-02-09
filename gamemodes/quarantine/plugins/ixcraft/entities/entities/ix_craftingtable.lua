AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Crafting table"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.ShowPlayerInteraction = true
ENT.canIgnite = false


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/controlroom_desk001b.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()
	end

	function ENT:Use(ply)
        if IsValid(ply) and ply:GetCharacter() then
			ply:PerformInteraction(ix.config.Get("itemPickupTime", 0.5), self, function(client)
            	netstream.Start(client, "Crafting.OpenMenu")
				return false
			end)
        end
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
