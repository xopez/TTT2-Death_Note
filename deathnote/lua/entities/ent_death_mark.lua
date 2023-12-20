Grave_Model = "models/props_c17/gravestone004a.mdl"
Shovel_Model = "models/props_junk/Shovel01a.mdl"
if SERVER then
	AddCSLuaFile("ent_death_mark.lua")
	function ENT:Initialize()
		-- self:SetModel( "models/error.mdl" )
		-- self:PhysicsInit( SOLID_VPHYSICS )
		-- self:SetMoveType( MOVETYPE_NONE  )
		-- self:SetSolid( SOLID_NONE )
		-- self:SetNotSolid( true )
		-- local phys = self:GetPhysicsObject()
		-- if (phys:IsValid()) then
		-- phys:Wake()
		-- end
		timer.Simple(
			0.1,
			function()
				if self:GetModel() == "models/error.mdl" then
					self:Remove()
				end
			end
		)

		timer.Simple(
			30,
			function()
				if IsValid(self) then
					self:Remove()
				end
			end
		)
	end

	function ENT:Use(activator, caller)
		return
	end

	function ENT:Think()
	end
elseif CLIENT then
	-- This is where the cl_init.lua stuff goes
	-- surface.CreateFont ("DEATHNOTE Font", 20, 400, true, false, "")
	surface.CreateFont(
		"DeathFont",
		{
			font = "DEATHNOTE Font",
			extended = false,
			size = 100,
			weight = 400,
			antialias = true,
		}
	)

	function ENT:Draw()
		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		self:DrawModel()
		if self:GetModel() == Grave_Model then
			Ang:RotateAroundAxis(Ang:Right(), 90)
			Ang:RotateAroundAxis(Ang:Up(), -90)
			cam.Start3D2D(Pos + -Ang:Right() * 45, Ang, 0.11)
			draw.DrawText("Here Lies\n " .. self:GetOwner():Nick(), "DeathFont", 0, 0, Color(25, 25, 25, 255), TEXT_ALIGN_CENTER)
			cam.End3D2D()
			Ang:RotateAroundAxis(Ang:Right(), 180)
			cam.Start3D2D(Pos + -Ang:Right() * 45, Ang, 0.11)
			draw.DrawText("Here Lies\n " .. self:GetOwner():Nick(), "DeathFont", 0, 0, Color(25, 25, 25, 255), TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Death-Note Death Mark"
ENT.Author = "Blue-Pentagram And TheRowan"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.Category = "Death Note"