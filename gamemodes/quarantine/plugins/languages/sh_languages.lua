
local PLUGIN = PLUGIN

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Русский"
    LANGUAGE.uniqueID = "language_ru"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/ru.png"
    LANGUAGE.format = "%s говорит на русском \"%s\""
    LANGUAGE.formatUnknown = "%s сказал что-то на русском.."

    LANGUAGE.formatWhispering = "%s шепчет на русском \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s шепчет что-то на русском.."

    LANGUAGE.formatYelling = "%s кричит на русском \"%s\""
    LANGUAGE.formatYellingUnknown = "%s кричит что-то на русском.."
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Немецкий"
    LANGUAGE.uniqueID = "language_ger"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/de.png"
    LANGUAGE.format = "%s говорит на немецком \"%s\""
    LANGUAGE.formatUnknown = "%s говорит что-то на немецком.."

    LANGUAGE.formatWhispering = "%s шепчет на немецком \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s шепчет что-то на немецком.."

    LANGUAGE.formatYelling = "%s кричит на немецком \"%s\""
    LANGUAGE.formatYellingUnknown = "%s кричит что-то на немецком.."
LANGUAGE:Register()

--[[local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Bulgarian"
    LANGUAGE.uniqueID = "language_bg"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/bg.png"
    LANGUAGE.format = "%s speaks in bulgarian \"%s\""
    LANGUAGE.formatUnknown = "%s says something in bulgarian"

    LANGUAGE.formatWhispering = "%s whispers in bulgarian \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in bulgarian"

    LANGUAGE.formatYelling = "%s yelling in bulgarian \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in bulgarian"
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Arabic"
    LANGUAGE.uniqueID = "language_ara"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/sa.png"
    LANGUAGE.format = "%s speaks in arabic \"%s\""
    LANGUAGE.formatUnknown = "%s says something in arabic"

    LANGUAGE.formatWhispering = "%s whispers in arabic \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in arabic"

    LANGUAGE.formatYelling = "%s yelling in arabic \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in arabic"
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Vortigese"
    LANGUAGE.uniqueID = "language_vo"
    LANGUAGE.category = "Off-Human"
    LANGUAGE.chatIcon = "icon16/bullet_star.png"
    LANGUAGE.format = "%s speaks in vortigese \"%s\""
    LANGUAGE.formatUnknown = "%s says something in vortigese"

    LANGUAGE.formatWhispering = "%s whispers in vortigese \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in vortigese"

    LANGUAGE.formatYelling = "%s yelling in vortigese \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in vortigese"
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Xenian"
    LANGUAGE.uniqueID = "language_xen"
    LANGUAGE.category = "Off-Human"
    LANGUAGE.chatIcon = "icon16/flag_red.png"
    LANGUAGE.format = "%s speaks in xenian \"%s\""
    LANGUAGE.formatUnknown = "%s says something in xenian"

    LANGUAGE.formatWhispering = "%s whispers in xenian \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in xenian"

    LANGUAGE.formatYelling = "%s yelling in xenian \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in xenian"
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Hindi"
    LANGUAGE.uniqueID = "language_hin"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/in.png"
    LANGUAGE.format = "%s speaks in hindi \"%s\""
    LANGUAGE.formatUnknown = "%s says something in hindi"

    LANGUAGE.formatWhispering = "%s whispers in hindi \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in hindi"

    LANGUAGE.formatYelling = "%s yelling in hindi \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in hindi"
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Bengali"
    LANGUAGE.uniqueID = "language_ben"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/bd.png"
    LANGUAGE.format = "%s speaks in bengali \"%s\""
    LANGUAGE.formatUnknown = "%s says something in bengali"

    LANGUAGE.formatWhispering = "%s whispers in bengali \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in bengali"

    LANGUAGE.formatYelling = "%s yelling in bengali \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in bengali"
LANGUAGE:Register()]]

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Итальянский"
    LANGUAGE.uniqueID = "language_ita"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/it.png"
    LANGUAGE.format = "%s говорит на итальянском \"%s\""
    LANGUAGE.formatUnknown = "%s говорит что то на итальянском"

    LANGUAGE.formatWhispering = "%s шепчет на итальянском \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s шепчет что-то на итальянском.."

    LANGUAGE.formatYelling = "%s кричит на итальянском \"%s\""
    LANGUAGE.formatYellingUnknown = "%s кричит что-то на итальянском.."
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Японский"
    LANGUAGE.uniqueID = "language_jap"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/jp.png"
    LANGUAGE.format = "%s говорит на японском \"%s\""
    LANGUAGE.formatUnknown = "%s говорит что-то на японском.."

    LANGUAGE.formatWhispering = "%s шепчет на японском \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s шепчет что-то на японском.."

    LANGUAGE.formatYelling = "%s кричит на японском \"%s\""
    LANGUAGE.formatYellingUnknown = "%s кричит что-то на японском.."
LANGUAGE:Register()

--[[local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Portuguese"
    LANGUAGE.uniqueID = "language_por"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/pt.png"
    LANGUAGE.format = "%s speaks in portuguese \"%s\""
    LANGUAGE.formatUnknown = "%s says something in portuguese"

    LANGUAGE.formatWhispering = "%s whispers in portuguese \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in portuguese"

    LANGUAGE.formatYelling = "%s yelling in portuguese \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in portuguese"
LANGUAGE:Register()]]

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Испанский"
    LANGUAGE.uniqueID = "language_spa"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/es.png"
    LANGUAGE.format = "%s говорит на испанском \"%s\""
    LANGUAGE.formatUnknown = "%s говорит что-то на испанском.."

    LANGUAGE.formatWhispering = "%s шепчет на испанском \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s шепчет что-то на испанском.."

    LANGUAGE.formatYelling = "%s кричит на испанском \"%s\""
    LANGUAGE.formatYellingUnknown = "%s кричит что-то на испанском.."
LANGUAGE:Register()

--[[local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Farsi"
    LANGUAGE.uniqueID = "language_far"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/ir.png"
    LANGUAGE.format = "%s speaks in farsi \"%s\""
    LANGUAGE.formatUnknown = "%s says something in farsi"

    LANGUAGE.formatWhispering = "%s whispers in farsi \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in farsi"

    LANGUAGE.formatYelling = "%s yelling in farsi \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in farsi"
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Malay"
    LANGUAGE.uniqueID = "language_mal"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/my.png"
    LANGUAGE.format = "%s speaks in malay \"%s\""
    LANGUAGE.formatUnknown = "%s says something in malay"

    LANGUAGE.formatWhispering = "%s whispers in malay \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in malay"

    LANGUAGE.formatYelling = "%s yelling in malay \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in malay"
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Swahili"
    LANGUAGE.uniqueID = "language_swa"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/ke.png"
    LANGUAGE.format = "%s speaks in swahili \"%s\""
    LANGUAGE.formatUnknown = "%s says something in swahili"

    LANGUAGE.formatWhispering = "%s whispers in swahili \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in swahili"

    LANGUAGE.formatYelling = "%s yelling in swahili \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in swahili"
LANGUAGE:Register()

local LANGUAGE = ix.RPLanguages:New()
    LANGUAGE.name = "Urdu"
    LANGUAGE.uniqueID = "language_urd"
    LANGUAGE.category = "Human"
    LANGUAGE.chatIcon = "flags16/ly.png"
    LANGUAGE.format = "%s speaks in urdu \"%s\""
    LANGUAGE.formatUnknown = "%s says something in urdu"

    LANGUAGE.formatWhispering = "%s whispers in urdu \"%s\""
    LANGUAGE.formatWhisperingUnknown = "%s whispers something in urdu"

    LANGUAGE.formatYelling = "%s yelling in urdu \"%s\""
    LANGUAGE.formatYellingUnknown = "%s yelling something in urdu"
LANGUAGE:Register()]]

do
    local stored = ix.RPLanguages:GetAll()
    for _, lang in pairs( stored ) do
        -- IC/Normal talking
        ix.command.Add(string.Replace(lang.uniqueID, 'language_', ''), {
            arguments = ix.type.text,
            description = "Позволяет говорить на " .. string.lower(lang.name) .. " языке",
            OnRun = function(_, pl, message)
                if !pl:GetCharacter() then return end
                if !message || message == "" then return end
                if pl:GetCharacter():CanSpeakLanguage(lang.uniqueID) then
                    ix.chat.Send(pl, lang.uniqueID, message)
                    ix.chat.Send(pl, lang.uniqueID .. "_unknown", message)
                else
                    pl:Notify('Вы не знаете этот язык!')
                end
            end
        })

		ix.chat.Register(lang.uniqueID, {
            format = lang.format,
            icon = lang.chatIcon,
            deadCanChat = false,
            indicator = "chatTalking",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.config.Get("chatListenColor")
				end

				return ix.config.Get("chatColor")
			end,
            CanHear = function(self, speaker, listener)
                local chatRange = ix.config.Get("chatRange", 280)
                return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange) and listener:GetCharacter():CanSpeakLanguage(tostring(lang.uniqueID))
            end
        })

		ix.chat.Register(lang.uniqueID .. "_unknown", {
            format = lang.formatUnknown,
            icon = lang.chatIcon,
            deadCanChat = false,
            indicator = "chatTalking",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.config.Get("chatListenColor")
				end

				return ix.config.Get("chatColor")
			end,
            CanHear = function(self, speaker, listener)
                local chatRange = ix.config.Get("chatRange", 280)
                return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange) and !listener:GetCharacter():CanSpeakLanguage(tostring(lang.uniqueID))
            end,
            OnChatAdd = function(self, speaker, text, bAnonymous, data)
                local color = self:GetColor(self, speaker, text)
                local icon = ix.util.GetMaterial(self.icon)
                local name = bAnonymous and L"someone" or
                    hook.Run("GetCharacterName", speaker, "ic") or
                    (IsValid(speaker) and speaker:Name() or "Console")
                chat.AddText(icon, color, string.format(self.format, name))
            end
        })

        -- Whispering
        ix.command.Add('whisper_' .. string.Replace(lang.uniqueID, 'language_', ''), {
            arguments = ix.type.text,
            description = "Позволяет шептать на " .. string.lower(lang.name) .. " языке",
            OnRun = function(_, pl, message)
                if !pl:GetCharacter() then return end
                if !message || message == "" then return end
                if pl:GetCharacter():CanSpeakLanguage(lang.uniqueID) then
                    ix.chat.Send(pl, "whisper_" .. lang.uniqueID, message)
                    ix.chat.Send(pl, "whisper_" .. lang.uniqueID .. "_unknown", message)
                else
                    pl:Notify('Вы не знаете этот язык!')
                end
            end
        })

		ix.chat.Register("whisper_" .. lang.uniqueID, {
            format = lang.formatWhispering,
            icon = lang.chatIcon,
            deadCanChat = false,
            indicator = "chatWhispering",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.config.Get("chatListenColor")
				end

				return ix.config.Get("chatColor")
			end,
            CanHear = function(self, speaker, listener)
                local chatRange = ix.config.Get("chatRange", 280)
                return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= ((chatRange * chatRange) * 0.25) and listener:GetCharacter():CanSpeakLanguage(tostring(lang.uniqueID))
            end
        })

		ix.chat.Register("whisper_" .. lang.uniqueID .. "_unknown", {
            format = lang.formatWhisperingUnknown,
            icon = lang.chatIcon,
            deadCanChat = false,
            indicator = "chatWhispering",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.config.Get("chatListenColor")
				end

				return ix.config.Get("chatColor")
			end,
            CanHear = function(self, speaker, listener)
                local chatRange = ix.config.Get("chatRange", 280)
                return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= ((chatRange * chatRange) * 0.25) and !listener:GetCharacter():CanSpeakLanguage(tostring(lang.uniqueID))
            end,
            OnChatAdd = function(self, speaker, text, bAnonymous, data)
                local color = self:GetColor(self, speaker, text)
                local icon = ix.util.GetMaterial(self.icon)
                local name = bAnonymous and L"someone" or
                    hook.Run("GetCharacterName", speaker, "ic") or
                    (IsValid(speaker) and speaker:Name() or "Console")
                chat.AddText(icon, color, string.format(self.format, name))
            end
        })

        -- Yelling
        ix.command.Add('yell_' .. string.Replace(lang.uniqueID, 'language_', ''), {
            arguments = ix.type.text,
            description = "Позволяет кричать на " .. string.lower(lang.name) .. " языке",
            OnRun = function(_, pl, message)
                if !pl:GetCharacter() then return end
                if !message || message == "" then return end
                if pl:GetCharacter():CanSpeakLanguage(lang.uniqueID) then
                    ix.chat.Send(pl, "yell_" .. lang.uniqueID, message)
                    ix.chat.Send(pl, "yell_" .. lang.uniqueID .. "_unknown", message)
                else
                    pl:Notify('Вы не знаете этот язык!')
                end
            end
        })

		ix.chat.Register("yell_" .. lang.uniqueID, {
            format = lang.formatYelling,
            icon = lang.chatIcon,
            deadCanChat = false,
            indicator = "chatYelling",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.config.Get("chatListenColor")
				end

				return ix.config.Get("chatColor")
			end,
            CanHear = function(self, speaker, listener)
                local chatRange = ix.config.Get("chatRange", 280)
                return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= ((chatRange * chatRange) * 2) and listener:GetCharacter():CanSpeakLanguage(tostring(lang.uniqueID))
            end
        })

		ix.chat.Register("yell_" .. lang.uniqueID .. "_unknown", {
            format = lang.formatYellingUnknown,
            icon = lang.chatIcon,
            deadCanChat = false,
            indicator = "chatYelling",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.config.Get("chatListenColor")
				end

				return ix.config.Get("chatColor")
			end,
            CanHear = function(self, speaker, listener)
                local chatRange = ix.config.Get("chatRange", 280)
                return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= ((chatRange * chatRange) * 2) and !listener:GetCharacter():CanSpeakLanguage(tostring(lang.uniqueID))
            end,
            OnChatAdd = function(self, speaker, text, bAnonymous, data)
                local color = self:GetColor(self, speaker, text)
                local icon = ix.util.GetMaterial(self.icon)
                local name = bAnonymous and L"someone" or
                    hook.Run("GetCharacterName", speaker, "ic") or
                    (IsValid(speaker) and speaker:Name() or "Console")
                chat.AddText(icon, color, string.format(self.format, name))
            end
        })

        if (CLIENT) then
            ix.command.list["yell_"..string.Replace(lang.uniqueID, 'language_', '')].OnCheckAccess = function(self, pl) return pl:GetCharacter():CanSpeakLanguage(lang.uniqueID) end
            ix.command.list["whisper_"..string.Replace(lang.uniqueID, 'language_', '')].OnCheckAccess = function(self, pl) return pl:GetCharacter():CanSpeakLanguage(lang.uniqueID) end
            ix.command.list[string.Replace(lang.uniqueID, 'language_', '')].OnCheckAccess = function(self, pl) return pl:GetCharacter():CanSpeakLanguage(lang.uniqueID) end

            CHAT_RECOGNIZED[lang.uniqueID] = true
            CHAT_RECOGNIZED[lang.uniqueID .. "_unknown"] = true
            CHAT_RECOGNIZED["yell_" .. lang.uniqueID .. "_unknown"] = true
            CHAT_RECOGNIZED["yell_" .. lang.uniqueID] = true
            CHAT_RECOGNIZED["whisper_" .. lang.uniqueID] = true
            CHAT_RECOGNIZED["whisper_" .. lang.uniqueID .. "_unknown"] = true
        end
    end
end