/*-----------------------------------------------------------
Leak by Famouse
https://www.youtube.com/c/Famouse
https://discord.gg/N6JpA29 - More leaks
-------------------------------------------------------------*/
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/custom_models/sterling/ahshop_crate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self.dist_count = 0
	self.dist_amount = 0
	self.dist_side = 0
end

local farmcroplist2 = {
	["fm_crop1"] = "fm_crop1",
	["fm_crop2"] = "fm_crop2",
	["fm_crop3"] = "fm_crop3",
	["fm_crop4"] = "fm_crop4",
	["fm_crop5"] = "fm_crop5"
}
-- Some class checks are ran twice, due to the calculations that have to be ran pre and after, else models get offset etc.
function ENT:StartTouch( ent )	
	local class = ent:GetClass()
	
	if !( class == farmcroplist2[class] ) then return end
	
	if self.crop == nil then
		self.crop = class
	end
	
	if !( self.crop == farmcroplist2[class] ) then return end

	if !(self.dist_count >= ent.maxamount) then 	
	
		if (class == "fm_crop3") then
			if (self.dist_count == 0) then 
				self.dist_amount = ((self.dist_amount || 0) - 5)
			end
		else
			self.dist_amount = ((self.dist_amount || 0) - 5)	
		end
		
		if (self.dist_count == 2) then
			if !(class == "fm_crop1") && !(class == "fm_crop3") then
				self.dist_side = ((self.dist_side) + 5)
			end	
			if !(class == "fm_crop3") then
				self.dist_amount = -5.5	
			end
		elseif (self.dist_count == 4) then
			if !(class == "fm_crop1") && !(class == "fm_crop3") then
				self.dist_side = ((self.dist_side) + 5)	
			end
			if !(class == "fm_crop3") then
				self.dist_amount = -5.5	
			end
		end
		
		self.dist_count = (self.dist_count + 1)

		if (class == "fm_crop1") then
			if (self.dist_count >= 3) then 
				self.height = ((self.height or ent.height) + 1)
			else
				self.height = 0
			end
			self:SetValue(self:GetValue() + fastfarm2.CornPrice)
		elseif (class == "fm_crop2") then
			self.height = 0
			self:SetValue(self:GetValue() + fastfarm2.TomatoPrice)		
		elseif (class == "fm_crop3") then
			if (self.dist_count >= 2) then 
				self.dist_side = ((self.dist_side) + 8)				
			end	
			self.height = 0
			self:SetValue(self:GetValue() + fastfarm2.CabagePrice)
		elseif (class == "fm_crop4") then
			self.height = 0
			self:SetValue(self:GetValue() + fastfarm2.CarrotPrice)
		elseif (class == "fm_crop5") then
			self.height = 0
			self:SetValue(self:GetValue() + fastfarm2.WheatPrice)
		end
		
		self.dist_bottle = self.dist_bottle or {}
		self.dist_bottle[self.dist_count] = ents.Create("prop_dynamic")
		if ( !IsValid( self.dist_bottle[self.dist_count] ) ) then return end
		self.dist_bottle[self.dist_count]:SetModel(ent:GetModel())
		self.dist_bottle[self.dist_count]:PhysicsInit(SOLID_VPHYSICS)
		self.dist_bottle[self.dist_count]:SetParent(self)
		self.dist_bottle[self.dist_count]:SetPos(Vector(ent.placement + self.dist_side, 7 + self.dist_amount, ent.height + self.height))
		self.dist_bottle[self.dist_count]:SetAngles(self:GetAngles())
		self.dist_bottle[self.dist_count]:Spawn()
		ent:Remove()
	end
end


/*-----------------------------------------------------------
Leak by Famouse
https://www.youtube.com/c/Famouse
https://discord.gg/N6JpA29 - More leaks
-------------------------------------------------------------*/