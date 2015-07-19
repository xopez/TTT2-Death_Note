/*
Note Form Blue-Pentagram
Changing any of these values will need a map change for them to take affect

Sandbox Configure is Non TTT SWEP Version and the Entity of the DeathNote
*/
---------------------
--General Configure--
---------------------

ulx_installed = false 
-- If you use ULX for your Admin ranks

Debug_Mode_DN = false  
-- "Default: false" change this to true if you want admins to be able reset the cooldown

ulx_premissions = {"superadmin","admin","operator"}
-- just add more ulx groups in these brackets keep same format (do not worry if ulx_installed is on false)
-- Example {"owner","superadmin","admin","moderator","t_mod","God_Is_Fake101","Blue-Pentagram_is_better_then_TheRowan"}

---------------------
--Sandbox Configure--
---------------------
DN_DeathTime = 5
-- "Default: 5 " change how long in till the target dies form the DN

DN_ExplodeTimer = 10
-- "Default: 10 " change how long in till the target explodes form the DN

DN_ExplodeCountDown = false
-- "Default: false" Display a countdown explode timer (starts at 5 seconds)

-----------------
--TTT Configure--
-----------------
TTT_DN_DeathTime 	= 15
-- "Default: 15" change how long in till the target dies form the DN

TTT_DN_AlwaysDies 	= false 	
-- "Default: false" If set true it will 100% kill / even though you can change TTT_DN_Chance to 1 for it this is more neater and does not do the roll

TTT_DN_Chance 		= {2,4}
-- "Default: {2,4} "If "TTT_DN_AlwaysDies" is set to true don't worry about this (only use numbers between 1 and 6)

TTT_Explode_Enable	= true
-- "Default: true" Allow people to use the explode Death type.

TTT_Explode_Time	= 15
-- "Default: 15" The Explode Time for the TTT SWEP And Entities. (Person will stay alive for longer but can damge others)

TTT_LoseDNOnFail 	= true
-- "Default: true" While true the player will lose his/her Death-note when they fail the roll

TTT_DNLockOut 	= 30
-- "Default: 30" The time it will take form them to Reuse the Death-note (Do not worry about this if TTT_LoseDNOnFail is on true)