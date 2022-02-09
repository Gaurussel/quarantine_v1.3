local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()

	self:SetSize(scrW, scrH)
	self:SetPos(0, 0)

	local text = string.utf8upper("Посмотрев в микроскоп, вы сделали записи..")

	surface.SetFont("ixMenuButtonHugeFont")
	local textW, textH = surface.GetTextSize(text)

	self.label = self:Add("DLabel")
	self.label:SetPaintedManually(true)
	self.label:SetPos(scrW * 0.6 - textW * 0.5, scrH * 0.5 - textH * 0.5)
	--self.label:SetContentAlignment(5)
	self.label:SetFont("ixSubTitleFont")
	self.label:SetText(text)
	self.label:SizeToContents()

	self.progress = 0

	self:CreateAnimation(3, {
		bIgnoreConfig = true,
		target = {progress = 1},

		OnComplete = function(animation, panel)
			if (!panel:IsClosing()) then
				panel:Close()
			end
		end
	})
end

function PANEL:Think()
	self.label:SetAlpha(((self.progress - 0.3) / 0.3) * 255)
end

function PANEL:IsClosing()
	return self.bIsClosing
end

function PANEL:Close()
	self.bIsClosing = true

	self:CreateAnimation(2, {
		index = 2,
		bIgnoreConfig = true,
		target = {progress = 0},

		OnComplete = function(animation, panel)
			panel:Remove()
		end
	})
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintDeathScreenBackground", self, width, height, self.progress)
		self.label:PaintManual()
	derma.SkinFunc("PaintDeathScreen", self, width, height, self.progress)
end

vgui.Register("ixShadowPanel", PANEL, "Panel")

function PLUGIN:OpenShadowPanel(data)
    vgui.Create("ixShadowPanel")
	netstream.Start("Lab.NotesReady", data)
end

netstream.Hook("Lab.OpenMicroscope", function(have, ent)
    local menu = DermaMenu()
    local ply = LocalPlayer()

    if have then
        menu:AddOption( "Просмотреть", function() PLUGIN:OpenShadowPanel(ent:GetNetVar("petri", {})) end )
        menu:AddOption( "Забрать чашку петри", function() netstream.Start("Lab.Petritake", ent, ent:GetNetVar("petri", {})) end )
        menu:Open()
        menu:Center()
    end
end)

local disable = true
local function testcapacity(ply, com, args)
disable = !disable
local checktime = 1
if args[1] then
	if isnumber(tonumber(args[1])) then
		checktime = tonumber(args[1])
	end
end
local CallTime = {}
local WaitTime = {}
local CallLine = {}
local events = {
    ["return"] = function(e)
    	if disable then return end
    	local inf = debug.getinfo(3)
    	if WaitTime[inf.short_src] then
	    	WaitTime[inf.short_src] = WaitTime[inf.short_src] + SysTime() - (CallTime[inf.short_src] or SysTime())
	    else
	    	WaitTime[inf.short_src] = SysTime() - (CallTime[inf.short_src] or SysTime())
	    end
    end,
    ["call"] = function(e)
    	if disable then return end
   		local inf = debug.getinfo(3)
    	CallTime[inf.short_src] = SysTime()
    	CallLine[inf.short_src] = inf.currentline
    end
}
local IN_COUNT = 0
if disable then
	debug.sethook(function(e) end, "cr")
	timer.Remove("debug.waittime")
else
	debug.sethook(function(e)
	    IN_COUNT = IN_COUNT + 1
	    if (IN_COUNT == 1) then
	        events[e](e)
	    end
	    IN_COUNT = IN_COUNT - 1
	end, "cr")
	timer.Create( "debug.waittime", checktime, 0, function()
		local newtable = {}
		local alltime = 0
		for k,v in pairs(WaitTime) do
			table.insert(newtable, {file_str = k, time = v, line = CallLine[k]})
			alltime = alltime + v
		end
		table.sort(newtable, function(a, b) return a.time > b.time end)
		PrintTable(newtable)
		print("All Time:", alltime)
		table.Empty(WaitTime)
		table.Empty(CallLine)
	end)
end

end

concommand.Add("testcapacity",testcapacity)