Scriptname MFGAStartAddPerkScript extends Quest
;Script runs on game start to add some Perks to the player for the mod to work properly.
;The Perks are mostly hidden and only activate when their related Actor values are changed.

Actor Player
Perk [] MFGAPerkArray


Event OnInit()
	player = Game.GetPlayer()
	RegisterForRemoteEvent(player, "OnPlayerLoadGame")
	ReInit()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	Debug.Trace ("OnPlayerLoadGame()")
	ReInit()
EndEvent

Function ReInit()
	MFGAPerkArray = New Perk [17]
	MFGAPerkArray [0] = MFGARegisterForHitsPerk ;Crucial! The entire mod doesnt work without this! This activates the spell that applies MFGA_SKillIncreaseMonitor.psc
	MFGAPerkArray [1] = MFGA_SkillPerkReload ;All reloads done here (hopefully)
	MFGAPerkArray [2] = MFGASkillPerkAccHeavy ;AV: MFGA_HeavyReloadAV
	MFGAPerkArray [3] = MFGASkillPerkAccMissile ;AV: MFGA_MissileReloadAV
	MFGAPerkArray [4] = MFGASkillPerkAccPistol 
	MFGAPerkArray [5] = MFGASkillPerkAccPistol ;MFGASkillPerkAccShotgun (Probably limb damage)
	MFGAPerkArray [6] = MFGASkillPerkAccSniperRifle
	MFGAPerkArray [7] = MFGASkillPerkAccRifle
	MFGAPerkArray [8] = MFGASkillPerkAccAutoRifle
	MFGAPerkArray [9] = MFGASkillPerkDmgHeavy
	MFGAPerkArray [10] = MFGASkillPerkDmgMissile
	MFGAPerkArray [11] = MFGASkillPerkDmgPistol
	MFGAPerkArray [12] = MFGASkillPerkDmgPistol ;MFGASkillPerkDmgShotgun
	MFGAPerkArray [13] = MFGASkillPerkDmgSniperRifle
	MFGAPerkArray [14] = MFGASkillPerkDmgRifle
	MFGAPerkArray [15] = MFGASkillPerkDmgAutoRifle
	MFGAPerkArray [16] = MFGA_SkillPerkStagger

	int ArrayLength = MFGAPerkArray.Length
	int i = 0
	while i < ArrayLength
		if !(player.HasPerk(MFGAPerkArray[i])) ;Don't add Perks you already have as it can cause issues.
			player.AddPerk(MFGAPerkArray[i])
			TraceAndNotify("" + i + ") Perk: " + MFGAPerkArray[i] + " was added to the player.", True)
		else 
			TraceAndNotify("" + i + ") Perk: " + MFGAPerkArray[i] + " was not added to the player. They already have it", True)
		endif
		i += 1
	EndWhile
	
	if i < ArrayLength
		Debug.Notification("Error: Perk addition loop ended early.")		
	else 
		Debug.Notification("Perks successfully added to player.") ;Test For Perk Addition
	EndIf
EndFunction



Function TraceAndNotify(string msg, bool TraceOnly = false)
    Debug.Trace(msg)
    if !TraceOnly
        Debug.Notification(msg)
    EndIf
EndFunction

Perk Property MFGARegisterForHitsPerk Auto Const

;Reload Perks
Perk Property MFGA_SkillPerkReload Auto 
Perk Property MFGA_SkillPerkStagger Auto

;/Perk Property MFGA_SkillPerkReloadAutoRifle Auto 
Perk Property MFGA_SkillPerkReloadHeavy Auto 
Perk Property MFGA_SkillPerkReloadMissile Auto 
Perk Property MFGA_SkillPerkReloadPistol Auto 
Perk Property MFGA_SkillPerkReloadShotgun Auto 
Perk Property MFGA_SkillPerkReloadSniperRifle Auto 
Perk Property MFGA_SkillPerkReloadRifle Auto /;

;Accuracy Perks
Perk Property MFGASkillPerkAccAutoRifle Auto 
Perk Property MFGASkillPerkAccHeavy Auto 
Perk Property MFGASkillPerkAccMissile Auto 
Perk Property MFGASkillPerkAccPistol Auto 
Perk Property MFGASkillPerkAccShotgun Auto Hidden
Perk Property MFGASkillPerkAccSniperRifle Auto 
Perk Property MFGASkillPerkAccRifle Auto 

;Damage Perks
Perk Property MFGASkillPerkDmgAutoRifle Auto 
Perk Property MFGASkillPerkDmgHeavy Auto 
Perk Property MFGASkillPerkDmgMissile Auto 
Perk Property MFGASkillPerkDmgPistol Auto 
Perk Property MFGASkillPerkDmgShotgun Auto 
Perk Property MFGASkillPerkDmgSniperRifle Auto 
Perk Property MFGASkillPerkDmgRifle Auto 