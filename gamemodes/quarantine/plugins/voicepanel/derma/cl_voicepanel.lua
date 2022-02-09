
local PLUGIN = PLUGIN
local GM = GAMEMODE or GM

local PANEL = {}
local PlayerVoicePanels = {}

function PANEL:Init()

	self.Panel = vgui.Create( "DPanel", self )
	self.Panel:Dock( FILL )
	self.Panel:DockMargin( 8, 0, 0, 0 )

	self.Panel.Paint = function()

	end

	self.LabelName = vgui.Create( "DLabel", self.Panel )
	self.LabelName:SetFont( "ixSmallFont" )
	self.LabelName:SetSize(0, 32)
	self.LabelName:Dock( TOP )
	self.LabelName:DockMargin( 0, 0, 0, 0 )
	self.LabelName:SetTextColor( Color( 255, 255, 255, 255 ) )

	self.Avatar = vgui.Create( "ModelImage", self )
	self.Avatar:Dock( LEFT )
	self.Avatar:SetSize( 32, 32 )

	self:SetSize( 250, 32 + 8 )
	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( BOTTOM )

end

function PANEL:Setup( ply )

	self.ply = ply

	local localCharacter = LocalPlayer():GetCharacter()
	local character = self.ply:GetCharacter()

	if (localCharacter and character) then
		local bRecognize = hook.Run("IsCharacterRecognized", localCharacter, character:GetID())
			or hook.Run("IsPlayerRecognized", self.ply) or hook.Run("ShouldAllowScoreboardOverride", self.ply)

		self.LabelName:SetText( bRecognize and character:GetName() or character:GetDescription()  )

		if character:GetMasked() then
			self.LabelName:SetText("Неизвестный "..character:GetID())
		end
	end
	self.Avatar:SetModel(ply:GetModel())
	/*
	if ((!ICON_RENDER_QUEUE[string.lower(ply:GetModel())])) then
		ICON_RENDER_QUEUE[string.lower(ply:GetModel())] = true
		self.Avatar:RebuildSpawnIcon()
	end*/
	/*
	local headpos = self.Avatar.Entity:GetBonePosition(self.Avatar.Entity:LookupBone("ValveBiped.Bip01_Head1"))
	self.Avatar:SetLookAt(headpos+Vector(0,0,2))
	self.Avatar:SetCamPos(headpos-Vector(-30, 0, 0))
	self.Avatar.Entity:SetEyeTarget(self.Avatar:GetCamPos())

	if ((!ICON_RENDER_QUEUE[string.lower(model)])) then
		local iconCam
		iconCam = {
			cam_pos = Vector(29.750843, 0.086402, 63.880325),
			cam_fov = 20,
			cam_ang = Angle(356.186, 180.000, 0.000),
		}
		ICON_RENDER_QUEUE[string.lower(model)] = true

		self.Avatar:RebuildSpawnIconEx(
			iconCam
		)
	end
	*/

	self:InvalidateLayout()
end

function PANEL:Paint( w, h )

	if ( !IsValid( self.ply ) ) then return end
	draw.RoundedBox( 4, 0, 0, w, h, Color( 0, self.ply:VoiceVolume() * 255, 0, 240 ) )

end

function PANEL:Think()

	if ( self.fadeAnim ) then
		self.fadeAnim:Run()
	end

end

function PANEL:FadeOut( anim, delta, data )
	
	if ( anim.Finished ) then
	
		if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end
		
	return end
	
	self:SetAlpha( 255 - ( 255 * delta ) )

end

derma.DefineControl( "VoiceNotifyHN", "", PANEL, "DPanel" )


function GM:PlayerStartVoice( ply )

	if ( !IsValid( g_VoicePanelList ) ) then return end
	
	-- There'd be an exta one if voice_loopback is on, so remove it.
	GAMEMODE:PlayerEndVoice( ply )


	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			PlayerVoicePanels[ ply ].fadeAnim:Stop()
			PlayerVoicePanels[ ply ].fadeAnim = nil
		end

		PlayerVoicePanels[ ply ]:SetAlpha( 255 )

		return

	end

	if ( !IsValid( ply ) ) then return end

	local pnl = g_VoicePanelList:Add( "VoiceNotifyHN" )
	pnl:Setup( ply )
	
	PlayerVoicePanels[ ply ] = pnl

end

local function VoiceClean()

	for k, v in pairs( PlayerVoicePanels ) do
	
		if ( !IsValid( k ) ) then
			GAMEMODE:PlayerEndVoice( k )
		end
	
	end

end
timer.Create( "VoiceClean", 10, 0, VoiceClean )

function GM:PlayerEndVoice( ply )

	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then return end

		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 2 )

	end

end