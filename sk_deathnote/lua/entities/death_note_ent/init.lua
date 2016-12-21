-- DeathNote Ent Init

AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" )

include('shared.lua')
local TheDeathType = "heart-attack"
ENT_FallInUse = false
ENT_ExplodeInUse = false
ENT_BurialInUse = false

function ENT:Initialize()
	self:SetModel( "models/death_note/DeathNote.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
    return
end

function ENT:AcceptInput(ply, caller)
	if caller:IsPlayer() && !caller.CantUse && !caller.MenuOpen then
		caller.CantUse = true
		caller.MenuOpen = true
		caller.CanUse = true
		timer.Simple(3, function()  caller.CantUse = false end)

		if caller:IsValid() then
			umsg.Start("deathnote_ent", caller)
			umsg.End()
		end
	end
end

if ( SERVER ) then
util.AddNetworkString( "ENTpName" )
util.AddNetworkString( "DN_CloseMenu" )
util.AddNetworkString( "ENTDeathType" )
util.AddNetworkString( "DN_RESET" )

	net.Receive("DN_CloseMenu", function(length, ply)
		ply.MenuOpen = false
	end)
	
	net.Receive("DN_RESET", function(length, ply)
		if GetConVar("DeathNote_Debug"):GetBool() then
			if GetConVar("DeathNote_ulx_installed"):GetBool() then
				if table.HasValue(ulx_premissions, ply:GetNWString("usergroup")) then
					deathnoteuseage = 0
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: DeathNote Reset")
				end
			else
				if ply:IsAdmin() then
					deathnoteuseage = 0
					ply:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: DeathNote Reset")
				end
			end
		end
	end)
	
	net.Receive( "ENTDeathType", function( len, ply )
		TheDeathType = string.lower(net.ReadString())
	end )
	
	net.Receive( "ENTpName", function( len, ply )
		ply.MenuOpen = false
		local plyName = tonumber(net.ReadString())
		local TarPly = player.GetByID(plyName)
		if ply.CanUse then
			ply.CanUse = false
			if !ply.DeathNoteUse then
				if TarPly:Alive() then
					ply.DeathNoteUse = true
					timer.Simple( GetConVar("DeathNote_DeathTime"):GetInt(), function()
						if TarPly:Alive() then
							if TheDeathType == "heart-attack" then
								DN_HeartAttack_ENT(ply,TarPly)
							end
							if TheDeathType == "ignite" then
								DN_Ignite_ENT(ply,TarPly)
							end
							if TheDeathType == "fall" then
								if !ENT_FallInUse then
									DN_Fall_ENT(ply,TarPly)
								else
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
								end
							end
							if TheDeathType == "explode" then
								if !ENT_ExplodeInUse then
									DN_Explode_ENT(ply,TarPly)
								else
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
								end
							end
							if TheDeathType == "premature burial" then
								if !ENT_ENT_BurialInUse then
									DN_Burial_ENT(ply,TarPly)
								else
									ply:PrintMessage(HUD_PRINTTALK,"DeathNote: Sorry another player is useing that death")
								end
							end 
							ply.DeathNoteUse = false
							AdminMessege_ENT(ply,TarPly,TheDeathType)
						else
							ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
							ply.DeathNoteUse = false
							FailAdminMessege_ENT(ply,TarPly)
						end
					end)
				else
					ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK,"The DeathNote is in cooldown.")
			end
		else
			ply:PrintMessage(HUD_PRINTTALK,"DeathNote: I am sorry, I'm not allowed to do that for you, Please open it form the entity and try again.")
		end
	end )
end

function ENT:Think()
end

function AdminMessege_ENT(ply,TarPly,TheDeathType)
	if GetConVar("DeathNote_Admin_Messeges"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if GetConVar("DeathNote_ulx_installed"):GetBool() then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					v:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: "..ply:Nick().." has used the DeathNote on "..TarPly:Nick()..". ("..TheDeathType..")")
				end
			else
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: "..ply:Nick().." has used the DeathNote on "..TarPly:Nick()..". ("..TheDeathType..")")
				end
			end
		end
	else return false end
end

function FailAdminMessege_ENT(ply,TarPly)
	if GetConVar("DeathNote_Admin_Messeges"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if GetConVar("DeathNote_ulx_installed"):GetBool() then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					v:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: "..ply:Nick().." tried the DeathNote on "..TarPly:Nick().." but failed")
				end
			else
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: "..ply:Nick().." tried the DeathNote on "..TarPly:Nick().." but failed")
				end
			end
		end
	else return false end
end

/*----------------------
--Multiple Death Types--
----------------------*/
-- Heart Attack --
function DN_HeartAttack_ENT(ply,TarPly)
	TarPly:Kill()
	TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: Died via the Death-Note killed by '"..ply:Nick().."'")
end
-- Ignite --
function DN_Ignite_ENT(ply,TarPly)
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	TarPly:Ignite( 5000000 )
	TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: Ignited via the Death-Note.")
end
-- Fall Death --
function DN_Fall_ENT(ply,TarPly)
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
function DN_Explode_ENT(ply,TarPly)
	ENT_ExplodeInUse = true
	DN_ExplodeTimer = GetConVar("DeathNote_ExplodeTimer"):GetInt()
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: "..TarPly:Nick().." Has been set to explode in "..DN_ExplodeTimer.." seconds.")
	end
	ENT_Explode_Time_Left = DN_ExplodeTimer
	timer.Create( "ENT_Expolde_Countdown", 1, 0, function()
		ENT_Explode_Time_Left = ENT_Explode_Time_Left - 1
		
		if ENT_Explode_Time_Left <= 5 then
			if GetConVar("DeathNote_ExplodeCountDown"):GetBool() then
				for k,v in pairs(player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: "..TarPly:Nick().." Will explode in "..ENT_Explode_Time_Left.." seconds!!!!")
				end
			end
		end
		
		if !TarPly:Alive() then
			for k,v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: "..TarPly:Nick().." has died before he exploded.")
			end
			ENT_ExplodeInUse = false
			timer.Remove("ENT_Expolde_Countdown")
		end
		
		if ENT_Explode_Time_Left <= 0 then
			timer.Remove("ENT_Expolde_Countdown")
			TarPly:SetHealth(1)
			TarPly:GodDisable()
			local DN_Explosion = ents.Create("env_explosion")
			DN_Explosion:SetPos(TarPly:GetPos())
	
			DN_Explosion:Spawn()
			DN_Explosion:SetKeyValue("iMagnitude", 100)
			DN_Explosion:Fire("Explode", 0, 0)
			DN_Explosion:EmitSound("BaseGrenade.Explode", 100, 100)
			ENT_ExplodeInUse = false
		end
	end)
end
-- Burial --
function DN_Burial_ENT(ply,TarPly)
	ENT_BurialInUse = true
	local DN_Burial_Count_ENT = 0
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	timer.Create( "BuryTime", 1, 14, function()
		DN_Burial_Count_ENT = DN_Burial_Count_ENT + 1
		if DN_Burial_Count_ENT <= 4 then
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
					v:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: "..TarPly:Nick().." has been buried alive!")
				end
				ENT_BurialInUse = false
			end
			if DN_Burial_Count_ENT == 14 then
				TarPly:Kill()
				TarPly:Freeze( false )
				timer.Remove("BuryTime")
				for k,v in pairs(player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: "..TarPly:Nick().." has been buried alive!")
				end
				ENT_BurialInUse = false
			end
		end
	end)
end
