AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Бочка"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.canIgnite = true


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_junk/barrel_fire.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()

	end

	function ENT:Use(ply)
        if IsValid(ply) and ply:GetCharacter() then
			if self:IsOnFire() then
            	netstream.Start(ply, "Crafting.OpenMenu")
			else
				ply:Notify("Необходимо разжечь огонь.")
			end
        end
	end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
