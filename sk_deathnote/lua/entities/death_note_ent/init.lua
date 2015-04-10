
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

	net.Receive("DN_CloseMenu", function(length, ply)
		ply.MenuOpen = false
	end)
	
	net.Receive( "ENTDeathType", function( len, ply )
		TheDeathType = string.lower(net.ReadString())
	end )
	
	net.Receive( "ENTpName", function( len, ply )
		ply.MenuOpen = false
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if !entdeathnoteuseage then
		if killP:Alive() then
			entdeathnoteuseage = true
			timer.Simple( 5, function()
				if killP:Alive() then
					if TheDeathType == "heartattack" then
						DN_HeartAttack(ply,TarPly)
					end
					if TheDeathType == "ignite" then
						DN_Ignite(ply,TarPly)
					end
					if TheDeathType == "fall" then
						DN_Fall(ply,TarPly)
					end
					entdeathnoteuseage = false
					AdminMessege(ply,TarPly,TheDeathType)
				else
					ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
					entdeathnoteuseage = false
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

function ENT:Think()
end

function AdminMessege(ply,TarPly,TheDeathType)
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

function FailAdminMessege(ply,TarPly)
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
function DN_HeartAttack(ply,TarPly)
	TarPly:Kill()
	TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: Died via the Death-Note killed by '"..ply:Nick().."'")
end
-- Ignite --
function DN_Ignite(ply,TarPly)
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	TarPly:Ignite( 5000000 )
	TarPly:PrintMessage(HUD_PRINTTALK,"DeathNote Ent: Ignited via the Death-Note.")
end
-- Fall Death --
function DN_Fall(ply,TarPly)
	if TarPly:Health() >= 100 then
		TarPly:SetHealth(100)
	end
	TarPly:SetVelocity(Vector(0,0,1000))
	timer.Simple( 1, function() TarPly:SetVelocity(Vector(0,0,-1000)) end )
end