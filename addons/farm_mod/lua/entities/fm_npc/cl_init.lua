/*-----------------------------------------------------------
Leak by Famouse
https://www.youtube.com/c/Famouse
https://discord.gg/N6JpA29 - More leaks
-------------------------------------------------------------*/
include("shared.lua")

surface.CreateFont( "crop_font_17", {
	font = "Lato",
	size = 17,
	weight = 500,
	antialias = true
} )

surface.CreateFont( "crop_font_19", {
	font = "Lato",
	size = 28,
	weight = 500,
	antialias = true
} )

local ahshop3_icon1 = Material("materials/farm/icon.png")

function ENT:Draw()

	self:DrawModel()

	local leng = self:GetPos():Distance(EyePos())
	local clam = math.Clamp(leng, 0, 255 )
	local main = (255 - clam)
	
	if (main <= 0) then return end
	self.price = 0
	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == "fm_crate" then
			if !(self:GetPos():Distance(v:GetPos()) > fastfarm2.NpcSellDistance) then 
				self.price = ((self.price or 0) + v:GetValue())
			end
		end
	end
	
	local value = self.price or 0
	local ahAngle = self:GetAngles()
	local AhEyes = LocalPlayer():EyeAngles()
	
	ahAngle:RotateAroundAxis(ahAngle:Forward(), 90)
	ahAngle:RotateAroundAxis(ahAngle:Right(), -90)		
	
	cam.Start3D2D(self:GetPos()+self:GetUp()*79, Angle(0, AhEyes.y-90, 90), 0.08)
	
		draw.RoundedBox(0,-130,10,260,60,Color(32, 30, 32, 70 + main))
		draw.RoundedBox( 0,-130,10,260,28, Color( 40, 38, 40, 70 + main ) )
		surface.SetDrawColor( 150, 150, 150, 70 + main )
		surface.SetMaterial( ahshop3_icon1	) 
		surface.DrawTexturedRect( -120, 16, 16, 16 )	
		draw.SimpleText( "John Eryk", "crop_font_19", -103, 23, Color( 168, 167, 168, 70 + main ), 0, 1 )
		draw.SimpleText( "I will pay $"..value.." for your crops.", "crop_font_17", -120, 51, Color( 113, 111, 113, 70 + main ), 0, 1 )
		surface.SetDrawColor( Color(77, 75, 77 , 70 + main) )
		surface.DrawOutlinedRect( -130,10,260,60 )
		
	cam.End3D2D()	
	
end		

/*-----------------------------------------------------------
Leak by Famouse
https://www.youtube.com/c/Famouse
https://discord.gg/N6JpA29 - More leaks
-------------------------------------------------------------*/