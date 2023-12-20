

function dn_module_prematureburial(ply,TarPly,TTT)
	Grave_Model = "models/props_c17/gravestone004a.mdl"
	Shovel_Model = "models/props_junk/Shovel01a.mdl"
		TTT_BurialInUse = true
		local Pos = Vector(0,0,0)
		local DN_Burial_Count = 0
		local TarPlyPos = 0
		local HasGrave = false
		if TarPly:Health() >= 100 then
			TarPly:SetHealth(100)
		end
		timer.Create( "TTT_BuryTime", 1, 14, function()
			DN_Burial_Count = DN_Burial_Count + 1
			if TarPlyPos == 0 then
				Pos = TarPly:GetPos()
				TarPlyPos = 1
			end
			if DN_Burial_Count <= 4 then
				TarPly:SetPos(TarPly:GetPos() + Vector(0,0,-20))
			else
				-- PreBuryGrave(Pos,TarPly,HasGrave) -- ERROR no existant entity
				TarPly:Freeze( true )
				TarPly:SetHealth(TarPly:Health() - 10)
				if TarPly:Health() <= 10 then
					TarPly:Kill()
				end
				if !TarPly:Alive() then
					TarPly:Freeze( false )
					timer.Remove("TTT_BuryTime")
					for k,v in pairs(player.GetAll()) do
						v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." has been buried alive!")
					end
					TTT_BurialInUse = false
				end
				if DN_Burial_Count == 14 then
					TarPly:Kill()
					TarPly:Freeze( false )
					for k,v in pairs(player.GetAll()) do
						v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." has been buried alive!")
					end
					TTT_BurialInUse = false
				end
			end
		end)
end
hook.Add( "dn_module_prematureburial", "DN Premature Bury Death", dn_module_prematureburial )







function PreBuryGrave(Pos,TarPly,HasGrave)
	if !HasGrave then
		HasGrave = true
		-- local Pos = Pos1
		local Ang = TarPly:GetAngles()
		local Grave = ents.Create( "ent_death_mark" )
		if ( !IsValid( Grave ) ) then return end 
		Grave:SetPos( Pos + Ang:Up() * 17 )
		Grave:SetAngles( Ang )
		Grave:SetOwner(TarPly)
		Grave:SetModel(Grave_Model)
		Grave:Spawn()
		local Shovel = ents.Create( "ent_death_mark" )
		if ( !IsValid( Shovel ) ) then return end
		Shovel:SetPos( Pos + Ang:Up() * 23 + Ang:Forward() * -8 )
		Ang:RotateAroundAxis(Ang:Right(), -20)
		Ang:RotateAroundAxis(Ang:Forward(), 8)
		Ang:RotateAroundAxis(Ang:Up(), 180)
		Shovel:SetAngles( Ang )
		Shovel:SetOwner(TarPly)
		Shovel:SetModel(Shovel_Model)
		Shovel:Spawn()
	end
end
