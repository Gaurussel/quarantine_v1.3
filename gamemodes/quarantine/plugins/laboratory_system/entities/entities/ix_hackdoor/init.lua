AddCSLuaFile("cl_init.lua")

ENT.Type = "anim"
ENT.PrintName = "Hack device"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.Timer = 30
ENT.Sound = Sound("ambient/levels/labs/equipment_beep_loop1.wav")

local PLUGIN = PLUGIN

function ENT:SpawnFunction(client, trace)
	local angles = (client:GetPos() - trace.HitPos):Angle()
	angles.p = 0
	angles.r = 0
	angles:RotateAroundAxis(angles:Up(), 270)

	local entity = ents.Create("ix_hackdoor")
	entity:SetPos(trace.HitPos + Vector(0, 0, 40))
	entity:SetAngles(angles:SnapTo("y", 90))
	entity:Spawn()

	return entity
end

function ENT:Initialize()
	self:SetModel("models/props_lab/reciever01d.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	self.SoundHacked = Sound("ambient/levels/labs/electric_explosion"..math.random(1, 5)..".wav")
end

function ENT:Hack()
	self:EmitSound( self.Sound, 50 )
	timer.Simple(self.Timer, function()
		if IsValid(self) and IsValid(self:GetParent()) then
			self:GetParent():EmitSound(self.SoundHacked, 60)
			self:StopSound(self.Sound)
			self:GetParent():Fire("Press")
			ix.item.Spawn("hackdoor", self:GetPos(), nil, self:GetAngles())
			self:Remove()
		end
	end)
end