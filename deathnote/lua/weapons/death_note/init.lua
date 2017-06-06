--DeathNote Weapon init


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
include( 'autorun/server/sv_deathnote.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.deathtype = 1
local TheDeathType = "heartattack"
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

-- if ( SERVER ) then

-- end

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
	
	-- if !IsFirstTimePredicted() then return end
	if self.Owner:KeyDown(IN_USE) then
		self.deathtype = self.deathtype + 1
		if self.deathtype > #deathtypes then
			self.deathtype = 1
		end
		self.Owner:PrintMessage(HUD_PRINTTALK,"DeathNote: "..deathtypes[self.deathtype])
	else	
		if IsValid(self.Owner:GetEyeTrace().Entity) then
			if self.Owner:GetEyeTrace().Entity:IsPlayer() then
				local trKill = player.GetByID(self.Owner:GetEyeTrace().Entity:EntIndex())
				DeathNote_Primary(ply,trKill,deathtypes[self.deathtype])
			end
		end
		if self.Owner:GetEyeTrace().Entity:IsNPC() then
			self.Owner:GetEyeTrace().Entity:Fire("sethealth", "0", 0)
		end	
	end
end
	
function SWEP:SecondaryAttack()
	if ( SERVER ) then
		net.Start( "deathnote_gui" )
			net.WriteTable(deathtypes)
		net.Send( self.Owner ) 
	end
end

function DeathNote_Primary(ply,TarPly,TheDeathType) -- this is here just for my simple sake (Bitch Code)
	if !ply.DeathNoteUse then
		ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You have selected, "..TarPly:Nick()..", With "..TheDeathType)
		if TarPly:Alive() then
			ply.DeathNoteUse = true
			timer.Simple( GetConVar("DeathNote_DeathTime"):GetInt(), function()
				if TarPly:Alive() then
					hook.Run( "dn_module_"..TheDeathType, ply,TarPly,false ) 
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
end
