function dn_module_ignite(ply, TarPly, TTT)
	TTT_IgniteInUse = true
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end

	timer.Create(
		"InstaIngniteDeathCheck",
		5,
		0,
		function()
			if not TarPly:Alive() then
				timer.Remove("InstaIngniteDeathCheck")
				TTT_IgniteInUse = false
				TarPly:PrintMessage(HUD_PRINTTALK, "DeathNote: Died via the Death-Note killed by '" .. ply:Nick() .. "'")
			else
				if not TarPly:IsOnFire() then
					if TarPly:Health() >= 50 then
						TarPly:SetHealth(50)
					end

					TarPly:Ignite(5000000)
				end
			end
		end
	)

	TarPly:Ignite(5000000)
	TarPly:PrintMessage(HUD_PRINTTALK, "DeathNote: Ignited via the Death-Note.")
	for k, v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK, "DeathNote: " .. TarPly:Nick() .. ", Ignited via the Death-Note.")
	end
end

hook.Add("dn_module_ignite", "DN Iginite Death", dn_module_ignite)