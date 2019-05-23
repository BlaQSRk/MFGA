Scriptname MFGA_WeaponSkillQuest extends Quest

Actor Player ;All hail the God: The Player!

;Debug
;-----------
GlobalVariable[] GlobalSkillToIndex ;Used for...something? Deprecated probably haha
GlobalVariable[] GlobalToCounter ;Used for...something? Deprecated probably haha
GlobalVariable[] GlobalTotalToCounter ;Used for...something? Deprecated probably haha
int [] ObjectiveUpdate ;Used for...something? Deprecated probably haha

;Exp and Leveling -------
string[] diffScalerText ;Displays current difficulty level
float[] diffScaler ; Used to lower or increase total exp based on what the difficulty currently is
int gameDifficulty

ObjectMod[] FSpeedMod

bool isMelee   ;Bool Set for melee types to optimize code
bool isUnequip ;Bool for if an unequip is happening Probably better to use a state
float baseExpToLvUp ;Starting exp for level 1
float expScale ;How much the exp grows per level ontop of the baseExpToLvUp
int ammoExpModifier  ;Used to lower total exp for ammo Types
int secondaryExpModifier ;Used to lower total exp for secondary weapon growth
float expPerHit

bool isAmmoLeveling ;Deprecated? Originally used to allow more than one type to level at a time. Replaced with leveling states and a queue.
bool isSecondaryLeveling ;Deprecated? Originally used to allow more than one type to level at a time. Replaced with leveling states and a queue.

int [] levelUpQueue ;
int currentLevelingIndex

int skillIndex
int ammoIndex
string weaponName
string[] skillName 

Struct RaceData
	int ObjectiveID
	GlobalVariable GlobalID
	GlobalVariable Total
	String DisplayText
EndStruct

Race[] RaceToIndex
int[] RaceIndexToRaceDataIndex
RaceData[] RaceDataArray
ActorValue[] WeaponToIndex ;Used for secondary weapon leveling

Struct WeaponData
	ActorValue expPrimary
	ActorValue expSecondary
	ActorValue skillName1
	ActorValue skillName2
	String skillNameText
	string skillNameText2
	Quest QuestSkill
	GlobalVariable Level 
	GlobalVariable Accuracy
	GlobalVariable Damage
	GlobalVariable Reload
	GlobalVariable Critical
	GlobalVariable ExpCurr
	GlobalVariable ExpTotal	
	ActorValue AccuracyAV
	ActorValue DamageAV
	ActorValue ReloadAV
	ActorValue CriticalAV
	Spell ReloadSpell
	Perk DamagePerk
	Bool OptIn
	Int FSpeedLv
EndStruct

Struct AmmoData
	ActorValue expAmmo
	ActorValue skillName
	string skillNameText
EndStruct

WeaponData[] WeaponDataArray
AmmoData[] AmmoDataArray

Event OnQuestInit()
	Debug.Trace("OnQuestInit()")
	Player = Game.GetPlayer()
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
	ReInit()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	Debug.Trace ("OnPlayerLoadGame()")
	ReInit()
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Debug.Trace("OnItemEquipped()")
	isUnequip = False
	Utility.Wait(0.35)
	if akBaseObject.HasKeyword(WeaponTypeExplosive) || akBaseObject.HasKeyword(WeaponTypeGrenade)
		if akBaseObject.HasKeyword(WeaponTypeMissileLauncher) || akBaseObject.HasKeyword(WeaponTypeFatman)
			skillIndex = 5
			TraceAndNotify("The player equipped a Missile Launcher", True)
		else 
			TraceAndNotify("A grenade or mine was equipped", True)
			;Set Grenade Equip (Though this is probably not even necessary)
		EndIf
	else
		TraceAndNotify("No explosives found, checking for weapon type...", True)
		GetWeaponType()
	EndIf
	UpdateSpells(skillindex)
	DisplayReloadSpeed(skillindex)
	;ModPlayerEquippedWeapon(MFGA_mod_Weapon_Speed_Test, MFGA_mod_Weapon_Reload_Test, DavyJonesLocker, true) 
	Utility.Wait(2)
	
EndEvent

Event Actor.OnCombatStateChanged(Actor akSender, Actor akTarget, int aeCombatState)
	Debug.Trace("OnCombatStateChanged()")
	if aeCombatState == 0
		;LevelUpCheckAll()
	endif
EndEvent

Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Debug.Trace ("OnItemUnequipped()")	
	isUnequip = True
	if akBaseObject.HasKeyword(WeaponTypeExplosive) || akBaseObject.HasKeyWord(WeaponTypeGrenade)
		if akBaseObject.HasKeyword(WeaponTypeMissileLauncher) || akBaseObject.HasKeyword(WeaponTypeFatman)
			GetWeaponType()
		else 
			TraceAndNotify("A grenade or mine was unequipped", True)
			;Do Nothing
		EndIf
	EndIf
	GetWeaponType()
	;if player.GetEquippedWeapon() == None
	;		expToIncreaseWeapon1 = MFGAWeaponSkillUnarmedExp
	;		expToIncreaseWeapon2 = None
	;		expToIncreaseAmmo = None
	;		relevantSkillWeapon1 = MFGAWeaponSkillUnarmed
	;		TraceAndNotify("Player equipped an Unarmed Weapon", True)	
	;EndIf
EndEvent

Event Actor.OnDifficultyChanged(actor akSender, int aOldDifficulty, int aNewDifficulty)
	Debug.trace("OnDifficultyChanged() aOldDifficulty, aNewDifficulty: " + aOldDifficulty + ", " + aNewDifficulty)
	gameDifficulty = Game.GetDifficulty()
	TraceAndNotify("Difficulty: " + diffScalerText[gameDifficulty])
	TraceAndNotify("Difficulty Scaler: " + diffScaler[gameDifficulty]) 
EndEvent


Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
	TraceAndNotify("OnMenuOpenCloseEvent()", True)
	if (asMenuName == "PipboyMenu")
		if (abOpening)
			;LevelUpCheckAll()
			UpdateQuestExpAll()
		EndIf
	endif
EndEvent

Function UpdateQuestExp(bool isKilled = False, int i = -1)
	;Goal for this is to update the global values for the weapon's EXP in its quest window. Since globals lag behind the real EXP values
	Debug.Trace("UpdateQuestExp()")
	if i > -1 ;if i is negative, it's not in the group, so skip it.
		if (WeaponDataArray[i].OptIn) ;if not Opted In, dont bother updating the quest as it's not even there yet.
			if isKilled ;If a kill happened, then update the exp
				;---- Initialization ----
				Quest QuestToUpdate
				float totalExp
				GlobalVariable currentExpGlobal
				GlobalVariable totalExpGlobal
				float currSkillExp
				float currSkillLevel
				float expNeededToLevelUp
				;---- Assign Quest Values and Globals! ----
				currentExpGlobal = WeaponDataArray[i].ExpCurr ;Get the global variable used by the currently equipped weapon for current exp and set it
				currSkillExp = player.GetValue(WeaponDataArray[i].expPrimary) ;Get the value the current EXP for this weapon
				totalExpGlobal = WeaponDataArray[i].ExpTotal ; Get the global variable for total EXP needed to level up (second value in the EXP) used for this weapon
				currSkillLevel = player.GetValue(WeaponDataArray[i].skillName1) ; Get the current level of this skill and store it
				totalExp = Math.Floor(baseExpToLvUp + (expScale * currSkillLevel))  ; Recalculate the total Exp needed to level up for this level.
				QuestToUpdate = WeaponDataArray[i].QuestSkill ;Set the current Quest to update for this weapon
	    		;---- Little bit more intialization ----
				int prevExpCurr = currentExpGlobal.GetValueInt() ;get the value of the Global for current exp
				int currSkillExpInt = Math.Floor(currSkillExp) ;convert the real current EXP value from a float to an int
				int prevExpTotal = totalExpGlobal.GetValueInt() ;get the 'current' global value for total exp needed, that will potentially be updated
				int totalExpInt = Math.Floor(totalExp) ;get the real value for total Exp needed, and convert it to an int
				;---- Debug Block ----
				Debug.Trace("" + QuestToUpdate)
	    		Debug.Trace("currSkillLevel: " + currSkillLevel)
	    		Debug.Trace("currSkillExp: " + currSkillExp)
	    		Debug.Trace("totalExp: " + totalExp)
	    		Debug.Trace("currentExpGlobal: " + currentExpGlobal)
	    		Debug.Trace("totalExpGlobal: " + totalExpGlobal)
	    		Debug.Trace("currentExpGlobal: " + currentExpGlobal.GetValue())
	    		Debug.Trace("totalExpGlobal: " + totalExpGlobal.GetValue())

				if !(prevExpCurr == currSkillExpInt) ; if the Quest's Value for EXP is Equal to the actual EXP value then skip this. Saves unnecessary processing. Example: Global 21/27 exp vs Real Value: 24/27
					Debug.Trace("Current exp is not equal!")
					Debug.Trace("Attempting to Update " + WeaponDataArray[i].skillNameText)
	    			currSkillExp = Math.Floor(currSkillExp) ;Get the real value again??? I guess in case it updated somehow? Maybe can remove this line and just set it as currSkillExpInt on the next SetValue
		    		currentExpGlobal.SetValue(currSkillExp) ;Set the value for the global = to the currentSkillValue
		    		totalExpGlobal.SetValue(totalExp) ;Set the value for the Quest total exp global
		    		QuestToUpdate.UpdateCurrentInstanceGlobal(currentExpGlobal) ;Update the instance globals
		    		QuestToUpdate.UpdateCurrentInstanceGlobal(totalExpGlobal) ;Update the instance globals
		    		QuestToUpdate.SetObjectiveDisplayed(5, true, true) ;Necessary to redisplay it for it to update, unfortunately.
		    		Debug.Trace(WeaponDataArray[i].skillNameText + " successfully updated!")
		    	elseif !(prevExpTotal == totalExpInt) ;In the rare instance that the Global EXP but the Levels are different. then also update. Example Global Value: 22/27 EXP vs Real: 22/105 EXP. Probably can condense these but I dunno how at the moment.
		    		Debug.Trace("Current exp is equal!")
		    		Debug.Trace("Total exp is not equal!")
		    		Debug.Trace("Attempting to Update " + WeaponDataArray[i].skillNameText)
	    			currSkillExp = Math.Floor(currSkillExp)
		    		currentExpGlobal.SetValue(currSkillExp)
		    		totalExpGlobal.SetValue(totalExp)
		    		QuestToUpdate.UpdateCurrentInstanceGlobal(currentExpGlobal)
		    		QuestToUpdate.UpdateCurrentInstanceGlobal(totalExpGlobal)
		    		QuestToUpdate.SetObjectiveDisplayed(5, true, true)
		    		Debug.Trace(WeaponDataArray[i].skillNameText + " successfully updated!")
		    	else
		    		Debug.Trace (WeaponDataArray[i].skillNameText + " Value is Idendtical. Skipping...")
		    	endif
		    else
		    	Debug.Trace("Not a Kill, Escaping...")
	    	endif
	    else
	    	Debug.Trace("Not Opted In, Escaping...")
		EndIf
	endif
EndFunction

Function UpdateQuestExpAll()
	Debug.Trace("UpdateQuestExpAll()")
	Quest QuestToUpdate
	float totalExp
	GlobalVariable currentExpGlobal
	GlobalVariable totalExpGlobal
	float currSkillExp
	float currSkillLevel
	float expNeededToLevelUp
	int i = 0
	int arrayLength = WeaponDataArray.Length
	while i < arrayLength
		Debug.Trace("Attempting to Update " + WeaponDataArray[i].skillNameText)
		if (WeaponDataArray[i].OptIn)
			QuestToUpdate = WeaponDataArray[i].QuestSkill
			currentExpGlobal = WeaponDataArray[i].ExpCurr
			totalExpGlobal = WeaponDataArray[i].ExpTotal
			currSkillLevel = player.GetValue(WeaponDataArray[i].skillName1)
    		currSkillExp = player.GetValue(WeaponDataArray[i].expPrimary)
    		currSkillExp = Math.Floor(currSkillExp)
    		totalExp = Math.Floor(baseExpToLvUp + (expScale * currSkillLevel))
    		currentExpGlobal.SetValue(currSkillExp)
    		totalExpGlobal.SetValue(totalExp)
    		QuestToUpdate.UpdateCurrentInstanceGlobal(currentExpGlobal)
    		QuestToUpdate.UpdateCurrentInstanceGlobal(totalExpGlobal)
    		QuestToUpdate.SetObjectiveDisplayed(5, true, true)
    		Debug.Trace(WeaponDataArray[i].skillNameText + " successfully updated!")
    		;Debug.Trace("" + QuestToUpdate)
    		;Debug.Trace("currSkillLevel: " + currSkillLevel)
    		;Debug.Trace("currSkillExp: " + currSkillExp)
    		;Debug.Trace("totalExp: " + totalExp)
    		;Debug.Trace("currentExpGlobal: " + currentExpGlobal)
    		;Debug.Trace("totalExpGlobal: " + totalExpGlobal)
    		;Debug.Trace("currentExpGlobal: " + currentExpGlobal.GetValue())
    		;Debug.Trace("totalExpGlobal: " + totalExpGlobal.GetValue())
    	endif
    	i += 1
	EndWhile
EndFunction

Function IncreaseSkill(float increaseAmount = 1.0, bool isKilled = False, bool isGrenade = False) ;Default value of 1, Default False for Grenades/Explosives
	TraceAndNotify("IncreaseSkill()", True)
	increaseAmount *= diffScaler[gameDifficulty]
	int skillIndexLocal = skillIndex ;turn the script wide into a Local variable for preservation sake (in case the player shoots a bullet, and then switches weapon before it hits)
	int ammoIndexLocal = ammoIndex ;turn the global into a local variable for preservation sake (in case the player shoots a bullet, and then switches weapon before it hits)
	ActorValue skill 
	ActorValue skill2
	ActorValue skillExp
	;ActorValue ammoSkill
	if isGrenade ;Grenades/Mines/Throwables are a special case
		skill = WeaponDataArray[9].skillName1
		skillExp = WeaponDataArray[9].expPrimary
		player.ModValue(WeaponDataArray[9].expPrimary, increaseAmount)
		TraceAndNotify("Your EXP in " + WeaponDataArray[9].skillNameText + " increased by " + increaseAmount, True)
		TraceAndNotify("Your Total EXP in " + WeaponDataArray[9].skillNameText + " is " + player.getvalue(skillExp), True)
		isGrenade = False ;
		LevelUpCheck(skill, skillExp, 9, isKilled) ;Special Case for Explosives
	else
		skill = WeaponDataArray[skillIndexLocal].skillName1
		skillExp = WeaponDataArray[skillIndexLocal].expPrimary
		Player.ModValue(skillExp, increaseAmount)
		TraceAndNotify("Your EXP in " + WeaponDataArray[skillIndexLocal].skillNameText + " increased by " + increaseAmount, True)
		TraceAndNotify("Your Total EXP in " + WeaponDataArray[skillIndexLocal].skillNameText + " is " + player.getvalue(skillExp), True)
		LevelUpCheck(WeaponDataArray[skillIndexLocal].skillName1, WeaponDataArray[skillIndexLocal].expPrimary, skillIndexLocal, isKilled)
		if !isMelee ;if it's not a melee weapon, and not an explosive, then it has ammo. Check for ammo.
			skill = WeaponDataArray[ammoIndexLocal].skillName1
			skillExp = WeaponDataArray[ammoIndexLocal].expPrimary
			Player.ModValue(skillExp, (increaseAmount/ammoExpModifier))
			if ammoIndexLocal == 9
				TraceAndNotify("Your EXP in " + WeaponDataArray[9].skillNameText + " increased by " + (increaseAmount/ammoExpModifier), True)
				TraceAndNotify("Your Total EXP in " + WeaponDataArray[9].skillNameText + " is " + player.getvalue(WeaponDataArray[9].expPrimary), True)
				LevelUpCheck(WeaponDataArray[9].skillName1, WeaponDataArray[9].expPrimary, 9, isKilled) ;Special Case for Explosive Ammo
			else
				bool isAmmo = True
				TraceAndNotify("Your EXP in " + WeaponDataArray[skillIndexLocal].skillNameText + " increased by " + (increaseAmount/ammoExpModifier), True)
				TraceAndNotify("Your Total EXP in " + AmmoDataArray[ammoIndexLocal].skillNameText + " is " + player.getvalue(AmmoDataArray[ammoIndexLocal].expAmmo), True)
				LevelUpCheck(skill, skillExp, WeaponToIndex.Find(skill), isKilled, isAmmo)
			EndIf
		EndIf
		if (WeaponDataArray[skillIndexLocal].skillName2) ;Check Secondary Skills
			skill2 = WeaponDataArray[skillIndexLocal].skillName2
			Player.ModValue(WeaponDataArray[skillIndexLocal].expSecondary, (increaseAmount / secondaryExpModifier))
			TraceAndNotify("Your EXP in " + WeaponDataArray[skillIndexLocal].skillNameText2 + " increased by " + (increaseAmount / secondaryExpModifier), True)
			TraceAndNotify("Your Total EXP in " + WeaponDataArray[skillIndexLocal].skillNameText2 + " is " + player.getvalue(WeaponDataArray[skillIndexLocal].expSecondary), True)
			LevelUpCheck(WeaponDataArray[skillIndexLocal].skillName2, WeaponDataArray[skillIndexLocal].expSecondary, WeaponToIndex.Find(skill2), isKilled, False, True)
		EndIf
	EndIf
	;DisplaySkills()
EndFunction

Function IncrementAndDisplayExpValues(int indexValue, float increaseAmount)
		skill = WeaponDataArray[indexValue].skillName1
		skillExp = WeaponDataArray[indexValue].expPrimary
		skillText = WeaponDataArray[skillIndexLocal].skillNameText 
		Player.ModValue(skillExp, increaseAmount)
		TraceAndNotify("Your EXP in " + WeaponDataArray[skillIndexLocal].skillNameText + " increased by " + increaseAmount, True)
		TraceAndNotify("Your Total EXP in " + WeaponDataArray[skillIndexLocal].skillNameText + " is " + player.getvalue(skillExp), True)
		LevelUpCheck(WeaponDataArray[skillIndexLocal].skillName1, WeaponDataArray[skillIndexLocal].expPrimary, skillIndexLocal, isKilled)
EndFunction


Function DisplaySkills()
	TraceAndNotify("DisplaySkills()", True)
	TraceAndNotify("Ballistic EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillBallisticExp)) + "Laser EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillLaserExp)) + "Plasma EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillPlasmaExp)), True)
	TraceAndNotify("AutoRifle EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillAssaultRifleExp)) + "Explosive EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillExplosiveExp)) + "HeavyGun EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillHeavyGunExp)) + "Melee EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillMeleeExp)) + "Missile EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillMissileLauncherExp)) + "Pistol EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillPistolExp)) + "Rifle EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillRifleExp)) + "Shotgun EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillShotgunExp)) + "Sniper EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillSniperExp)) + "Unarmed EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillUnarmedExp)), True)
	Debug.Trace(" EXP " + "")
EndFunction


Function GetWeaponType()
	TraceAndNotify("GetWeaponType()", True)
	skillIndex = -1 ;Values out of bounds
	ammoIndex = -1 ;Values out of bounds
	isMelee = False
	isMiniGun = False
	isAutomatic = False
	if player.WornHasKeyword(AnimsMinigun) || player.WornHasKeyword(WeaponTypeGatlingLaser)
		TraceAndNotify("Player equipped a Minigun", True)
		isMiniGun = True
	endif
	if player.WornHasKeyword(WeaponTypeAutomatic)
		TraceAndNotify("Player equipped an Automatic Weapon", True)
		isAutomatic = True
	endif
	;Melee Check
	if (player.WornHasKeyWord(WeaponTypeMelee1H) || player.WornHasKeyWord(WeaponTypeMelee2H))
		skillindex = 0
		isMelee = True
		TraceAndNotify("Player equipped a Melee Weapon", True)
	ElseIf (player.WornHasKeyWord(WeaponTypeUnarmed)) || player.GetEquippedWeapon() == None
		skillindex = 1
		isMelee = True
		TraceAndNotify("Player equipped an Unarmed Weapon", True)
	EndIf
	
	if !isMelee ;Don't check for ammo/gun keywords if unarmed/using melee. Save processing time
		;Ammotype Check
		if player.WornHasKeyWord(WeaponTypeBallistic)
			ammoIndex = 10
			TraceAndNotify("Weapon uses Ballistic Ammo", True)
		elseif (player.WornHasKeyWord(WeaponTypePlasma))
			ammoIndex = 11
			TraceAndNotify("Weapon uses Plasma Ammo", True)
		elseif player.WornHasKeyWord(WeaponTypeLaser) || player.WornHasKeyword(WeaponTypeGatlingLaser)
			ammoIndex = 12
			TraceAndNotify("Weapon uses Laser Ammo", True)
		EndIf
		;Weapon type check
		If (player.WornHasKeyWord(WeaponTypePistol))
			skillindex = 2
			TraceAndNotify("Player equipped a Pistol", True)
		elseIf (player.WornHasKeyword(WeaponTypeShotgun))
			skillindex = 3
			TraceAndNotify("Player equipped a Shotgun", True)
		ElseIf (player.WornHasKeyword(WeaponTypeHeavyGun))
			if (player.WornHasKeyword(WeaponTypeMissileLauncher)) || player.WornHasKeyword(WeaponTypeFatman)
				skillindex = 5 ; missile launcher
				ammoIndex = 3 ;explosive ammo
				TraceAndNotify("Player equipped a Missile Launcher", True)
			else 
				skillindex = 4
				TraceAndNotify("Player equipped a HeavyGun", True)
			EndIf
		elseif (player.WornHasKeyWord(WeaponTypeRifle))
			if (player.WornHasKeyWord(WeaponTypeAutomatic))
				skillIndex = 7
				TraceAndNotify("Player equipped an Automatic Rifle", True)
			elseif (player.WornHasKeyWord(HasScope))
				skillIndex = 8
				TraceAndNotify("Player equipped a Sniper Rifle", True)
			else 
				skillIndex = 6
				TraceAndNotify("Player equipped a Normal Rifle", True)
			EndIf 
		else 
			skillIndex = 1
			TraceAndNotify("Test fell through the list, so must be 'truly' Unarmed", True) ;Fists don't have a "type" for some reason.
		EndIf

	EndIf
	if !isUnequip
		int testVal = skillIndex
	EndIf
	;SetStageOnEquipWeapon(skillindex)
EndFunction

Function DisplayReloadSpeed(int indexValue)
	TraceAndNotify("DisplayReloadSpeed()", True)
	Utility.Wait(0.25)
	TraceAndNotify("" + WeaponDataArray[indexValue].skillNameText + " - ReloadSpeed: " + player.GetValue(WeapReloadSpeedMult)) 
EndFunction

Function SetStageQuest(int indexValue)
	TraceAndNotify("SetStageOnEquipWeapon()", True)
	Quest QuestToUpdate = WeaponDataArray[indexValue].QuestSkill
	QuestToUpdate.SetStage(0)
	;Utility.Wait(5)
EndFunction

Function HitInformation (form source, bool sneakAttack, bool bashAttack, bool hitBlocked)
	TraceAndNotify("HitInformation()", True)
	Debug.Trace("Weapon: " + source)
	If source.HasKeyword(WeaponTypeExplosive) || source.HasKeyword(WeaponTypeGrenade)
		Debug.Trace ("Enemy was Hit by some kind of explosion")
	EndIf
	Debug.Trace("Players was Sneaking? " + sneakAttack)
	Debug.Trace("Player used Bash Attack? " + bashAttack)
	Debug.Trace("Attack was blocked? " + hitBlocked)
EndFunction
		
Function EnemyHitReward(Form akSource)
	TraceAndNotify("EnemyHitReward()", True)
	bool isKilled = False
	if akSource.HasKeyword(WeaponTypeExplosive) || akSource.haskeyword(WeaponTypeGrenade)
		if akSource.HasKeyWord(WeaponTypeMissileLauncher) || akSource.HasKeyword(WeaponTypeFatman)
			TraceAndNotify("Enemy was Hit by a Missile", True)
			IncreaseSkill(expPerHit * 2.5, isKilled, False) ;Double Exp Per Hit for fired explosives
		else
			TraceAndNotify("Enemy was hit by a grenade", True)
			IncreaseSkill(expPerHit * 4, isKilled, True) ;Quadruple Exp Per Hit for Grenades
		EndIf
	else
		IncreaseSkill(expPerHit) 
	endif
EndFunction

Function EnemyKillReward(int enemyLevel, ActorBase enemyActorBase, form causeOfDeath, bool assist = False)
	TraceAndNotify("EnemyKillReward()", True)
	Debug.Trace("Enemy ActorBase " + enemyActorBase)
	Int baseExp = 4
	float expGained
	int playerLevel = player.GetLevel()
	float bonus = Math.Max((Math.Min(EnemyLevel - playerLevel, 6)),-3)  * 0.2 * Math.Min(enemyLevel, 25) 
	bool isKilled = True
	expGained = BaseExp + (enemyLevel * 1.15) + bonus
	if assist
		Debug.Trace("Enemy Killed by an Assist") ;Reward Assist Kills even if not hit by the player.
		expGained /= 2
	else
		Debug.Trace("Enemy Killed by the Player")
	EndIf
	if causeOfDeath
		if (causeOfDeath.HasKeyword(WeaponTypeExplosive) || causeOfDeath.HasKeyword(WeaponTypeGrenade)) && !(causeOfDeath.HasKeyword(WeaponTypeMissileLauncher)) ;if an explosive kills, increase explosive exp. But not if its a missile.
			Debug.Trace("Rewarding Exp For Explosion Kill")
			IncreaseSkill(expGained, isKilled, True)
		else
			Debug.Trace("Rewarding Exp For Kill")
			IncreaseSkill(expGained, isKilled, False)
		EndIf
	else 
		Debug.Trace("Rewarding Exp For Kill without a Cause of Death")
		IncreaseSkill(expGained, isKilled, False)
	EndIf
EndFunction
	
Function TraceAndNotify(string msg, bool TraceOnly = false)
    Debug.Trace(msg)
    if !TraceOnly
        Debug.Notification(msg)
    EndIf
EndFunction

Function DisplayValue(string itemName, float value )
	TraceAndNotify("" + itemName + ": " + value, True)
EndFunction

Function DisplayAV(string itemName, ActorValue value )
	TraceAndNotify("" + itemName + ": " + value, True)
EndFunction

Function EnemyKillCounter(Race enemyRace, ActorBase enemyActorBase, bool enemyHitByPlayer) 
	Debug.Trace("EnemyKillCounter()")
	if enemyHitByPlayer ;You have to hit it at least one time to get a kill
		int RaceIndexValue = RaceToIndex.Find(EnemyRace)
		int testRaceIndex = RaceIndexToRaceDataIndex[RaceIndexValue]
		;TraceAndNotify("IndexValue of Race = " + RaceIndexValue)
		EnemyKillFunction(RaceIndexValue, 1)
		if testRaceIndex == 6 || testRaceIndex == 7 ;Mirelurk king and queen also increases Mirelurk Total by 3
			EnemyKillFunction(15, 3)
		elseif testRaceIndex == 12
			EnemyKillFunction(35, 6) ;Increment SuperMutants by 6 if a Behemoth Killed
		EndIf
	EndIf
EndFunction

Function EnemyKillFunction (int RaceIndexValue, int killCount = 1)
	Debug.Trace("EnemyKillFunction()")
	RaceData RaceKilled = RaceDataArray[ RaceIndexToRaceDataIndex[RaceIndexValue] ] 
	;TraceAndNotify("" + RaceKilled.DisplayText) 
	if ModObjectiveGlobal(killCount, RaceKilled.GlobalID, RaceKilled.ObjectiveID, RaceKilled.Total.Value) 
		SetStage(RaceKilled.ObjectiveID + 5) ;Add Perk If Total is Reached.
	EndIf
	return
EndFunction

Function LevelUpCheckAll()
	TraceAndNotify("LevelUpCheckAll()", True)
	ActorValue skill 
	ActorValue skillExp
	int i = 0
	int weaponArrayLength = WeaponDataArray.Length
	int ammoArrayLength = AmmoDataArray.Length
	While (i < weaponArrayLength)
		skill = WeaponDataArray[i].skillName1
		skillExp = WeaponDataArray[i].expPrimary
		if player.getvalue(skillExp) >= baseExpToLvUp ;If current exp in this skill is more than the base value then the player is at least level 1
			LevelUpCheck(skill, skillExp, i)
		EndIf
		i+=1
	EndWhile
	i = 0
	While (i < ammoArrayLength)
		skill = AmmoDataArray[i].skillName
		skillExp = AmmoDataArray[i].expAmmo
		if player.GetValue(skillExp) >= baseExpToLvUp ;If current exp in this skill is more than the base value 
			LevelUpCheck(skill, skillExp, i, False, True)
		EndIf
		i+=1
	EndWhile
EndFunction

Function LevelUpCheck (ActorValue skill, ActorValue skillExp, int indexValue, bool isKilled = False, bool isAmmo = False, bool isSecondary = False)
    Debug.Trace("LevelUpCheck()")
    ;UpdateQuestExp(isKilled, indexValue)
    TraceAndNotify("\n Skill: " + skill + "\n SkillExp: " + skillExp + "\n indexValue: " + indexValue + "\n isKilled: " + isKilled + "\n isAmmo: " + isAmmo + "\n isSecondary: " + isSecondary + "\n", True )
	bool HasLeveled = False
	float currSkillLevel = player.GetValue(skill)
	float currSkillExp = player.GetValue(skillExp)
	float expNeededToLevelUp
	expNeededToLevelUp = baseExpToLvUp + (expScale * currSkillLevel)
	if currSkillExp >= expNeededToLevelUp
        LevelUp(currSkillExp, skill, skillExp, expNeededToLevelUp, indexValue, isAmmo, isSecondary) ;Level Up and Subtract EXP Values
        ;Debug.Trace("Displaying Values After Level Up...")
    	;DisplayAV("skill", skill)
    	;DisplayValue("skill", player.GetValue(skill))
    	;DisplayAV("skillExp", skillExp)
    	;DisplayValue("skillExp", player.GetValue(skillExp))
    	;DisplayValue("currSkillExp", currSkillExp)
    	;DisplayValue("expNeededToLevelUp", expNeededToLevelUp)
    	;DisplayValue("indexValue", indexValue)
    	HasLeveled = True
        ExpDisplay(skill, skillExp, currSkillExp, expNeededToLevelUp, indexValue, isAmmo, isSecondary) ;Display Exp Amount
	else 
    	if isKilled    
    		ExpDisplay(skill, skillExp, currSkillExp, expNeededToLevelUp, indexValue, isAmmo, isSecondary)
    	endif
    if HasLeveled
    	LevelUpCheck(skill, skillExp, indexValue, isKilled, isAmmo, isSecondary) ;Check To see if you leveled up more then once
    endif
	EndIf
    
EndFunction


Float Function difficultyScaler()
	Debug.Trace("difficultyScaler()")
	;TraceAndNotify("Difficulty: " + diffScalerText[Game.GetDifficulty()])
	return diffScaler[Game.GetDifficulty()]
EndFunction

;Empty State
Function LevelUp (float currSkillExp, ActorValue skill, ActorValue skillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
	Debug.Trace("LevelUp()")
	player.ModValue(skill, 1)
	TraceAndNotify("" + "\n Skill: " + skill + "\n SkillExp: " + skillExp + "\n indexValue: " + indexValue + "\n isAmmo: " + isAmmo + "\n isSecondary: " + isSecondary, True )
	if isAmmo
		TraceAndNotify("You leveled up! You're now Level " + Math.Floor(player.GetValue(skill))  + " in " + AmmoDataArray[indexValue].skillNameText)
		;update quest globals
	else 
		TraceAndNotify("You leveled up! You're now Level " + Math.Floor(player.GetValue(skill))  + " in " + WeaponDataArray[indexValue].skillNameText)
		UpdateSkillTextReplacement(skill, indexValue)
		;update quest globals
	EndIf
	SubtractExp(skillExp, expNeededToLevelUp)
	ExpDisplay(skill, skillExp, currSkillExp, expNeededToLevelUp, indexValue, isAmmo, isSecondary)
EndFunction


auto State notLeveling
	;This is the state when nothing is leveling

	Function LevelUp (float currSkillExp, ActorValue skill, ActorValue skillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
		Debug.Trace("LevelUp()")
		TraceAndNotify("Current State: " + GetState(), True)
		GotoState("busyLeveling")
		currentLevelingIndex = indexValue
		player.ModValue(skill, 1)
		TraceAndNotify("" + "\n Skill: " + skill + "\n SkillExp: " + skillExp + "\n indexValue: " + indexValue + "\n isAmmo: " + isAmmo + "\n isSecondary: " + isSecondary, True )
		;if isAmmo
		;	TraceAndNotify("You leveled up! You're now Level " + Math.Floor(player.GetValue(skill))  + " in " + AmmoDataArray[indexValue].skillNameText)
			;update quest globals
		;else 
		TraceAndNotify("You leveled up! You're now Level " + Math.Floor(player.GetValue(skill))  + " in " + WeaponDataArray[indexValue].skillNameText)
		UpdateSkillTextReplacement(skill, indexValue)
			;update quest globals
		;EndIf
		SubtractExp(skillExp, expNeededToLevelUp)
		ExpDisplay(skill, skillExp, currSkillExp, expNeededToLevelUp, indexValue, isAmmo, isSecondary)
		GoToState("doneLeveling")
	EndFunction
EndState

State busyLeveling
	Function LevelUp (float currSkillExp, ActorValue skill, ActorValue skillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
		;This is the state when busy leveling
		;Do Nothing, Fam!
		TraceAndNotify("Current State: " + GetState(), True)
		TraceAndNotify("Attempting to add " + WeaponDataArray[indexValue].skillnameText + " to the queue.", True)
		if currentLevelingIndex != indexValue ;Skip Requests to level up the same weapon multiple times as it will do consecutive levels
			if (levelUpQueue.Find(indexValue) < 0) ;If you can't find the indexValue in the queue, add it to the queue
				levelUpQueue.Add(indexValue)
				TraceAndNotify("Adding " + WeaponDataArray[indexValue].skillnameText + " to the queue.", True)
			else
				TraceAndNotify("Failed to add " + WeaponDataArray[indexValue].skillnameText + " to the queue. Reason: Value already in the queue.", True)	
			EndIf
		else
			TraceAndNotify("Failed to add " + WeaponDataArray[indexValue].skillnameText + " to the queue. Reason: Identical to weapon that is currently leveling.", True)
		EndIf
	EndFunction
EndState

State doneLeveling
	;This is the state when done leveling
	Function LevelUp (float currSkillExp, ActorValue skill, ActorValue skillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
		TraceAndNotify("Current State: " + GetState(), True)
		currentLevelingIndex = -1
		QueueParser()
		GotoState("notLeveling")
	EndFunction
EndState

Function QueueParser()
	Debug.Trace("QueueParser()")
	int arrayLength = levelUpQueue.Length
	Debug.Trace("Queue Length = " + arrayLength)
	if arrayLength > 0 
		int indexValue = levelUpQueue[0]
		TraceAndNotify("Attempting to level up " + WeaponDataArray[indexValue].skillnameText + " via the queue.", True)
		levelUpQueue.Remove(0)
		LevelUpCheck(WeaponDataArray[indexValue].skillName1, WeaponDataArray[indexValue].expPrimary, indexValue)
	EndIf
EndFunction

Function ExpDisplay(ActorValue skill, ActorValue skillExp, float currSkillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
	;float currSkillLevel = player.GetValue(skill)
    ;currSkillExp = player.GetValue(skillExp)
    ;expNeededToLevelUp = baseExpToLvUp + (expScale * currSkillLevel)
    
	;GlobalVariable currExpGlobal = WeaponDataArray[indexValue].ExpCurr
	;GlobalVariable totalExpGlobal = WeaponDataArray[indexValue].ExpTotal
	;Quest QuestToUpdate = WeaponDataArray[indexValue].QuestSkill
	;float modAmountCurr = Math.Floor(currSkillExp - currExpGlobal.GetValue())
	;float modAmountTotal = Math.Floor(expNeededToLevelUp - totalExpGlobal.GetValue())
	;TraceAndNotify("Global CurrentExp: " + currExpGlobal.GetValue() + "\n" + "EXP: " + Math.Floor(currSkillExp) + "\n " + "ModAmountCurr: " + Math.Floor(modAmountCurr) + "\n ModAmountTotal: " + Math.Floor(modAmountTotal) + "\n expNeededToLevelUp: " + expNeededToLevelUp, True)
	;QuestToUpdate.ModObjectiveGlobal(modAmountCurr, currExpGlobal, 5)	
	;QuestToUpdate.ModObjectiveGlobal(modAmountTotal, totalExpGlobal, 5)

	if !(currSkillExp >= expNeededToLevelUp) ;Don't display exp if it's over the value. Just looks weird
        if isAmmo
          	TraceAndNotify("EXP: " + Math.Floor(currSkillExp) + "/" + Math.Floor(expNeededToLevelUp) + " " + AmmoDataArray[indexValue].skillNameText)
        elseIf isSecondary
            TraceAndNotify("EXP: " + Math.Floor(currSkillExp) + "/" + Math.Floor(expNeededToLevelUp) + " " + WeaponDataArray[indexValue].skillNameText2)
           	;update quest globals
        else
           	TraceAndNotify("EXP: " + Math.Floor(currSkillExp) + "/" + Math.Floor(expNeededToLevelUp) + " " + WeaponDataArray[indexValue].skillNameText)
           	;update quest globals
        EndIf
    endif

    ;if currExpGlobal.GetValue() > totalExpGlobal.GetValue()
    ;	ExpDisplay(skill, skillExp, currSkillExp, expNeededToLevelUp, indexValue, isAmmo, isSecondary)
    ;EndIf
EndFunction

Function SubtractExp(ActorValue skillExp, float expNeededToLevelUp)
	Debug.Trace("SubtractExp()")
	TraceAndNotify("SkillExp: " + skillExp)
	TraceAndNotify("expNeededToLevelUp: " + expNeededToLevelUp)
	float expToSubtract = 0
	expToSubtract = 0 - expNeededToLevelUp
	Debug.Trace("expToSubtract " + expToSubtract)
	player.ModValue(skillExp, expToSubtract)
EndFunction

Function UpdateSkillTextReplacement (ActorValue skill, int indexValue)
	Debug.Trace("UpdateSkillTextReplacement()")
	int skillLv = Math.Floor(player.GetValue(skill))
	int currentSkillGrouping = skillLv / 3 
	SetStageQuest(indexValue)
	Quest QuestToUpdate = WeaponDataArray[indexValue].QuestSkill
	GlobalVariable reloadSkillGlobal = WeaponDataArray[indexValue].Reload
	ActorValue reloadSkillAV = WeaponDataArray[indexValue].ReloadAV
	GlobalVariable skillLevelGlobal = WeaponDataArray[indexValue].Level 
	TraceAndNotify("reloadSkillAV: " + reloadSkillAV, True)
	;TraceAndNotify("IndexValue: " + indexValue)
	if skillLv % 3 == 1	
		float reloadPercent = 8.0
		player.ModValue(reloadSkillAV, reloadPercent)
		QuestToUpdate.ModObjectiveGlobal(reloadPercent, reloadSkillGlobal, 20)	
		QuestToUpdate.ModObjectiveGlobal(1, skillLevelGlobal, 0)
		if currentSkillGrouping == 0
			QuestToUpdate.SetStage(10) ;Update Text Replacement for Just Reload and Level
		else 
			QuestToUpdate.SetStage(0) ;Update Text Replacement for All Stats
		EndIf
		TraceAndNotify("Value of ReloadGlobal: " + reloadSkillGlobal.GetValue())
		if !(WeaponDataArray[indexValue].OptIn) 
			player.AddSpell(WeaponDataArray[indexValue].ReloadSpell)
			WeaponDataArray[indexValue].OptIn = True
		EndIf
		TraceAndNotify("Reload AV Value: " + player.GetValue(reloadSkillAV))
		TraceAndNotify("Reload AV: " + reloadSkillAV, True)
		;TraceAndNotify("1) Weapon Reload Speed Mult: " + player.GetValue(WeapReloadSpeedMult))
	elseif skillLv % 3 == 2
		float accuracyPercent = -9.0
		ActorValue accuracySkillAV = WeaponDataArray[indexValue].AccuracyAV
		GlobalVariable accuracySkillGlobal = WeaponDataArray[indexValue].Accuracy
		player.ModValue(accuracySkillAV, accuracyPercent)
		QuestToUpdate.ModObjectiveGlobal(Math.abs(accuracyPercent), accuracySkillGlobal, 30)
		QuestToUpdate.ModObjectiveGlobal(1, skillLevelGlobal, 0)	
		if currentSkillGrouping == 0
			QuestToUpdate.SetStage(20) ;Update Text Replacement for Accuracy, Reload and Level
		else 
			QuestToUpdate.SetStage(0) ;Update Text Replacement for All Stats
		EndIf
		int accuracyValue = Math.Floor(player.GetValue(WeaponDataArray[indexValue].AccuracyAV))
		TraceAndNotify("Accuracy AV Value: " + player.GetValue(accuracySkillAV))
		TraceAndNotify("Accuracy AV: " + accuracySkillAV, True)
		;WeaponDataArray[indexValue].Accuracy.SetValue(accuracyValue)
		;TraceAndNotify("Accuracy: " + accuracyValue, True)
	else 
		if skillLv / 3 == 1	
			player.AddPerk(WeaponDataArray[indexValue].DamagePerk) 
		EndIf
		float damagePercent = 10.0
		float critPercent = 1.0
		ActorValue damageSkillAV = WeaponDataArray[indexValue].DamageAV
		ActorValue criticalSkillAV = WeaponDataArray[indexValue].CriticalAV
		GlobalVariable damageSkillGlobal = WeaponDataArray[indexValue].Damage
		GlobalVariable criticalSkillGlobal = WeaponDataArray[indexValue].Critical

		player.ModValue(damageSkillAV, damagePercent)
		player.ModValue(criticalSkillAV, critPercent)

		QuestToUpdate.ModObjectiveGlobal(damagePercent, damageSkillGlobal, 10)
		QuestToUpdate.ModObjectiveGlobal(critPercent, criticalSkillGlobal, 40)
		QuestToUpdate.ModObjectiveGlobal(1, skillLevelGlobal, 0)
		QuestToUpdate.SetStage(0)
		
		int dmgValue = Math.Floor(player.GetValue(WeaponDataArray[indexValue].DamageAV))
		int critValue = Math.Floor(player.GetValue(WeaponDataArray[indexValue].CriticalAV))
		TraceAndNotify("Dmg: " + dmgValue)
		TraceAndNotify("Crit: " + critValue)
	EndIf
	
	UpdateSpells(indexValue)
	;TraceAndNotify("2) Weapon Reload Speed Mult: " + player.GetValue(WeapReloadSpeedMult))
	
EndFunction

Function UpdateSpells (int indexValue)
	TraceAndNotify("UpdateSpells()", True)
	if WeaponDataArray[indexValue].OptIn ;If Opted in, they have the reload spell as its the first one, but I am paranoid, hence the next line.
		if player.hasspell(WeaponDataArray[indexValue].ReloadSpell) 
			player.RemoveSpell(WeaponDataArray[indexValue].ReloadSpell)	;If the player has the spell, remove it.
		endif
		if player.hasspell(WeaponDataArray[indexValue].ReloadSpell) ;If the spell hasn't been removed yet, wait a while for removal to finish
			Utility.Wait(0.5)
		EndIf
		player.AddSpell(WeaponDataArray[indexValue].ReloadSpell) ;Re-Add the spell so it can update its values
		if !player.hasspell(WeaponDataArray[indexValue].ReloadSpell) ;If the spell hasn't been re-added yet, wait a while for it to be added
			Utility.Wait(0.5)
		EndIf
		if player.hasspell(WeaponDataArray[indexValue].ReloadSpell) ;If after waiting, the spell was added. You know it worked.
			Debug.Notification("Spell for " + WeaponDataArray[indexValue].skillNameText + " has been reset.")
		else 
			Debug.Notification("Spell for " + WeaponDataArray[indexValue].skillNameText + " wasn't added in time.") ;if spell wasn't added, then there was a waiting issue
		EndIf
	else ;You haven't gotten a level in that weapon yet, so you arent opted in.
		Debug.Notification("You don't have a spell for " + WeaponDataArray[indexValue].skillNameText + " yet.")
	EndIf
	DisplayReloadSpeed(indexValue)
EndFunction

Function ModPlayerEquippedWeapon(ObjectMod mod1, ObjectMod mod2,  ObjectReference container, bool attach = true)
    Debug.Trace("ModPlayerEquippedWeapon()")
    Weapon EquippedWeapon = Player.GetEquippedWeapon()
    if !(player.WornHasKeyword(MFGA_ObjectMod))
    	;TraceAndNotify("Object Mod successfully added!!!!")
    	;EquippedWeapon.AddKeyword(MFGA_ap_Gun_FSpeed)
    	Player.RemoveItem(EquippedWeapon, 1, true, DavyJonesLocker)
    	ObjectReference DroppedWeaponRef = DavyJonesLocker.DropObject(EquippedWeapon, 1)
    	if attach
        	DroppedWeaponRef.AttachMod(mod1)
        	DroppedWeaponRef.AttachMod(mod2)
  	  	Else
        	DroppedWeaponRef.RemoveMod(mod1)
        	DroppedWeaponRef.RemoveMod(mod2)
    	EndIf
    	Player.AddItem(DroppedWeaponRef, 1, true)
    	Player.EquipItem(EquippedWeapon, FALSE, TRUE)
    	if DroppedWeaponRef.HasKeyword(MFGA_ObjectMod)
    		TraceAndNotify("Object Mod successfully added!")
    	else
    		TraceAndNotify("Mod Failed to be added :(")
    	EndIf
    	if DroppedWeaponRef.HasKeyword(MFGA_ObjectMod_Recoil)
    		TraceAndNotify("Reload Object Mod successfully added!")
    	else
    		TraceAndNotify("Recoil Mod Failed to be added :(")
    	EndIf
    	if DroppedWeaponRef.HasKeyword(MFGA_ObjectMod_FSpeed)
    		TraceAndNotify("Speed Object Mod successfully added!")
    	else
    		TraceAndNotify("Speed Mod Failed to be added :(")
    	EndIf
    ;if player.WornHasKeyword(MFGA_ObjectMod) 
    ;	TraceAndNotify("Object Mod successfully added!!!!")
    ;endif
	else
		TraceAndNotify("Weapon Already Has an MFGA Object Mod")
    endif
    ;DroppedWeaponRef.AddKeyword(MFGA_ap_Gun_FSpeed)
    ;if DroppedWeaponRef.HasKeyword(MFGA_ap_Gun_FSpeed)
    ;	TraceAndNotify("DroppedWeaponRef now has the keyword.")
    ;EndIf
EndFunction

Function ReInit() ;Allows the game to reinitialize things if you need to change. OnQuestInit isn't sufficient. Put changes here.
	Debug.Trace("ReInit()")
	Debug.Trace("Registering Player For Future Events...")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
	RegisterForMenuOpenCloseEvent("PipboyMenu")
	RegisterForRemoteEvent(Player, "OnCombatStateChanged")
	RegisterForRemoteEvent(Player, "OnDifficultyChanged")
	;TraceAndNotify("" + player.GetEquippedWeapon(0) + "currently equipped in slot 1", True)
	;TraceAndNotify("" + player.GetEquippedWeapon(1) + "currently equipped in slot 2", True)
	;TraceAndNotify("" + player.GetEquippedWeapon(2) + "currently equipped in slot 3", True)
	Debug.Trace("Initializing values...")
	;Initialization values Deprecated. Please Remove
	;isAmmoLeveling = False Deprecated. Please Remove
	;isSecondaryLeveling = False Deprecated. Please Remove
	isUnequip = False
	Debug.Trace("Initializing EXP Values...")
	expPerHit = 1.0
	baseExpToLvUp = 12 ;Base Exp Needed to Level up
	expScale = 15 ;Exp Increase Per Level
	secondaryExpModifier = 2 ;EXP Gained / SecondaryExpModifier = Secondary Exp Gained
	ammoExpModifier = 4 ;EXP Gained / AmmoExpModifier = Ammo Exp Gained
	gameDifficulty = Game.GetDifficulty()

	Debug.Trace("Setting Difficulty Multipliers...")
	diffScaler = New float [7] ;EXP Modifiers for difficulty. Multiplies EXP gained by these values ie: ExpGained *= diffScaler[Game.GetDifficulty()]
    diffScaler[0] = 1.50 ;Very Easy
    diffScaler[1] = 1.25 ;Easy
    diffScaler[2] = 1.00 ;Normal
    diffScaler[3] = 0.85 ;Hard
    diffScaler[4] = 0.70 ;V-Hard
    diffScaler[5] = 0.50 ;Survival 1
    diffScaler[6] = 0.50 ;Survival 2

    diffScalerText = New string[7]
    diffScalerText[0] = "Very Easy"
    diffScalerText[1] = "Easy"
    diffScalerText[2] = "Normal"
    diffScalerText[3] = "Hard"
    diffScalerText[4] = "Very Hard"
    diffScalerText[5] = "Survival (1)"
    diffScalerText[6] = "Survival (2)"
    
    TraceAndNotify("Difficulty: " + diffScalerText[gameDifficulty])
	TraceAndNotify("Difficulty Scaler: " + diffScaler[gameDifficulty])    

    levelUpQueue = New int[0]

	Debug.Trace("Initializing Races...")
    ;Race Array    
	RaceToIndex = New Race [37]
	RaceToIndex[0] = HumanRace
	RaceToIndex[1] = GhoulRace
	RaceToIndex[2] = MoleratRace
	RaceToIndex[3] = YaoGuaiRace
	RaceToIndex[4] = RadStagRace
	RaceToIndex[5] = BrahminRace
	RaceToIndex[6] = CatRace
	RaceToIndex[7] = BloatflyRace
	RaceToIndex[8] = BloodbugRace
	RaceToIndex[9] = RadRoachRace
	RaceToIndex[10] = RadScorpionRace
	RaceToIndex[11] = StingwingRace
	RaceToIndex[12] = DeathclawRace
	RaceToIndex[13] = FeralGhoulRace
	RaceToIndex[14] = FeralGhoulGlowingRace
	RaceToIndex[15] = MirelurkHunterRace
	RaceToIndex[16] = MirelurkRace
	RaceToIndex[17] = MirelurkKingRace
	RaceToIndex[18] = MirelurkQueenRace
	RaceToIndex[19] = FEVHoundRace
	RaceToIndex[20] = RaiderDogRace
	RaceToIndex[21] = ViciousDogRace
	RaceToIndex[22] = AssaultronRace
	RaceToIndex[23] = EyeBotRace
	RaceToIndex[24] = HandyRace
	RaceToIndex[25] = LibertyPrimeRace
	RaceToIndex[26] = ProtectronRace
	RaceToIndex[27] = SentryBotRace
	RaceToIndex[28] = TurretBubbleRace
	RaceToIndex[29] = TurretWorkshopRace
	RaceToIndex[30] = TurretTripodRace
	RaceToIndex[31] = VertibirdRace
	RaceToIndex[32] = SynthGen1Race
	RaceToIndex[33] = SynthGen2Race
	RaceToIndex[34] = GorillaRace
	RaceToIndex[35] = SupermutantRace
	RaceToIndex[36] = SupermutantBehemothRace

	RaceIndexToRaceDataIndex = New Int [37]
	RaceIndexToRaceDataIndex[0] = 0
	RaceIndexToRaceDataIndex[1] = 0
	RaceIndexToRaceDataIndex[2] = 1
	RaceIndexToRaceDataIndex[3] = 1
	RaceIndexToRaceDataIndex[4] = 1
	RaceIndexToRaceDataIndex[5] = 1
	RaceIndexToRaceDataIndex[6] = 1
	RaceIndexToRaceDataIndex[7] = 2
	RaceIndexToRaceDataIndex[8] = 2
	RaceIndexToRaceDataIndex[9] = 2
	RaceIndexToRaceDataIndex[10] = 2
	RaceIndexToRaceDataIndex[11] = 2
	RaceIndexToRaceDataIndex[12] = 3
	RaceIndexToRaceDataIndex[13] = 4
	RaceIndexToRaceDataIndex[14] = 4
	RaceIndexToRaceDataIndex[15] = 5
	RaceIndexToRaceDataIndex[16] = 5
	RaceIndexToRaceDataIndex[17] = 6
	RaceIndexToRaceDataIndex[18] = 7
	RaceIndexToRaceDataIndex[19] = 8
	RaceIndexToRaceDataIndex[20] = 8
	RaceIndexToRaceDataIndex[21] = 8
	RaceIndexToRaceDataIndex[22] = 9
	RaceIndexToRaceDataIndex[23] = 9
	RaceIndexToRaceDataIndex[24] = 9
	RaceIndexToRaceDataIndex[25] = 9
	RaceIndexToRaceDataIndex[26] = 9
	RaceIndexToRaceDataIndex[27] = 9
	RaceIndexToRaceDataIndex[28] = 9
	RaceIndexToRaceDataIndex[29] = 9
	RaceIndexToRaceDataIndex[30] = 9
	RaceIndexToRaceDataIndex[31] = 9
	RaceIndexToRaceDataIndex[32] = 10
	RaceIndexToRaceDataIndex[33] = 10
	RaceIndexToRaceDataIndex[34] = 10
	RaceIndexToRaceDataIndex[35] = 11
	RaceIndexToRaceDataIndex[36] = 12

	RaceDataArray = New RaceData[13]

	RaceDataArray[0] = New RaceData
	RaceDataArray[0].ObjectiveId = 10
	RaceDataArray[0].GlobalID = MFGA_numHumansKilled
	RaceDataArray[0].Total = MFGA_numHumansKilledTotal
	RaceDataArray[0].DisplayText = "You killed a Human/Ghoul."
	
	RaceDataArray[1] = New RaceData
	RaceDataArray[1].ObjectiveId = 20
	RaceDataArray[1].GlobalID = MFGA_numAnimalsKilled
	RaceDataArray[1].Total = MFGA_numAnimalsKilledTotal
	RaceDataArray[1].DisplayText = "You killed an Animal."

	RaceDataArray[2] = New RaceData
	RaceDataArray[2].ObjectiveId = 30
	RaceDataArray[2].GlobalID = MFGA_numBugsKilled
	RaceDataArray[2].Total = MFGA_numBugsKilledTotal
	RaceDataArray[2].DisplayText = "You killed a Bug."

	RaceDataArray[3] = New RaceData
	RaceDataArray[3].ObjectiveId = 40
	RaceDataArray[3].GlobalID = MFGA_numDeathclawsKilled
	RaceDataArray[3].Total = MFGA_numDeathclawsKilledTotal
	RaceDataArray[3].DisplayText = "You killed a Deathclaw"
	
	RaceDataArray[4] = New RaceData
	RaceDataArray[4].ObjectiveId = 50
	RaceDataArray[4].GlobalID = MFGA_numGhoulsKilled
	RaceDataArray[4].Total = MFGA_numGhoulsKilledTotal
	RaceDataArray[4].DisplayText = "You killed a Feral Ghoul"

	RaceDataArray[5] = New RaceData
	RaceDataArray[5].ObjectiveId = 60
	RaceDataArray[5].GlobalID = MFGA_numMirelurksKilled
	RaceDataArray[5].Total = MFGA_numMirelurksKilledTotal
	RaceDataArray[5].DisplayText = "You killed a Mirelurk"

	RaceDataArray[6] = New RaceData
	RaceDataArray[6].ObjectiveId = 70
	RaceDataArray[6].GlobalID = MFGA_numMirelurkKingsKilled
	RaceDataArray[6].Total = MFGA_numMirelurkKingsKilledTotal
	RaceDataArray[6].DisplayText = "You killed a Mirelurk King"
	;increment GlobalMirelurks
	;if ModObjectiveGlobal(1, GlobalToCounter[5], ObjectiveUpdate[10], GlobalTotalToCounter[5].Value)
	;	SetStage(ObjectiveUpdate[11]) ;Add Perk If Total is Reached.
	;endif
		
	RaceDataArray[7] = New RaceData
	RaceDataArray[7].ObjectiveId = 80
	RaceDataArray[7].GlobalID = MFGA_numMirelurkQueensKilled
	RaceDataArray[7].Total = MFGA_numMirelurkQueensKilledTotal
	RaceDataArray[7].DisplayText = "You killed a Mirelurk Queen"
	;increment GlobalMirelurks
	;if ModObjectiveGlobal(1, GlobalToCounter[5], ObjectiveUpdate[10], GlobalTotalToCounter[5].Value)
	;	SetStage(ObjectiveUpdate[11]) ;Add Perk If Total is Reached.
	;endif

	RaceDataArray[8] = New RaceData
	RaceDataArray[8].ObjectiveId = 90
	RaceDataArray[8].GlobalID = MFGA_numDogsKilled
	RaceDataArray[8].Total = MFGA_numDogsKilledTotal
	RaceDataArray[8].DisplayText = "You killed a Dog"


	RaceDataArray[9] = New RaceData
	RaceDataArray[9].ObjectiveId = 100
	RaceDataArray[9].GlobalID = MFGA_numRobotsKilled
	RaceDataArray[9].Total = MFGA_numRobotsKilledTotal
	RaceDataArray[9].DisplayText = "You killed a Robot"

	RaceDataArray[10] = New RaceData
	RaceDataArray[10].ObjectiveId = 110
	RaceDataArray[10].GlobalID = MFGA_numSynthsKilled
	RaceDataArray[10].Total = MFGA_numSynthsKilledTotal
	RaceDataArray[10].DisplayText = "You killed a Synth"

	RaceDataArray[11] = New RaceData
	RaceDataArray[11].ObjectiveId = 120
	RaceDataArray[11].GlobalID = MFGA_numSuperMutantsKilled
	RaceDataArray[11].Total = MFGA_numSuperMutantsKilledTotal
	RaceDataArray[11].DisplayText = "You killed a Super Mutant"

	RaceDataArray[12] = New RaceData
	RaceDataArray[12].ObjectiveId = 130
	RaceDataArray[12].GlobalID = MFGA_numSuperMutantBehemothsKilled
	RaceDataArray[12].Total = MFGA_numSuperMutantBehemothsKilledTotal
	RaceDataArray[12].DisplayText = "You killed a Super Mutant Behemoth"

	Debug.Trace("Setting Objectives...")
	Debug.Trace("Initializing Global Kill Counter...")
	Debug.Trace("Setting Kill Totals...")



	Debug.Trace("Initializing Weapon Structs...")
	
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

	FSpeedMod = New ObjectMod[6]
	FSpeedMod[0] = None
	FSpeedMod[1] = None
	FSpeedMod[2] = None
	FSpeedMod[3] = None
	FSpeedMod[4] = None
	FSpeedMod[5] = None

	WeaponDataArray = New WeaponData[13]

	WeaponDataArray[0] = New WeaponData
	WeaponDataArray[0].expPrimary = MFGAWeaponSkillMeleeExp
	WeaponDataArray[0].expSecondary = None
	WeaponDataArray[0].skillName1 = MFGAWeaponSkillMelee
	WeaponDataArray[0].skillName2 = None
	WeaponDataArray[0].skillNameText = "Melee"
	WeaponDataArray[0].skillNameText2 = None
	WeaponDataArray[0].QuestSkill = MFGA_MeleeTextReplacementQuest
	WeaponDataArray[0].Level = MFGA_MeleeLV
	WeaponDataArray[0].Accuracy = None
	WeaponDataArray[0].Damage = MFGA_MeleeDmg
	WeaponDataArray[0].Reload = None
	WeaponDataArray[0].Critical = MFGA_MeleeCrit
	WeaponDataArray[0].ExpCurr = MFGA_MeleeExpCurr
	WeaponDataArray[0].ExpTotal = MFGA_MeleeExpTotal
	WeaponDataArray[0].AccuracyAV = None
	WeaponDataArray[0].DamageAV = MFGA_MeleeDmgAV
	WeaponDataArray[0].ReloadAV = None
	WeaponDataArray[0].CriticalAV = MFGA_MeleeCritAV
	WeaponDataArray[0].ReloadSpell = None
	WeaponDataArray[0].DamagePerk = None
	WeaponDataArray[0].OptIn = False
	WeaponDataArray[0].FSpeedLv = 0

	WeaponDataArray[1] = New WeaponData
	WeaponDataArray[1].expPrimary = MFGAWeaponSkillUnarmedExp
	WeaponDataArray[1].expSecondary = None
	WeaponDataArray[1].skillName1 = MFGAWeaponSkillUnarmed
	WeaponDataArray[1].skillName2 = None
	WeaponDataArray[1].skillNameText = "Unarmed"
	WeaponDataArray[1].skillNameText2 = None
	WeaponDataArray[1].QuestSkill = MFGA_UnarmedTextReplacementQuest
	WeaponDataArray[1].Level = MFGA_UnarmedLV
	WeaponDataArray[1].Accuracy = None
	WeaponDataArray[1].Damage = MFGA_UnarmedDmg
	WeaponDataArray[1].Reload = None
	WeaponDataArray[1].Critical = MFGA_UnarmedCrit
	WeaponDataArray[1].ExpCurr = MFGA_UnarmedExpCurr
	WeaponDataArray[1].ExpTotal = MFGA_UnarmedExpTotal
	WeaponDataArray[1].AccuracyAV = None
	WeaponDataArray[1].DamageAV = MFGA_UnarmedDmgAV
	WeaponDataArray[1].ReloadAV = None
	WeaponDataArray[1].CriticalAV = MFGA_UnarmedCritAV
	WeaponDataArray[1].ReloadSpell = None
	WeaponDataArray[1].DamagePerk = None
	WeaponDataArray[1].OptIn = False
	WeaponDataArray[1].FSpeedLv = 0


	WeaponDataArray[2] = New WeaponData
	WeaponDataArray[2].expPrimary = MFGAWeaponSkillPistolExp
	WeaponDataArray[2].expSecondary = None
	WeaponDataArray[2].skillName1 = MFGAWeaponSkillPistol
	WeaponDataArray[2].skillName2 = None
	WeaponDataArray[2].skillNameText = "Pistol"
	WeaponDataArray[2].skillNameText2 = None
	WeaponDataArray[2].QuestSkill = MFGA_PistolTextReplacementQuest
	WeaponDataArray[2].Level = MFGA_PistolLV
	WeaponDataArray[2].Accuracy = MFGA_PistolAcc
	WeaponDataArray[2].Damage = MFGA_PistolDmg
	WeaponDataArray[2].Reload = MFGA_PistolReload
	WeaponDataArray[2].Critical = MFGA_PistolCrit 
	WeaponDataArray[2].ExpCurr = MFGA_PistolExpCurr
	WeaponDataArray[2].ExpTotal = MFGA_PistolExpTotal
	WeaponDataArray[2].AccuracyAV = MFGA_PistolAccAV
	WeaponDataArray[2].DamageAV = MFGA_PistolDmgAV
	WeaponDataArray[2].ReloadAV = MFGA_PistolReloadAV
	WeaponDataArray[2].CriticalAV = MFGA_PistolCritAV 
	WeaponDataArray[2].ReloadSpell = MFGAAbPerkReloadSpeedPistol
	WeaponDataArray[2].DamagePerk = MFGASkillPerkDmgPistol
	WeaponDataArray[2].OptIn = False
	WeaponDataArray[2].FSpeedLv = 0


	WeaponDataArray[3] = New WeaponData
	WeaponDataArray[3].expPrimary = MFGAWeaponSkillShotgunExp
	WeaponDataArray[3].expSecondary = None
	WeaponDataArray[3].skillName1 = MFGAWeaponSkillShotgun
	WeaponDataArray[3].skillName2 = None
	WeaponDataArray[3].skillNameText = "Shotgun"
	WeaponDataArray[3].skillNameText2 = None
	WeaponDataArray[3].QuestSkill = MFGA_ShotgunTextReplacementQuest
	WeaponDataArray[3].Level = MFGA_ShotgunLV
	WeaponDataArray[3].Accuracy = MFGA_ShotgunAcc
	WeaponDataArray[3].Damage = MFGA_ShotgunDmg
	WeaponDataArray[3].Reload = MFGA_ShotgunReload
	WeaponDataArray[3].Critical = MFGA_ShotgunCrit
	WeaponDataArray[3].ExpCurr = MFGA_ShotgunExpCurr
	WeaponDataArray[3].ExpTotal = MFGA_ShotgunExpTotal
	WeaponDataArray[3].AccuracyAV = MFGA_ShotgunAccAV
	WeaponDataArray[3].DamageAV = MFGA_ShotgunDmgAV
	WeaponDataArray[3].ReloadAV = MFGA_ShotgunReloadAV
	WeaponDataArray[3].CriticalAV = MFGA_ShotgunCritAV
	WeaponDataArray[3].ReloadSpell = MFGAAbPerkReloadSpeedShotgun
	WeaponDataArray[3].DamagePerk = None
	WeaponDataArray[3].OptIn = False
	WeaponDataArray[3].FSpeedLv = 0


	WeaponDataArray[4] = New WeaponData
	WeaponDataArray[4].expPrimary = MFGAWeaponSkillHeavyGunExp
	WeaponDataArray[4].expSecondary = None
	WeaponDataArray[4].skillName1 = MFGAWeaponSkillHeavyGun
	WeaponDataArray[4].skillName2 = None
	WeaponDataArray[4].skillNameText = "Heavy Guns"
	WeaponDataArray[4].skillNameText2 = None
	WeaponDataArray[4].QuestSkill = MFGA_HeavyTextReplacementQuest
	WeaponDataArray[4].Level = MFGA_HeavyLV
	WeaponDataArray[4].Accuracy = MFGA_HeavyAcc
	WeaponDataArray[4].Damage = MFGA_HeavyDmg
	WeaponDataArray[4].Reload = MFGA_HeavyReload
	WeaponDataArray[4].Critical = MFGA_HeavyCrit
	WeaponDataArray[4].ExpCurr = MFGA_HeavyExpCurr
	WeaponDataArray[4].ExpTotal = MFGA_HeavyExpTotal
	WeaponDataArray[4].AccuracyAV = MFGA_HeavyAccAV
	WeaponDataArray[4].DamageAV = MFGA_HeavyDmgAV
	WeaponDataArray[4].ReloadAV = MFGA_HeavyReloadAV
	WeaponDataArray[4].CriticalAV = MFGA_HeavyCritAV
	WeaponDataArray[4].ReloadSpell = MFGAAbPerkReloadSpeedHeavyGun
	WeaponDataArray[4].DamagePerk = None
	WeaponDataArray[4].OptIn = False
	WeaponDataArray[4].FSpeedLv = 0
	

	WeaponDataArray[5] = New WeaponData
	WeaponDataArray[5].expPrimary = MFGAWeaponSkillMissileLauncherExp
	WeaponDataArray[5].expSecondary = MFGAWeaponSkillHeavyGunExp
	WeaponDataArray[5].skillName1 = MFGAWeaponSkillMissileLauncher
	WeaponDataArray[5].skillName2 = MFGAWeaponSkillHeavyGun
	WeaponDataArray[5].skillNameText = "Missile Launcher"
	WeaponDataArray[5].skillNameText2 = "Heavy Guns"
	WeaponDataArray[5].QuestSkill = None
	WeaponDataArray[5].Level = MFGA_MissileLV
	WeaponDataArray[5].Accuracy = MFGA_MissileAcc ;MFGA_ have to populate these
	WeaponDataArray[5].Damage = MFGA_MissileDmg ;MFGA_
	WeaponDataArray[5].Reload = MFGA_MissileReload ;MFGA_
	WeaponDataArray[5].Critical = MFGA_MissileCrit ;MFGA_
	WeaponDataArray[5].ExpCurr = MFGA_MissileExpCurr
	WeaponDataArray[5].ExpTotal = MFGA_MissileExpTotal
	WeaponDataArray[5].AccuracyAV = MFGA_MissileAccAV
	WeaponDataArray[5].DamageAV = MFGA_MissileDmgAV
	WeaponDataArray[5].ReloadAV = MFGA_MissileReloadAV
	WeaponDataArray[5].CriticalAV = MFGA_MissileCritAV
	WeaponDataArray[5].ReloadSpell = MFGAAbPerkReloadSpeedMissile
	WeaponDataArray[5].DamagePerk = None
	WeaponDataArray[5].OptIn = False
	WeaponDataArray[5].FSpeedLv = 0
	

	WeaponDataArray[6] = New WeaponData
	WeaponDataArray[6].expPrimary = MFGAWeaponSkillRifleExp
	WeaponDataArray[6].expSecondary = None
	WeaponDataArray[6].skillName1 = MFGAWeaponSkillRifle
	WeaponDataArray[6].skillName2 = None
	WeaponDataArray[6].skillNameText = "Rifle"
	WeaponDataArray[6].skillNameText2 = None
	WeaponDataArray[6].QuestSkill = MFGA_RifleTextReplacementQuest
	WeaponDataArray[6].Level = MFGA_RifleLV
	WeaponDataArray[6].Accuracy = MFGA_RifleAcc
	WeaponDataArray[6].Damage = MFGA_RifleDmg
	WeaponDataArray[6].Reload = MFGA_RifleReload
	WeaponDataArray[6].Critical = MFGA_RifleCrit
	WeaponDataArray[6].ExpCurr = MFGA_RifleExpCurr
	WeaponDataArray[6].ExpTotal = MFGA_RifleExpTotal
	WeaponDataArray[6].AccuracyAV = MFGA_RifleAccAV
	WeaponDataArray[6].DamageAV = MFGA_RifleDmgAV
	WeaponDataArray[6].ReloadAV = MFGA_RifleReloadAV
	WeaponDataArray[6].CriticalAV = MFGA_RifleCritAV
	WeaponDataArray[6].ReloadSpell = MFGAAbPerkReloadSpeedRifle
	WeaponDataArray[6].DamagePerk = None
	WeaponDataArray[6].OptIn = False
	WeaponDataArray[6].FSpeedLv = 0

	WeaponDataArray[7] = New WeaponData
	WeaponDataArray[7].expPrimary = MFGAWeaponSkillAssaultRifleExp
	WeaponDataArray[7].expSecondary = MFGAWeaponSkillRifleExp
	WeaponDataArray[7].skillName1 = MFGAWeaponSkillAssaultRifle
	WeaponDataArray[7].skillName2 = MFGAWeaponSkillRifle
	WeaponDataArray[7].skillNameText = "Assault Rifle"
	WeaponDataArray[7].skillNameText2 = "Rifle"
	WeaponDataArray[7].QuestSkill = MFGA_ARifleTextReplacementQuest
	WeaponDataArray[7].Level = MFGA_ARifleLV
	WeaponDataArray[7].Accuracy = MFGA_ARifleAcc
	WeaponDataArray[7].Damage = MFGA_ARifleDmg
	WeaponDataArray[7].Reload = MFGA_ARifleReload
	WeaponDataArray[7].Critical = MFGA_ARifleCrit
	WeaponDataArray[7].ExpCurr = MFGA_ARifleExpCurr
	WeaponDataArray[7].ExpTotal = MFGA_ARifleExpTotal
	WeaponDataArray[7].AccuracyAV = MFGA_ARifleAccAV
	WeaponDataArray[7].DamageAV = MFGA_ARifleDmgAV
	WeaponDataArray[7].ReloadAV = MFGA_ARifleReloadAV
	WeaponDataArray[7].CriticalAV = MFGA_ARifleCritAV
	WeaponDataArray[7].ReloadSpell = MFGAAbPerkReloadSpeedAutoRifle
	WeaponDataArray[7].DamagePerk = None
	WeaponDataArray[7].OptIn = False
	WeaponDataArray[7].FSpeedLv = 0
	

	WeaponDataArray[8] = New WeaponData
	WeaponDataArray[8].expPrimary = MFGAWeaponSkillSniperExp
	WeaponDataArray[8].expSecondary = MFGAWeaponSkillRifleExp
	WeaponDataArray[8].skillName1 = MFGAWeaponSkillSniper
	WeaponDataArray[8].skillName2 = MFGAWeaponSkillRifle
	WeaponDataArray[8].skillNameText = "Sniper Rifle"
	WeaponDataArray[8].skillNameText2 = "Rifle"
	WeaponDataArray[8].QuestSkill = MFGA_SniperRifleTextReplacementQuest
	WeaponDataArray[8].Level = MFGA_SniperLV
	WeaponDataArray[8].Accuracy = MFGA_SniperAcc
	WeaponDataArray[8].Damage = MFGA_SniperDmg
	WeaponDataArray[8].Reload = MFGA_SniperReload
	WeaponDataArray[8].Critical = MFGA_SniperCrit
	WeaponDataArray[8].ExpCurr = MFGA_SniperExpCurr
	WeaponDataArray[8].ExpTotal = MFGA_SniperExpTotal
	WeaponDataArray[8].AccuracyAV = MFGA_SniperAccAV
	WeaponDataArray[8].DamageAV = MFGA_SniperDmgAV
	WeaponDataArray[8].ReloadAV = MFGA_SniperReloadAV
	WeaponDataArray[8].CriticalAV = MFGA_SniperCritAV
	WeaponDataArray[8].ReloadSpell = MFGAAbPerkReloadSpeedSniperRifle
	WeaponDataArray[8].DamagePerk = None
	WeaponDataArray[8].OptIn = False
	WeaponDataArray[8].FSpeedLv = 0
	

	WeaponDataArray[9] = New WeaponData
	WeaponDataArray[9].expPrimary = MFGAWeaponSkillExplosiveExp
	WeaponDataArray[9].expSecondary = None
	WeaponDataArray[9].skillName1 = MFGAWeaponSkillExplosive
	WeaponDataArray[9].skillName2 = None
	WeaponDataArray[9].skillNameText = "Explosives"
	WeaponDataArray[9].skillNameText2 = None
	WeaponDataArray[9].QuestSkill = MFGA_ExplosionTextReplacementQuest
	WeaponDataArray[9].Level = MFGA_ExplosionLV
	WeaponDataArray[9].Accuracy = MFGA_ExplosionRadius
	WeaponDataArray[9].Damage = MFGA_ExplosionDmg
	WeaponDataArray[9].Reload = None
	WeaponDataArray[9].Critical = None
	WeaponDataArray[9].ExpCurr = MFGA_ExplosionExpCurr
	WeaponDataArray[9].ExpTotal = MFGA_ExplosionExpTotal
	WeaponDataArray[9].AccuracyAV = MFGA_ExplosionRadiusAV
	WeaponDataArray[9].DamageAV = MFGA_ExplosionDmgAV
	WeaponDataArray[9].ReloadAV = None
	WeaponDataArray[9].CriticalAV = None
	WeaponDataArray[9].ReloadSpell = None
	WeaponDataArray[9].DamagePerk = None
	WeaponDataArray[9].OptIn = False
	WeaponDataArray[9].FSpeedLv = 0
	

	WeaponDataArray[10] = New WeaponData
	WeaponDataArray[10].expPrimary = MFGAWeaponSkillBallisticExp
	WeaponDataArray[10].expSecondary = None
	WeaponDataArray[10].skillName1 = MFGAWeaponSkillBallistic
	WeaponDataArray[10].skillName2 = None
	WeaponDataArray[10].skillNameText = "Ballistic Ammo"
	WeaponDataArray[10].skillNameText2 = None
	WeaponDataArray[10].QuestSkill = MFGA_ExplosionTextReplacementQuest
	WeaponDataArray[10].Level = MFGA_BallisticLv
	WeaponDataArray[10].Accuracy = None
	WeaponDataArray[10].Damage = None
	WeaponDataArray[10].Reload = None
	WeaponDataArray[10].Critical = None
	WeaponDataArray[10].ExpCurr = MFGA_BallisticExpCurr
	WeaponDataArray[10].ExpTotal = MFGA_BallisticExpTotal
	WeaponDataArray[10].AccuracyAV = None
	WeaponDataArray[10].DamageAV = None
	WeaponDataArray[10].ReloadAV = None
	WeaponDataArray[10].CriticalAV = None
	WeaponDataArray[10].ReloadSpell = None
	WeaponDataArray[10].DamagePerk = None
	WeaponDataArray[10].OptIn = False
	WeaponDataArray[10].FSpeedLv = 0
	

	WeaponDataArray[11] = New WeaponData
	WeaponDataArray[11].expPrimary = MFGAWeaponSkillPlasmaExp
	WeaponDataArray[11].expSecondary = None
	WeaponDataArray[11].skillName1 = MFGAWeaponSkillPlasma
	WeaponDataArray[11].skillName2 = None
	WeaponDataArray[11].skillNameText = "Plasma Ammo"
	WeaponDataArray[11].skillNameText2 = None
	WeaponDataArray[11].QuestSkill = MFGA_PlasmaTextReplacementQuest
	WeaponDataArray[11].Level = MFGA_PlasmaLV
	WeaponDataArray[11].Accuracy = None
	WeaponDataArray[11].Damage = None
	WeaponDataArray[11].Reload = None
	WeaponDataArray[11].Critical = None
	WeaponDataArray[11].ExpCurr = MFGA_PlasmaExpCurr
	WeaponDataArray[11].ExpTotal = MFGA_PlasmaExpTotal
	WeaponDataArray[11].AccuracyAV = None
	WeaponDataArray[11].DamageAV = None
	WeaponDataArray[11].ReloadAV = None
	WeaponDataArray[11].CriticalAV = None
	WeaponDataArray[11].ReloadSpell = None
	WeaponDataArray[11].DamagePerk = None
	WeaponDataArray[11].OptIn = False
	WeaponDataArray[11].FSpeedLv = 0
	

	WeaponDataArray[12] = New WeaponData
	WeaponDataArray[12].expPrimary = MFGAWeaponSkillLaserExp
	WeaponDataArray[12].expSecondary = None
	WeaponDataArray[12].skillName1 = MFGAWeaponSkillLaser
	WeaponDataArray[12].skillName2 = None
	WeaponDataArray[12].skillNameText = "Laser Ammo"
	WeaponDataArray[12].skillNameText2 = None
	WeaponDataArray[12].QuestSkill = MFGA_LaserTextReplacementQuest
	WeaponDataArray[12].Level = MFGA_LaserLV
	WeaponDataArray[12].Accuracy = MFGA_LaserAcc
	WeaponDataArray[12].Damage = MFGA_LaserDmg
	WeaponDataArray[12].Reload = MFGA_LaserReload
	WeaponDataArray[12].Critical = MFGA_LaserCrit
	WeaponDataArray[12].ExpCurr = MFGA_LaserExpCurr
	WeaponDataArray[12].ExpTotal = MFGA_LaserExpTotal
	WeaponDataArray[12].AccuracyAV = None
	WeaponDataArray[12].DamageAV = None
	WeaponDataArray[12].ReloadAV = None
	WeaponDataArray[12].CriticalAV = None
	WeaponDataArray[12].ReloadSpell = None
	WeaponDataArray[12].DamagePerk = None
	WeaponDataArray[12].OptIn = False
	WeaponDataArray[12].FSpeedLv = 0
	

	;int x = 0
	;while x < 10 
	;	TraceAndNotify("Display Weapon Structs", True)
	;	TraceAndNotify(" " + WeaponDataArray[x].skillNameText + "\n" + WeaponDataArray[x].expPrimary + "\n" + WeaponDataArray[x].expSecondary + "\n" + WeaponDataArray[x].skillname1 + "\n" + WeaponDataArray[x].skillname2 + "\n" + WeaponDataArray[x].skillnameText + "\n" + WeaponDataArray[x].skillnameText2 + "\n" + WeaponDataArray[x].Accuracy + "\n" + WeaponDataArray[x].Critical + "\n" + WeaponDataArray[x].Damage + "\n" + WeaponDataArray[x].Reload + "\n \n", True)
	;	x = x + 1
	;EndWhile		
	

	Debug.Trace("Initializing Ammo Structs...")
	AmmoDataArray = New AmmoData[4]
	
	AmmoDataArray[0] = New AmmoData
	AmmoDataArray[0].expAmmo = MFGAWeaponSkillBallisticExp
	AmmoDataArray[0].skillName = MFGAWeaponSkillBallistic
	AmmoDataArray[0].skillNameText = "Ballistic Ammo"

	AmmoDataArray[1] = New AmmoData
	AmmoDataArray[1].expAmmo = MFGAWeaponSkillPlasmaExp
	AmmoDataArray[1].skillName = MFGAWeaponSkillPlasma
	AmmoDataArray[1].skillNameText = "Plasma Ammo"

	AmmoDataArray[2] = New AmmoData
	AmmoDataArray[2].expAmmo = MFGAWeaponSkillLaserExp
	AmmoDataArray[2].skillName = MFGAWeaponSkillLaser
	AmmoDataArray[2].skillNameText = "Laser Ammo"

	AmmoDataArray[3] = New AmmoData
	AmmoDataArray[3].expAmmo = MFGAWeaponSkillExplosiveExp
	AmmoDataArray[3].skillName = MFGAWeaponSkillExplosive
	AmmoDataArray[3].skillNameText = "Explosive Ammo"
	
	Debug.Trace ("Initialization Complete!")
	GetWeaponType()
	;ModPlayerEquippedWeapon(MFGA_mod_Weapon_Speed_Test, DavyJonesLocker, true)
EndFunction
 


;Attach Point Keywords
Keyword Property MFGA_ap_Gun_FSpeed Auto
keyword Property MFGA_ObjectMod Auto
keyword Property MFGA_ObjectMod_Recoil Auto
keyword Property MFGA_ObjectMod_FSpeed Auto

Weapon Property MFGA_PipeRevolver Auto

ObjectMod Property MFGA_mod_Legendary_Weapon_Speed Auto
ObjectMod Property MFGA_mod_Weapon_Speed_Test Auto
ObjectMod Property MFGA_mod_Weapon_Reload_Test Auto

ActorValue Property WeapReloadSpeedMult Auto
ActorValue Property WeapSpeedMult Auto

;Containers
ObjectReference Property DavyJonesLocker Auto

;Booleans
bool Property isMiniGun Auto Hidden
bool Property isAutomatic Auto Hidden

;Perks
Perk Property MFGASkillPerkDmgPistol Auto

;Spells
Spell Property MFGAAbPerkReloadSpeedAutoRifle Auto
Spell Property MFGAAbPerkReloadSpeedHeavyGun Auto
Spell Property MFGAAbPerkReloadSpeedMissile Auto
Spell Property MFGAAbPerkReloadSpeedPistol Auto
Spell Property MFGAAbPerkReloadSpeedRifle Auto
Spell Property MFGAAbPerkReloadSpeedShotgun Auto
Spell Property MFGAAbPerkReloadSpeedSniperRifle Auto

;Quests
Quest Property MFGA_ARifleTextReplacementQuest Auto
Quest Property MFGA_ExplosionTextReplacementQuest Auto
Quest Property MFGA_HeavyTextReplacementQuest Auto
Quest Property MFGA_PistolTextReplacementQuest Auto  
Quest Property MFGA_RifleTextReplacementQuest Auto  
Quest Property MFGA_ShotgunTextReplacementQuest Auto  
Quest Property MFGA_SniperRifleTextReplacementQuest Auto 
Quest Property MFGA_UnarmedTextReplacementQuest Auto 
Quest Property MFGA_MeleeTextReplacementQuest Auto
Quest Property MFGA_BallisticTextReplacementQuest Auto
Quest Property MFGA_LaserTextReplacementQuest Auto
Quest Property MFGA_PlasmaTextReplacementQuest Auto

;Enemy Type Kill Globals
GlobalVariable Property MFGA_numAnimalsKilled Auto
GlobalVariable Property MFGA_numBugsKilled Auto
GlobalVariable Property MFGA_numDeathclawsKilled Auto
GlobalVariable Property MFGA_numDogsKilled Auto
GlobalVariable Property MFGA_numGhoulsKilled Auto
GlobalVariable Property MFGA_numHumansKilled Auto
GlobalVariable Property MFGA_numMirelurksKilled Auto
GlobalVariable Property MFGA_numMirelurkKingsKilled Auto
GlobalVariable Property MFGA_numMirelurkQueensKilled Auto
GlobalVariable Property MFGA_numRobotsKilled Auto
GlobalVariable Property MFGA_numSuperMutantsKilled Auto
GlobalVariable Property MFGA_numSuperMutantBehemothsKilled Auto
GlobalVariable Property MFGA_numSynthsKilled Auto

GlobalVariable Property MFGA_numAnimalsKilledTotal Auto
GlobalVariable Property MFGA_numBugsKilledTotal Auto
GlobalVariable Property MFGA_numDeathclawsKilledTotal Auto
GlobalVariable Property MFGA_numDogsKilledTotal Auto
GlobalVariable Property MFGA_numGhoulsKilledTotal Auto
GlobalVariable Property MFGA_numHumansKilledTotal Auto
GlobalVariable Property MFGA_numMirelurksKilledTotal Auto
GlobalVariable Property MFGA_numMirelurkKingsKilledTotal Auto
GlobalVariable Property MFGA_numMirelurkQueensKilledTotal Auto
GlobalVariable Property MFGA_numRobotsKilledTotal Auto
GlobalVariable Property MFGA_numSuperMutantsKilledTotal Auto
GlobalVariable Property MFGA_numSuperMutantBehemothsKilledTotal Auto
GlobalVariable Property MFGA_numSynthsKilledTotal Auto


;Text Replacement Globals
GlobalVariable Property MFGA_ARifleLV Auto
GlobalVariable Property MFGA_ARifleAcc Auto
GlobalVariable Property MFGA_ARifleCrit Auto
GlobalVariable Property MFGA_ARifleDmg Auto
GlobalVariable Property MFGA_ARifleReload Auto
GlobalVariable Property MFGA_ARifleExpCurr Auto
GlobalVariable Property MFGA_ARifleExpTotal	 Auto

GlobalVariable Property MFGA_ExplosionLV Auto
GlobalVariable Property MFGA_ExplosionRadius Auto
GlobalVariable Property MFGA_ExplosionDmg Auto
GlobalVariable Property MFGA_ExplosionExpCurr Auto
GlobalVariable Property MFGA_ExplosionExpTotal Auto

GlobalVariable Property MFGA_HeavyLV Auto
GlobalVariable Property MFGA_HeavyAcc Auto
GlobalVariable Property MFGA_HeavyCrit Auto
GlobalVariable Property MFGA_HeavyDmg Auto
GlobalVariable Property MFGA_HeavyReload Auto
GlobalVariable Property MFGA_HeavyExpCurr Auto
GlobalVariable Property MFGA_HeavyExpTotal Auto

GlobalVariable Property MFGA_MeleeLV Auto
GlobalVariable Property MFGA_MeleeDmg Auto
GlobalVariable Property MFGA_MeleeCrit Auto
GlobalVariable Property MFGA_MeleeExpCurr Auto
GlobalVariable Property MFGA_MeleeExpTotal Auto

GlobalVariable Property MFGA_MissileLV Auto
GlobalVariable Property MFGA_MissileAcc Auto
GlobalVariable Property MFGA_MissileCrit Auto
GlobalVariable Property MFGA_MissileDmg Auto
GlobalVariable Property MFGA_MissileReload Auto
GlobalVariable Property MFGA_MissileExpCurr Auto
GlobalVariable Property MFGA_MissileExpTotal Auto

GlobalVariable Property MFGA_PistolLV Auto
GlobalVariable Property MFGA_PistolAcc Auto
GlobalVariable Property MFGA_PistolCrit Auto
GlobalVariable Property MFGA_PistolDmg Auto
GlobalVariable Property MFGA_PistolReload Auto
GlobalVariable Property MFGA_PistolExpCurr Auto
GlobalVariable Property MFGA_PistolExpTotal Auto

GlobalVariable Property MFGA_RifleLV Auto
GlobalVariable Property MFGA_RifleAcc Auto
GlobalVariable Property MFGA_RifleCrit Auto
GlobalVariable Property MFGA_RifleDmg Auto
GlobalVariable Property MFGA_RifleReload Auto
GlobalVariable Property MFGA_RifleExpCurr Auto
GlobalVariable Property MFGA_RifleExpTotal Auto

GlobalVariable Property MFGA_ShotgunLV Auto
GlobalVariable Property MFGA_ShotgunAcc Auto
GlobalVariable Property MFGA_ShotgunCrit Auto
GlobalVariable Property MFGA_ShotgunDmg Auto
GlobalVariable Property MFGA_ShotgunReload Auto
GlobalVariable Property MFGA_ShotgunExpCurr Auto
GlobalVariable Property MFGA_ShotgunExpTotal Auto

GlobalVariable Property MFGA_SniperLV Auto
GlobalVariable Property MFGA_SniperAcc Auto
GlobalVariable Property MFGA_SniperCrit Auto
GlobalVariable Property MFGA_SniperDmg Auto
GlobalVariable Property MFGA_SniperReload Auto
GlobalVariable Property MFGA_SniperExpCurr Auto
GlobalVariable Property MFGA_SniperExpTotal Auto

GlobalVariable Property MFGA_UnarmedLV Auto
GlobalVariable Property MFGA_UnarmedCrit Auto
GlobalVariable Property MFGA_UnarmedDmg Auto
GlobalVariable Property MFGA_UnarmedExpCurr Auto
GlobalVariable Property MFGA_UnarmedExpTotal Auto

GlobalVariable Property MFGA_BallisticLV Auto
GlobalVariable Property MFGA_BallisticExpCurr Auto
GlobalVariable Property MFGA_BallisticExpTotal Auto

GlobalVariable Property MFGA_PlasmaLV Auto
GlobalVariable Property MFGA_PlasmaExpCurr Auto
GlobalVariable Property MFGA_PlasmaExpTotal Auto

GlobalVariable Property MFGA_LaserLV Auto
GlobalVariable Property MFGA_LaserExpCurr Auto
GlobalVariable Property MFGA_LaserExpTotal Auto
GlobalVariable Property MFGA_LaserAcc Auto
GlobalVariable Property MFGA_LaserCrit Auto
GlobalVariable Property MFGA_LaserDmg Auto
GlobalVariable Property MFGA_LaserReload Auto


;Spell/Perk Magnitude Actor Values
ActorValue Property MFGA_ARifleAccAV Auto
ActorValue Property MFGA_ARifleCritAV Auto
ActorValue Property MFGA_ARifleDmgAV Auto
ActorValue Property MFGA_ARifleReloadAV Auto

ActorValue Property MFGA_ExplosionRadiusAV Auto
ActorValue Property MFGA_ExplosionDmgAV Auto

ActorValue Property MFGA_HeavyAccAV Auto
ActorValue Property MFGA_HeavyCritAV Auto
ActorValue Property MFGA_HeavyDmgAV Auto
ActorValue Property MFGA_HeavyReloadAV Auto

ActorValue Property MFGA_MeleeDmgAV Auto
ActorValue Property MFGA_MeleeCritAV Auto

ActorValue Property MFGA_MissileAccAV Auto
ActorValue Property MFGA_MissileDmgAV Auto
ActorValue Property MFGA_MissileCritAV Auto
ActorValue Property MFGA_MissileReloadAV Auto

ActorValue Property MFGA_PistolAccAV Auto
ActorValue Property MFGA_PistolCritAV Auto
ActorValue Property MFGA_PistolDmgAV Auto
ActorValue Property MFGA_PistolReloadAV Auto

ActorValue Property MFGA_RifleAccAV Auto
ActorValue Property MFGA_RifleCritAV Auto
ActorValue Property MFGA_RifleDmgAV Auto
ActorValue Property MFGA_RifleReloadAV Auto

ActorValue Property MFGA_ShotgunAccAV Auto
ActorValue Property MFGA_ShotgunCritAV Auto
ActorValue Property MFGA_ShotgunDmgAV Auto
ActorValue Property MFGA_ShotgunReloadAV Auto

ActorValue Property MFGA_SniperAccAV Auto
ActorValue Property MFGA_SniperCritAV Auto
ActorValue Property MFGA_SniperDmgAV Auto
ActorValue Property MFGA_SniperReloadAV Auto

ActorValue Property MFGA_UnarmedCritAV Auto
ActorValue Property MFGA_UnarmedDmgAV Auto



;Races
Race Property AssaultronRace Auto Const
Race Property BloatflyRace Auto Const
Race Property BloodbugRace Auto Const
Race Property BrahminRace Auto Const
Race Property CatRace Auto Const
Race Property DeathclawRace Auto Const
Race Property EyeBotRace Auto Const
Race Property FeralGhoulGlowingRace Auto Const
Race Property FeralGhoulRace Auto Const
Race Property FEVHoundRace Auto Const
Race Property GhoulRace Auto Const
Race Property GorillaRace Auto Const
Race Property HandyRace Auto Const
Race Property HumanRace Auto Const
Race Property LibertyPrimeRace Auto Const
Race Property MirelurkHunterRace Auto Const
Race Property MirelurkKingRace Auto Const
Race Property MirelurkQueenRace Auto Const
Race Property MirelurkRace Auto Const
Race Property MoleratRace Auto Const
Race Property ProtectronRace Auto Const
Race Property RadRoachRace Auto Const
Race Property RadScorpionRace Auto Const
Race Property RadStagRace Auto Const
Race Property RaiderDogRace Auto Const
Race Property SentryBotRace Auto Const
Race Property StingwingRace Auto Const
Race Property SupermutantBehemothRace Auto Const
Race Property SupermutantRace Auto Const
Race Property SynthGen1Race Auto Const
Race Property SynthGen2Race Auto Const
Race Property TurretBubbleRace Auto Const
Race Property TurretTripodRace Auto Const
Race Property TurretWorkshopRace Auto Const
Race Property VertibirdRace Auto Const
Race Property ViciousDogRace Auto Const
Race Property YaoGuaiRace Auto Const


;Ammo Type Identifiers
Keyword Property WeaponTypeBallistic Auto Const
Keyword Property WeaponTypePlasma Auto Const
Keyword Property WeaponTypeLaser Auto Const
Keyword Property WeaponTypeMelee1H Auto Const
Keyword Property WeaponTypeMelee2H Auto Const
Keyword Property WeaponTypeUnarmed Auto Const

;Weapon Type Identifiers
Keyword Property WeaponTypeAssaultRifle Auto Const ;Probably will be removed
Keyword Property WeaponTypeExplosive Auto Const
Keyword Property WeaponTypeFatman Auto Const
Keyword Property WeaponTypeGatlingLaser Auto Const
Keyword Property WeaponTypeGrenade Auto Const
Keyword Property WeaponTypeMissileLauncher Auto Const
Keyword Property WeaponTypeHeavyGun Auto Const
Keyword Property WeaponTypePistol Auto Const
Keyword Property WeaponTypeRifle Auto Const
Keyword Property WeaponTypeShotgun Auto Const
Keyword Property WeaponTypeSniper Auto Const
Keyword Property HasScope Auto Const ; Prioritize this. More Reliable than 'WeaponTypeSniper'
Keyword Property WeaponTypeAutomatic Auto Const ; Prioritize this. Generally more reliable for automatic weapons ie: SMG is an Automatic 'Rifle'
Keyword Property AnimsMinigun Auto Const

;MFGA WeaponSkill Levels
ActorValue Property MFGAWeaponSkillAssaultRifle Auto Const ;All Automatic Rifles
ActorValue Property MFGAWeaponSkillBallistic Auto Const
ActorValue Property MFGAWeaponSkillExplosive Auto Const
ActorValue Property MFGAWeaponSkillHeavyGun Auto Const
ActorValue Property MFGAWeaponSkillLaser Auto Const
ActorValue Property MFGAWeaponSkillMelee Auto Const
ActorValue Property MFGAWeaponSkillMissileLauncher Auto Const
ActorValue Property MFGAWeaponSkillPistol Auto Const
ActorValue Property MFGAWeaponSkillPlasma Auto Const
ActorValue Property MFGAWeaponSkillRifle Auto Const
ActorValue Property MFGAWeaponSkillShotgun Auto Const
ActorValue Property MFGAWeaponSkillSniper Auto Const
ActorValue Property MFGAWeaponSkillUnarmed Auto Const

;MFGA Weapon Exp Values
ActorValue Property MFGAWeaponSkillAssaultRifleExp Auto Const ;All Automatic Rifles
ActorValue Property MFGAWeaponSkillBallisticExp Auto Const
ActorValue Property MFGAWeaponSkillExplosiveExp Auto Const
ActorValue Property MFGAWeaponSkillHeavyGunExp Auto Const
ActorValue Property MFGAWeaponSkillLaserExp Auto Const
ActorValue Property MFGAWeaponSkillMeleeExp Auto Const
ActorValue Property MFGAWeaponSkillMissileLauncherExp Auto Const
ActorValue Property MFGAWeaponSkillPistolExp Auto Const
ActorValue Property MFGAWeaponSkillPlasmaExp Auto Const
ActorValue Property MFGAWeaponSkillRifleExp Auto Const
ActorValue Property MFGAWeaponSkillShotgunExp Auto Const
ActorValue Property MFGAWeaponSkillSniperExp Auto Const
ActorValue Property MFGAWeaponSkillUnarmedExp Auto Const