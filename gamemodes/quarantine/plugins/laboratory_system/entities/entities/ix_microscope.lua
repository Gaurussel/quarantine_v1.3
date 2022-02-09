AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Микроскоп"
ENT.Category = "Laboratory"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.canIgnite = true


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_watertreatment/microscope.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()
		self:SetNetVar("petri", {})
	end

	function ENT:Use(ply)
		local petri = self:GetNetVar("petri", {})

		if !table.IsEmpty(petri) then
			netstream.Start(ply, "Lab.OpenMicroscope", true, self)
		end
	end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
