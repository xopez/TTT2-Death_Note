function dn_module_heartattack(ply, TarPly, TTT)
	TarPly:Kill()
	TarPly:PrintMessage(HUD_PRINTTALK, "DeathNote: Died via the Death-Note killed by '" .. ply:Nick() .. "'")
	for k, v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK, "DeathNote: " .. TarPly:Nick() .. ", Has died via the DeathNote.")
	end
end

hook.Add("dn_module_heartattack", "DN Heart Attack Death", dn_module_heartattack)