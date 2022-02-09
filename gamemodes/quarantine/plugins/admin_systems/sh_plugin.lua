PLUGIN.name = "Admin Systems"
PLUGIN.author = "Gaurussel"
PLUGIN.description = "Random things"

if (SERVER) then
	timer.Create( "itemcleanup", 3600, 0, function()
		for k, itm in ipairs( ents.FindByClass( "ix_item" ) ) do
			if ( itm.lifetime ) then
				if ( itm.lifetime == true ) then
					itm:TakeDamage(0, game.GetWorld(), game.GetWorld())
					itm:Remove()
				end
			else
				itm.lifetime = true
			end
		end
	end)
end

if (CLIENT) then
	function PLUGIN:OnSpawnMenuOpen()
		if not LocalPlayer():GetCharacter():HasFlags("e") then
			return false
		end
	end
end

ix.command.Add("cleanupitems", {
	adminOnly = true,
	OnRun = function(self, client)
		for k, v in ipairs( ents.FindByClass( "ix_item" ) ) do
			v:TakeDamage(0, game.GetWorld(), game.GetWorld())
			v:Remove()
		end
	end
})

ix.container.Register("models/illusion/eftcontainers/ifak.mdl", {
	name = "Схрон",
	description = "Кем-то оставленный водонепроницаемый рюкзак",
	width = 4,
	height = 4,
	health = 100,
})