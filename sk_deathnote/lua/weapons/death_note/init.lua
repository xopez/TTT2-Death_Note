


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
local TheDeathType = "heartattack"

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
					timer.Simple( DN_DeathTime, function()
						if TarPly:Alive() then
							if TheDeathType == "heartattack" then
								DN_HeartAttack(ply,TarPly)
							end
							if TheDeathType == "ignite" then
								DN_Ignite(ply,TarPly)
							end
							if TheDeathType == "fall" then
								DN_Fall(ply,TarPly)
							end
							if TheDeathType == "explode" then
								DN_Explode(ply,TarPly)
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
						for k,v in pairs(player.GetAll()) do
							if ulx_installed then
								if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
									v:PrintMessage(HUD_PRINTTALK,ply:Nick().." has used the deathnote on "..TarPly:Nick())
								end
							else
								if v:IsAdmin() then
									v:PrintMessage(HUD_PRINTTALK,ply:Nick().." has used the deathnote on "..TarPly:Nick())
								end
							end
						end
					else
						ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
						ply.DeathNoteUse = false
						for k,v in pairs(player.GetAll()) do
							if ulx_installed then
								if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
									v:PrintMessage(HUD_PRINTTALK,ply:Nick().." tried the deathnote on "..TarPly:Nick().." but failed")
								end
							else
								if v:IsAdmin() then
									v:PrintMessage(HUD_PRINTTALK,ply:Nick().." tried the deathnote on "..TarPly:Nick().." but failed")
								end
							end
						end
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
		if ulx_installed then
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
		if ulx_installed then
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
		if ulx_installed then
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
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	TarPly:SetVelocity(Vector(0,0,1000))
	timer.Simple( 1, function() TarPly:SetVelocity(Vector(0,0,-1000)) end )
end
-- Explode --
function DN_Explode(ply,TarPly)
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." Has been set to explode in "..DN_ExplodeTimer.." seconds.")
	end
	Explode_Time_Left = DN_ExplodeTimer
	timer.Create( "Expolde_Countdown", 1, 0, function()
		Explode_Time_Left = Explode_Time_Left - 1
		
		if Explode_Time_Left <= 5 then
			if DN_ExplodeCountDown then
				for k,v in pairs(player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." Will explode in "..Explode_Time_Left.." seconds!!!!")
				end
			end
		end
		
		if !TarPly:Alive() then
			for k,v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." has died before he exploded.")
			end
			timer.Remove("Expolde_Countdown")
		end
		
		if Explode_Time_Left <= 0 then
			timer.Remove("Expolde_Countdown")
			TarPly:SetHealth(1)
			local DN_Explosion = ents.Create("env_explosion")
			DN_Explosion:SetPos(TarPly:GetPos())
	
			DN_Explosion:Spawn()
			DN_Explosion:SetKeyValue("iMagnitude", 100)
			DN_Explosion:Fire("Explode", 0, 0)
			DN_Explosion:EmitSound("BaseGrenade.Explode", 100, 100)
		end
	end)
end