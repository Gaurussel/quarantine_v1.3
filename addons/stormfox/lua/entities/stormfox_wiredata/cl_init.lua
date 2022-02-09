include("shared.lua")

function ENT:GetOverlayText()
	return "StormFox wiremod support"
end

local matBeam = Material( "effects/lamp_beam" )

local sf = Material("stormfox/SF.png")
local part = Material("effects/lamp_beam")
local mat = Material("dev/dev_combinemonitor_3")
local sin,abs = math.sin,math.abs
function ENT:Draw()
	self:DrawModel()
	if ( halo.RenderedEntity() == self ) then return end
	if not StormFox then return end
	if not StormFox.GetRealTime then return end
	if not StormFox.GetWeatherSymbol then return end

	cam.Start3D2D(self:LocalToWorld(Vector(5.8,-5.11,0.82)),self:LocalToWorldAngles(Angle(0,90,90)),0.1)
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,50,25)
		surface.SetMaterial(sf)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(15,2,20,20)
		surface.SetMaterial(mat)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(0,0,50,25)
	cam.End3D2D()

	local p = self:LocalToWorld(Vector(5.9,0,0))
	local a = abs(sin(SysTime())) * 255
	render.SetColorMaterial()
	render.DrawBox(p,self:GetAngles(),Vector(-0.1,-0.1,-0.1),Vector(0.1,0.1,0.1),Color(a,0,0))
	render.SetMaterial(part)
	render.DrawBeam(p,p + self:GetForward() * 1,1,0,1,Color(a,0,0,a))
end
