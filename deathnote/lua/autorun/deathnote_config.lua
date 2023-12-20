ulx_premissions = {"superadmin", "admin", "operator", "owner"}
TTT_DN_Chance = {2, 4}
--------------------------------------
-- Don't Change Under This Line!!!! --
--------------------------------------
-- General
if not ConVarExists("DeathNote_ulx_installed") then
	CreateConVar("DeathNote_ulx_installed", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_Debug") then
	CreateConVar("DeathNote_Debug", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_Admin_Messages") then
	CreateConVar("DeathNote_Admin_Messages", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_Update_Messege") then
	CreateConVar("DeathNote_Update_Messege", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

-- Default
if not ConVarExists("DeathNote_DeathTime") then
	CreateConVar("DeathNote_DeathTime", 5, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_ExplodeTimer") then
	CreateConVar("DeathNote_ExplodeTimer", 10, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_ExplodeCountDown") then
	CreateConVar("DeathNote_ExplodeCountDown", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

-- TTT
if not ConVarExists("DeathNote_TTT_DeathTime") then
	CreateConVar("DeathNote_TTT_DeathTime", 15, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_TTT_AlwaysDies") then
	CreateConVar("DeathNote_TTT_AlwaysDies", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_TTT_Explode_Enable") then
	CreateConVar("DeathNote_TTT_Explode_Enable", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_TTT_Explode_Time") then
	CreateConVar("DeathNote_TTT_Explode_Time", 15, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_TTT_LoseDNOnFail") then
	CreateConVar("DeathNote_TTT_LoseDNOnFail", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

if not ConVarExists("DeathNote_TTT_DNLockOut") then
	CreateConVar("DeathNote_TTT_DNLockOut", 30, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY})
end

concommand.Add(
	"DeathNote_Copy_Module",
	function(ply, cmd, args)
		print("-----------------------------------------------------------------------------------")
		print(DeathnoteCustomDeathCode)
		print("-----------------------------------------------------------------------------------")
		if CLIENT then
			SetClipboardText(DeathnoteCustomDeathCode)
		end

		print("Create a Lua file in 'lua modules deathnote' in LOWERCASE and paste what has been copyed to your clipboard in there")
		print("don't forget to change the 'customdeath' in the 'dn_module_customdeath'.")
	end
)