;Global
bool runOnce
int maxLevelUp

;ReInit()
maxLevelUp = 5

	WeaponToIndex = New ActorValue[13]
	WeaponToIndex[0] = MFGAWeaponSkillMelee
	WeaponToIndex[1] = MFGAWeaponSkillUnarmed
	WeaponToIndex[2] = MFGAWeaponSkillPistol
	WeaponToIndex[3] = MFGAWeaponSkillShotgun
	WeaponToIndex[4] = MFGAWeaponSkillHeavyGun
	WeaponToIndex[5] = MFGAWeaponSkillMissileLauncher
	WeaponToIndex[6] = MFGAWeaponSkillRifle
	WeaponToIndex[7] = MFGAWeaponSkillAssaultRifle
	WeaponToIndex[8] = MFGAWeaponSkillSniper
	WeaponToIndex[9] = MFGAWeaponSkillExplosive
	WeaponToIndex[10] = MFGAWeaponSkillBallistic
	WeaponToIndex[11] = MFGAWeaponSkillPlasma
	WeaponToIndex[12] = MFGAWeaponSkillLaser


	float AccuracyMult
	float CriticalMult
	float DamageMult
	float ReloadMult

	NonAccuracyArray = New ActorValue[1] ;Weapons Not Affected by accuracy or reduced incoming damage
	NonAccuracyArray[0] = MFGAWeaponSkillShotgun

	;AccuracyArray 
	;NonAccuracyArray[0] = MFGAWeaponSkillPistol
	;NonAccuracyArray[1] = MFGAWeaponSkillHeavyGun
	;NonAccuracyArray[2] = MFGAWeaponSkillMissileLauncher
	;NonAccuracyArray[3] = MFGAWeaponSkillRifle
	;NonAccuracyArray[4] = MFGAWeaponSkillAssaultRifle
	;NonAccuracyArray[5] = MFGAWeaponSkillSniper
	;NonAccuracyArray[6] = MFGAWeaponSkillBallistic
	;NonAccuracyArray[7] = MFGAWeaponSkillPlasma
	;NonAccuracyArray[8] = MFGAWeaponSkillLaser
	;WeaponToIndex[0] = MFGAWeaponSkillMelee
	;WeaponToIndex[1] = MFGAWeaponSkillUnarmed
	;WeaponToIndex[2] = MFGAWeaponSkillPistol
	;WeaponToIndex[9] = MFGAWeaponSkillExplosive

	LimbDamageArray = New ActorValue [4]
	
	WeaponToIndex[3] = MFGAWeaponSkillShotgun
	




; what should affect accuracy:
; 2 Pistol, 4 HeavyGun, 5 MissileLauncher, 6 Rifle, 7 ARifle, 8 Sniper, 10 Ballistic, 11 Plasma, 12 Laser

; Not Affected by Accuracy 
; 0 = Melee 1 = Unarmed 3 = Shotgun 9 = Explosive 

Find(elementType akElement, int aiStartIndex = 0)

WeaponDataArray[0].AccuracyMult = 5;Reduce Incoming Damage
WeaponDataArray[0].CriticalMult = 
WeaponDataArray[0].DamageMult = 
WeaponDataArray[0].ReloadMult = ;Outgoing Limb Damage


WeaponDataArray[1].AccuracyMult = 5;Reduce Incoming Damage
WeaponDataArray[1].CriticalMult =
WeaponDataArray[1].DamageMult = 
WeaponDataArray[1].ReloadMult = ;Outgoing Limb Damage


WeaponDataArray[2].AccuracyMult = 
WeaponDataArray[2].CriticalMult =
WeaponDataArray[2].DamageMult = 
WeaponDataArray[2].ReloadMult = 


WeaponDataArray[3].AccuracyMult = 
WeaponDataArray[3].CriticalMult =
WeaponDataArray[3].DamageMult = 
WeaponDataArray[3].ReloadMult = 


WeaponDataArray[4].AccuracyMult = 
WeaponDataArray[4].CriticalMult =
WeaponDataArray[4].DamageMult = 
WeaponDataArray[4].ReloadMult = 


WeaponDataArray[5].AccuracyMult = 
WeaponDataArray[5].CriticalMult =
WeaponDataArray[5].DamageMult = 
WeaponDataArray[5].ReloadMult = 


WeaponDataArray[6].AccuracyMult = 
WeaponDataArray[6].CriticalMult =
WeaponDataArray[6].DamageMult = 
WeaponDataArray[6].ReloadMult = 


WeaponDataArray[7].AccuracyMult = 
WeaponDataArray[7].CriticalMult =
WeaponDataArray[7].DamageMult = 
WeaponDataArray[7].ReloadMult = 


WeaponDataArray[8].AccuracyMult = 
WeaponDataArray[8].CriticalMult =
WeaponDataArray[8].DamageMult = 
WeaponDataArray[8].ReloadMult = 


WeaponDataArray[9].AccuracyMult = 
WeaponDataArray[9].CriticalMult =
WeaponDataArray[9].DamageMult = 
WeaponDataArray[9].ReloadMult = 


WeaponDataArray[10].AccuracyMult = 
WeaponDataArray[10].CriticalMult =
WeaponDataArray[10].DamageMult = 
WeaponDataArray[10].ReloadMult = 


WeaponDataArray[11].AccuracyMult = 
WeaponDataArray[11].CriticalMult =
WeaponDataArray[11].DamageMult = 
WeaponDataArray[11].ReloadMult = 


WeaponDataArray[12].AccuracyMult = 
WeaponDataArray[12].CriticalMult =
WeaponDataArray[12].DamageMult = 
WeaponDataArray[12].ReloadMult = 


Struct StatGroup
	string statName1
	string statName2
	int stageToSet
	int objectiveID
EndStruct

StatGroupArray = New StatGroup [5]

StatGroupArray[0].statName1 = "Firing Speed"
StatGroupArray[0].statName2 = "Stagger Chance"
StatGroupArray[0].stageToSet = 0
StatGroupArray[0].objectiveID = 50

StatGroupArray[1].statName1 = "Reload Speed"
StatGroupArray[1].statName2 = "Limb Damage"
StatGroupArray[1].stageToSet = 10 ;
StatGroupArray[1].objectiveID = 20

StatGroupArray[2].statName1 = "Accuracy"
StatGroupArray[2].statName2 = "Damage Resistance"
StatGroupArray[2].stageToSet = 20 ;Accuracy
StatGroupArray[2].objectiveID = 30

StatGroupArray[3].statName1 = "Damage"
StatGroupArray[3].statName2 = "Damage"
StatGroupArray[3].stageToSet = 30
StatGroupArray[3].objectiveID = 10

StatGroupArray[4].statName1 = "Crit"
StatGroupArray[4].statName2 = "Crit"
StatGroupArray[4].stageToSet = 40
StatGroupArray[4].objectiveID = 40


Function UpdateQuestValues (int skillLV, int indexValue, int stageToSet, int objectiveID, GlobalVariable globalStat, float amountToIncrement, bool firstTime = False)
	Quest QuestToUpdate = WeaponDataArray[indexValue].QuestSkill
	GlobalVariable skillLevelGlobal = WeaponDataArray[indexValue].Level
	if skillLV >= 5 || skillLV  ;If in the first few Levels, update only that specific stat, otherwise, update all stats
		stageToSet = 0
	EndIf
	QuestToUpdate.ModObjectiveGlobal(1, skillLevelGlobal , 0) ;increment the Level by 1
	QuestToUpdate.ModObjectiveGlobal(amountToIncrement, globalStat, objectiveID) ;Increment the global by it's amount	
	QuestToUpdate.SetStage(stageToSet) ;Update the objectives
EndFunction

Function SetStageQuest(int indexValue)
	TraceAndNotify("SetStageOnEquipWeapon()", True)
	Quest QuestToUpdate = WeaponDataArray[indexValue].QuestSkill
	QuestToUpdate.SetStage(0)
	;Utility.Wait(5)
EndFunction

Function UpdateStats (ActorValue skill, int indexValue)
	int skillLv = Math.Floor(player.GetValue(skill))
	int currentStatAsInt = skillLv % 5 ;Case selection
	float statMult
	ActorValue statAV
	GlobalVariable statGlobal 
	if currentStatAsInt == 1 ;Reload Bonus on Level 1, 6, 11, 16, etc
		int reloadLV = Math.Min(skillLv / 5 + 1, maxLevelUp) ;Clamp the values 
		statMult = WeaponDataArray[indexValue].ReloadMult
		statGlobal = WeaponDataArray[indexValue].Reload
		statAV = WeaponDataArray[indexValue].ReloadAV
		if !(OptedIn[indexValue]) ;Opt the player in to receiving the spell only once
			if WeaponDataArray[indexValue].ReloadSpell ;Check for the existence of a spell first
				player.AddSpell(WeaponDataArray[indexValue].ReloadSpell) 
			EndIf
			OptedIn[indexValue] = True ;Opts in even if spell not present. Useful for other things
		EndIf
	elseif currentStatAsInt == 2 ;Accuracy Bonus on Level 2, 7, 12, 17, etc
		int accuracyLV = Math.Min(skillLv / 5 + 1, maxLevelUp)
		statMult = WeaponDataArray[indexValue].AccuracyMult
		statGlobal = WeaponDataArray[indexValue].Accuracy
		statAV = WeaponDataArray[indexValue].AccuracyAV
	elseif currentStatAsInt == 3 ;Damage Bonus on Level 3, 8, 13, 18, etc
		int damageLV = Math.Min(skillLv / 5 + 1, maxLevelUp)
		statMult = WeaponDataArray[indexValue].DamageMult
		statGlobal = WeaponDataArray[indexValue].Damage
		statAV = WeaponDataArray[indexValue].DamageAV
	elseif currentStatAsInt == 4 ;Crit Bonus on Level 4, 9, 14, 19, etc
		int critLV = Math.Min(skillLv / 5 + 1, maxLevelUp) 
		statMult = WeaponDataArray[indexValue].CriticalMult
		statGlobal = WeaponDataArray[indexValue].Critical
		statAV = WeaponDataArray[indexValue].CriticalAV
	elseif currentStatAsInt == 0 ;Firing Speed Bonus on Level 5, 10, 15, 20, etc
		int fspeedLV = Math.Min(skillLv / 5, maxLevelUp) 
		;Havent figured out firing speed yet, lol
	EndIf
	AVStatUpdate(currentStatAsInt, statAV, accuracyLV, statMult)
	UpdateQuestValues(skillLV, indexValue, StatGroupArray[currentStatAsInt].stageToSet, StatGroupArray[currentStatAsInt].objectiveID, statGlobal, statMult)
	DisplayGlobalsAndAVs(indexValue, currentStatAsInt, statAV, statGlobal) 
EndFunction


Function DisplayGlobalsAndAVs(int indexValue, int currentStatAsInt, ActorValue statAV, GlobalVariable statGlobal) 
	GlobalVariable skillLevelGlobal = WeaponDataArray[indexValue].Level 
	TraceAndNotify("SkillAV Just Updated: " + statAV, True)
	;TraceAndNotify("IndexValue: " + indexValue)
	TraceAndNotify("Global Value of Skill Level: " + skillLevelGlobal.GetValue())
	TraceAndNotify("Value of " + StatGroupArray[currentStatAsInt].statName1 + " " + "Global: " + statGlobal.GetValue())
	TraceAndNotify("Stat AV Just Updated: " + statAV, True)
	TraceAndNotify("Stat AV Value of " + StatGroupArray[currentStatAsInt].statName1 + ": " + player.GetValue(statAV))
EndFunction


Function AVStatUpdate(int currentStatAsInt, ActorValue statToUpdate, float statLV, float statMult)
	Debug.Trace("AVStatUpdate()")
	if currentStatAsInt == 0
		Debug.Trace("Firing Speed Handled Separately...Escaping")
		;Do Nothing
	elseif currentStatAsInt == 2 ;Accuracy
		Debug.Trace("Attempting to Update Accuracy")
		AccAVStatUpdate(statToUpdate, statLV, statMult)
	else ;All other Skills
		Debug.Trace("Attempting to Set AV Value")
		SetValue(statToUpdate, statLV * statMult) ;Value of Related Stat will be it's Level * It's Incremental Value per Level. Since this is retroactive it will work for any level and any skill.
	EndIf
	;return GetValue(statToUpdate)
EndFunction

Function AccAVStatUpdate(ActorValue statToUpdate, float statLV, float statMult) ;Acc Done a little differently than the other stats
	Debug.Trace("AVStatUpdate()")
	if WeaponDataArray[indexValue].skillName1 != MFGAWeaponSkillShotgun ;Shotguns don't become 'more accurate' (accuracy/incoming damage reduction is a decrease in value) 
		SetValue(statToUpdate, 100 - (statLV * statMult))
	else 
		SetValue(statToUpdate, statMult * statLV)
	EndIf
EndFunction

Function RunOnce(bool resetMod = False)
	Debug.Trace("RunOnce()")
	if resetMod || !ranOnce
		Debug.Trace("Initializing Booleans...")
		OptedIn = New bool[13]
		OptedIn[0] = False
		OptedIn[1] = False
		OptedIn[2] = False
		OptedIn[3] = False
		OptedIn[4] = False
		OptedIn[5] = False
		OptedIn[6] = False
		OptedIn[7] = False
		OptedIn[8] = False
		OptedIn[9] = False
		OptedIn[10] = False
		OptedIn[11] = False
		OptedIn[12] = False

		ranOnce = True
		Debug.Trace("Booleans Initialized!")
	else
		Debug.Trace("Ran once already or Isnt a Reset Call. Escaping...")
	EndIf
EndFunction