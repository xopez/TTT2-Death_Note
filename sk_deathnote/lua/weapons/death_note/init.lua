


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
local deathnoteuseage = 0
local dndebuged = 0  -- change this to 1 if you want admins to be able reset the cooldown

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

	net.Receive( "pName", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if deathnoteuseage == 0 then
		if killP:Alive() then
			deathnoteuseage = 1
			timer.Simple( 5, function()
				if killP:Alive() then
					killP:Kill()
					deathnoteuseage = 0
				else
					ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
					deathnoteuseage = 0
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
		else
			killP:Spawn()
		end
	end )	
end

function SWEP:Reload()
	if dndebuged == 1 then
		if self.Owner:IsAdmin() then
		deathnoteuseage = 0
		self.Owner:PrintMessage(HUD_PRINTTALK,"You Reset the deathnote")
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
					else
						ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
						deathnoteuseage = 0
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

