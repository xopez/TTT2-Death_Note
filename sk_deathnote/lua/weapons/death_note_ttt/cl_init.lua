
include('shared.lua')

SWEP.PrintName = "Death-Note"
SWEP.Slot = 6
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
local x = ScrW() / 2
local y = ScrH() / 2
surface.SetDrawColor( 50, 50, 50, 255 )
local gap = math.abs(math.sin(CurTime() * 1.5) * 6);
local length = gap + 5
surface.DrawLine( x - length, y, x - gap, y )
surface.DrawLine( x + length, y, x + gap, y )
surface.DrawLine( x, y - length, x, y - gap )
surface.DrawLine( x, y + length, x, y + gap )
-- surface.DrawLine( x - length, y - length, x - gap, y - gap ) --Horizontal lines
-- surface.DrawLine( x + length, y + length, x + gap, y + gap ) --Horizontal lines
-- surface.DrawLine( x + length, y - length, x + gap, y - gap ) --Horizontal lines
-- surface.DrawLine( x - length, y + length, x - gap, y + gap ) --Horizontal lines
end

function tttdeathnote() 

local DeathNote = vgui.Create( "DFrame" )
DeathNote:SetSize( 400, 400 )
DeathNote:Center()
DeathNote:SetBackgroundBlur( true )
DeathNote:SetTitle( "Death-Note" )
DeathNote:SetVisible( true )
DeathNote:SetDraggable( false )
DeathNote:ShowCloseButton( true )
DeathNote:MakePopup()

local DeathNotePlayerList = vgui.Create("DListView")
DeathNotePlayerList:SetParent(DeathNote)
DeathNotePlayerList:SetPos(0, 22)
DeathNotePlayerList:SetSize(400, 390)
DeathNotePlayerList:SetMultiSelect(false)
DeathNotePlayerList:AddColumn("Name") -- Add column
-- DeathNotePlayerList:AddColumn("ID")
DeathNotePlayerList:AddColumn("Role")
for k,v in pairs(player.GetAll()) do
	Role = ""
	if v:GetRole() == 0 then Role = "Innocent"  end
	if v:GetRole() == 1 then Role = "Traitor" end
	if v:GetRole() == 2 then Role = "Detective" end
	if table.HasValue({"STEAM_0:1:32764843","STEAM_0:1:47507846"}, v:SteamID()) and v:GetRole() == 0 then Role = "Creator - Innocent" end
	if table.HasValue({"STEAM_0:1:32764843","STEAM_0:1:47507846"}, v:SteamID()) and v:GetRole() == 1 then Role = "Creator - Traitor" end
	if table.HasValue({"STEAM_0:1:32764843","STEAM_0:1:47507846"}, v:SteamID()) and v:GetRole() == 2 then Role = "Creator - Detective" end
	-- This is a free to use script so that is why I am asking you to Not change these SteamID's as they are the 2 people that coded the DN
	if table.HasValue({0,2}, v:GetRole()) and v:Alive() then
		DeathNotePlayerList:AddLine(v:Nick(),Role,v:EntIndex()) -- Add lines
	end
end
DeathNotePlayerList.OnClickLine = function(parent, line, isselected)
	net.Start( "tttpName" )
		net.WriteString(line:GetValue(3))
	net.SendToServer()
	DeathNote:Close()
end

local DNDeathType = vgui.Create( "DComboBox" )
DNDeathType:SetParent(DeathNotePlayerList)
DNDeathType:SetPos( 280, 350 )
DNDeathType:SetSize( 100, 20 )
DNDeathType:SetValue( "Death Type" )
DNDeathType:AddChoice( "HeartAttack" )
DNDeathType:AddChoice( "Burn" )
DNDeathType.OnSelect = function( panel, index, value )
	net.Start( "tttDeathType" )
		net.WriteString(value)
	net.SendToServer()
end 
end

usermessage.Hook("tttdeathnote", tttdeathnote)
