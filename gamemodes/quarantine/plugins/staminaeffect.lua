PLUGIN.name = "Stamina Effect"
PLUGIN.author = "Riggs"
PLUGIN.description = "..."

ix.StaminaBreathe = false
ALWAYS_RAISED["cw_sai_gry_npc"] = true

function PLUGIN:PlayerTick(ply)
	if not ply.NextStaminaBreathe or ply.NextStaminaBreathe <= CurTime() then
		local stamina = ply:GetNetVar("stm", 100)
		if stamina <= 10 then -- change the '10' to whatever you want for a reasonable number.
			ply:EmitSound("player/heartbeat1.wav", 60)
			ply:EmitSound("player/breathe1.wav", 60)
			ix.StaminaBreathe = true
			timer.Simple(3.9, function()
				ply:StopSound("player/heartbeat1.wav")
				ply:StopSound("player/breathe1.wav")
				ix.StaminaBreathe = false
			end)
			ply.NextStaminaBreathe = CurTime() + 4
		end
	end
end

if CLIENT then
	local staminabluramount = 0
	
	function PLUGIN:HUDPaint()
		local frametime = RealFrameTime()
		if (ix.StaminaBreathe == true) then
			staminabluramount = Lerp(frametime / 2, staminabluramount, 255)
		else
			staminabluramount = Lerp(frametime / 2, staminabluramount, 0)
		end
		
		ix.util.DrawBlurAt(0, 0, ScrW(), ScrH(), 5, 0.2, staminabluramount)
	end
end

function PLUGIN:PlayerStaminaLost(client)
	if client:InVehicle() then
		return false
	end
end

if SERVER then
	concommand.Add("getitemforbandage", function( ply, cmd, args )
		if !ply:IsSuperAdmin() then return end
		local char = ply:GetCharacter()
		local inventory = char:GetInventory()

		inventory:Add("iodide", 1)
		inventory:Add("toiletpaper", 1)
		inventory:Add("ducttape", 1)
	end)
end