
AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "../../deathnote_config.lua" ) 

include('shared.lua')
include( '../../deathnote_config.lua' )
local entdeathnoteuseage = false
local TheDeathType = "heartattack"

function ENT:Initialize()
	self:SetModel( "models/death_note/deathnote.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
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
		if Debug_Mode_DN then
			if ulx_installed then
				if table.HasValue(ulx_premissions, ply:GetNWString("usergroup")) then
					deathnoteuseage = 0
					ply:PrintMessage(HUD_PRINTTALK,"Deathnote Ent: Deathnote Reset")
				end
			else
				if ply:IsAdmin() then
					deathnoteuseage = 0
					ply:PrintMessage(HUD_PRINTTALK,"Deathnote Ent: Deathnote Reset")
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
		if !entdeathnoteuseage then
		if TarPly:Alive() then
			entdeathnoteuseage = true
			timer.Simple( DN_DeathTime, function()
				if TarPly:Alive() then
					if TheDeathType == "heartattack" then
						DN_HeartAttack_ENT(ply,TarPly)
					end
					if TheDeathType == "ignite" then
						DN_Ignite_ENT(ply,TarPly)
					end
					if TheDeathType == "fall" then
						DN_Fall_ENT(ply,TarPly)
					end 
					if TheDeathType == "explode" then
						DN_Explode_ENT(ply,TarPly)
					end 
					entdeathnoteuseage = false
					AdminMessege_ENT(ply,TarPly,TheDeathType)
				else
					ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
					entdeathnoteuseage = false
					FailAdminMessege_ENT(ply,TarPly)
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

function ENT:Think()
end

function AdminMessege_ENT(ply,TarPly,TheDeathType)
	for k,v in pairs( player.GetAll() ) do
		if ulx_installed then
			if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
				v:PrintMessage(HUD_PRINTTALK,"Deathnote Ent: "..ply:Nick().." has used the deathnote on "..TarPly:Nick()..". ("..TheDeathType..")")
			end
		else
			if v:IsAdmin() then
				v:PrintMessage(HUD_PRINTTALK,"Deathnote Ent: "..ply:Nick().." has used the deathnote on "..TarPly:Nick()..". ("..TheDeathType..")")
			end
		end
	end
end

function FailAdminMessege_ENT(ply,TarPly)
	for k,v in pairs( player.GetAll() ) do
		if ulx_installed then
			if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
				v:PrintMessage(HUD_PRINTTALK,"Deathnote Ent: "..ply:Nick().." tried the deathnote on "..TarPly:Nick().." but failed")
			end
		else
			if v:IsAdmin() then
				v:PrintMessage(HUD_PRINTTALK,"Deathnote Ent: "..ply:Nick().." tried the deathnote on "..TarPly:Nick().." but failed")
			end
		end
	end
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
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	TarPly:SetVelocity(Vector(0,0,1000))
	timer.Simple( 1, function() TarPly:SetVelocity(Vector(0,0,-1000)) end )
end
-- Explode --
function DN_Explode_ENT(ply,TarPly)
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." Has been set to explode in "..DN_ExplodeTimer.." seconds.")
	end
	ENT_Explode_Time_Left = DN_ExplodeTimer
	timer.Create( "ENT_Expolde_Countdown", 1, 0, function()
		ENT_Explode_Time_Left = ENT_Explode_Time_Left - 1
		
		if ENT_Explode_Time_Left <= 5 then
			if DN_ExplodeCountDown then
				for k,v in pairs(player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." Will explode in "..ENT_Explode_Time_Left.." seconds!!!!")
				end
			end
		end
		
		if !TarPly:Alive() then
			for k,v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK,"Deathnote: "..TarPly:Nick().." has died before he exploded.")
			end
			timer.Remove("ENT_Expolde_Countdown")
		end
		
		if ENT_Explode_Time_Left <= 0 then
			timer.Remove("ENT_Expolde_Countdown")
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