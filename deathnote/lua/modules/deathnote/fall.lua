

function dn_module_fall(ply,TarPly,TTT)
	if !TTT then
		FallInUse = true
		if TarPly:Health() >= 100 then
			TarPly:SetHealth(100)
		end
		TarPly:SetVelocity(Vector(0,0,1000))
		timer.Simple( 1, function() 
			if TarPly:Alive() then
				TarPly:SetVelocity(Vector(0,0,-1000))
			end 
			FallInUse = false
		end )
	else
		TTT_FallInUse = true
		if TarPly:Health() >= 100 then
			TarPly:SetHealth(100)
		end
		TarPly:SetVelocity(Vector(0,0,1000))
		timer.Simple( 1, function() TarPly:SetVelocity(Vector(0,0,-1000)) end )
		timer.Create( "FallDeath", 10, 0, function()
			if TarPly:Alive() then
				Rand1 = math.random(1, 1000)
				Rand2 = math.random(1, 1000)
				TarPly:SetVelocity(Vector(Rand1,Rand2,1000))
				timer.Simple( 1, function() TarPly:SetVelocity(Vector(0,0,-1000)) end )
			else
				TTT_FallInUse = false
				TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
				timer.Remove("FallDeath")
			end
		end )
		for k,v in pairs(player.GetAll()) do
			v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..TarPly:Nick()..", Has been flung via the Death-Note.")
		end
	end
end
hook.Add( "dn_module_fall", "DN fall Death", dn_module_fall )
