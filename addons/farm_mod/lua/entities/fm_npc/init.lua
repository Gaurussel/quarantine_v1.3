/*-----------------------------------------------------------
Leak by Famouse
https://www.youtube.com/c/Famouse
https://discord.gg/N6JpA29 - More leaks
-------------------------------------------------------------*/
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize( )
	self:SetModel(fastfarm2.NpcModel)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid( SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)
	self:SetCollisionGroup( 1 )
end

function ENT:AcceptInput( key, ply )

	local EI = self:EntIndex()

	if ( ( self.lastUsed or CurTime() ) <= CurTime() ) and ( key == "Use" && ply:IsPlayer() && IsValid( ply ) ) then
	
		self.lastUsed = CurTime() + 0.25

		for k,v in pairs(ents.FindByClass("fm_crate")) do 
			
			if self:GetPos():Distance(v:GetPos()) <= fastfarm2.NpcSellDistance then 
					
				ply:addMoney( v:GetValue() )
				ply:ChatPrint("You just sold a crate for: $"..v:GetValue())
				v:Remove()
							
			end
		end	
	end	
end



/*-----------------------------------------------------------
Leak by Famouse
https://www.youtube.com/c/Famouse
https://discord.gg/N6JpA29 - More leaks
-------------------------------------------------------------*/