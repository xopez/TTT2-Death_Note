


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
	timer.Remove("InstaFallDeath")
	timer.Remove("FallDeath")
	timer.Remove("InstaIngniteDeathCheck")
	timer.Remove("IngniteDeathCheck")
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
					if TheDeathType == "ignite" then
						if killP:Health() >= 100 then
							killP:SetHealth(100)
						end
						timer.Create( "InstaIngniteDeathCheck", 5, 0, function()
							if !killP:Alive() then
								timer.Remove("InstaIngniteDeathCheck")
								killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
							end						
						end)
						killP:Ignite( 5000000 )
						killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Ignited via the Death-Note.")
						for k,v in pairs(player.GetAll()) do
							v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..killP:Nick()..", Ignited via the Death-Note.")
						end
					end
					if TheDeathType == "fall" then
						if killP:Health() >= 100 then
							killP:SetHealth(100)
						end
					killP:SetVelocity(Vector(0,0,1000))
					timer.Simple( 1, function() killP:SetVelocity(Vector(0,0,-1000)) end )
						timer.Create( "InstaFallDeath", 10, 0, function()
							if killP:Alive() then
								ply:PrintMessage(HUD_PRINTTALK,"DeathNote: "..killP:Nick().." Has escaped death. Retrying.")
								Rand1 = math.random(1, 1000)
								Rand2 = math.random(1, 1000)
								killP:SetVelocity(Vector(Rand1,Rand2,1000))
								timer.Simple( 1, function() killP:SetVelocity(Vector(0,0,-1000)) end )
							else
								killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
								timer.Remove("InstaFallDeath")
							end
						end )
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
						if TheDeathType == "ignite" then
							if killP:Health() >= 100 then
								killP:SetHealth(100)
							end
							timer.Create( "IngniteDeathCheck", 5, 0, function()
								if !killP:Alive() then
									timer.Remove("InstaIngniteDeathCheck")
									killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
								end						
							end)
							killP:Ignite( 5000000 )
							killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Burned via the Death-Note.")
							for k,v in pairs(player.GetAll()) do
								v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..killP:Nick()..", Burned via the Death-Note.")
							end
						end
						if TheDeathType == "fall" then
							if killP:Health() >= 100 then
								killP:SetHealth(100)
							end
						killP:SetVelocity(Vector(0,0,1000))
						timer.Simple( 1, function() killP:SetVelocity(Vector(0,0,-1000)) end )
						timer.Create( "FallDeath", 10, 0, function()
							if killP:Alive() then
								Rand1 = math.random(1, 1000)
								Rand2 = math.random(1, 1000)
								killP:SetVelocity(Vector(Rand1,Rand2,1000))
								timer.Simple( 1, function() killP:SetVelocity(Vector(0,0,-1000)) end )
							else
								killP:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
								timer.Remove("FallDeath")
							end
						end )
							for k,v in pairs(player.GetAll()) do
								v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..killP:Nick()..", Has been flung via the Death-Note.")
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
					tttdeathnoteuseage = 0
					self.Owner:PrintMessage(HUD_PRINTTALK,"DeathNote: You Reset the DeathNote")
				end
			else
				if v:IsAdmin() then
					tttdeathnoteuseage = 0
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