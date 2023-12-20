function dn_module_explode(ply, TarPly)
	ExplodeInUse = true
	DN_ExplodeTimer = GetConVar("DeathNote_ExplodeTimer"):GetInt()
	for k, v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK, "Deathnote: " .. TarPly:Nick() .. " Has been set to explode in " .. DN_ExplodeTimer .. " seconds.")
	end

	Explode_Time_Left = DN_ExplodeTimer
	timer.Create(
		"Expolde_Countdown",
		1,
		0,
		function()
			Explode_Time_Left = Explode_Time_Left - 1
			if Explode_Time_Left <= 5 then
				if GetConVar("DeathNote_ExplodeCountDown"):GetBool() then
					for k, v in pairs(player.GetAll()) do
						v:PrintMessage(HUD_PRINTTALK, "Deathnote: " .. TarPly:Nick() .. " Will explode in " .. Explode_Time_Left .. " seconds!!!!")
					end
				end
			end

			if not TarPly:Alive() then
				for k, v in pairs(player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK, "Deathnote: " .. TarPly:Nick() .. " has died before he exploded.")
				end

				ExplodeInUse = false
				timer.Remove("Expolde_Countdown")
			end

			if Explode_Time_Left <= 0 then
				timer.Remove("Expolde_Countdown")
				TarPly:SetHealth(1)
				TarPly:GodDisable()
				local DN_Explosion = ents.Create("env_explosion")
				DN_Explosion:SetPos(TarPly:GetPos())
				DN_Explosion:Spawn()
				DN_Explosion:SetKeyValue("iMagnitude", 100)
				DN_Explosion:Fire("Explode", 0, 0)
				DN_Explosion:EmitSound("BaseGrenade.Explode", 100, 100)
				ExplodeInUse = false
			end
		end
	)
end

hook.Add("dn_module_explode", "DN Explode Death", dn_module_explode)