ENT.Type = "anim"
ENT.PrintName = "Hack Nexus Door"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.Timer = 30

function ENT:Initialize()
	self.hackend = CurTime()
end

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	cam.Start3D2D(pos + ang:Up()*6 - ang:Forward()*5.25 - ang:Right(), ang, 0.05)
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,100,60)
		draw.SimpleText("Взлом:", "ixGenericFont", 5,5, Color(0,255,0))
		surface.SetDrawColor(0,255,0)
		surface.DrawOutlinedRect( 5, 30, 90, 20 )

		surface.DrawRect(7, 32, math.min(86, 86*((CurTime() - self.hackend)/self.Timer)), 16)
	cam.End3D2D()
end
