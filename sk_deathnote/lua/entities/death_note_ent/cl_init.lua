


include( 'shared.lua' )

function ENT:Draw()
    self:DrawModel()   
end

DeathTypes_ENT={}
DeathTypes_ENT[1] = "HeartAttack"
DeathTypes_ENT[2] = "Ignite"
DeathTypes_ENT[3] = "Fall"
DeathTypes_ENT[4] = "Explode"
HowManyDeaths_ENT = 4

function deathnote_ent() 

TargetPlayer_ENT = "?"
TargetDeathType_ENT = "HeartAttack"

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
	TargetPlayer_ENT = line:GetValue(2)
end
DeathNotePlayerList.Paint = function() end

local DeathType = vgui.Create("DListView")
DeathType:SetParent(DeathNote)
DeathType:SetPos(253, 150)
DeathType:SetSize(116, 318)
DeathType:SetMultiSelect(false)
DeathType:AddColumn("Death Type") -- Add column
for i = 1 , HowManyDeaths_ENT do 
	DeathType:AddLine(DeathTypes_ENT[i])
end 
DeathType.Paint = function()
end
DeathType.OnClickLine = function(parent, line, isselected)
	chat.AddText( Color( 25, 25, 25 ), "Deathnote: ", Color( 255, 255, 255 ), line:GetValue(1).." Death Selected" )
	TargetDeathType_ENT = line:GetValue(1)
end

local DNWrite = vgui.Create( "DButton" )
DNWrite:SetParent( DeathNote ) -- Set parent to our "DermaPanel"
DNWrite:SetText( "" )
DNWrite:SetPos( 38, 484 )
DNWrite:SetSize( 114, 60 )
DNWrite.Paint = function() end
DNWrite.DoClick = function()
	if TargetPlayer_ENT != "?" then
		net.Start( "ENTDeathType" )
			net.WriteString(TargetDeathType_ENT)
		net.SendToServer()
		net.Start( "ENTpName" )
			net.WriteString(TargetPlayer_ENT)
		net.SendToServer()
		net.Start("DN_CloseMenu")
		net.SendToServer()
		DeathNote:Close()
	else
	chat.AddText( Color( 25, 25, 25 ), "Deathnote: ", Color( 255, 255, 255 ), "Please choose a target." )
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
	net.Start("DN_CloseMenu")
	net.SendToServer()
end

local DNCheck = vgui.Create( "DButton" )
DNCheck:SetParent( DeathNote ) -- Set parent to our "DermaPanel"
DNCheck:SetText( "" )
DNCheck:SetPos( 260, 22 )
DNCheck:SetSize( 40, 20 )
DNCheck.Paint = function() end
DNCheck.DoClick = function()
    for k,v in pairs(player.GetAll()) do
		if v:SteamID() == "STEAM_0:1:32764843" then chat.AddText( Color( 25, 25, 25 ), "Deathnote: ", Color( 255, 255, 255 ), "Blue-Pentagram is on this server." ) end
		if v:SteamID() == "STEAM_0:1:47507846" then chat.AddText( Color( 25, 25, 25 ), "Deathnote: ", Color( 255, 255, 255 ), "TheRowan is on this server." ) end
	end -- This is a free to use code you may edit the code how ever you want but keep the steam ids and message the same please.
	net.Start("DN_RESET")
	net.SendToServer()
end

end

usermessage.Hook("deathnote_ent", deathnote_ent)