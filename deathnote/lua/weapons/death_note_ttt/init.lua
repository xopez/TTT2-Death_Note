--DeathNote TTT Weapon init


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.deathtype = 1
TTT_IgniteInUse = false
TTT_FallInUse = false
TTT_ExplodeInUse = false
TTT_BurialInUse = false

resource.AddFile("vgui/deathnote_vgui.vmt")
resource.AddFile("vgui/icon/ttt_deathnote_shop.vmt")

if SERVER then
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
				DeathNote_TTT_Primary(ply,trKill,deathtypes[self.deathtype])
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if ( SERVER ) then
		net.Start( "deathnote_gui" )
			net.WriteTable(deathtypes)
			net.WriteString("w_ttt")
		net.Send( self.Owner ) 
	end
end

function DeathNote_TTT_Primary(ply,TarPly,TheDeathType) -- this is here just for my simple sake (Bitch Code)
	if !ply.DeathNoteUse then
		ply:PrintMessage(HUD_PRINTTALK,"DeathNote: You have selected, "..TarPly:Nick()..", With "..TheDeathType)
		if TarPly:Alive() then
			ply.DeathNoteUse = true
			timer.Simple( GetConVar("DeathNote_TTT_DeathTime"):GetInt(), function()
			if GetConVar("DeathNote_TTT_AlwaysDies"):GetBool() then -- Always Die
				ply.DeathNoteUse = false
				if TarPly:Alive() then
					hook.Run( "dn_module_"..TheDeathType, ply,TarPly,true ) 
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
						hook.Run( "dn_module_"..TheDeathType, ply,TarPly,true ) 
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
end
