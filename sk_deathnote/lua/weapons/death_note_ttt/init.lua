


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "../../deathnote_config.lua" )
include( 'shared.lua' )
include( '../../deathnote_config.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
local tttdeathnoteuseage = 0
local TheDeathType = "heartattack"

if CLIENT then
else
	function SWEP:GetRepeating()
		local ply = self.Owner
		return IsValid(ply)
	end
end

function DNRESET()
	if tttdeathnoteuseage == 1 then
		tttdeathnoteuseage = 0
	end
end
hook.Add( "TTTBeginRound", "deathnotereset", DNRESET )

if ( SERVER ) then
util.AddNetworkString( "tttpName" )
util.AddNetworkString( "tttpName1" )
util.AddNetworkString( "tttDeathType" )

	net.Receive( "tttDeathType", function( len, ply )
		TheDeathType = string.lower(net.ReadString())
	end )
	
	net.Receive( "tttpName", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if tttdeathnoteuseage == 0 then
		if killP:Alive() then
			tttdeathnoteuseage = 1
			timer.Simple( TTT_DN_DeathTime, function()
			if TTT_DN_AlwaysDies then
				tttdeathnoteuseage = 0
				if killP:Alive() then
					if TheDeathType == "heartattack" then
						killP:Kill()
						killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
						for k,v in pairs(player.GetAll()) do
							v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..killP:Nick()..", Has died via the DeathNote.")
						end
					end
					if TheDeathType == "burn" then
						if killP:Health() >= 100 then
							killP:SetHealth(100)
						end
						killP:Ignite( 5000000 )
						killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Burned via the Death-Note.")
						for k,v in pairs(player.GetAll()) do
							v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..killP:Nick()..", Burned via the Death-Note.")
						end
					end
					ply:StripWeapon("death_note_ttt")
				else
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person already dead, Choose a new target.")
				end
			else
				rolled = math.random(1,TTT_DN_Chance)
				rolled1 = math.random(1,TTT_DN_Chance)
				if (rolled == rolled1 ) then
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You rolled a "..rolled.." and "..rolled1)
					tttdeathnoteuseage = 0
					if killP:Alive() then
						if TheDeathType == "heartattack" then
							killP:Kill()
							killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
							for k,v in pairs(player.GetAll()) do
								v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..killP:Nick()..", Has died via the DeathNote.")
							end
						end
						if TheDeathType == "burn" then
							if killP:Health() >= 100 then
								killP:SetHealth(100)
							end
							killP:Ignite( 5000000 )
							killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Burned via the Death-Note.")
							for k,v in pairs(player.GetAll()) do
								v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..killP:Nick()..", Burned via the Death-Note.")
							end
						end
						ply:StripWeapon("death_note_ttt")
					else
						ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person Is Already Dead, You did not lose the Death-Note")
					end
				else
					ply:StripWeapon("death_note_ttt")
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You rolled a "..rolled.." and "..rolled1.." and lost the Death-Note")
					tttdeathnoteuseage = 0
				end	
			end

			end)
		else
			ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person Is Already Dead")
		end
		else
			ply:PrintMessage(HUD_PRINTTALK,"DeathNote: The DeathNote is in cooldown.")
		end
	end )

	net.Receive( "tttpName1", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if killP:Alive() then
			ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person Is Already Alive")
		else
			killP:Spawn()
			ply:StripWeapon("death_note_ttt")
		end
	end )	
end

function SWEP:Reload()
	if Debug_Mode_DN then
		for k,v in pairs(player.GetAll()) do
			if ulx_installed then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					deathnoteuseage = 0
					self.Owner:PrintMessage(HUD_PRINTTALK,"DeathNote: You Reset the DeathNote")
				end
			else
				if v:IsAdmin() then
					deathnoteuseage = 0
					self.Owner:PrintMessage(HUD_PRINTTALK,"DeathNote: You Reset the DeathNote")
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	local ply = self.Owner
	if IsValid(self.Owner:GetEyeTrace().Entity) then
		if self.Owner:GetEyeTrace().Entity:IsPlayer() then
			local trKill = player.GetByID(self.Owner:GetEyeTrace().Entity:EntIndex())
			if trKill:Alive() then
				if tttdeathnoteuseage == 0 then
					if trKill:GetRole() != 1 then
						tttdeathnoteuseage = 1
						timer.Simple( TTT_DN_DeathTime, function()
							if TTT_DN_AlwaysDies then
								tttdeathnoteuseage = 0
								if trKill:Alive() then
									trKill:Kill()
									ply:StripWeapon("death_note_ttt")
									trKill:PrintMessage(HUD_PRINTTALK,"DeathNote: died via the Death-Note killed by '"..ply:Nick().."'")
									for k,v in pairs(player.GetAll()) do
										v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..trKill:Nick().." Has died via the DeathNote.")
									end
								else
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person already dead, Choose a new target.")
								end
							else
								rolled = math.random(1,TTT_DN_Chance)
								rolled1 = math.random(1,TTT_DN_Chance)
								if (rolled == rolled1 ) then
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You rolled a "..rolled.." and "..rolled1)
									tttdeathnoteuseage = 0
									if trKill:Alive() then
										trKill:Kill()
										ply:StripWeapon("death_note_ttt")
									trKill:PrintMessage(HUD_PRINTTALK,"DeathNote: died via the Death-Note killed by '"..ply:Nick().."'")
										for k,v in pairs(player.GetAll()) do
											v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..trKill:Nick().." Has died via the DeathNote.")
										end
									else
										ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person Is Already Dead, You did not lose the Death-Note")
									end
								else
									ply:StripWeapon("death_note_ttt")
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You rolled a "..rolled.." and "..rolled1.." and lost the Death-Note")
									tttdeathnoteuseage = 0
								end	
							end
						end)
					else
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote: "..trKill:Nick().." is a traitor, Do not attempt to team kill with the DN.")
					end
					else
					ply:PrintMessage(HUD_PRINTTALK,"The deathnote is in cooldown.")
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if ( SERVER ) then
		umsg.Start( "tttdeathnote", self.Owner ) 
		umsg.End()
	end
end