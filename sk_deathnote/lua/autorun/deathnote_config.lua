


ulx_premissions	= {"superadmin","admin","operator","owner"}
TTT_DN_Chance	= {2,4}


--------------------------------------
-- Don't Change Under This Line!!!! --
--------------------------------------

-- General
if !ConVarExists( "DeathNote_ulx_installed") then
	CreateConVar( "DeathNote_ulx_installed", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_Debug") then
	CreateConVar( "DeathNote_Debug", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_Admin_Messeges") then
	CreateConVar( "DeathNote_Admin_Messeges", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
-- Default
if !ConVarExists( "DeathNote_DeathTime") then
	CreateConVar( "DeathNote_DeathTime", 5, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_ExplodeTimer") then
	CreateConVar( "DeathNote_ExplodeTimer", 10, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_ExplodeCountDown") then
	CreateConVar( "DeathNote_ExplodeCountDown", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
 
-- TTT
if !ConVarExists( "DeathNote_TTT_DeathTime") then
	CreateConVar( "DeathNote_TTT_DeathTime", 15, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_TTT_AlwaysDies") then
	CreateConVar( "DeathNote_TTT_AlwaysDies", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_TTT_Explode_Enable") then
	CreateConVar( "DeathNote_TTT_Explode_Enable", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_TTT_Explode_Time") then
	CreateConVar( "DeathNote_TTT_Explode_Time", 15, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_TTT_LoseDNOnFail") then
	CreateConVar( "DeathNote_TTT_LoseDNOnFail", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_TTT_DNLockOut") then
	CreateConVar( "DeathNote_TTT_DNLockOut", 30, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end

-- concommand.Add( "Deathnote_Settings", function()
	-- for k,v in pairs(player.GetAll()) do
		-- v:PrintMessage(HUD_PRINTCONSOLE,"\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"-----------------------------------\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"-------DeathNote Server Settings---\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"-----------------------------------\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"ULX Installed: "..tostring(GetConVar("DeathNote_ulx_installed"):GetBool()).."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"Debug: "..tostring(GetConVar("DeathNote_Debug"):GetBool()).."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"---------------General--------------\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"Death Time: "..GetConVar("DeathNote_DeathTime"):GetInt().."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"Explode Time: "..GetConVar("DeathNote_ExplodeTimer"):GetInt().."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"Explode CountDown: "..tostring(GetConVar("DeathNote_ExplodeCountDown"):GetBool()).."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"----------------TTT----------------\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"TTT Death timer: "..GetConVar("DeathNote_TTT_DeathTime"):GetInt().."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"TTT Always Die: "..tostring(GetConVar("DeathNote_TTT_AlwaysDies"):GetBool()).."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"TTT Explode Enable: "..tostring(GetConVar("DeathNote_TTT_Explode_Enable"):GetBool()).."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"TTT Explode Time: "..GetConVar("DeathNote_TTT_Explode_Time"):GetInt().."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"TTT Lost on Death: "..tostring(GetConVar("DeathNote_TTT_LoseDNOnFail"):GetBool()).."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"TTT Lock out: "..GetConVar("DeathNote_TTT_DNLockOut"):GetInt().."\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"----------------------------------------\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"---Made By Blue-Pentagram & The Rowan---\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"----------------------------------------\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"\n")
		-- v:PrintMessage(HUD_PRINTCONSOLE,"\n")
	-- end
-- end)