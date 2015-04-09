
AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "../../deathnote_config.lua" ) 

include('shared.lua')
include( '../../deathnote_config.lua' )
local entdeathnoteuseage = 0
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
util.AddNetworkString( "ENTpName2" )
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
		if entdeathnoteuseage == 0 then
		if killP:Alive() then
			entdeathnoteuseage = 1
			timer.Simple( 5, function()
				if killP:Alive() then
					if TheDeathType == "heartattack" then
						killP:Kill()
					end
					if TheDeathType == "ignite" then
						if killP:Health() >= 100 then
							killP:SetHealth(100)
						end
						killP:Ignite( 5000000 )
					end
					if TheDeathType == "fall" then
						if killP:Health() >= 100 then
							killP:SetHealth(100)
						end
					killP:SetVelocity(Vector(0,0,1000))
					timer.Simple( 1, function() killP:SetVelocity(Vector(0,0,-1000)) end )
					end
					entdeathnoteuseage = 0
					for k,v in pairs( player.GetAll() ) do
						if ulx_installed then
							if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
								v:PrintMessage(HUD_PRINTTALK,"DeathNote ENT: "..ply:Nick().." has used the deathnote on "..killP:Nick()..". ("..TheDeathType..")")
							end
						else
							if v:IsAdmin() then
								v:PrintMessage(HUD_PRINTTALK,"DeathNote ENT: "..ply:Nick().." has used the deathnote on "..killP:Nick()..". ("..TheDeathType..")")
							end
						end
					end
				else
					ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
					entdeathnoteuseage = 0
					for k,v in pairs( player.GetAll() ) do
						if ulx_installed then
							if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
								v:PrintMessage(HUD_PRINTTALK,"DeathNote ENT: "..ply:Nick().." tried the deathnote on "..killP:Nick().." but failed")
							end
						else
							if v:IsAdmin() then
								v:PrintMessage(HUD_PRINTTALK,"DeathNote ENT: "..ply:Nick().." tried the deathnote on "..killP:Nick().." but failed")
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
	
	net.Receive( "ENTpName1", function( len, ply )
		ply.MenuOpen = false
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if killP:Alive() then
			ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Alive")
			if ulx_installed then
				if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
					v:PrintMessage(HUD_PRINTTALK,"DeathNote ENT: "..ply:Nick().." tried the lifenote on "..killP:Nick().." but failed")
				end
			else
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"DeathNote ENT: "..ply:Nick().." tried the lifenote on "..killP:Nick().." but failed")
				end
			end
		else
			killP:Spawn()
			for k,v in pairs( player.GetAll() ) do
				if ulx_installed then
					if table.HasValue(ulx_premissions, v:GetNWString("usergroup")) then
						v:PrintMessage(HUD_PRINTTALK,"DeathNote ENT: "..ply:Nick().." has used the lifenote on "..killP:Nick())
					end
				else
					if v:IsAdmin() then
						v:PrintMessage(HUD_PRINTTALK,"DeathNote ENT: "..ply:Nick().." has used the lifenote on "..killP:Nick())
					end
				end
			end
		end
	end )	
end

function ENT:Think()
end
 