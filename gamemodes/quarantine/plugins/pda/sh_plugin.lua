PLUGIN.name = "PDA chatting system"
PLUGIN.author = "verne"
PLUGIN.description = "PDA chatting system, supporting avatars and nicknames"

--removal of helix chats we dont use
hook.Add("InitializedChatClasses", "ixChatRemoval2", function()
	ix.chat.classes["ooc"] = nil
	ix.chat.classes["pm"] = nil

	ix.chat.Register("ooc", {
		CanSay = function(self, speaker, text)
			/*local pda = speaker:GetCharacter():GetData("pdaequipped", false)
			if pda then
				return true
			else 
				return false
			end*/
			return true
		end,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			chat.AddText(Color(255, 140, 0), "[Общий канал] ", Color(240, 240, 240), speaker:GetCharacter():GetData("pdanickname", speaker:GetCharacter():GetName()), Color(200, 200, 200), ": "..text)
		end,
		prefix = {"//", "/OOC", "/gpda"},
		indicator = "Печатает в КПК",
		description = "Отправить сообщение в глобальную сеть КПК",
		CanHear = function(self, speaker, listener)
			local pda = speaker:GetCharacter():GetData("pdaequipped", false)
			if pda then
				return true
			else
				return false
			end
			return true
		end,
	})

	ix.chat.Register("pm", {
		format = "[PMPDA] %s %s -> %s %s: %s",
		indicator = "Печатает в КПК",
		color = Color(240, 240, 240, 255),
		deadCanChat = true,

		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			chat.AddText(Color(255, 215, 0), "[Личный канал] ", Color(240, 240, 240), speaker:GetCharacter():GetData("pdanickname", speaker:GetCharacter():GetName()), "-", data.target:GetCharacter():GetData("pdanickname", data.target:GetCharacter():GetName()), " ",  Color(200, 200, 200), ": ", text)
		end
	})
end)

-- Overwrites defualt PM Command
function PLUGIN:InitializedPlugins()
	ix.command.list["pm"] = nil

	ix.command.Add("ppda", {
		description = "@cmdPM",
		arguments = {
			ix.type.player,
			ix.type.text
		},
		alias = {"PM", "pmpda"},
		OnRun = function(self, client, target, message)
			if ((client.ixNextPM or 0) < CurTime()) then
				ix.chat.Send(client, "pm", message, false, {client, target}, {target = target})

				client.ixNextPM = CurTime() + 0.5
				target.ixLastPM = client
			end
		end
	})
end

-- NPC talker PDA
ix.chat.Register("npcpdainternal", {
	CanSay = function(self, speaker, text)
	
		return true
	end,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(Color(255, 140, 0), "[Общий канал] ", Color(240, 240, 240), data.name, Color(200, 200, 200), ": "..data.message)
	end,
	prefix = {},
})

ix.command.Add("npcpda", {
	adminOnly = true,
	description = "Write a PDA message from an arbitrary name",
	arguments = {
			ix.type.string,
			ix.type.text
		},
	OnRun = function(self, client, npcname, message)
		
		ix.chat.Send(client, "npcpdainternal", message, nil, nil, {
			name = npcname,
			message = message
		})
	end
})