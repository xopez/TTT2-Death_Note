include( 'shared.lua' )
 

function ENT:Draw()
    self:DrawModel()   
end


function deathnote_ent() 

local DeathNote = vgui.Create( "DFrame" )
DeathNote:SetSize( 400, 400 )
DeathNote:Center()
DeathNote:SetBackgroundBlur( true )
DeathNote:SetTitle( "Death-Note" )
DeathNote:SetVisible( true )
DeathNote:SetDraggable( false )
DeathNote:ShowCloseButton( false )
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
	DeathNotePlayerList:AddLine(v:Nick(),v:Deaths(),v:EntIndex()) -- Add lines
end
DeathNotePlayerList.OnClickLine = function(parent, line, isselected)
	net.Start( "ENTpName" )
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
DNDeathType:AddChoice( "Burn" )
DNDeathType.OnSelect = function( panel, index, value )
	net.Start( "ENTDeathType" )
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
	LifeNotePlayerList:AddLine(v:Nick(),v:Deaths(),v:EntIndex()) -- Add lines
end
LifeNotePlayerList.OnClickLine = function(parent, line, isselected)
	net.Start( "ENTpName1" )
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

local Close = vgui.Create( "DButton" )
Close:SetParent(DNInfo)
Close:SetSize( 90, 30 )
Close:SetPos( 225, 306 )
Close:SetText( "Close Menu" )
Close.DoClick = function( button )
		DeathNote:Close() 
		net.Start("DN_CloseMenu")
		net.SendToServer()
end
 
DeathnoteSheet:AddSheet( "DeathNote", DeathNotePlayerList, "materials/VGUI/icon/skull.png", false, false, "The notes of Death" )
DeathnoteSheet:AddSheet( "LifeNote", LifeNotePlayerList, "materials/VGUI/icon/heart.png", false, false, "The notes of Alive" )
DeathnoteSheet:AddSheet( "DeathNote Info", DNInfo, "materials/VGUI/icon/info.png", false, false, "" ) 
end

usermessage.Hook("deathnote_ent", deathnote_ent)
