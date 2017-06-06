

function dn_module_headexplode(ply,TarPly,TTT)
	if !TTT then -- Sandbox Version
		HeadBone = TarPly:LookupBone("ValveBiped.Bip01_Head1") 
		HeadSize = 1
		timer.Create( "HeadGrow", 0.01, 0, function()
			ply:PrintMessage(HUD_PRINTTALK,HeadSize) 
			if TarPly:Alive() then
				TarPly:ManipulateBoneScale( HeadBone, Vector(HeadSize,HeadSize,HeadSize))
				HeadSize = HeadSize + 0.05
				if HeadSize >= 2 then
					timer.Remove("HeadGrow")
					timer.Simple( 2, function() TarPly:ManipulateBoneScale( HeadBone, Vector(1,1,1)) end )
					ply:PrintMessage(HUD_PRINTTALK,"Deathnote: HEAD TO BLOW")
					TarPly:ManipulateBoneScale( HeadBone, Vector(0,0,0))
					TarPly:Kill()
					
					-- if TarPly:GetRagdollEntity()then
						local Ragdoll = TarPly:GetRagdollEntity()
						
						-- ply:PrintMessage(HUD_PRINTTALK,"Deathnote: Dead Body Thingy"..Ragdoll)
						print("----------AFTER------")
						print(Ragdoll)
						print("----------BEFORE-----")
						timer.Simple( 0.1, function() 
							-- if CLIENT then
								if not TarPly:Alive() and IsValid( Ragdoll ) then
									Ragdoll:ManipulateBoneScale( HeadBone, Vector(0,0,0))
								end
							-- end
						end)
					-- end			
					
					HeadSize = 1
				end
			else
	
				timer.Remove("HeadGrow")
				HeadSize = 1
				TarPly:ManipulateBoneScale( HeadBone, Vector(1,1,1))
			end
		end)
		-- timer.Simple( 5, function() TarPly:ManipulateBoneScale( HeadBone, Vector(1,1,1)) end )
		ply:PrintMessage(HUD_PRINTTALK,"Deathnote: New Death Is A WIP!!!!")
	end
end
hook.Add( "dn_module_headexplode", "DN Heart Attack Death", dn_module_headexplode )