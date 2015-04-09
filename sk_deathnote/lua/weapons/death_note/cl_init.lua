
include('shared.lua')

SWEP.PrintName = "Death-Note"
SWEP.Slot = 5
SWEP.SlotPos = 20
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
local x = ScrW() / 2
local y = ScrH() / 2
surface.SetDrawColor( 255, 50, 50, 255 )
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

function deathnote() 

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
DeathNotePlayerList:AddColumn("Amount of Deaths")
for k,v in pairs(player.GetAll()) do
	Death = ""
	if table.HasValue({"STEAM_0:1:32764843","STEAM_0:1:47507846"}, v:SteamID()) then Death = v:Deaths().." - Creator" else Death = v:Deaths() end
	DeathNotePlayerList:AddLine(v:Nick(),Death,v:EntIndex()) -- Add lines
end
DeathNotePlayerList.OnClickLine = function(parent, line, isselected)
	net.Start( "pName" )
		net.WriteString(line:GetValue(3))
	net.SendToServer()
	DeathNote:Close()
end
 
local DNDeathType = vgui.Create( "DComboBox" )
DNDeathType:SetParent(DeathNotePlayerList)
DNDeathType:SetPos( 280, 315 )
DNDeathType:SetSize( 100, 20 )
DNDeathType:SetValue( "Death Type" )
DNDeathType:AddChoice( "HeartAttack" )
DNDeathType:AddChoice( "Ignite" )
DNDeathType:AddChoice( "Fall" )
DNDeathType.OnSelect = function( panel, index, value )
	net.Start( "DeathType" )
		net.WriteString(value)
	net.SendToServer()
end 

local LifeNotePlayerList = vgui.Create("DListView")
LifeNotePlayerList:SetPos(0, 22)
LifeNotePlayerList:SetSize(300, 300)
LifeNotePlayerList:SetMultiSelect(false)
LifeNotePlayerList:AddColumn("Name") -- Add column
-- LifeNotePlayerList:AddColumn("ID")
LifeNotePlayerList:AddColumn("Amount of Deaths")
for k,v in pairs(player.GetAll()) do
	LDeath = ""
	if table.HasValue({"STEAM_0:1:32764843","STEAM_0:1:47507846"}, v:SteamID()) then LDeath = v:Deaths().." - Creator" else LDeath = v:Deaths() end
	LifeNotePlayerList:AddLine(v:Nick(),LDeath,v:EntIndex()) -- Add lines
end
LifeNotePlayerList.OnClickLine = function(parent, line, isselected)
	net.Start( "pName1" )
		net.WriteString(line:GetValue(3))
	net.SendToServer()
	DeathNote:Close()
end
  
local DNInfo = vgui.Create("DPanel")
DNInfo:SetSize(300, 300)
DNInfo:SetPos(10, 31)

local DNText = vgui.Create("DLabel")
DNText:SetParent(DNInfo)
DNText:SetPos(15, 15)
DNText:SetText([[
Death Note Info:

This SWEP is made for multiplayer servers,
The idea of the Death Note came from the actual Death Note Anime/Manga.
While Life Note come from Smosh.

This SWEP was made by Blue-Pentagram and TheRowan.
The model is made by FluxMage what was on (GarrysMod.org).
With help from the SWEP Construction Kit for the view and world model.
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
DeathnoteSheet:AddSheet( "LifeNote", LifeNotePlayerList, "materials/VGUI/icon/heart.png", false, false, "The notes of Alive" )
DeathnoteSheet:AddSheet( "DeathNote Info", DNInfo, "materials/VGUI/icon/info.png", false, false, "" ) 
end

usermessage.Hook("deathnote", deathnote)
