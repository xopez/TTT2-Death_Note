
include('shared.lua')

SWEP.PrintName = "Death-Note"
SWEP.Slot = 6
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
local x = ScrW() / 2
local y = ScrH() / 2
surface.SetDrawColor( 50, 50, 50, 255 )
local gap = 3
local length = gap + 5
surface.DrawLine( x - length, y, x - gap, y )
surface.DrawLine( x + length, y, x + gap, y )
surface.DrawLine( x, y - length, x, y - gap )
surface.DrawLine( x, y + length, x, y + gap )
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

local DeathnoteSheet = vgui.Create( "DPropertySheet" )
DeathnoteSheet:SetParent( DeathNote )
DeathnoteSheet:SetPos( 0, 22 )
DeathnoteSheet:SetSize( 400, 378 )
  
local DeathNotePlayerList = vgui.Create("DListView")
DeathNotePlayerList:SetPos(0, 22)
DeathNotePlayerList:SetSize(300, 300)
DeathNotePlayerList:SetMultiSelect(false)
DeathNotePlayerList:AddColumn("Name") -- Add column
-- DeathNotePlayerList:AddColumn("ID")
DeathNotePlayerList:AddColumn("Role")
for k,v in pairs(player.GetAll()) do
	Role = ""
	if v:GetRole() == 0 then Role = "Innocent"  end
	if v:GetRole() == 1 then Role = "Traitor" end
	if v:GetRole() == 2 then Role = "Detective" end
	if table.HasValue({0,2}, v:GetRole()) then
		DeathNotePlayerList:AddLine(v:Nick(),Role,v:EntIndex()) -- Add lines
	end
end
DeathNotePlayerList.OnClickLine = function(parent, line, isselected)
	net.Start( "tttpName" )
		net.WriteString(line:GetValue(3))
	net.SendToServer()
	DeathNote:Close()
end
 
-- local LifeNotePlayerList = vgui.Create("DListView")
-- LifeNotePlayerList:SetPos(0, 22)
-- LifeNotePlayerList:SetSize(300, 300)
-- LifeNotePlayerList:SetMultiSelect(false)
-- LifeNotePlayerList:AddColumn("Name") -- Add column
-- LifeNotePlayerList:AddColumn("ID")
-- LifeNotePlayerList:AddColumn("Amount of Deaths")
-- for k,v in pairs(player.GetAll()) do
	-- LifeNotePlayerList:AddLine(v:Nick(),v:Deaths(),v:EntIndex()) -- Add lines
-- end
-- LifeNotePlayerList.OnClickLine = function(parent, line, isselected)
	-- net.Start( "tttpName1" )
		-- net.WriteString(line:GetValue(3))
	-- net.SendToServer()
	-- DeathNote:Close()
-- end
 
local DNInfo = vgui.Create("DPanel")
DNInfo:SetSize(300, 300)
DNInfo:SetPos(10, 31)

local DNText = vgui.Create("DLabel")
DNText:SetParent(DNInfo)
DNText:SetPos(15, 15)
DNText:SetText([[Death Note Info:
This SWEP is made for multiplayer servers,
The idea of the Death Note came from the actual Death Note show.
While Life Note come from Smosh.

This SWEP was made by Bluey and Rowan.
The model is made by FluxMage (GarrysMod.org)
With help from the SWEP Construction Kit for the view and world model.

DeathNote Usage:
General Version
- A 5 seconds wait for the target to die.
- You can also use it to kill npcs (No Wait)

TTT Version
- A 15 seconds wait for the target to die
- A chance killing system the system rolls two dice (doubles requried).
- You can not kill npcs 
]])
DNText:SizeToContents()
DNText:SetTextColor(Color(0, 0, 0, 255))

local Workshop = vgui.Create( "DButton" )
Workshop:SetParent(DNInfo)
Workshop:SetSize( 90, 30 )
Workshop:SetPos( 5, 306 )
Workshop:SetText( "Workshop Item" )
Workshop.DoClick = function( button )
	gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=278185787&searchtext=")
end

local SWEPConstructionKit = vgui.Create( "DButton" )
SWEPConstructionKit:SetParent(DNInfo)
SWEPConstructionKit:SetSize( 120, 30 )
SWEPConstructionKit:SetPos( 100, 306 )
SWEPConstructionKit:SetText( "SWEP Construction Kit" )
SWEPConstructionKit.DoClick = function( button )
	gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=109724869&requirelogin=true")
end
 
DeathnoteSheet:AddSheet( "DeathNote", DeathNotePlayerList, "materials/VGUI/icon/skull.png", false, false, "The notes of Death" )
-- DeathnoteSheet:AddSheet( "LifeNote", LifeNotePlayerList, "materials/VGUI/icon/heart.png", false, false, "The notes of Alive" )
DeathnoteSheet:AddSheet( "DeathNote Info", DNInfo, "materials/VGUI/icon/info.png", false, false, "DeathNote Info" ) 
end

usermessage.Hook("tttdeathnote", tttdeathnote)
