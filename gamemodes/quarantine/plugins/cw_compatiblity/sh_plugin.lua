PLUGIN.name = "CW 2.0 Compatibility"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Adds compatibility for Customizable Weaponry 2.0 to Helix."
PLUGIN.changeAmmo = {
	["7.92x33mm Kurz"] = "ar2",
	["300 AAC Blackout"] = "ar2",
	["5.7x28mm"] = "pistol",
	["7.65x17MM"] = "smg1",
	["7.62x25mm Tokarev"] = "smg1",
	["7.62x25MM"] = "smg1",
	[".50 BMG"] = "ar2",
	["5.56x45mm"] = "ar2",
	["7.62x51mm"] = "ar2",
	["7.62x31mm"] = "ar2",
	["Frag Grenades"] = "grenade",
	["Flash Grenades"] = "grenade",
	["Smoke Grenades"] = "grenade",
	["9x17MM"] = "smg1",
	["9x19MM"] = "smg1",
	["glock_ammo"] = "smg1",
	[".45 ACP"] = "pistol",
	["9x18MM"] = "pistol",
	["9x39MM"] = "ar2",
	[".40 S&W"] = "pistol",
	[".44 Magnum"] = "357",
	[".50 AE"] = "357",
	["5.45x39MM"] = "ar2",
	["5.56x45MM"] = "ar2",
	["5.7x28MM"] = "pistol",
	["7.62x51MM"] = "ar2",
	["7.62x54mmR"] = "ar2",
	["12 Gauge"] = "buckshot",
	["7.62x54R"] = "sniperround",
	[".338 Lapua"] = "sniperround",
	["RPG_Round"] = "rpg_round",
	[".338mm"] = "sniperround",
	["7.62x39MM"] = "ar2",
	["6.8MM"] = "ar2",
	["9x39MM"] = "ar2",
	["9X19MM"] = "smg1",
	["9x19mm"] = "pistol",
	["10x25MM"] = "pistol",
	["Gauss Ammo"] = "sniperround",
}

-- [[ INCLUDES ]] --

ix.util.Include("sh_cwmeta.lua")
ix.util.Include("cl_cw3d2d.lua")

if (SERVER) then

	util.AddNetworkString("attSound")

	function PLUGIN:InitializedPlugins()
		do
			for k, v in ipairs(weapons.GetList()) do
				local class = v.ClassName
				local prefix

				if (class:find("cw_")) then
					prefix = "cw_"
				elseif (class:find("ma85_")) then
					prefix = "ma85_"
				end
				
				if (prefix and !class:find("base")) then
					v.CanRicochet = false
					v.isGoodWeapon = true
					v.canPenetrate = function() return false end
					v.canRicochet = function() return false end
					v.Primary.DefaultClip = 0

					if v.AddSafeMode then
						v.AddSafeMode = false
					end

					if v.Primary.Ammo and self.changeAmmo[ v.Primary.Ammo ] then
						v.Primary.Ammo = self.changeAmmo[ v.Primary.Ammo ]
					end

					v.VelocitySensitivity = 2

					if (v.MaxSpreadInc) then
						if (!v.neat_MaxSpreadInc) then
							v.neat_MaxSpreadInc = v.MaxSpreadInc
						end
						v.MaxSpreadInc = ((v.neat_MaxSpreadInc or v.MaxSpreadInc) or 0.1) * 3 
					end
					
					if (v.SpreadPerShot) then
						if (!v.neat_SpreadPerShot) then
							v.neat_SpreadPerShot  = v.SpreadPerShot or 0.1
						end

						v.SpreadPerShot = (v.neat_SpreadPerShot or v.SpreadPerShot) * 10

						if (v.FireDelay) then
							v.SpreadCooldown = (v.FireDelay or 0)*0.3
						end
						v.AddSpreadSpeed = v.SpreadPerShot*5
					end
				end
			end
		end
	end

	--[[ FUNCTIONS ]]--

	--[[
		FUNCTION: PLUGIN:PlayerSwitchWeapon( client, _, wep )
		DESCRIPTION: When the player switches to a weapon using the CW 2.0 base, it will set the
		weapon to be lowered if safe, or raised if anything else.
	]]

	function PLUGIN:PlayerSwitchWeapon( client, _, wep )
		if CustomizableWeaponry then 
			if wep.Base == "cw_base" or wep.Base =="cw_kk_ins2_base" then
				timer.Simple( 0.05, function() 
					client:SetWepRaised( false, weapon )
					wep.IsAlwaysRaised = false
				end )

				timer.Simple( 0.3, function()
					wep.CanCustomize = false
				end)
			end
		end
	end

	--[[
		FUNCTION: PLUGIN:CanTransferItem( item, oldInv, newInv )
		DESCRIPTION: This is used to make sure that only attachments can be put into weapon inventories.
		Then is also makes sure that there are no categories taking the same slot as any other attached attachments,
		and makes sure it is also possible to attach the attachment before allowing to be transfered.
	]]

	function PLUGIN:CanTransferItem( item, oldInv, newInv )
		if (newInv.vars and newInv.vars.isGun) then
			if item.attClass then
				local owner
				local items = newInv:GetItems()
				local hostItem = newInv.vars.item
				local weapon = hostItem:GetData("weapon", nil)
				local activeAtts = hostItem:GetData("activeAtt", {})
				local returnval = true

				if (isfunction(newInv.GetOwner)) then
					owner = newInv:GetOwner()
				end

				if not weapon then
					owner:Give( hostItem.class, true )
					weapon = owner:GetWeapon( hostItem.class )

					if table.IsEmpty( activeAtts ) then
						for k, v in pairs( activeAtts ) do
							weapon:attachSpecificAttachment( hostItem.class )
						end
					end

					local canAttach = weapon:canAttachSpecificAttachment( item.attClass )

					if !canAttach then 
						returnval = false
					else
						net.Start("attSound")
							net.WriteString("cw/attach.wav")
						net.Send(owner)
					end
					
					owner:StripWeapon( hostItem.class )
				else
					local canAttach = weapon:canAttachSpecificAttachment( item.attClass )

					if !canAttach then returnval = false end
				end

				for _, v in pairs(items) do
					if (v.id != self.id) then
						local itemTable = ix.item.instances[v.id]

						if (!itemTable) then
							client:NotifyLocalized("tellAdmin", "wid!xt")

							returnval = false
						else
							if ( itemTable.attCategory == item.attCategory ) then
								returnval = false
							end
						end
					end
				end
				return returnval
			end
		end
		
		if (oldInv.vars and oldInv.vars.isGun) then
			local owner
			local hostItem = oldInv.vars.item
			local weapon = hostItem:GetData("weapon", nil)

			if (isfunction(oldInv.GetOwner)) then
				owner = newInv:GetOwner()
			end

			if weapon == nil then
				net.Start("attSound")
					net.WriteString("cw/detach.wav")
				net.Send(owner)
			end

			return true
		end
	end

else
	net.Receive("attSound", function( len, pl )
		local soundstr = net.ReadString()
		surface.PlaySound( soundstr )
	end)
	
	function PLUGIN:InitializedPlugins()
		do
			for k, v in ipairs(weapons.GetList()) do
				local class = v.ClassName
				local prefix

				if (class:find("cw_")) then
					prefix = "cw_"
				elseif (class:find("ma85_")) then
					prefix = "ma85_"
				end
				
				if (prefix and !class:find("base")) then
					v.CanRicochet = false
					v.isGoodWeapon = true
					v.canPenetrate = function() return false end
					v.canRicochet = function() return false end
					v.Primary.DefaultClip = 0

					if v.AddSafeMode then
						v.AddSafeMode = false
					end

					if v.Primary.Ammo and self.changeAmmo[ v.Primary.Ammo ] then
						v.Primary.Ammo = self.changeAmmo[ v.Primary.Ammo ]
					end

					v.VelocitySensitivity = 2

					if (v.MaxSpreadInc) then
						if (!v.neat_MaxSpreadInc) then
							v.neat_MaxSpreadInc = v.MaxSpreadInc
						end
						v.MaxSpreadInc = ((v.neat_MaxSpreadInc or v.MaxSpreadInc) or 0.1) * 3 
					end
					
					if (v.SpreadPerShot) then
						if (!v.neat_SpreadPerShot) then
							v.neat_SpreadPerShot  = v.SpreadPerShot or 0.1
						end

						v.SpreadPerShot = (v.neat_SpreadPerShot or v.SpreadPerShot) * 10

						if (v.FireDelay) then
							v.SpreadCooldown = (v.FireDelay or 0)*0.3
						end
						v.AddSpreadSpeed = v.SpreadPerShot*5
					end
				end
			end
		end
	end
end