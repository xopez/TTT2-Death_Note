
AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
local entdeathnoteuseage = 0
 
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
util.AddNetworkString("DN_CloseMenu")

	net.Receive("DN_CloseMenu", function(length, ply)
		ply.MenuOpen = false
	end)
	net.Receive( "ENTpName", function( len, ply )
		ply.MenuOpen = false
		local plyName = tonumber(net.ReadString())
		local killP = player.GetByID(plyName)
		if entdeathnoteuseage == 0 then
		print ("Death-note ENT Started")
		if killP:Alive() then
			entdeathnoteuseage = 1
			print ("Death-note on Cooldown")
			timer.Simple( 5, function()
				if killP:Alive() then
					killP:Kill()
					print ("Death-note Killed Target")
					entdeathnoteuseage = 0
				else
					ply:PrintMessage(HUD_PRINTTALK,"That Person Is Already Dead")
					print ("Death-note Target Already Dead")
					entdeathnoteuseage = 0
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
		else
			killP:Spawn()
		end
	end )	
end

function ENT:Think()
end
 