--[[
    original code from KVS-lib
    оригинальный код из KVS-lib
]]

local PANEL = {}
local font = "qMediumLightFont"

local lastAngle = 0
local wheelSize = ScrH() * 0.7
local wheelThickness = ScrH() * 0.2

local extRadius = wheelSize / 2
local intRadius = extRadius - wheelThickness

AccessorFunc( PANEL, 'FontHoveredName', 'FontHoveredName' )
AccessorFunc( PANEL, 'FontHoveredSize', 'FontHoveredSize' )
AccessorFunc( PANEL, 'FontSize', 'FontSize' )
AccessorFunc( PANEL, 'FontName', 'FontName' )

function draw.KVS_Arc(cx,cy,radius,thickness,startang,endang,roughness,color)
	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.KVS_DrawArc( surface.KVS_PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness) )
end

function surface.KVS_PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness)
	local triarc = {}
	-- local deg2rad = math.pi / 180
	radius = radius / 2
	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	
	if startang > endang then
		step = math.abs(step) * -1
	end
	
	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*r), cy+(-math.sin(rad)*r)
		table.insert(inner, {
			x=ox + radius,
			y=oy + radius,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end	
	
	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*radius), cy+(-math.sin(rad)*radius)
		table.insert(outer, {
			x=ox + radius,
			y=oy + radius,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end	
	
	-- Triangulize the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end
	
		table.insert(triarc, {p1,p2,p3})
	end
	
	-- Return a table of triangles to draw.
	return triarc
end

function surface.KVS_DrawArc(arc)
	for k,v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end

function PANEL:MakeChainableMethod( panel, methods )
	if ( not istable( methods ) or not ispanel( panel ) ) then return end

	-- Override default functions
	for _, name in pairs( methods ) do
		panel[ name .. 'Internal' ] = panel[ name ]
		panel[ name ] = function( _, ... )
			panel[ name .. 'Internal' ]( panel, unpack( { ... } ) )
			return panel
		end
	end
end

function PANEL:InitVar(panel)
	panel:MakeChainableMethod( self, { 'SetPos', 'SetSize', 'SetTall', 'SetWide', 'Dock', 'DockMargin', 'DockPadding' } )
end

function PANEL:Init( )
	-- Instanciate some var
	ix.gui.wheel = self
	self:InitVar(self)
	self:SetSize( 0, 0 )

	hook.Add( "GUIMousePressed", "GUIMousePressed.KVSWheel", function( iKeycode )
		if not IsValid( self ) then
			hook.Remove( "GUIMousePressed", "GUIMousePressed.KVSWheel" )
			return
		end
		
		if not self.ButtonHovered then
			if iKeycode == MOUSE_RIGHT and isfunction( self.OnOutRightClick ) then
				self:OnOutRightClick()
			else
				self:Remove()
			end
		end
	end )
end

function PANEL:AddButton( sName, fFunc, bPreventCalculate )
	self.Buttons = self.Buttons or {}
	table.insert( self.Buttons, {
		Name = sName,
		DoClick = fFunc
	} )

	if bPreventCalculate then return end

	self:CalculateButtons( self.Buttons )
end

function PANEL:ClearButtons()
	self.Buttons = {}
end

function PANEL:SetWheelSize( newWheelSize )
	newWheelSize = math.Round( newWheelSize or wheelSize or ScrH() * 0.7 )
	self:SizeTo( newWheelSize, newWheelSize, 0.4 )

	wheelSize = newWheelSize
	extRadius = wheelSize / 2

	self:SetWheelThickness( 0.2 * wheelSize / 0.7  )
end

function PANEL:SetFontName(name)
	self.FontName = name
end

function PANEL:SetFontSize(size)
	self.FontSize = size
end

function PANEL:SetWheelThickness( newWheelThickness )
	wheelThickness = newWheelThickness
	intRadius = extRadius - wheelThickness
end

function PANEL:CalculateButtons( tButtons )
	if not tButtons then self.Buttons = {} return end

	local buttonsAmount = #tButtons

	for i, tData in ipairs( tButtons ) do
		local angle = ( 2 * math.pi ) / buttonsAmount * i
		local cos = math.cos( angle + math.pi / 2)
		local sin = math.sin( angle + math.pi / 2 )

		local ang1, ang2 = lastAngle and ( math.deg( lastAngle ) ) or 0, ( math.deg( angle ) )
		ang1 = ang1 ~= 360 and ang1 or 0
		ang1, ang2 = ang1 - 90, ang2 - 90

		ang1 = math.min( ang1, ang2 )
		ang2 = math.max( ang1, ang2 )

		local ang1Abs = ang1 < 0 and ( ang1 + 360 ) or ang1
		local ang2Abs = ang2 < 0 and ( ang2 + 360 ) or ang2


		local moyAng = -( ang1 + ang2 ) / 2
		local cosText = math.cos( math.rad( moyAng ) )
		local sinText = math.sin( math.rad( moyAng ) )
		local multiplicator = ( wheelSize - wheelThickness ) /  wheelSize

		tData.Angles = {
			angle = angle,
			cos = cos,
			sin = sin,
			ang1 = ang1,
			ang2 = ang2,
			ang1Abs = ang1Abs,
			ang2Abs = ang2Abs,
			sinText = sinText,
			cosText = cosText,
			multiplicator = multiplicator
		}

		lastAngle = angle
	end

	self.Buttons = tButtons
end

local grey_text = Color( 200, 200, 200, 255 )
local mat = Material( "materials/menu/wheel.png" )
local mat_ext = Material( "materials/menu/wheel_ext.png" )
local mat_int = Material( "materials/menu/wheel_int.png" )
local mat_pointer_b = Material( "materials/menu/wheel_pointer_b.png" )
local mat_pointer_m = Material( "materials/menu/wheel_pointer_m.png" )
local cached_opacity
local cached_angle
local cached_startunhover
local cached_starthover

function PANEL:Paint( w, h )
	if not self.Buttons then self.Buttons = {} return end
	local buttonsAmount = #self.Buttons

	local smallPointer = false
	if buttonsAmount > 4 then
		smallPointer = true
	end

	local grey = Color( 48, 49, 51, 255 )
	local grey_l = Color( grey.r * 1.4, grey.g * 1.4, grey.b * 1.4, 255 )
	local primary = Color( 48, 49, 51, 255 )

	local iPercentage = w / wheelSize

	surface.SetDrawColor( ColorAlpha( grey_l, 250 ) )
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( 0, 0, w, h )

	surface.SetDrawColor( ColorAlpha( grey, 255 * iPercentage ) )
	surface.SetMaterial( mat_ext )
	surface.DrawTexturedRect( 0, 0, w, h )

	local cursor_x, cursor_y = self:CursorPos()
	local cursorDist = math.sqrt( ( extRadius - cursor_x )^2 + ( extRadius - cursor_y )^2 )

	local fakeCircleRadius = cursorDist
	local cosCursor = cursor_x - extRadius
	local angleCursor = math.deg( math.acos( cosCursor / fakeCircleRadius ) )
	angleCursor = cursor_y < extRadius and angleCursor or -1 * angleCursor
	local cursorAbs = angleCursor < 0 and ( angleCursor + 360 ) or angleCursor

	local isCursorIn = math.Clamp( cursorDist, intRadius, extRadius ) == cursorDist
	if isCursorIn then
		self:SetCursor( "hand" )
	else
		self:SetCursor( "arrow" )
	end

	local isSomethingHovered = false

	local last_i = 1
	for i, tData in ipairs( self.Buttons or {} ) do
		local ang1 = tData.Angles.ang1
		local ang2 = tData.Angles.ang2
		local cos = tData.Angles.cos
		local sin = tData.Angles.sin
		local ang1Abs = tData.Angles.ang1Abs
		local ang2Abs = tData.Angles.ang2Abs

		local cosText = tData.Angles.cosText
		local sinText = tData.Angles.sinText
		local multiplicator = tData.Angles.multiplicator

		local moyAng = -( ang1 + ang2 ) / 2
		local cosText = math.cos( math.rad( moyAng ) )
		local sinText = math.sin( math.rad( moyAng ) )
		local multiplicator = ( wheelSize - wheelThickness ) /  wheelSize

		local textColor = grey_text
		local isTextHovered = false

		if iPercentage and iPercentage >= 1 then
			if isCursorIn and ( ang1Abs == ang2Abs or ( math.Clamp( ang1Abs > ang2Abs and angleCursor or cursorAbs, ang1Abs > ang2Abs and ang1 or ang1Abs, ang1Abs > ang2Abs and ang2 or ang2Abs ) == ( ang1Abs > ang2Abs and angleCursor or cursorAbs ) ) ) then
				if not tData.Hovered then tData.Hovered = CurTime() end 

				textColor = color_white
				isTextHovered = true
				isSomethingHovered = true
				cached_startunhover = false
				cached_starthover = CurTime()

				self.ButtonHovered = i

				local iHoverPercentage = math.Clamp( ( CurTime() - tData.Hovered ) * 3, 0, 1 )
				draw.KVS_Arc( 0, 0, extRadius * 2 * iPercentage, wheelThickness, ang1, ang2, 1, ColorAlpha( grey, Lerp( iHoverPercentage, 0, 75 ) )  )
				draw.KVS_Arc( 0, 0, extRadius * 2 * iPercentage, wheelSize * 0.012, Lerp( iHoverPercentage, ang1 - ( ang1 - ang2 ) / 2, ang1 ) , Lerp( iHoverPercentage, ang2 + ( ang1 - ang2 ) / 2, ang2 ), 1, ColorAlpha( primary, 255 * iHoverPercentage ) )

				if iHoverPercentage < 1 then
					cached_opacity = math.max( cached_opacity or 0, 200 * iHoverPercentage )
					cached_angle = cached_angle and LerpAngle( iHoverPercentage, cached_angle, Angle( 0, ang1 + ( ang1 - ang2 ) / 2, 0 ) ) or Angle( 0, ang1 + ( ang1 - ang2 ) / 2, 0 )
				end

				surface.SetDrawColor( ColorAlpha( grey, cached_opacity ) )
				surface.SetMaterial( smallPointer and mat_pointer_m or mat_pointer_b )
				surface.DrawTexturedRectRotated( w / 2, h / 2, w, h, cached_angle.yaw - ( 90 - math.abs( ang2 - ang1 ) ) )
			else
				if self.ButtonHovered == i then
					self.ButtonHovered = nil
				end

				if tData.Hovered then
					tData.Hovered = nil
					tData.LastHovered = CurTime()
				end

				if tData.LastHovered then
					local iHoverPercentage = math.Clamp( 1 - ( ( CurTime() - tData.LastHovered ) * 3 ), 0, 1 )
					draw.KVS_Arc( 0, 0, extRadius * 2 * iPercentage, wheelThickness, ang1, ang2, 1, ColorAlpha( grey, Lerp( iHoverPercentage, 0, 75 ) )  )
				end
			end
		end
		
		local sText = tData.Name
		local sFont = ( isTextHovered and self.FontHoveredName ) or ( self.FontName or "Rajdhani" )
		local iFontSize = ( isTextHovered and self.FontHoveredSize ) or self.FontSize or 20
		iFontSize = iFontSize * iPercentage

		draw.SimpleText( sText, sFont, ( wheelThickness / 2 + ( extRadius + cosText * extRadius ) * multiplicator ) * iPercentage, ( wheelThickness / 2 + ( extRadius + sinText * extRadius ) * multiplicator ) * iPercentage, ColorAlpha( textColor, 255 * iPercentage ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		last_i = i
	end

	if not isSomethingHovered then
		if not cached_startunhover then
			cached_angle = false
			cached_opacity = 0
			cached_startunhover = CurTime()
		end
		cached_percentage = Lerp( ( CurTime() - cached_startunhover ) / 0.4, 0, 1 )

		surface.SetDrawColor( ColorAlpha( grey, 130 * cached_percentage ) )
		surface.SetMaterial( mat_int )
		surface.DrawTexturedRect( 0, 0, w, h )
	elseif cached_starthover then
		cached_percentage = Lerp( ( CurTime() - cached_starthover ) / 0.4, 0, 1 )
		
		surface.SetDrawColor( ColorAlpha( grey, 130 * cached_percentage ) )
		surface.SetMaterial( mat_int )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
end

function PANEL:OnMousePressed( iKeycode )
	if self.Buttons and self.ButtonHovered and self.Buttons[ self.ButtonHovered ] and isfunction( self.Buttons[ self.ButtonHovered ].DoClick ) then
		self.Buttons[ self.ButtonHovered ].DoClick( self )
	else
		self:Remove()
	end
end

derma.DefineControl( 'qButtonWheel' , nil, PANEL, 'Panel' )