


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "../../deathnote_config.lua" )
include( 'shared.lua' )
include( '../../deathnote_config.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
local tttdeathnoteuseage = false
local TheDeathType = "heartattack"

resource.AddFile("vgui/Deathnote_VGUI.vmt")
resource.AddFile("vgui/icon/TTT_DeathNote_Shop.vmt")

if CLIENT then
else
	function SWEP:GetRepeating()
		local ply = self.Owner
		return IsValid(ply)
	end
end

function DNRESET()
	if tttdeathnoteuseage then
		tttdeathnoteuseage = false
	end
	timer.Remove("InstaFallDeath")
	timer.Remove("FallDeath")
	timer.Remove("InstaIngniteDeathCheck")
	timer.Remove("IngniteDeathCheck")
end
hook.Add( "TTTBeginRound", "deathnotereset", DNRESET )

if ( SERVER ) then
util.AddNetworkString( "tttpName" )
util.AddNetworkString( "tttDeathType" )

	net.Receive( "tttDeathType", function( len, ply )
		TheDeathType = string.lower(net.ReadString())
	end )
	
	net.Receive( "tttpName", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local TarPly = player.GetByID(plyName)
		if !tttdeathnoteuseage then
		if TarPly:Alive() then
			tttdeathnoteuseage = true
			timer.Simple( TTT_DN_DeathTime, function()
			if TTT_DN_AlwaysDies then -- Always Die
				tttdeathnoteuseage = false
				if TarPly:Alive() then
						if TheDeathType == "heartattack" then
							DN_TTT_HeartAttack(ply,TarPly)
						end
						if TheDeathType == "ignite" then
							DN_TTT_Ignite(ply,TarPly)
						end
						if TheDeathType == "fall" then
							DN_TTT_Fall(ply,TarPly)
						end
						if TheDeathType == "explode" then
							if TTT_Explode_Enable == true then
								DN_TTT_Explode(ply,TarPly)
							else
								ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry, Explode is not enabled switching to Heart Attack.")
								DN_TTT_HeartAttack(ply,TarPly)
							end
						end
					ply:StripWeapon("death_note_ttt")
				else
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person already dead, Choose a new target.")
				end
			else
				rolled = math.random(1,6)
				if table.HasValue(TTT_DN_Chance, rolled) then
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You rolled a "..rolled)
					tttdeathnoteuseage = false
					if TarPly:Alive() then
						if TheDeathType == "heartattack" then
							DN_TTT_HeartAttack(ply,TarPly)
						end
						if TheDeathType == "ignite" then
							DN_TTT_Ignite(ply,TarPly)
						end
						if TheDeathType == "fall" then
							DN_TTT_Fall(ply,TarPly)
						end
						if TheDeathType == "explode" then
							if TTT_Explode_Enable == true then
								DN_TTT_Explode(ply,TarPly)
							else
								ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry, Explode is not enabled switching to Heart Attack.")
								DN_TTT_HeartAttack(ply,TarPly)
							end
						end
					ply:StripWeapon("death_note_ttt")
					else
						ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person Is Already Dead, You did not lose the Death-Note")
					end
				else
					if TTT_LoseDNOnFail then
						ply:StripWeapon("death_note_ttt")
					else
						ply:StripWeapon("death_note_ttt")
						ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You have lost the Deathnote for now but you will get it back in "..TTT_DNLockOut.." seconds.")
						timer.Simple( TTT_DNLockOut, function()
							if ply:Alive() then
								ply:Give( "death_note_ttt" )
								ply:PrintMessage(HUD_PRINTTALK,"DeathNote: The Deathnote has returned to your red bloody hands.")
							end
						end )
					end
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You rolled a "..rolled.." And needed either a "..table.concat( TTT_DN_Chance, " " ))
					tttdeathnoteuseage = false
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
end

function SWEP:Reload()
	if Debug_Mode_DN then
		for k,v in pairs(player.GetAll()) do
			if ulx_installed then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					tttdeathnoteuseage = false
					self.Owner:PrintMessage(HUD_PRINTTALK,"DeathNote: You Reset the DeathNote")
				end
			else
				if v:IsAdmin() then
					tttdeathnoteuseage = false
					self.Owner:PrintMessage(HUD_PRINTTALK,"DeathNote: You Reset the DeathNote")
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if ( SERVER ) then
		umsg.Start( "tttdeathnote", self.Owner ) 
		umsg.End()
	end
end

function SWEP:SecondaryAttack()
	if ( SERVER ) then
		umsg.Start( "tttdeathnote", self.Owner ) 
		umsg.End()
	end
end

/*----------------------
--Multiple Death Types--
----------------------*/
-- Heart Attack --
function DN_TTT_HeartAttack(ply,TarPly)
	TarPly:Kill()
	TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..TarPly:Nick()..", Has died via the DeathNote.")
	end
end
-- Ignite --
function DN_TTT_Ignite(ply,TarPly)
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	timer.Create( "InstaIngniteDeathCheck", 5, 0, function()
		if !TarPly:Alive() then
			timer.Remove("InstaIngniteDeathCheck")
			TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
		else
			if !TarPly:IsOnFire() then
				if TarPly:Health() >= 50 then
					TarPly:SetHealth(50)
				end
				TarPly:Ignite( 5000000 )
			end
		end						
	end)
	TarPly:Ignite( 5000000 )
	TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote: Ignited via the Death-Note.")
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..TarPly:Nick()..", Ignited via the Death-Note.")
	end
end
-- Fall Death --
function DN_TTT_Fall(ply,TarPly)
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
			TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
			timer.Remove("FallDeath")
		end
	end )
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK,"DeathNote: "..TarPly:Nick()..", Has been flung via the Death-Note.")
	end
end
-- Explode --
function DN_TTT_Explode(ply,TarPly)
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." Has been set to explode in "..TTT_Explode_Time.." seconds!!!!")
		v:PrintMessage(HUD_PRINTCENTER,"Deathnote: "..TarPly:Nick().." Has been set to explode in "..TTT_Explode_Time.." seconds!!!!")
	end
	TTT_Explode_Time_Left = TTT_Explode_Time
	timer.Create( "TTT_Expolde_Countdown", 1, 0, function() 
		TTT_Explode_Time_Left = TTT_Explode_Time_Left - 1
		if TTT_Explode_Time_Left <= 5 then
			for k,v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." Will explode in "..TTT_Explode_Time_Left.." seconds!!!!")
			end
		end
		if !TarPly:Alive() then
			for k,v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." has died before he exploded.")
			end
			timer.Remove("TTT_Expolde_Countdown")
		end
		if TTT_Explode_Time_Left <= 0 then
			timer.Remove("TTT_Expolde_Countdown")
			TarPly:SetHealth(1)
			local DN_Explosion = ents.Create("env_explosion")
			DN_Explosion:SetPos(TarPly:GetPos())
	
			DN_Explosion:Spawn()
			DN_Explosion:SetKeyValue("iMagnitude", 100)
			DN_Explosion:Fire("Explode", 0, 0)
			DN_Explosion:EmitSound("BaseGrenade.Explode", 100, 100)
		end
	end )
end