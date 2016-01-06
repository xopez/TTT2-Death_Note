--DeathNote Weapon init


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
local TheDeathType = "heart-attack"
FallInUse = false
ExplodeInUse = false
BurialInUse = false

if CLIENT then
else
	function SWEP:GetRepeating()
		local ply = self.Owner
		return IsValid(ply)
	end
end

if ( SERVER ) then
util.AddNetworkString( "pName" )
util.AddNetworkString( "DeathType" )

	net.Receive( "DeathType", function( len, ply )
		TheDeathType = string.lower(net.ReadString())
	end )

	net.Receive( "pName", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local TarPly = player.GetByID(plyName)
		if ply:HasWeapon("death_note") then
			if !ply.DeathNoteUse then
				if TarPly:Alive() then
					ply.DeathNoteUse = true
					timer.Simple( GetConVar("DeathNote_DeathTime"):GetInt(), function()
						if TarPly:Alive() then
							if TheDeathType == "heart-attack" then
								DN_HeartAttack(ply,TarPly)
							end
							if TheDeathType == "ignite" then
								DN_Ignite(ply,TarPly)
							end
							if TheDeathType == "fall" then
								if !FallInUse then
									DN_Fall(ply,TarPly)
								else
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
								end
							end
							if TheDeathType == "explode" then
								if !ExplodeInUse then
									DN_Explode(ply,TarPly)
								else
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
								end
							end
							if TheDeathType == "premature burial" then
								if !BurialInUse then
									DN_Burial(ply,TarPly)
								else
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
								end
							end
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
	end )
end

function SWEP:Reload()
	if GetConVar("DeathNote_Debug"):GetBool() then
		for k,v in pairs(player.GetAll()) do
			if GetConVar("DeathNote_ulx_installed"):GetBool() then
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
	local ply = self.Owner
	if IsValid(self.Owner:GetEyeTrace().Entity) then
		if self.Owner:GetEyeTrace().Entity:IsPlayer() then
			local trKill = player.GetByID(self.Owner:GetEyeTrace().Entity:EntIndex())
			if trKill:Alive() then
				if !ply.DeathNoteUse then
				ply.DeathNoteUse = true
				timer.Simple( 5, function()
					if trKill:Alive() then
						trKill:Kill()
						ply.DeathNoteUse = false
						TheDeathType = "heart-attack"
						AdminMessege(ply,trKill,TheDeathType)
					else
						ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
						ply.DeathNoteUse = false
						FailAdminMessege(ply,trKill)
					end
				end)
				else
					ply:PrintMessage(HUD_PRINTTALK,"The deathnote is in cooldown.")
				end
			end
		end
	end
	if self.Owner:GetEyeTrace().Entity:IsNPC() then
				self.Owner:GetEyeTrace().Entity:Fire("sethealth", "0", 0)
	end	
end
	
function SWEP:SecondaryAttack()
	if ( SERVER ) then
		umsg.Start( "deathnote", self.Owner ) 
		umsg.End()
	end
end

function AdminMessege(ply,TarPly,TheDeathType)
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
end

function FailAdminMessege(ply,TarPly)
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
end

function AdminMessegeExploit(ply,TarPly)
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
end

/*----------------------
--Multiple Death Types--
----------------------*/
-- Heart Attack --
function DN_HeartAttack(ply,TarPly)
	TarPly:Kill()
	TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote: Died via the Death-Note killed by '"..ply:Nick().."'")
end
-- Ignite --
function DN_Ignite(ply,TarPly)
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	TarPly:Ignite( 5000000 )
	TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote: Ignited via the Death-Note.")
end
-- Fall Death --
function DN_Fall(ply,TarPly)
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
end
-- Explode --
function DN_Explode(ply,TarPly)
	ExplodeInUse = true
	DN_ExplodeTimer = GetConVar("DeathNote_ExplodeTimer"):GetInt()
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." Has been set to explode in "..DN_ExplodeTimer.." seconds.")
	end
	Explode_Time_Left = DN_ExplodeTimer
	timer.Create( "Expolde_Countdown", 1, 0, function()
		Explode_Time_Left = Explode_Time_Left - 1
		
		if Explode_Time_Left <= 5 then
			if GetConVar("DeathNote_ExplodeCountDown"):GetBool() then
				for k,v in pairs(player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." Will explode in "..Explode_Time_Left.." seconds!!!!")
				end
			end
		end
		
		if !TarPly:Alive() then
			for k,v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." has died before he exploded.")
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
	end)
end
-- Burial --
function DN_Burial(ply,TarPly)
	BurialInUse = true
	local DN_Burial_Count = 0
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	timer.Create( "BuryTime", 1, 15, function()
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
				timer.Remove("BuryTime")
				for k,v in pairs(player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." has been buried alive!")
				end
				BurialInUse = false
			end
			if DN_Burial_Count == 15 then
				TarPly:Kill()
				TarPly:Freeze( false )
				timer.Remove("BuryTime")
				for k,v in pairs(player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." has been buried alive!")
				end
				BurialInUse = false
			end
		end
	end)
end