Schema.name = "Quarantine"
Schema.author = "Gaurussel"
Schema.description = "G-Vector."

ix.currency.Set("$", "", "")
ix.config.language = "russian"

ix.util.Include("libs/thirdparty/sh_netstream2.lua")
ix.util.Include("libs/sh_business.lua")
ix.util.Include("libs/sh_color.lua")
ix.util.Include("libs/sh_fagnigutils.lua")
ix.util.Include("libs/sh_utils.lua")
ix.util.Include("libs/sv_utils.lua")
ix.util.Include("libs/sh_voices.lua")

ix.util.Include("cl_schema.lua")
ix.util.Include("sv_schema.lua")

ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")

ix.util.Include("meta/sh_character.lua")
ix.util.Include("meta/sv_character.lua")
ix.util.Include("meta/sh_tool.lua")
ix.util.Include("meta/sh_player.lua")
