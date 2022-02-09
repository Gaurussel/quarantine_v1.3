AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self.index = self:EntIndex()
	self:SetCollisionGroup( 11 )
	self:SetModelScale(self:GetModelScale() * self.scale, 0)
	self:TimerPlantRemover()
end

function ENT:TimerPlantRemover()
	timer.Create( "plantremover"..self:EntIndex(), 160, 1, function()
		if !IsValid(self) then return end
		self:Remove()
	end)
end

function ENT:TimerDelete()
	timer.Remove("plantremover"..self:EntIndex())
end

function ENT:Use( ply )
	if ( ( self.lastUsed or CurTime() ) <= CurTime() ) then
		self.lastUsed = CurTime() + 0.25

		if ( self:Getdist_harvest() ) then
			if IsValid(self.plant) then 
				self.plant:Remove() 
				ix.item.Spawn(self.plant.growItem, self:GetPos() + Vector(0, 0, 16), nil, Angle(0, 0, 0), {finded = true})
				ix.XPSystem.AddXP(ply, 10)
				self:TimerPlantRemover()
			end
		end
	end
end

function ENT:StartTouch( ent )
	if ent:GetClass() == "ix_item" then
		local itemTable = ent:GetItemTable()

		if !itemTable.IsSeed then return end

		if !IsValid( self.plant ) then
			self.plant = ents.Create( "prop_dynamic" )

			if ( !IsValid( self.plant ) ) then return end

			self.plant:SetModel( itemTable.plantModel )
			self.plant:PhysicsInit( SOLID_VPHYSICS )
			self.plant:SetParent( self )
			self.plant:SetPos( Vector(self.placement,0, itemTable.plantpos * self.moveup) )
			self.plant:SetAngles( self:GetAngles() )
			self.plant:SetCollisionGroup( 11 )
			self.plant:SetModelScale(self.plant:GetModelScale() * 0.10, 0)
			self.plant.growItem = itemTable.plant

			self.size = itemTable.sizeP
			self.farmcrop = itemTable.farmcrop
			self.plant:Spawn()
			self:GrowTimer(itemTable.growtime)
			ent:Remove()
			self:TimerDelete()
		end
	end
end

function ENT:GrowTimer(second)
	self.plant:SetModelScale( self.plant:GetModelScale() * self.size, second )
	timer.Create( "growtimer"..self.index, second, 1, function()
		if !IsValid(self) then timer.Remove( "growtimer"..self.index ) return end
		self:Setdist_harvest(true)
	end)
end

function ENT:OnRemove()
	if timer.Exists( "growtimer"..self.index ) then
		timer.Remove( "growtimer"..self.index )
	end
end