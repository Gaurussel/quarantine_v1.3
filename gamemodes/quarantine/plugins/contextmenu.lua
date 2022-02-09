PLUGIN.name = "Context Menu"
PLUGIN.author = "Steve Jobs"
PLUGIN.description = "Adds context menu for fast commands"

if CLIENT then

	-- local chat_voice_combine = {}
	-- chat_voice_combine["Коды"] = {}
	-- local counter = 0
	-- for k,v in pairs(Schema.voices.stored["combine"]) do
	-- 	counter = counter + 1
	-- 	local char = k[1]
	-- 	if string.find(char, "%d") then
	-- 		chat_voice_combine["Коды"][counter] = k
	-- 		continue
	-- 	end
	-- 	char = string.upper(k[1]..k[2])
	-- 	if string.find(char, "[%z\x01-\x7F\xC2-\xF4][\x80-\xBF]*") then
	-- 		chat_voice_combine[char] = chat_voice_combine[char] or {}
	-- 		chat_voice_combine[char][counter] = k
	-- 		continue
	-- 	end
	-- end
	
	-- local chat_voice_vortigaunt = {}
	-- local counter = 0
	-- for k,v in pairs(Schema.voices.stored["vortigaunt"]) do
	-- 	counter = counter + 1
	-- 	local char = k:utf8sub(1, 1):utf8upper()
	-- 	//char = string.upper(k[1]..k[2])
	-- 	if string.find(char, "[%z\x01-\x7F\xC2-\xF4][\x80-\xBF]*") then
	-- 		chat_voice_vortigaunt[char] = chat_voice_vortigaunt[char] or {}
	-- 		chat_voice_vortigaunt[char][counter] = k
	-- 		continue
	-- 	end
	-- end
	
	local chat_voice_male = {}
	local counter = 0
	for k,v in pairs(Schema.voices.stored["male"]) do
		counter = counter + 1
		local char = k:utf8sub(1, 1):utf8upper()
		//char = string.upper(k[1]..k[2])
		if string.find(char, "[%z\x01-\x7F\xC2-\xF4][\x80-\xBF]*") then
			chat_voice_male[char] = chat_voice_male[char] or {}
			chat_voice_male[char][counter] = k
			continue
		end
	end
	
	local chat_voice_female = {}
	local counter = 0
	for k,v in pairs(Schema.voices.stored["female"]) do
		counter = counter + 1
		local char = k:utf8sub(1, 1):utf8upper()
		//char = string.upper(k[1]..k[2])
		if string.find(char, "[%z\x01-\x7F\xC2-\xF4][\x80-\xBF]*") then
			chat_voice_female[char] = chat_voice_female[char] or {}
			chat_voice_female[char][counter] = k
			continue
		end
	end

	--- Плагин фракций
	-- local faction_commands = {}
	-- faction_commands[1] = {name = "Пригласить", func = function(ply)
	-- 	RunConsoleCommand("say", "/invite "..ply:Name())
	-- end, filter = function(ply) return !ply:Team() end}
	-- faction_commands[2] = {name = "Назначить ранг", func = function(ply)
	-- 	Derma_StringRequest(
	-- 		"Назначение ранга",
	-- 		"Введите ранг, который необходимо выдать игроку "..ply:Name(),
	-- 		"",
	-- 		function( text ) 
	-- 			RunConsoleCommand("say", "/setclass "..string.Split(ply:Name(), " ")[1].." "..text) 
	-- 		end
	-- 	 )
	-- end, filter = function(ply) return ply:Team() == LocalPlayer():Team() end}

	function PLUGIN:OnContextMenuOpen()
		timer.Simple(0, function()
			local contextmenu = DermaMenu()
			-- if LocalPlayer():IsCombine() then
			-- 	local SubMenu, Parent = contextmenu:AddSubMenu( "Голосовые команды" )
			-- 	Parent:SetIcon( "icon16/group.png" )
			-- 	for k,v in SortedPairs(chat_voice_combine) do
			-- 		local SubMenu, Parent = SubMenu:AddSubMenu( k )
			-- 		for k2, v2 in SortedPairsByValue(v) do
			-- 			local command = SubMenu:AddOption( v2, function() RunConsoleCommand("say", v2) end)
			-- 		end
			-- 	end
			-- end
			-- if LocalPlayer():IsDispatch() then
			-- 	local SubMenu, Parent = contextmenu:AddSubMenu( "Диспетчер" )
			-- 	Parent:SetIcon( "icon16/group.png" )
			-- 	for k,v in SortedPairs(Schema.voices.stored["dispatch"]) do
			-- 		local command = SubMenu:AddOption( k, function() RunConsoleCommand("say", "/dispatch "..k) end)
			-- 	end
			-- end
			if Schema.voices.classes["male"].condition(LocalPlayer()) then
				local SubMenu, Parent = contextmenu:AddSubMenu( "Голосовые команды" )
				Parent:SetIcon( "icon16/group.png" )
				for k,v in SortedPairs(chat_voice_male) do
					local SubMenu, Parent = SubMenu:AddSubMenu( k )
					for k2, v2 in SortedPairsByValue(v) do
						local command = SubMenu:AddOption( v2, function() RunConsoleCommand("say", v2) end)
					end
				end
			end
			if LocalPlayer():GetLocalVar("scanner", false) then
				local command = contextmenu:AddOption( "Покинуть сканнер", function() netstream.Start("ejectScanner") end)
			end
			if Schema.voices.classes["female"].condition(LocalPlayer()) then
				local SubMenu, Parent = contextmenu:AddSubMenu( "Голосовые команды" )
				Parent:SetIcon( "icon16/group.png" )
				for k,v in SortedPairs(chat_voice_female) do
					local SubMenu, Parent = SubMenu:AddSubMenu( k )
					for k2, v2 in SortedPairsByValue(v) do
						local command = SubMenu:AddOption( v2, function() RunConsoleCommand("say", v2) end)
					end
				end
			end
			-- local char = LocalPlayer():GetCharacter()
			-- if char:IsVortigaunt() then
			-- 	local SubMenu, Parent = contextmenu:AddSubMenu( "Голосовые команды" )
			-- 	Parent:SetIcon( "icon16/group.png" )
			-- 	for k,v in SortedPairs(chat_voice_vortigaunt) do
			-- 		local SubMenu, Parent = SubMenu:AddSubMenu( k )
			-- 		for k2, v2 in SortedPairsByValue(v) do
			-- 			local command = SubMenu:AddOption( v2, function() RunConsoleCommand("say", v2) end)
			-- 		end
			-- 	end
			-- end
			-- if char then
			-- 	if char:GetData("leader", -1) != -1 then
					
			-- 		local SubMenu, Parent = contextmenu:AddSubMenu( "Фракция" )
			-- 		Parent:SetIcon( "icon16/group.png" )
			-- 		for k,v in pairs(faction_commands) do

			-- 			local SubMenu, Parent = SubMenu:AddSubMenu( v.name )
			-- 			Parent:SetIcon( "icon16/group.png" )

			-- 			for k2, v2 in pairs(player.GetAll()) do
			-- 				if v.filter(v2) then
			-- 					local command = SubMenu:AddOption( v2:Name(), function() v.func(v2) end)
			-- 				end
			-- 			end
			-- 		end
			-- 	end 
			-- end
			contextmenu:Open()
			contextmenu.x = 0
			contextmenu:CenterVertical()
		end)
	end
end