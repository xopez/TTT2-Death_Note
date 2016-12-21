

Grave_Model = "models/props_c17/gravestone004a.mdl"
-- SetBugModel = "models/props_lab/huladoll.mdl"
-- SetNewModel = nil
if SERVER then
 	
	AddCSLuaFile( "ent_death_mark.lua" ) -- Make sure clientside	
	-- include('ent_death_mark.lua')
	
	function ENT:Initialize(SetNewModel,TarPly)

		-- if SetNewModel != nil then
			-- local TheModel = SetNewModel
		-- else
			-- local TheModel = SetBugModel
		-- end
		-- self:SetModel( TheModel )
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
 
	function ENT:Think()
		-- print(TheModel)    -- uses the 'self' parameter
		-- print(self:GetOwner())    -- uses the 'self' parameter
	end
 
elseif CLIENT then // This is where the cl_init.lua stuff goes
	-- surface.CreateFont ("DEATHNOTE Font", 20, 400, true, false, "")
	surface.CreateFont( "DeathFont", {
	font = "Default",
	extended = false,
	size = 10,
	weight = 400,
	antialias = true,
} )
	
	
	function ENT:Draw()
		-- self:DrawEntityOutline( 1.0 )
		self:DrawModel()
		if self:GetModel() == Grave_Model then
			cam.Start3D2D( self:GetPos() + Vector(0,3,45), self:GetAngles() + Angle(0,90,90) , 1 )
				draw.DrawText("Here Lies\n"..self:GetOwner():Nick(), "Default", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
			cam.End3D2D()
			cam.Start3D2D( self:GetPos() + Vector(0,-3,45), self:GetAngles() + Angle(0,-90,90) , 1 )
				draw.DrawText("Here Lies\n"..self:GetOwner():Nick(), "Default", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
			cam.End3D2D()
		end
	end
end
  
ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"

ENT.PrintName 		= "Death-Note Death Mark"
ENT.Author 			= "Blue-Pentagram And TheRowan"
ENT.Spawnable 		= true
ENT.AdminOnly		= true
ENT.Category 		= "Death Note"
