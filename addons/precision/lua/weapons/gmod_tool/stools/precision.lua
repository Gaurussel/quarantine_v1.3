
TOOL.Category		= "Constraints"
TOOL.Name			= "#Толкатель"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "mode" ]	 			= "1"
TOOL.ClientConVar[ "user" ] 			= "1"

TOOL.ClientConVar[ "freeze" ]	 		= "1"
TOOL.ClientConVar[ "nocollide" ]		= "1"
TOOL.ClientConVar[ "nocollideall" ]		= "0"
TOOL.ClientConVar[ "rotation" ] 		= "15"
TOOL.ClientConVar[ "rotate" ] 			= "1"
TOOL.ClientConVar[ "offset" ]	 		= "0"
TOOL.ClientConVar[ "forcelimit" ]		= "0"
TOOL.ClientConVar[ "torquelimit" ] 		= "0"
TOOL.ClientConVar[ "friction" ]	 		= "0"
TOOL.ClientConVar[ "width" ]	 		= "1"
TOOL.ClientConVar[ "offsetpercent" ] 	= "1"
TOOL.ClientConVar[ "removal" ]	 		= "0"
TOOL.ClientConVar[ "move" ]	 			= "1"
TOOL.ClientConVar[ "physdisable" ]		= "0"
TOOL.ClientConVar[ "ShadowDisable" ]	= "0"
TOOL.ClientConVar[ "allowphysgun" ]		= "0"
TOOL.ClientConVar[ "autorotate" ]		= "0"
TOOL.ClientConVar[ "entirecontrap" ]	= "0"
TOOL.ClientConVar[ "nudge" ]			= "25"
TOOL.ClientConVar[ "nudgepercent" ]		= "1"
TOOL.ClientConVar[ "disablesliderfix" ]	= "0"

//adv ballsocket
TOOL.ClientConVar[ "XRotMin" ]		= "-180"
TOOL.ClientConVar[ "XRotMax" ]		= "180"
TOOL.ClientConVar[ "YRotMin" ]		= "-180"
TOOL.ClientConVar[ "YRotMax" ]		= "180"
TOOL.ClientConVar[ "ZRotMin" ]		= "-180"
TOOL.ClientConVar[ "ZRotMax" ]		= "180"
TOOL.ClientConVar[ "XRotFric" ]		= "0"
TOOL.ClientConVar[ "YRotFric" ]		= "0"
TOOL.ClientConVar[ "ZRotFric" ]		= "0"
TOOL.ClientConVar[ "FreeMov" ]		= "0"

//Removal
TOOL.ClientConVar[ "removal_nocollide" ]	= "1"
TOOL.ClientConVar[ "removal_weld" ]	 		= "1"
TOOL.ClientConVar[ "removal_axis" ]	 		= "1"
TOOL.ClientConVar[ "removal_ballsocket" ]	= "1"
TOOL.ClientConVar[ "removal_advballsocket" ]= "1"
TOOL.ClientConVar[ "removal_slider" ]	 	= "1"
TOOL.ClientConVar[ "removal_parent" ]	 	= "1"
TOOL.ClientConVar[ "removal_other" ]	 	= "1"


TOOL.ClientConVar[ "enablefeedback" ]	= "1"
TOOL.ClientConVar[ "chatfeedback" ]		= "1"
TOOL.ClientConVar[ "nudgeundo" ]		= "0"
TOOL.ClientConVar[ "moveundo" ]			= "1"
TOOL.ClientConVar[ "rotateundo" ]		= "1"


function TOOL:SendMessage( message )
	if ( self:GetClientNumber( "enablefeedback" ) == 0 ) then return end
	if ( self:GetClientNumber( "chatfeedback" ) == 1 ) then
		self:GetOwner():PrintMessage( HUD_PRINTTALK, "Tool: " .. message )
	else
		self:GetOwner():PrintMessage( HUD_PRINTCENTER, message )
	end
end

function TOOL:WithinABit( v1, v2 )
	local tol = 0.1
	local da = v1.x-v2.x
	local db = v1.y-v2.y
	local dc = v1.z-v2.z
	if da < tol && da > -tol && db < tol && db > -tol && dc < tol && dc > -tol then
		return true
	else
		da = v1.x+v2.x
		db = v1.y+v2.y
		dc = v1.z+v2.z
		if da < tol && da > -tol && db < tol && db > -tol && dc < tol && dc > -tol then
			return true
		else
			return false
		end
	end
end



function TOOL:Nudge( trace, direction )
	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	local Phys1 = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	local offsetpercent		= self:GetClientNumber( "nudgepercent" ) == 1
	local offset		= self:GetClientNumber( "nudge", 100 )
	local max = 8192
	if ( offsetpercent != 1 ) then
		if ( offset > max ) then
			offset = max
		elseif ( offset < -max ) then
			offset = -max
		end
	end
	//if ( offset == 0 ) then offset = 1 end
	local NewOffset = offset
	if ( offsetpercent ) then
		local glower = trace.Entity:OBBMins()
		local gupper = trace.Entity:OBBMaxs()
		local height = math.abs(gupper.z - glower.z) -0.5
		if self:WithinABit(trace.HitNormal,trace.Entity:GetForward()) then
			height = math.abs(gupper.x - glower.x)-0.5
		elseif self:WithinABit(trace.HitNormal,trace.Entity:GetRight()) then
			height = math.abs(gupper.y - glower.y)-0.5
		end
		NewOffset = NewOffset / 100
		local cap = math.floor(max / height)//No more than max units.
		if ( NewOffset > cap ) then
			NewOffset = cap
		elseif ( NewOffset < -cap ) then
			NewOffset = -cap
		end
		NewOffset = NewOffset * height
	end

	if !IsValid(Phys1) then return end

	if ( self:GetClientNumber( "entirecontrap" ) == 1 ) then
		local NumApp = 0
		local TargetEnts = {}
		local EntsTab = {}
		local ConstsTab = {}
		GetAllEnts(trace.Entity, TargetEnts, EntsTab, ConstsTab)
		for key,CurrentEnt in pairs(TargetEnts) do
			if ( CurrentEnt and CurrentEnt:IsValid() ) then
				local CurrentPhys = CurrentEnt:GetPhysicsObject()
				if ( CurrentPhys:IsValid() ) then

					local TargetPos = CurrentPhys:GetPos() + trace.HitNormal * NewOffset * direction
					CurrentPhys:SetPos( TargetPos )
					CurrentPhys:Wake()
					if (CurrentEnt:GetMoveType() == 0 ) then //phys disabled, so move manually
						CurrentEnt:SetPos( TargetPos )
					end

				end
			end
			NumApp = NumApp + 1
		end
		if ( direction == -1 ) then
			self:SendMessage( NumApp .. " items pushed." )
		elseif ( direction == 1 ) then
			self:SendMessage( NumApp .. " items pulled." )
		else
			self:SendMessage( NumApp .. " items nudged." )
		end
	else
		if ( self:GetClientNumber( "nudgeundo" ) == 1 ) then
			local oldpos = Phys1:GetPos()
			local function NudgeUndo( Undo, Entity, oldpos )
				if trace.Entity:IsValid() then
					trace.Entity:SetPos( oldpos )
				end
			end
			undo.Create("Precision PushPull")
				undo.SetPlayer(self:GetOwner())
				undo.AddFunction( NudgeUndo, trace.Entity, oldpos )
			undo.Finish()
		end
		local TargetPos = Phys1:GetPos() + trace.HitNormal * NewOffset * direction
		Phys1:SetPos( TargetPos )
		Phys1:Wake()
		if ( trace.Entity:GetMoveType() == 0 ) then
			trace.Entity:SetPos( TargetPos )
		end
		if ( direction == -1 ) then
			self:SendMessage( "target pushed." )
		elseif ( direction == 1 ) then
			self:SendMessage( "target pulled." )
		else
			self:SendMessage( "target nudged." )
		end
	end
	return true
end


function TOOL:LeftClick( trace )
	local rotate = self:GetClientNumber( "rotate" ) == 1
	local mode = self:GetClientNumber( "mode" )
	if ( (mode == 2 && self:NumObjects() == 1) || (rotate && self:NumObjects() == 2 ) ) then
		if ( CLIENT ) then return false end
	else
		if ( CLIENT ) then return true end
		return self:Nudge( trace, -1 )
	end
end


function TOOL:RightClick( trace )
	local rotate = self:GetClientNumber( "rotate" ) == 1
	local mode = self:GetClientNumber( "mode" )
	if ( (mode == 2 && self:NumObjects() == 1) || (rotate && self:NumObjects() == 2 ) ) then
		if ( CLIENT ) then return false end
	else
		if ( CLIENT ) then return true end
		return self:Nudge( trace, 1 )
	end
end

function TOOL:Reload( trace )

end

if CLIENT then

	language.Add( "Tool.precision.name", "Precision Tool 0.98e" )
	language.Add( "Tool.precision.desc", "Accurately moves/constrains objects" )
	language.Add( "Tool.precision.0", "Primary: Move/Apply | Secondary: Push | Reload: Pull" )
	language.Add( "Tool.precision.1", "Target the second item. If enabled, this will move the first item.  (Swap weps to cancel)" )
	language.Add( "Tool.precision.2", "Rotate enabled: Turn left and right to rotate the object (Hold Reload or Secondary for other rotation directions!)" )


	language.Add("Undone.precision", "Undone Precision Constraint")
	language.Add("Undone.precision.nudge", "Undone Precision PushPull")
	language.Add("Undone.precision.rotate", "Undone Precision Rotate")
	language.Add("Undone.precision.move", "Undone Precision Move")
	language.Add("Undone.precision.weld", "Undone Precision Weld")
	language.Add("Undone.precision.axis", "Undone Precision Axis")
	language.Add("Undone.precision.ballsocket", "Undone Precision Ballsocket")
	language.Add("Undone.precision.advanced.ballsocket", "Undone Precision Advanced Ballsocket")
	language.Add("Undone.precision.slider", "Undone Precision Slider")

	local showgenmenu = 0//Seems to hide often, probably for the best

	local function AddDefControls( Panel )
		Panel:ClearControls()

		Panel:AddControl("ComboBox",
		{
			Label = "#Presets",
			MenuButton = 1,
			Folder = "precision",
			Options = {},
			CVars =
			{
				[0] = "precision_offset",
				[1] = "precision_forcelimit",
				[2] = "precision_freeze",
				[3] = "precision_nocollide",
				[4] = "precision_nocollideall",
				[5] = "precision_rotation",
				[6] = "precision_rotate",
				[7] = "precision_torquelimit",
				[8] = "precision_friction",
				[9] = "precision_mode",
				[10] = "precision_width",
				[11] = "precision_offsetpercent",
				[12] = "precision_removal",
				[13] = "precision_move",
				[14] = "precision_physdisable",
				[15] = "precision_advballsocket",
				[16] = "precision_XRotMin",
				[17] = "precision_XRotMax",
				[18] = "precision_YRotMin",
				[19] = "precision_YRotMax",
				[20] = "precision_ZRotMin",
				[21] = "precision_ZRotMax",
				[22] = "precision_XRotFric",
				[23] = "precision_YRotFric",
				[24] = "precision_ZRotFric",
				[25] = "precision_FreeMov",
				[26] = "precision_ShadowDisable",
				[27] = "precision_allowphysgun",
				[28] = "precision_autorotate",
				[29] = "precision_massmode",
				[30] = "precision_nudge",
				[31] = "precision_nudgepercent",
				[32] = "precision_disablesliderfix"
			}
		})

		//Panel:AddControl( "Label", { Text = "Secondary attack pushes, Reload pulls by this amount:", Description	= "Phx 1x is 47.45, Small tiled cube is 11.8625 and thin is 3 exact units" }  )
		Panel:AddControl( "Slider",  { Label	= "Push/Pull Amount",
					Type	= "Float",
					Min		= 1,
					Max		= 100,
					Command = "precision_nudge",
					Description = "Distance to push/pull props with altfire/reload"}	 ):SetDecimals( 4 )


		Panel:AddControl( "Checkbox", { Label = "Push/Pull as Percent (%) of target's depth", Command = "precision_nudgepercent", Description = "Unchecked = Exact units, Checked = takes % of width from target prop when pushing/pulling" } )
	end


	function TOOL.BuildCPanel( Panel )
		AddDefControls( Panel )
	end

end

function TOOL:Holster()

end