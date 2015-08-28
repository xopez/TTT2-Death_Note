
 
function Deathnote_Settings( )
 
	local DN_Settings = vgui.Create( "DFrame" ) -- Creates the frame itself
	DN_Settings:SetSize( 400, 400 )
	DN_Settings:Center()
	DN_Settings:SetTitle( "Testing Derma Stuff" ) -- Title of the frame
	DN_Settings:SetVisible( true )
	DN_Settings:SetDraggable( false ) -- Draggable by mouse?
	DN_Settings:ShowCloseButton( false ) -- Show the close button?
	DN_Settings:MakePopup() -- Show the frame
	
	local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( DN_Settings )
	PropertySheet:SetPos( 0, 0 )
	PropertySheet:SetSize( 400, 400 )
	
	local GeneralSettings = vgui.Create( "DPanel" )
	GeneralSettings:SetSize(300, 300)
	GeneralSettings:SetPos(0, 0)
	GeneralSettings.Paint = function() 
		surface.SetDrawColor( 200, 50, 0, 255 ) 
		surface.DrawRect( 0, 0, GeneralSettings:GetWide(), GeneralSettings:GetTall() ) -- Draw the rect
	end
	
	local DebugSettings = vgui.Create( "DCheckBoxLabel" )
	DebugSettings:SetParent( GeneralSettings )
	DebugSettings:SetText( "Debug Mode" )
	DebugSettings:SetConVar( "DeathNote_Debug" )
	DebugSettings:SetPos( 10, 10 )
	DebugSettings:SetValue( 0 )
	DebugSettings:SizeToContents()
	
	local ULXSettings = vgui.Create( "DCheckBoxLabel" )
	ULXSettings:SetParent( GeneralSettings )
	ULXSettings:SetText( "ULX Installed" )
	ULXSettings:SetConVar( "DeathNote_ulx_installed" )
	ULXSettings:SetPos( 10, 30 )
	ULXSettings:SetValue( 0 )
	ULXSettings:SizeToContents()
	
	local ExplodeSettings = vgui.Create( "DCheckBoxLabel" )
	ExplodeSettings:SetParent( GeneralSettings )
	ExplodeSettings:SetText( "Explode Count Down" )
	ExplodeSettings:SetConVar( "DeathNote_ExplodeCountDown" )
	ExplodeSettings:SetPos( 10, 50 )
	ExplodeSettings:SetValue( 0 )
	ExplodeSettings:SizeToContents()
	
	local DeathTimeSetting = vgui.Create( "DNumSlider" )
	DeathTimeSetting:SetParent( GeneralSettings )
	DeathTimeSetting:SetPos( 10,25 )
	DeathTimeSetting:SetSize( 150, 100 ) 
	DeathTimeSetting:SetText( "Death Time" )
	DeathTimeSetting:SetMinMax( 1, 25 )
	DeathTimeSetting:SetDecimals( 0 ) 
	DeathTimeSetting:SetValue( 5 )
	DeathTimeSetting:SetConVar( "DeathNote_DeathTime" ) 
	
	local ExpoldeTimeSetting = vgui.Create( "DNumSlider" )
	ExpoldeTimeSetting:SetParent( GeneralSettings )
	ExpoldeTimeSetting:SetPos( 10,125 )
	ExpoldeTimeSetting:SetSize( 150, 100 ) 
	ExpoldeTimeSetting:SetText( "Expolde Time" )
	ExpoldeTimeSetting:SetMinMax( 1, 25 )
	ExpoldeTimeSetting:SetDecimals( 0 ) 
	ExpoldeTimeSetting:SetConVar( "DeathNote_ExplodeTimer" )
	
	local Close1 = vgui.Create( "DButton" )
	Close1:SetParent( GeneralSettings )
	Close1:SetText( "Close" )
	Close1:SetPos( 340, 10 )
	Close1:SetSize( 35, 20 )
	Close1.DoClick = function ()
		DN_Settings:Close()
	end

	local TTTSettings = vgui.Create( "DPanel" )
	TTTSettings:SetSize(300, 300)
	TTTSettings:SetPos(0, 0)
	TTTSettings.Paint = function() 
		surface.SetDrawColor( 200, 50, 0, 255 ) 
		surface.DrawRect( 0, 0, TTTSettings:GetWide(), TTTSettings:GetTall() ) -- Draw the rect
	end
	
	local Close2 = vgui.Create( "DButton" )
	Close2:SetParent( TTTSettings )
	Close2:SetText( "Close" )
	Close2:SetPos( 340, 10 )
	Close2:SetSize( 35, 20 )
	Close2.DoClick = function ()
		DN_Settings:Close()
	end
	
	PropertySheet:AddSheet( "General Menu", GeneralSettings, "materials/icon16/cog.png", false, false, "The Setting Varibles for everything else but TTT" )
	PropertySheet:AddSheet( "TTT Menu", TTTSettings, "materials/icon16/cog.png", false, false, "The Setting Varibles for TTT" ) 
end
concommand.Add("Deathnote_Settings_VGUI",Deathnote_Settings); 