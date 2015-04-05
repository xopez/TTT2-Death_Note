


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
util.AddNetworkString( "pName1" )
util.AddNetworkString( "DeathType" )

	net.Receive( "DeathType", function( len, ply )
		TheDeathType = string.lower(net.ReadString())
	end )

	net.Receive( "pName", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if deathnoteuseage == 0 then
		if killP:Alive() then
			deathnoteuseage = 1
			timer.Simple( 5, function()
				if killP:Alive() then
					if TheDeathType == "heartattack" then
						killP:Kill()
					end
					if TheDeathType == "burn" then
						if killP:Health() >= 100 then
							killP:SetHealth(100)
						end
						killP:Ignite( 5000000 )
					end
					deathnoteuseage = 0
					for k,v in pairs( player.GetAll() ) do
						if ulx_installed then
							if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
								v:PrintMessage(HUD_PRINTTALK,ply:Nick().." has used the deathnote on "..killP:Nick()..". ("..TheDeathType..")")
							end
						else
							if v:IsAdmin() then
								v:PrintMessage(HUD_PRINTTALK,ply:Nick().." has used the deathnote on "..killP:Nick()..". ("..TheDeathType..")")
							end
						end
					end
				else
					ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
					deathnoteuseage = 0
					for k,v in pairs( player.GetAll() ) do
						if ulx_installed then
							if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
								v:PrintMessage(HUD_PRINTTALK,ply:Nick().." tried the deathnote on "..killP:Nick().." but failed")
							end
						else
							if v:IsAdmin() then
								v:PrintMessage(HUD_PRINTTALK,ply:Nick().." tried the deathnote on "..killP:Nick().." but failed")
							end
						end
					end
				end
			end)
		else
			ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
		end
		else
			ply:PrintMessage(HUD_PRINTTALK,"The deathnote is in cooldown.")
		end
	end )
	
	net.Receive( "pName1", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if killP:Alive() then
			ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Alive")
			for k,v in pairs(player.GetAll()) do
				if ulx_installed then
					if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
						v:PrintMessage(HUD_PRINTTALK,ply:Nick().." tried the lifenote on "..killP:Nick().." but failed")
					end
				else
					if v:IsAdmin() then
						v:PrintMessage(HUD_PRINTTALK,ply:Nick().." tried the lifenote on "..killP:Nick().." but failed")
					end
				end
			end
		else
			killP:Spawn()
			for k,v in pairs(player.GetAll()) do
				if ulx_installed then
					if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
						v:PrintMessage(HUD_PRINTTALK,ply:Nick().." has used the lifenote on "..killP:Nick())
					end
				else
					if v:IsAdmin() then
						v:PrintMessage(HUD_PRINTTALK,ply:Nick().." has used the lifenote on "..killP:Nick())
					end
				end
			end
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
									v:PrintMessage(HUD_PRINTTALK,ply:Nick().." has used the deathnote on "..killP:Nick())
								end
							else
								if v:IsAdmin() then
									v:PrintMessage(HUD_PRINTTALK,ply:Nick().." has used the deathnote on "..killP:Nick())
								end
							end
						end
					else
						ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
						deathnoteuseage = 0
						for k,v in pairs(player.GetAll()) do
							if ulx_installed then
								if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
									v:PrintMessage(HUD_PRINTTALK,ply:Nick().." tried the deathnote on "..killP:Nick().." but failed")
								end
							else
								if v:IsAdmin() then
									v:PrintMessage(HUD_PRINTTALK,ply:Nick().." tried the deathnote on "..killP:Nick().." but failed")
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

