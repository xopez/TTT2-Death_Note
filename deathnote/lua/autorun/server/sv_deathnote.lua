

local folder = "modules/deathnote/"
deathtypes = {}
for _, File in SortedPairs(file.Find(folder .. "/*.lua", "LUA"), true) do
	if SERVER then
		AddCSLuaFile(folder .. "/" .. File)
		include(folder .. "/" .. File)
		
		local RemoveLua = string.Split( string.lower(File), "." )
		table.insert( deathtypes, RemoveLua[1] )
		-- print("Deathnote Module Loaded: "..RemoveLua[1])
		table.Empty(RemoveLua)
	end
end

if SERVER then
util.AddNetworkString( "deathnote_gui" )
util.AddNetworkString( "dn_name" )
util.AddNetworkString( "dn_deathtype" )

	net.Receive( "dn_deathtype", function( len, ply )
		RawTheDeathType = string.Split( string.lower(net.ReadString()), "." )
		TheDeathType = RawTheDeathType[1]
		print("The Death: "..TheDeathType)
	end )
	
	net.Receive( "dn_name", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local dn_type = net.ReadString()
		local TarPly = player.GetByID(plyName)
		if dn_type == "ent" then
		
			if ply.CanUse then
				ply.CanUse = false
				if !ply.DeathNoteUse then
					if TarPly:Alive() then
						ply.DeathNoteUse = true
						timer.Simple( GetConVar("DeathNote_DeathTime"):GetInt(), function()
							if TarPly:Alive() then
								hook.Run( "dn_module_"..TheDeathType, ply,TarPly,false ) 
								ply.DeathNoteUse = false
								AdminMessege(ply,TarPly,TheDeathType)
							else
								ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
								ply.DeathNoteUse = false
								FailAdminMessege(ply,TarPly)
							end
						end)
					else
						ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
					end
				else
					ply:PrintMessage(HUD_PRINTTALK,"The DeathNote is in cooldown.")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK,"DeathNote: I am sorry, I'm not allowed to do that for you, Please open it form the entity and try again.")
			end
			
		elseif dn_type == "w_ttt" then
			if ply:HasWeapon("death_note_ttt") then
				if !ply.DeathNoteUse then
					if TarPly:Alive() then
						ply.DeathNoteUse = true
						timer.Simple( GetConVar("DeathNote_TTT_DeathTime"):GetInt(), function()
						if GetConVar("DeathNote_TTT_AlwaysDies"):GetBool() then -- Always Die
							ply.DeathNoteUse = false
							if TarPly:Alive() then
								hook.Run( "dn_module_"..TheDeathType, ply,TarPly,true ) 
								ply:StripWeapon("death_note_ttt")
							else
								ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person already dead, Choose a new target.")
							end
						else
							rolled = math.random(1,6)
							if table.HasValue(TTT_DN_Chance, rolled) then
								ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You rolled a "..rolled)
								ply.DeathNoteUse = false
								if TarPly:Alive() then
									hook.Run( "dn_module_"..TheDeathType, ply,TarPly,true ) 
									ply:StripWeapon("death_note_ttt")
								else
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person Is Already Dead, You did not lose the Death-Note")
								end
							else
								if GetConVar("DeathNote_TTT_LoseDNOnFail"):GetBool() then
									ply:StripWeapon("death_note_ttt")
								else
									ply:StripWeapon("death_note_ttt")
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You have lost the Deathnote for now but you will get it back in "..GetConVar("DeathNote_TTT_DNLockOut"):GetInt().." seconds.")
									timer.Simple( GetConVar("DeathNote_TTT_DNLockOut"):GetInt(), function()
										if ply:Alive() then
											ply:Give( "death_note_ttt" )
											ply:PrintMessage(HUD_PRINTTALK,"DeathNote: The Deathnote has returned to your red bloody hands.")
										end
									end )
								end
								ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You rolled a "..rolled.." And needed either a "..table.concat( TTT_DN_Chance, " " ))
								ply.DeathNoteUse = false
							end	
						end
			
						end)
					else
						ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person Is Already Dead")
					end
				else
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote: The DeathNote is in cooldown.")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK,"DeathNote: I am sorry, I'm not allowed to do that for you, Please buy my weapon and try again")
				AdminMessegeExploit_TTT(ply,TarPly)
			end
		
		else
		
			if ply:HasWeapon("death_note") then
				if !ply.DeathNoteUse then
					if TarPly:Alive() then
						ply.DeathNoteUse = true
						timer.Simple( GetConVar("DeathNote_DeathTime"):GetInt(), function()
							if TarPly:Alive() then
								hook.Run( "dn_module_"..TheDeathType, ply,TarPly,false ) 
								ply.DeathNoteUse = false
								AdminMessege(ply,TarPly,TheDeathType)
							else
								ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person Is Already Dead")
								ply.DeathNoteUse = false
								FailAdminMessege(ply,TarPly)
							end
						end)
					else
						ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
					end
				else
					ply:PrintMessage(HUD_PRINTTALK,"The deathnote is in cooldown.")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK,"DeathNote: I am sorry, I'm not allowed to do that for you, Please grab my weapon and try again")
				AdminMessegeExploit(ply,TarPly)
			end
			
		end
	end )
end


--------------- ADMIN MESSEGES ---------------
function AdminMessege(ply,TarPly,TheDeathType)
	if GetConVar("DeathNote_Admin_Messages"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if GetConVar("DeathNote_ulx_installed"):GetBool() then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..ply:Nick().." has used the deathnote on "..TarPly:Nick()..". ("..TheDeathType..")")
				end
			else
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..ply:Nick().." has used the deathnote on "..TarPly:Nick()..". ("..TheDeathType..")")
				end
			end
		end
	else return false end
end

function FailAdminMessege(ply,TarPly)
	if GetConVar("DeathNote_Admin_Messages"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if GetConVar("DeathNote_ulx_installed"):GetBool() then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..ply:Nick().." tried the deathnote on "..TarPly:Nick().." but failed")
				end
			else
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..ply:Nick().." tried the deathnote on "..TarPly:Nick().." but failed")
				end
			end
		end
	else return false end
end

function AdminMessegeExploit(ply,TarPly)
	if GetConVar("DeathNote_Admin_Messages"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if GetConVar("DeathNote_ulx_installed"):GetBool() then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..ply:Nick()..", Had nearly exploited the deathnote on "..TarPly:Nick()..". (died while useing the DN or Trying to use the function with no DeeathNote)")
				end
			else
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..ply:Nick()..", Had nearly exploited the deathnote on "..TarPly:Nick()..". (died while useing the DN or Trying to use the function with no DeeathNote)")
				end
			end
		end
	else return false end
end