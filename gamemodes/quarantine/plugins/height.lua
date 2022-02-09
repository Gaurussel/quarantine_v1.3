
local PLUGIN = PLUGIN

PLUGIN.name = "Height"
PLUGIN.description = "Changes character height based on inputted height."
PLUGIN.author = "pedro.santos53"
PLUGIN.HeightTable = {
	["150"] = 0.8,
	["162"] = 0.97,
	["169"] = 1,
	["176"] = 1.05,
	["179"] = 1.07,
	["182"] = 1.10,
	["188"] = 1.13,
}

function PLUGIN:CharacterLoaded(character)
	local client = character:GetPlayer()
	print("1")
	timer.Simple(0.1, function()
		print(character:GetHeight())

		local scaleViewFix = PLUGIN.HeightTable[character:GetHeight()]
		local scaleViewFixOffset = Vector(0, 0, 64)
		local scaleViewFixOffsetDuck = Vector(0, 0, 28)

		client:SetViewOffset(scaleViewFixOffset * scaleViewFix)
		client:SetViewOffsetDucked(scaleViewFixOffsetDuck * scaleViewFix)

		client:SetModelScale( scaleViewFix )
	end)
end