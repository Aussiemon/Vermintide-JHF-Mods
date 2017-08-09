# Vermintide Just-Have-Fun Mod Collection
A collection of interesting Vermintide mods I've created, with no particular theme. 

Requires Grimalackt's quality-of-life modpack installed to function:

(https://www.reddit.com/r/Vermintide/search?sort=new&restrict_sr=on&q=flair%3ACustom%2BContent) 

----------------------------------------------------------------
Mod List:
----------------------------------------------------------------

**Krench Mutation** command (replace ogres with Krench) 

**Skip Cutscenes** mod (skip all cutscenes with space or escape)  

**Size Tweaks** mod (control sizes of creatures and players)  

**Steam Warning** mod (displays warning on Steam routine maintenance days)  

**Bot Improvements Extra** mod (additions to grimalackt, iamlupo, and walterr's BotImprovements mod)

**Fashion Patrol** mod (Stormvermin patrols have white armor, client-side, host only)


----------------------------------------------------------------
Retired Mods:
----------------------------------------------------------------

**Mission Stats** command (print # completions per level) has been included in QoL pack. An alternate version is included with this pack that prints stats publicly for the entire lobby to see. 

**Remind** command (save reminders to be repeated back to you at the scoreboard screen) has been included in QoL pack.

**Lorebook** command (reports unlock stats of lorebook pages) has been included in QoL pack.


----------------------------------------------------------------
Full Setup Instructions:
----------------------------------------------------------------

0.	Unpack .zip file. Drag mods folder to \<game folder\>\binaries. Merge and overwrite existing files or folders.

1.	Open mods\Initialize.lua

2.	Add lines 

		Mods.exec("patch", "SkipCutscenes")
		Mods.exec("patch", "SizeTweaks")
		Mods.exec("patch", "SteamWarning")
		Mods.exec("patch", "BotImprovementsExtra")
		Mods.exec("patch", "FashionPatrol")
    
	underneath "--Additional mods go here :" comment.
	
    **OPTIONAL:**   Open patch\SizeTweaks.lua to modify creature and player sizes. By default, Krench and rat ogres are scaled by 1.5x for demonstration purposes.
	
3.	Open mods\CommandList.lua

4.	Add lines

		{"/krenchtation",	 false, 	"commands", 	"krenchtation"},
		{"/fixcursor",	 false, 	"commands", 	"fixcursor"},
    
	to bottom of commands.
	
5.	Use spacebar or escape in-game to skip cutscenes.



----------------------------------------------------------------
Individual Mod Instructions:
----------------------------------------------------------------

For **Krench Mutation** command (replace ogres with Krench):

1.	Open mods\CommandList.lua

2.	Add line 

		{"/krenchtation",	 false, 	"commands", 	"krenchtation"},
    
	to bottom of commands.
	
3.	In-game command is "/krenchtation" without quotes.

----------------------------------------------------------------

For **Skip Cutscenes** mod (skip all cutscenes with space or escape):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "SkipCutscenes")
    
	underneath "--Additional mods go here :" comment.
	
3.	Open mods\CommandList.lua

4.	Add line 

		{"/fixcursor",	 false, 	"commands", 	"fixcursor"},
    
	to bottom of commands.
	
5.	Use spacebar or escape in-game to skip cutscenes.
	
----------------------------------------------------------------

For **Size Tweaks** mod (control sizes of creatures and players):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "SizeTweaks")
    
	underneath "--Additional mods go here :" comment.

    **OPTIONAL:**   Open patch\SizeTweaks.lua to modify creature and player sizes. By default, Krench and rat ogres are scaled by 1.5x for demonstration purposes.

----------------------------------------------------------------

For **Steam Warning** mod (displays warning on Steam routine maintenance days):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "SteamWarning")
    
	underneath "--Additional mods go here :" comment.

----------------------------------------------------------------

For **Bot Improvements Extra** mod (additions to grimalackt, iamlupo, and walterr's BotImprovements mod)

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "BotImprovementsExtra")
    
	underneath "--Additional mods go here :" comment.

----------------------------------------------------------------

For **Fashion Patrol** mod (Stormvermin patrols have white armor, client-side, host only)

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "FashionPatrol")
    
	underneath "--Additional mods go here :" comment.

----------------------------------------------------------------