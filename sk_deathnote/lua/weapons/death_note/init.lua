


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "../../deathnote_config.lua" )
include( 'shared.lua' )
include( '../../deathnote_config.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
local deathnoteuseage = 0
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
		if deathnoteuseage == 0 then
		if TarPly:Alive() then
			deathnoteuseage = 1
			timer.Simple( 5, function()
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
					deathnoteuseage = 0
					AdminMessege(ply,TarPly,TheDeathType)
				else
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote: That Person Is Already Dead")
					deathnoteuseage = 0
					FailAdminMessege(ply,TarPly)
				end
			end)
		else
			ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
		end
		else
			ply:PrintMessage(HUD_PRINTTALK,"The deathnote is in cooldown.")
		end
	end )
end

function SWEP:Reload()
	if Debug_Mode_DN then
		for k,v in pairs(player.GetAll()) do
			if ulx_installed then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					deathnoteuseage = 0
					self.Owner:PrintMessage(HUD_PRINTTALK,"You Reset the deathnote")
				end
			else
				if v:IsAdmin() then
					deathnoteuseage = 0
					self.Owner:PrintMessage(HUD_PRINTTALK,"You Reset the deathnote")
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
				if deathnoteuseage == 0 then
				deathnoteuseage = 1
				timer.Simple( 5, function()
					if trKill:Alive() then
						trKill:Kill()
						deathnoteuseage = 0
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
						deathnoteuseage = 0
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