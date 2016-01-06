--Weapon cl_init

include('shared.lua')

SWEP.PrintName = "Death-Note"
SWEP.Slot = 5
SWEP.SlotPos = 20
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

DeathTypes={}
DeathTypes[1] = "Heart-Attack"
DeathTypes[2] = "Ignite"
DeathTypes[3] = "Fall"
DeathTypes[4] = "Explode"
DeathTypes[5] = "Premature burial"
HowManyDeaths = 5

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

function deathnote() 

TargetPlayer = "?"
TargetDeathType = "Heart-Attack"

local DeathNote = vgui.Create( "DFrame" )
DeathNote:SetSize( 400, 619 )
DeathNote:Center()
DeathNote:SetTitle( "" )
DeathNote:SetVisible( true )
DeathNote:SetBackgroundBlur( true )
DeathNote:SetDraggable( false )
DeathNote:ShowCloseButton( false )
DeathNote:MakePopup()

DeathNote.Paint = function()
	tex = surface.GetTextureID( "vgui/deathnote_vgui"  )
	surface.SetTexture(tex)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(0, 0, 400, 600)
end

local DeathNotePlayerList = vgui.Create("DListView")
DeathNotePlayerList:SetParent(DeathNote)
DeathNotePlayerList:SetPos(38, 150)
DeathNotePlayerList:SetSize(114, 316)
DeathNotePlayerList:SetMultiSelect(false)
DeathNotePlayerList:AddColumn("Name")
DeathNotePlayerList:SelectFirstItem()
for k,v in pairs(player.GetAll()) do
	DeathNotePlayerList:AddLine(v:Name(),v:EntIndex()) -- Add lines
end
DeathNotePlayerList.OnClickLine = function(parent, line, isselected)
	chat.AddText( Color( 25, 25, 25 ), "Deathnote: ", Color( 255, 255, 255 ), line:GetValue(1).." Player Selected" )
	TargetPlayer = line:GetValue(2)
end
DeathNotePlayerList.Paint = function() end

local DeathType = vgui.Create("DListView")
DeathType:SetParent(DeathNote)
DeathType:SetPos(253, 150)
DeathType:SetSize(116, 318)
DeathType:SetMultiSelect(false)
DeathType:AddColumn("Death Type") -- Add column
for i = 1 , HowManyDeaths do 
		DeathType:AddLine(DeathTypes[i])
end 
DeathType.Paint = function()
end
DeathType.OnClickLine = function(parent, line, isselected)
	chat.AddText( Color( 25, 25, 25 ), "Deathnote: ", Color( 255, 255, 255 ), line:GetValue(1).." Death Selected" )
	TargetDeathType = line:GetValue(1)
end

local DNWrite = vgui.Create( "DButton" )
DNWrite:SetParent( DeathNote ) -- Set parent to our "DermaPanel"
DNWrite:SetText( "" )
DNWrite:SetPos( 38, 484 )
DNWrite:SetSize( 114, 60 )
DNWrite.Paint = function() end
DNWrite.DoClick = function()
	if TargetPlayer != "?" then
			net.Start( "DeathType" )
				net.WriteString(TargetDeathType)
			net.SendToServer()
			net.Start( "pName" )
				net.WriteString(TargetPlayer)
			net.SendToServer()
			DeathNote:Close()
	else
		chat.AddText( Color( 25, 25, 25 ), "Deathnote: ", Color( 255, 255, 255 ), "Please choose a Target" )
	end
end

local DNCloseButten = vgui.Create( "DButton" )
DNCloseButten:SetParent( DeathNote ) -- Set parent to our "DermaPanel"
DNCloseButten:SetText( "" )
DNCloseButten:SetPos( 253, 484 )
DNCloseButten:SetSize( 114, 60 )
DNCloseButten.Paint = function() end
DNCloseButten.DoClick = function()
    DeathNote:Close()
end

local DNCheck = vgui.Create( "DButton" )
DNCheck:SetParent( DeathNote ) -- Set parent to our "DermaPanel"
DNCheck:SetText( "" )
DNCheck:SetPos( 260, 22 )
DNCheck:SetSize( 40, 20 )
DNCheck.Paint = function() end
DNCheck.DoClick = function()
    for k,v in pairs(player.GetAll()) do
		if v:SteamID() == "STEAM_0:1:32764843" then chat.AddText( Color( 25, 25, 25 ), "Deathnote: ", Color( 0, 100, 255 ), "Blue-Pentagram", Color( 255, 255, 255 ), " is on this server." ) end
		if v:SteamID() == "STEAM_0:1:47507846" then chat.AddText( Color( 25, 25, 25 ), "Deathnote: ", Color( 255, 255, 255 ), "TheRowan is on this server." ) end
	end -- This is a free to use code you may edit the code how ever you want but keep the steam ids and message the same please.
end

end

usermessage.Hook("deathnote", deathnote)
