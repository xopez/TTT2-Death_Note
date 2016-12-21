--DeathNote TTT Weapon init


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
local TheDeathType = "heartattack"
TTT_IgniteInUse = false
TTT_FallInUse = false
TTT_ExplodeInUse = false
TTT_BurialInUse = false

resource.AddFile("vgui/deathnote_vgui.vmt")
resource.AddFile("vgui/icon/ttt_deathnote_shop.vmt")

if CLIENT then
else
	function SWEP:GetRepeating()
		local ply = self.Owner
		return IsValid(ply)
	end
end
function DNRESET()
	for k,v in pairs(player.GetAll()) do
		v.DeathNoteUse = false
	end
	TTT_FallInUse = false
	TTT_ExplodeInUse = false
	TTT_BurialInUse = false
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
		if ply:HasWeapon("death_note_ttt") then
			if !ply.DeathNoteUse then
				if TarPly:Alive() then
					ply.DeathNoteUse = true
					timer.Simple( GetConVar("DeathNote_TTT_DeathTime"):GetInt(), function()
					if GetConVar("DeathNote_TTT_AlwaysDies"):GetBool() then -- Always Die
						ply.DeathNoteUse = false
						if TarPly:Alive() then
								if TheDeathType == "heart-attack" then
									DN_TTT_HeartAttack(ply,TarPly)
								end
								if TheDeathType == "ignite" then
									if !TTT_IgniteInUse then
										DN_TTT_Ignite(ply,TarPly)
									else
										ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
									end
								end
								if TheDeathType == "fall" then
									if !TTT_FallInUse then
										DN_TTT_Fall(ply,TarPly)
									else
										ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
									end
								end
								if TheDeathType == "explode" then
									if GetConVar("DeathNote_TTT_Explode_Enable"):GetBool() == true then
										if !TTT_ExplodeInUse then
											DN_TTT_Explode(ply,TarPly)
										else
											ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
										end
									else
										ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry, Explode is not enabled switching to Heart Attack.")
										DN_TTT_HeartAttack(ply,TarPly)
									end
								end
								if TheDeathType == "premature burial" then
									if !TTT_BurialInUse then
										DN_TTT_Burial(ply,TarPly)
									else
										ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
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
							ply.DeathNoteUse = false
							if TarPly:Alive() then
								if TheDeathType == "heart-attack" then
									DN_TTT_HeartAttack(ply,TarPly)
								end
								if TheDeathType == "ignite" then
									if !TTT_IgniteInUse then
										DN_TTT_Ignite(ply,TarPly)
									else
										ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
									end
								end
								if TheDeathType == "fall" then
									if !TTT_FallInUse then
										DN_TTT_Fall(ply,TarPly)
									else
										ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
									end
								end
								if TheDeathType == "explode" then
									if GetConVar("DeathNote_TTT_Explode_Enable"):GetBool() == true then
										if !TTT_ExplodeInUse then
											DN_TTT_Explode(ply,TarPly)
										else
											ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
										end
									else
										ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry, Explode is not enabled switching to Heart Attack.")
										DN_TTT_HeartAttack(ply,TarPly)
									end
								end
								if TheDeathType == "premature burial" then
									if !TTT_BurialInUse then
										DN_TTT_Burial(ply,TarPly)
									else
										ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
									end
								end
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
	end )
end

function SWEP:Reload()
	if Debug_Mode_DN then
		for k,v in pairs(player.GetAll()) do
			if ulx_installed then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					for a,b in pairs(player.GetAll()) do
						b.DeathNoteUse = false
					end
					self.Owner:PrintMessage(HUD_PRINTTALK,"DeathNote: You Reset Everyone's the DeathNote")
				end
			else
				if v:IsAdmin() then
					for a,b in pairs(player.GetAll()) do
						b.DeathNoteUse = false
					end
					self.Owner:PrintMessage(HUD_PRINTTALK,"DeathNote: You Reset Everyone's the DeathNote")
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

function AdminMessegeExploit_TTT(ply,TarPly)
	if GetConVar("DeathNote_Admin_Messeges"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if ulx_installed then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..ply:Nick()..", Had nearly exploited the deathnote on "..TarPly:Nick()..". (died while useing the DN or Trying to use the function with no DeathNote)")
				end
			else
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..ply:Nick()..", Had nearly exploited the deathnote on "..TarPly:Nick()..". (died while useing the DN or Trying to use the function with no DeathNote)")
				end
			end
		end
	else return false end
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
	TTT_IgniteInUse = true
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	timer.Create( "InstaIngniteDeathCheck", 5, 0, function()
		if !TarPly:Alive() then
			timer.Remove("InstaIngniteDeathCheck")
			TTT_IgniteInUse = false
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
-- Explode --
function DN_TTT_Explode(ply,TarPly)
	TTT_ExplodeInUse = true
	TTT_Explode_Time = GetConVar("DeathNote_TTT_Explode_Time"):GetInt()
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
			ply:PrintMessage(HUD_PRINTTALK,"Deathnote: The Deathnote Has returned to your blood soaked hands.")
			ply:Give( "death_note_ttt" )
			TTT_ExplodeInUse = false
			timer.Remove("TTT_Expolde_Countdown")
		end
		if TTT_Explode_Time_Left <= 0 then
			timer.Remove("TTT_Expolde_Countdown")
			TarPly:SetHealth(1)
			TarPly:GodDisable()
			local DN_Explosion = ents.Create("env_explosion")
			DN_Explosion:SetPos(TarPly:GetPos())
			
			DN_Explosion:Spawn()
			DN_Explosion:SetKeyValue("iMagnitude", 100)
			DN_Explosion:Fire("Explode", 0, 0)
			DN_Explosion:EmitSound("BaseGrenade.Explode", 100, 100)
			TTT_ExplodeInUse = false
		end
	end )
end
-- Burial --
function DN_TTT_Burial(ply,TarPly)
	TTT_BurialInUse = true
	local DN_Burial_Count = 0
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	timer.Create( "TTT_BuryTime", 1, 14, function()
		DN_Burial_Count = DN_Burial_Count + 1
		if DN_Burial_Count <= 4 then
			TarPly:SetPos(TarPly:GetPos() + Vector(0,0,-20))
		else
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