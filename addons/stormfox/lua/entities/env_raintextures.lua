--[[-------------------------------------------------------------------------
Im an useless entity. We read the BSP intead.
---------------------------------------------------------------------------]]
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Rain Texture List"
ENT.Author = "Nak"
ENT.Information = "Contains a list of all snowtextures."
ENT.Category = "Other"

ENT.Editable = false
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	if ( CLIENT ) then return end
	self:Remove()
end