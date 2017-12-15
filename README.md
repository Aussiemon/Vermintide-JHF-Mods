# Vermintide Just-Have-Fun Mod Collection
A collection of interesting Vermintide mods I've created, with no particular theme. 

Requires Grimalackt's quality-of-life modpack installed to function:

(https://www.reddit.com/r/Vermintide/search?sort=new&restrict_sr=on&q=flair%3ACustom%2BContent) 

----------------------------------------------------------------
Mod List:
----------------------------------------------------------------

**Krench Mutation** command (replace ogres with Krench) 

**Skip Cutscenes** mod (skip all cutscenes with space or escape)  

**Steam Warning** mod (displays warning on Steam routine maintenance days)  

**Fashion Patrol** mod (Stormvermin patrols have white armor, client-side, host only)

**HiDef UI Scaling** mod (resizes display to fit resolutions greater than 1080p)

**Fair Loot Dice** mod (adjusts loot die chance to reflect number of chests in a map)

**Pub Brawl** mod (restores pub brawl to the inn with the option of several other minor inclusions)

**Smaller Bright Wizard Staffs** mod (allows scaling of all first-person bright wizard staff models)

**Pages Forever** mod (lorebook pages visible after full unlock, option to prevent sackrat pages)

**Unequip Hats** mod (allows unequipping headgear for non-elf characters)

**Red Moon Variety** mod (restores multiple loading screen images to Red Moon Inn)

**Sound Settings** mod (allows control over the presence of various sound effects on weapon hit)


----------------------------------------------------------------
Retired Mods:
----------------------------------------------------------------

**Mission Stats** command (print # completions per level) has been included in QoL pack. An alternate version is included with this pack that prints stats publicly for the entire lobby to see. 

**Remind** command (save reminders to be repeated back to you at the scoreboard screen) has been included in QoL pack.

**Lorebook** command (reports unlock stats of lorebook pages) has been included in QoL pack.

**Size Tweaks** mod (control sizes of creatures and players)  is at least temporarily retired for lack of immediate interest.

**Bot Improvements Extra** mod (additions to grimalackt, iamlupo, and walterr's BotImprovements mod) has been included in QoL pack.


----------------------------------------------------------------
Full Setup Instructions:
----------------------------------------------------------------

**Many mods in the JHF Modpack are disabled by default. Enable their respective settings in Mod Settings to activate them.**

1.	Unpack .zip file. Drag mods folder to \<game folder\>\binaries. Merge and overwrite existing files or folders.

2.	Open mods\Initialize.lua

3.	Add lines 

		Mods.exec("patch", "SkipCutscenes")
		Mods.exec("patch", "SteamWarning")
		Mods.exec("patch", "FashionPatrol")
		Mods.exec("patch", "HiDefUIScaling")
		Mods.exec("patch", "FairLootDice")
		Mods.exec("patch", "PubBrawl")
		Mods.exec("patch", "SmallerBWStaffs")
		Mods.exec("patch", "PagesForever")
		Mods.exec("patch", "UnequipHats")
		Mods.exec("patch", "RedMoonVariety")
		Mods.exec("patch", "SoundSettings")
	
	underneath "--Additional mods go here :" comment.
	
4.	Open mods\CommandList.lua

5.	Add lines

		{"/krenchtation",	 false, 	"commands", 	"krenchtation"},
		{"/fixcursor",	 false, 	"commands", 	"fixcursor"},
	
	to bottom of commands.
	
6.	Use spacebar or escape in-game to skip cutscenes.



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

For **Steam Warning** mod (displays warning on Steam routine maintenance days):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "SteamWarning")
	
	underneath "--Additional mods go here :" comment.

----------------------------------------------------------------

For **Fashion Patrol** mod (Stormvermin patrols have white armor, client-side, host only)

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "FashionPatrol")
	
	underneath "--Additional mods go here :" comment.
	
3.  Enable in Mod Settings

----------------------------------------------------------------

For **HiDef UI Scaling** mod (resizes display to fit resolutions greater than 1080p):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "HiDefUIScaling")
	
	underneath "--Additional mods go here :" comment.

3.  Enable in Mod Settings

----------------------------------------------------------------

For **Fair Loot Dice** mod (adjusts loot die chance to reflect number of chests in a map):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "FairLootDice")
	
	underneath "--Additional mods go here :" comment.

3.  Enable in Mod Settings

----------------------------------------------------------------

For **Pub Brawl** mod (restores pub brawl to the inn with the option of several other minor inclusions):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "PubBrawl")
	
	underneath "--Additional mods go here :" comment.

3.  Enable in Mod Settings

----------------------------------------------------------------

For **Smaller Bright Wizard Staffs** mod (allows scaling of all first-person bright wizard staff models):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "SmallerBWStaffs")
	
	underneath "--Additional mods go here :" comment.

3.  Enable in Mod Settings

----------------------------------------------------------------

For **Pages Forever** mod (lorebook pages visible after full unlock, option to prevent sackrat pages):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "PagesForever")
	
	underneath "--Additional mods go here :" comment.

3.  Enable in Mod Settings

----------------------------------------------------------------

For **Unequip Hats** mod (allows unequipping headgear for non-elf characters):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "UnequipHats")
	
	underneath "--Additional mods go here :" comment.

----------------------------------------------------------------

For **Red Moon Variety** mod (restores multiple loading screen images to Red Moon Inn):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "RedMoonVariety")
	
	underneath "--Additional mods go here :" comment.

----------------------------------------------------------------

For **Sound Settings** mod (allows control over the presence of various sound effects on weapon hit):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "SoundSettings")
	
	underneath "--Additional mods go here :" comment.
	
3.  Enable in Mod Settings

----------------------------------------------------------------