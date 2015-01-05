


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
local tttdeathnoteuseage = 0
local tttdndebuged = 0  -- change this to 1 if you want admins to be able reset the cooldown

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
		print ("Deathnote Glitched and has been forced Reseted")
	end
end
hook.Add( "TTTBeginRound", "deathnotereset", DNRESET )

if ( SERVER ) then
util.AddNetworkString( "tttpName" )
util.AddNetworkString( "tttpName1" )

	net.Receive( "tttpName", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if tttdeathnoteuseage == 0 then
		if killP:Alive() then
			tttdeathnoteuseage = 1
			timer.Simple( 15, function()
			rolled = math.random(1,6)
			rolled1 = math.random(1,6)
				if (rolled == rolled1 ) then
					ply:PrintMessage(HUD_PRINTTALK,"You rolled a "..rolled.." and "..rolled1)
					tttdeathnoteuseage = 0
					if killP:Alive() then
						killP:Kill()
						ply:StripWeapon("death_note_ttt")
					else
						ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead, You did not lose the Death-Note")
					end
				else
				ply:StripWeapon("death_note_ttt")
				ply:PrintMessage(HUD_PRINTTALK,"You rolled a "..rolled.." and "..rolled1.." and lost the Death-Note")
				tttdeathnoteuseage = 0
				end
			end)
		else
			ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
		end
		else
			ply:PrintMessage(HUD_PRINTTALK,"The deathnote is in cooldown.")
		end
	end )

	net.Receive( "tttpName1", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if killP:Alive() then
			ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Alive")
		else
			killP:Spawn()
			ply:StripWeapon("death_note_ttt")
		end
	end )	
end

function SWEP:Reload()
	if tttdndebuged == 1 then
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
				if tttdeathnoteuseage == 0 then
				tttdeathnoteuseage = 1
				timer.Simple( 15, function()
				rolled = math.random(1,6)
				rolled1 = math.random(1,6)
					if (rolled == rolled1 ) then
					ply:PrintMessage(HUD_PRINTTALK,"You rolled a "..rolled.." and "..rolled1)
					tttdeathnoteuseage = 0
						if trKill:Alive() then
							trKill:Kill()
							ply:StripWeapon("death_note_ttt")
						else
							ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead, You did not lose the Death-Note")
						end
					else
					ply:StripWeapon("death_note_ttt")
					ply:PrintMessage(HUD_PRINTTALK,"You rolled a "..rolled.." and "..rolled1.."And lost the Death-Note")
					tttdeathnoteuseage = 0
					end
				end)
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