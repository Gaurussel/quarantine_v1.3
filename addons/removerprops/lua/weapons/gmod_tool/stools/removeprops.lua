/*
	Perma Remove Props
	Created by Malboro, July 2015
	
	Ideas:
		Remove FUCKING Maps Props
		
	Errors:
		Errors on die

*/

TOOL.Category		=	"Props Tool"
TOOL.Name			=	"RemoveProps"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

if CLIENT then
	language.Add("Tool.removeprops.name", "RemoveProps")
	language.Add("Tool.removeprops.desc", "Remove a props permanently")
	language.Add("Tool.removeprops.0", "LeftClick: Add RightClick: OpenMenu")
end

if SERVER then
	util.AddNetworkString("ContentRmvProps")
	util.AddNetworkString("RmvPropsSQL")
	sql.Query("CREATE TABLE IF NOT EXISTS removeprops('id' INTEGER NOT NULL, 'map' TEXT NOT NULL, 'content' TEXT NOT NULL, PRIMARY KEY('id'));")
end

if SERVER then

	local function RmvPropsSQL( um, ply )

		local EntIndex = net.ReadFloat()
		if not ply:IsAdmin() then return end
		
		local content = sql.Query( "SELECT * FROM removeprops;" )

		if content == nil then return end
		
		for k, v in pairs( content ) do

			if game.GetMap() == v.map then

				local data = util.JSONToTable(v.content)

				if data.ID == EntIndex then

					sql.Query("DELETE FROM removeprops WHERE id = ".. v.id ..";")
				
				end

			end

		end

	end
	net.Receive("RmvPropsSQL", RmvPropsSQL)

end

local function RemoveProps()

	if CLIENT then return end

	local content = sql.Query( "SELECT * FROM removeprops;" )

	if not content or content == nil then return end
	
	for k, v in pairs( content ) do

		if game.GetMap() == v.map then

			local data = util.JSONToTable(v.content)

			local ent = ents.GetByIndex(data.ID)

			for k2, v2 in pairs(ents.FindInSphere( data.Pos, 0.2 )) do
				
				if v2:GetModel() == data.Model and v2:GetClass() == data.Name  then
					
					v2:Remove()

				end

			end

			/*if ent:IsValid() then
				
				ent:Remove()

			end*/

		end

	end

end
hook.Add("InitPostEntity", "InitializeRemoveProps", RemoveProps)
hook.Add("PostCleanupMap", "WhenCleanUpRemoveProps", RemoveProps)
timer.Simple(5, function() RemoveProps() end) -- When the hook isn't call ...

function TOOL:LeftClick(trace)

	if CLIENT then return end

	local ply = self:GetOwner()
	local ent = trace.Entity

	if not self:GetOwner():IsAdmin() then return false end
	if ent:IsWorld() then ply:ChatPrint( "You can't remove the world DUDE !" ) return false end
	if not ent then ply:ChatPrint( "That is not a valid entity !" ) return false end
	if not ent:IsValid() then ply:ChatPrint( "That is not a valid entity !" ) return false end
	if ent:IsPlayer() then ply:ChatPrint( "That is a player !" ) return false end
	if ent.OnDieFunctions then ply:ChatPrint( "You can't remove this !" ) return false end
	if ent.PermaProps then ply:ChatPrint( "You can't remove this !" ) return false end

	local effectdata = EffectData()
	effectdata:SetOrigin(ent:GetPos())
	effectdata:SetMagnitude(2)
	effectdata:SetScale(2)
	effectdata:SetRadius(3)
	util.Effect("Sparks", effectdata)

	local content = {}
	content.ID = ent:EntIndex()
	content.Name = ent:GetClass()
	content.Model = ent:GetModel()
	content.Pos = ent:GetPos()
	content.Angle = ent:GetAngles()

	sql.Query("INSERT INTO removeprops (id, map, content) VALUES(NULL, ".. sql.SQLStr(game.GetMap()) ..", ".. sql.SQLStr(util.TableToJSON(content)) ..");")
	ply:ChatPrint("You remove " .. ent:GetClass() .. " permanently in the map !")

	ent:Remove()

	return true

end

function TOOL:RightClick(trace)

	if CLIENT then return end

	local SendTable = {}
	local content = sql.Query( "SELECT * FROM removeprops;" )

	if content == nil then return end
	
	for k, v in pairs( content ) do

		if game.GetMap() == v.map then

			local data = util.JSONToTable(v.content)

			table.insert(SendTable, data)

		end

	end

	net.Start("ContentRmvProps")
	net.WriteTable(SendTable)
	net.Send(self:GetOwner())

	return false

end

function TOOL:Reload(trace)

	if CLIENT then return end

	return false

end

function TOOL.BuildCPanel(panel)

	panel:AddControl("Header",{Text = "Perma Remove Props", Description = "Remove a server props for restarts\nBy Malboro"})

end

local function ContentRmvProps()

	local Content = net.ReadTable()

	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetSize( 500, 200 )
	DermaPanel:SetTitle( "Removed props" )
	DermaPanel:Center()
	DermaPanel:MakePopup()
	 
	local DermaListView = vgui.Create("DListView", DermaPanel)
	DermaListView:SetPos(25, 30)
	DermaListView:SetSize(450, 125)
	DermaListView:SetMultiSelect(false)
	local Col1 = DermaListView:AddColumn("ID")
	local Col2 = DermaListView:AddColumn("Name")
	local Col3 = DermaListView:AddColumn("Model")
	Col1:SetMinWidth(50)
	Col1:SetMaxWidth(50)

	Col2:SetMinWidth(80)
	Col2:SetMaxWidth(80)
	DermaListView.OnRowRightClick = function(panel, line)

		local MenuButtonOptions = DermaMenu()
	    MenuButtonOptions:AddOption("Draw entity", function() 

	    	if not LocalPlayer().DrawRemovedEnt or not istable(LocalPlayer().DrawRemovedEnt) then LocalPlayer().DrawRemovedEnt = {} end

	    	if LocalPlayer().DrawRemovedEnt[Content[DermaListView:GetLine(line):GetValue(1)].ID] and LocalPlayer().DrawRemovedEnt[Content[DermaListView:GetLine(line):GetValue(1)].ID]:IsValid() then return end

		    local ent = ents.CreateClientProp( Content[DermaListView:GetLine(line):GetValue(1)].Model ) 
			ent:SetPos( Content[DermaListView:GetLine(line):GetValue(1)].Pos )
			ent:SetAngles( Content[DermaListView:GetLine(line):GetValue(1)].Angle )

			LocalPlayer().DrawRemovedEnt[Content[DermaListView:GetLine(line):GetValue(1)].ID] = ent

		end )

		if LocalPlayer().DrawRemovedEnt and LocalPlayer().DrawRemovedEnt[Content[DermaListView:GetLine(line):GetValue(1)].ID] != nil then
			
			MenuButtonOptions:AddOption("Stop Drawing", function() 

				LocalPlayer().DrawRemovedEnt[Content[DermaListView:GetLine(line):GetValue(1)].ID]:Remove()
				LocalPlayer().DrawRemovedEnt[Content[DermaListView:GetLine(line):GetValue(1)].ID] = nil

			end )

		end

	    MenuButtonOptions:AddOption("Remove", function()

	    	net.Start("RmvPropsSQL")
	    	net.WriteFloat(Content[DermaListView:GetLine(line):GetValue(1)].ID)
	    	net.SendToServer()

	    	if LocalPlayer().DrawRemovedEnt and LocalPlayer().DrawRemovedEnt[Content[DermaListView:GetLine(line):GetValue(1)].ID] != nil then

	    		LocalPlayer().DrawRemovedEnt[Content[DermaListView:GetLine(line):GetValue(1)].ID]:Remove()
				LocalPlayer().DrawRemovedEnt[Content[DermaListView:GetLine(line):GetValue(1)].ID] = nil
				
	    	end

	    	DermaListView:RemoveLine(line)

	    	LocalPlayer():ChatPrint("Removed successfully from the database ! ( Need server restart )")


		end )
	    MenuButtonOptions:Open()
		
	end
	 
	for k, v in pairs(Content) do

	    DermaListView:AddLine(k, v.Name, v.Model)

	end

end
net.Receive("ContentRmvProps", ContentRmvProps)

local function RemoverViewer()

	if not LocalPlayer().DrawRemovedEnt or not istable(LocalPlayer().DrawRemovedEnt) then return end

    local pos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 10
    local ang = LocalPlayer():EyeAngles()

    ang = Angle(ang.p + 90, ang.y, 0)

    for k, v in pairs(LocalPlayer().DrawRemovedEnt) do

    	if not v or not v:IsValid() then LocalPlayer().DrawRemovedEnt[k] = nil continue end

	    render.ClearStencil()
	    render.SetStencilEnable(true)
	        render.SetStencilWriteMask(255)
	        render.SetStencilTestMask(255)
	        render.SetStencilReferenceValue(15)
	        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	        render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
	        render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
	        render.SetBlend(0)
	        v:DrawModel()
	        render.SetBlend(1)
	        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	        cam.Start3D2D(pos, ang, 1)
	                surface.SetDrawColor(255, 0, 0, 255)
	                surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)
	        cam.End3D2D()
	        v:DrawModel()
	    render.SetStencilEnable(false)

	end

end
hook.Add("PostDrawOpaqueRenderables", "RemoverViewer", RemoverViewer)