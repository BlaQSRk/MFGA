Scriptname MFGA_WeaponSkillQuest extends Quest

Actor Player ;All hail the God: The Player!

;Debug
;-----------
;GlobalVariable[] GlobalSkillToIndex ;Used for...something? Deprecated probably haha
;GlobalVariable[] GlobalToCounter ;Used for...something? Deprecated probably haha
;GlobalVariable[] GlobalTotalToCounter ;Used for...something? Deprecated probably haha
;int[] ObjectiveUpdate ;Used for...something? Deprecated probably haha
;bool[] ExpQueue
;bool[] ExpQueue2


;Exp and Leveling -------
string[] diffScalerText ;Displays current difficulty level
float[] diffScaler ; Used to lower or increase total exp based on what the difficulty currently is
int gameDifficulty ; script wide gameDifficulty

ObjectMod[] FSpeedMod
int[] HasNoReloadSpell

bool isMelee   ;Bool Set for melee types to optimize code
bool isUnequip ;Bool for if an unequip is happening Probably better to use a state
float baseExpToLvUp ;Starting exp for level 1
float expScale ;How much the exp grows per level ontop of the baseExpToLvUp
int ammoExpModifier  ;Used to lower total exp for ammo Types
int secondaryExpModifier ;Used to lower total exp for secondary weapon growth
float expPerHit

bool[] OptedIn
bool runOnce
float maxLevelUp
int maxLevel ;Use this later to Cap Level Up Function
ActorValue[] NonAccuracyArray
StatGroup[] StatGroupArray


;bool isSecondaryLeveling Deprecated? Originally used to allow more than one type to level at a time. Replaced with leveling states and a queue.

int [] levelUpQueue ; used to hold index values for what weapon will be leveled
int [] skillDisplayQueue ; used to hold index values for what weapon's skills/exp will be displayed
float [] skillLevelSW ;SW stands for Script-Wide
float [] oldExpSW ;SW stands for Script-Wide

int currentLevelingIndex 

Keyword [] WeaponTypeKeywordArray
ActorValue [] WeaponKeywordToAV
ActorValue [] meleeAVArray
Keyword [] AmmoTypeKeywordArray
ActorValue [] AmmoKeywordToAV

int killUpdateTimer
int expUpdateTimer
int [] killCounterQueue
int [] killCounter
int skillIndex
int ammoIndex
string weaponName
string[] skillName 
bool ranOnce = False

int[] KillChallengeLevel
int[] KillChallengeIncrease

;======= Kill Counting and Races
int MirelurkAsInt
int SuperMutantAsInt

Struct RaceData
	int ObjectiveID
	GlobalVariable GlobalID
	GlobalVariable Total
	String DisplayText
EndStruct

Struct StatGroup
	string statName1
	string statName2
	int stageToSet
	int objectiveID
EndStruct

;Struct Addition

Struct WeaponQuestData
	int indexValue 
	int stageToSet 
	int objectiveID 
	GlobalVariable globalStat 
	float amountToIncrement 
	bool firstTime 
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
	float AccuracyMult
	float CriticalMult
	float DamageMult
	float ReloadMult
EndStruct

Struct AmmoData
	ActorValue expAmmo
	ActorValue skillName
	string skillNameText
EndStruct

WeaponData[] WeaponDataArray
AmmoData[] AmmoDataArray

Event OnQuestInit()
	;Runs when the quest first starts which runs on game start. Assigns the player to a variable, and registers them for future loadgames. Then runs initialization via ReInit().
	Debug.Trace("OnQuestInit()")
	Player = Game.GetPlayer()
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
	ReInit()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	;Reinitalizes the data in ReInit() when the game is loaded.
	Debug.Trace ("OnPlayerLoadGame()")
	ReInit()
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	;Once the player equips an item, what item type equipped is determined. If it was just a grenade, we ignore processing as they are handled separately.
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
	;Things to run on combat state changes.
	Debug.Trace("OnCombatStateChanged()")
	if aeCombatState == 0
		;LevelUpCheckAll()
		ExpQueueParser()
	endif
EndEvent

Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	;When items are unequipped, do the same as on equip. Except
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
	Debug.Trace("OnMenuOpenCloseEvent()")
	if (asMenuName == "PipboyMenu")
		if (abOpening)
			;LevelUpCheckAll()
			UpdateQuestExpAll()
		EndIf
	endif
EndEvent



Event OnTimer(int aiTimerID)
	Debug.Trace("OnTimer()")
    if aiTimerID == expUpdateTimer
    	Debug.Trace("expUpdateTimer has finished. Now parsing the queue")
    	ExpQueueParser()
    EndIf
    if aiTimerID == killUpdateTimer
    	Debug.Trace("killUpdateTimer has finished. Now parsing the queue")
    	KillQueueParser()
    EndIf
EndEvent

Function UpdateQuestExp(bool isKilled = False, int i = -1)
	;Goal for this is to update the global values for the weapon's EXP in its quest window. Since globals lag behind the real EXP values
	Debug.Trace("UpdateQuestExp()")
	if i > -1 ;if i is negative, it's not in the group, so skip it.
		if (OptedIn[i]) ;if not Opted In, dont bother updating the quest as it's not even there yet.
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
		if (OptedIn[i])
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
	increaseAmount *= diffScaler[gameDifficulty]; Vary the exp gained based on the difficulty values
	int skillIndexLocal = skillIndex ;turn the script wide into a Local variable for preservation sake (in case the player shoots a bullet, and then switches weapon before it hits)
	int ammoIndexLocal = ammoIndex ;turn the global into a local variable for preservation sake (in case the player shoots a bullet, and then switches weapon before it hits)
	;ActorValue ammoSkill
	if isGrenade ;Grenades/Mines/Throwables are a special case
		skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillExplosive) ;reassign skillIndexLocal as Explosive's num value
		IncrementAndDisplayExpValues(skillIndexLocal, increaseAmount, isKilled) 
		;isGrenade = False
	else;If the weapon is not a grenade, check for the equipped weapon
		IncrementAndDisplayExpValues(skillIndexLocal, increaseAmount, isKilled)
		if !isMelee ;if it's not a melee weapon, and not an explosive, then it has ammo. Check for ammo.
			IncrementAndDisplayExpValues(ammoIndexLocal, (increaseAmount/ammoExpModifier), isKilled)
		EndIf
		if (WeaponDataArray[skillIndexLocal].skillName2) ;Check Secondary Skills
			ActorValue skill2 = WeaponDataArray[skillIndexLocal].skillName2
			skillIndexLocal = WeaponToIndex.Find(skill2)
			IncrementAndDisplayExpValues(skillIndexLocal, (increaseAmount / secondaryExpModifier), isKilled) ;Lower the exp if it's a secondary weapon
		EndIf
	EndIf
	;DisplaySkills()
EndFunction

Function IncrementAndDisplayExpValues(int indexValue, float increaseAmount, bool isKilled) ;display is just for debug purposes
		TraceAndNotify("IncreaseAndDisplayExpValues()", True)
		ActorValue skillExp = WeaponDataArray[indexValue].expPrimary
		string skillText = WeaponDataArray[indexValue].skillNameText ;Remove this call later when the exp is good.
		Player.ModValue(skillExp, increaseAmount) ;Increase EXP on each thread call to Increment, but only check for LevelUp after .4 seconds have passed since the last increment.
		TraceAndNotify("Your EXP in " + skillText + " increased by " + increaseAmount, True)
		TraceAndNotify("Your Total EXP in " + skillText + " is " + player.getvalue(skillExp), True)
		QueueForLevelUpCheck(indexValue) ;Queue this exp value for level up. This allows multiple level up checks while minimizing the number of times it has to be checked. Essentially only focusing on adding exp until ready for a check. 
		StartTimer(0.4, expUpdateTimer)
		Debug.Trace("Timer: expUpdateTimer has started or been reset ")
EndFunction

Function QueueForLevelUpCheck (int indexValue)
	Debug.Trace("QueueForLevelUpCheck()")
	GotoState("busyQueueing")
	TraceAndNotify("Current State: " + GetState(), True)
	if (levelUpQueue.Find(indexValue) < 0) ;If you can't find the indexValue in the queue, add it to the queue
		levelUpQueue.Add(indexValue)
		TraceAndNotify("Adding " + WeaponDataArray[indexValue].skillnameText + " to the queue.", True)
	else
		TraceAndNotify("Failed to add " + WeaponDataArray[indexValue].skillnameText + " to the queue. Reason: Value already in the queue.", True)	
	EndIf
	GoToState("")
EndFunction

State busyQueueing
	Function QueueForLevelUpCheck (int indexValue)
		TraceAndNotify("Current State: " + GetState(), True)
		Utility.Wait(0.35) ;wait a bit so at the very least the first thread value can be set.
		if (levelUpQueue.Find(indexValue) < 0) ;If you can't find the indexValue in the queue, add it to the queue
			levelUpQueue.Add(indexValue)
			TraceAndNotify("Adding " + WeaponDataArray[indexValue].skillnameText + " to the queue.", True)
		else
			TraceAndNotify("Failed to add " + WeaponDataArray[indexValue].skillnameText + " to the queue. Reason: Value already in the queue.", True)	
		EndIf
	EndFunction
EndState

Function ExpQueueParser()
	Debug.Trace("ExpQueueParser()")
	int arrayLength = levelUpQueue.Length
	Debug.Trace("Queue Length = " + arrayLength)
	if arrayLength > 0 
		int indexValue = levelUpQueue[0]
		TraceAndNotify("Attempting to level up " + WeaponDataArray[indexValue].skillnameText + " via the queue.", True)
		levelUpQueue.Remove(0) ;Remove the first element BEFORE you level it up in case level up check has issues
		LevelUpCheck(WeaponDataArray[indexValue].skillName1, WeaponDataArray[indexValue].expPrimary, indexValue, True) ;Was Queued
	EndIf
EndFunction

Function QueueForExpDisplay (int indexValue)
	Debug.Trace("QueueForExpDisplay()")
	if (skillDisplayQueue.Find(indexValue) > -1)
		TraceAndNotify("Failed to add " + WeaponDataArray[indexValue].skillnameText + " to the queue. Reason: Value already in the queue.", True)	
		;GotoState("busyQueueingExpDisplay")
	else
		TraceAndNotify("Current State: " + GetState(), True)
		if (skillDisplayQueue.Find(indexValue) < 0)
			skillDisplayQueue.Add(indexValue)
			TraceAndNotify("Adding " + WeaponDataArray[indexValue].skillnameText + " to the queue.", True)
		endif
	EndIf
	GoToState("")
EndFunction

int [] Function PruneArrayDuplicates (int[] arrayToPrune)
	;Takes in any type array and prunes its duplicates, returning the result as a new array
	Debug.Trace("PruneArrayDuplicates()")
	int [] uniqueElements = new int[0]
	int arrayStartingLength = arrayToPrune.Length ;Debug Line
	int i = 0
	int element
	Debug.Trace("Length of array to prune: " + arrayToPrune.Length)
	while (i < arrayToPrune.Length)
		element = arrayToPrune[i]
		if (uniqueElements.Find(element) == -1)
			uniqueElements.Add(element)
			Debug.Trace("Adding " + element + " to the array")
	;Debug Block Start -----
		else 
			Debug.Trace(element + "wasn't added to the array, it's already in the array") 
		endif
		i += 1
	;Debug Block End -----
	EndWhile
;Debug Block Start -----
	if arrayStartingLength == uniqueElements.Length 
		Debug.Trace("No elements removed from the array") 
	else 
		Debug.Trace("Pruning removed some elements")
		Debug.Trace("New Array is:")
		i = 0
		While (i < uniqueElements.Length)
			Debug.Trace("uniqueElements[" + i + "] = " + uniqueElements[i])
		EndWhile
	endif
;Debug Block End -----
	return uniqueElements
EndFunction

Function ExpDisplayParser ()
	;Parses the array queue of skills to be displayed
	Debug.Trace("ExpQueueParser()")
	PruneArrayDuplicates (skillDisplayQueue)
	int arrayLength = skillDisplayQueue.Length
	WeaponData UpdatingWeapon
	while arrayLength > 0
		Debug.Trace("Queue Length = " + arrayLength)
		int indexValue = skillDisplayQueue[0]
		UpdatingWeapon = WeaponDataArray[indexValue]
		TraceAndNotify("Attempting to Update EXP for " + UpdatingWeapon.skillnameText + " via the queue.", True)
		skillDisplayQueue.Remove(0) ;Remove the current element BEFORE you display it in case level up check has issues. ie: an infinite loop is worse than not displaying the exp :)
    	UpdateExpGlobals(UpdatingWeapon) ;Pass the struct stored to be manipulated
    	Debug.Trace(UpdatingWeapon.skillNameText + " successfully updated!")
    	arrayLength = skillDisplayQueue.Length
    EndWhile
EndFunction

Function UpdateExpGlobals (WeaponData UpdatingWeapon)
	;Updates the Quest Globals For The Queued Weapon And Displays them
	Debug.Trace("UpdateExpGlobals()")
	float currSkillExp
	float currSkillLevel
	float expNeededToLevelUp
	currSkillLevel = player.GetValue(UpdatingWeapon.skillName1) ;Level is needed to calculate exp Neeeded To Level up
    currSkillExp = Math.Floor(player.GetValue(UpdatingWeapon.expPrimary)) ;Current Exp rounded down 
    expNeededToLevelUp = Math.Floor(baseExpToLvUp + (expScale * currSkillLevel)) ;baseExpToLevel is a global, as is expScale. These can be rebalanced, so it's important to know what they are, as they can vary.
	UpdatingWeapon.ExpCurr.SetValue(currSkillExp) ;Update Current EXP Value in the Global stored in 'ExpCurr'
    UpdatingWeapon.ExpTotal.SetValue(expNeededToLevelUp) ;Update Exp Needed to Level Up in the Global stored in 'ExpTotal'
    UpdatingWeapon.QuestSkill.UpdateCurrentInstanceGlobal(UpdatingWeapon.ExpCurr) ;Update Related Quest's Current Exp Global
    UpdatingWeapon.QuestSkill.UpdateCurrentInstanceGlobal(UpdatingWeapon.ExpTotal) ;Update Related Quest's Total Exp Global
    UpdatingWeapon.QuestSkill.SetObjectiveDisplayed(5, true, true) ;Display the Exp Changes
EndFunction

Function UpdateQuestExpParse()
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
		if (OptedIn[i])
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


Function DisplaySkills()
	TraceAndNotify("DisplaySkills()", True)
	TraceAndNotify("Ballistic EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillBallisticExp)) + "Laser EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillLaserExp)) + "Plasma EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillPlasmaExp)), True)
	TraceAndNotify("AutoRifle EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillAssaultRifleExp)) + "Explosive EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillExplosiveExp)) + "HeavyGun EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillHeavyGunExp)) + "Melee EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillMeleeExp)) + "Missile EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillMissileLauncherExp)) + "Pistol EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillPistolExp)) + "Rifle EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillRifleExp)) + "Shotgun EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillShotgunExp)) + "Sniper EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillSniperExp)) + "Unarmed EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillUnarmedExp)), True)
	Debug.Trace(" EXP " + "")
EndFunction

Function GetWeaponType()
	;Checks for what weapon and ammo type are equipped and stores that as the script wide ints: skillIndex and ammoIndex
	Debug.Trace("GetWeaponType()")
	skillIndex = -1 ;Script Wide Variant
	ammoIndex = -1 ;Script Wide Variant
	ActorValue MFGAWeaponSkillAV = None
	ActorValue MFGAWeaponAmmoAV = None 
	int skillIndexLocal = -1
	int ammoIndexLocal = -1
	if player.GetEquippedWeapon() == None ;If no weapon equipped, skip all other processing
		skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillUnarmed) 
	else 
		bool weaponTypeFound = False
		bool isScoped = player.WornHasKeyword(HasScope) ;Scope is necessary to check for sniper rifles and such
		bool isAuto = player.WornHasKeyword(WeaponTypeAutomatic) || player.WornHasKeyword(VATSWeaponLongBurst) ;Automatic Weapons only give EXP once per .35seconds, so they dont level faster than others
		isAutomatic = isAuto ;Script Wide Variant
		MFGAWeaponSkillAV = FindMFGAAV(WeaponTypeKeywordArray, WeaponKeywordToAV)
		skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAV)
		if MFGAWeaponSkillAV != None ;If it cant be identified, don't bother processing further. It's outside of the scope of the mod
			if (meleeAVArray.Find(MFGAWeaponSkillAV) > -1);If it's melee no futher processing needed
			else ;Weapon Specifier
				if MFGAWeaponSkillAV == MFGAWeaponSkillPistol
					;if isAuto
						;skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAutoPistol) ;Not Implemented yet, but later on maybe
					;EndIf
				elseif MFGAWeaponSkillAV == MFGAWeaponSkillHeavyGun ;Find the specific heavy gun equipped 
					weaponTypeFound = player.WornHasKeyword(WeaponTypeMissileLauncher) || player.WornHasKeyword(WeaponTypeFatman) 
					if weaponTypeFound ;If not a missile, then it sets itself as just 'Heavy Gun' when it falls through this if block
						skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillMissileLauncher) ;Only store if it's a missile
						ammoIndexLocal = WeaponToIndex.RFind(MFGAWeaponSkillExplosive) ;Set Explosive as the ammo type
					endif
				elseif MFGAWeaponSkillAV == MFGAWeaponSkillRifle
					if isAuto
						skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAssaultRifle) ;This order is important. Snipers CAN be automatic. But automatics intentionally takes priority.
					elseif isScoped
						skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillSniper)
					EndIf
				EndIf
				;Find Ammo
				if ammoIndexLocal == -1 ;Special case for explosives/missile launchers
					MFGAWeaponAmmoAV = FindMFGAAV(AmmoTypeKeywordArray, AmmoKeywordToAV)
					ammoIndexLocal = WeaponToIndex.RFind(MFGAWeaponAmmoAV)
				EndIf
				ammoIndex = ammoIndexLocal ;set the local as global value	
			EndIf
		EndIf
	Endif
	skillIndex = skillIndexLocal ;set the local as global value	
	player.SetValue(MFGA_WeaponType, skillindex as float) ;Used in Perks in the CK to determine weapon type in a group. Useful for clumping
	player.SetValue(MFGA_AmmoType, ammoIndex as float) ;Used in Perks in the CK to determine weapon type in a group. Useful for clumping
	DisplayResults(skillIndexLocal, ammoIndexLocal) ;Display Results
	TraceAndNotify("WeaponAV: " + player.GetValue(MFGA_WeaponType) + "\n AmmoAV: " + player.GetValue(MFGA_AmmoType))
EndFunction

ActorValue Function FindMFGAAV(Keyword[] ArrayToSearch, ActorValue[] ParralelArray)
	;Searches for a Keyword on the Player from an array, and if Found, searches for a related MFGAActorValue from its Parallel Array inside of 'WeaponToIndex'
	;WeaponToIndex holds the true int values for the specific skill.
	Debug.Trace("FindMFGAAV()")
	int i = 0 
	bool itemTypeFound = False ;for verifying whether was found already
	while ((i < ArrayToSearch.length) && !itemTypeFound) 
		itemTypeFound = player.WornHasKeyword(ArrayToSearch[i]) 
		if itemTypeFound 
			return ParralelArray[i] ;If was found, return the correct parallel value
		EndIf
		i += 1 ;increment counter
	EndWhile
		return None ;If it wasn't found, return None
EndFunction


Function DisplayResults(int skillIndexLocal = -1, int ammoIndexLocal = -1)
	Debug.Trace("DisplayResults()")
	if ammoIndexLocal > -1
		TraceAndNotify("WeaponEquipped: " + WeaponDataArray[skillIndexLocal].skillnameText + "\n AmmoEquipped: " + WeaponDataArray[ammoIndexLocal].skillNameText)
	else 
		TraceAndNotify("WeaponEquipped: " + WeaponDataArray[skillIndexLocal].skillnameText) 
	EndIf
EndFunction


Function DisplayReloadSpeed(int indexValue)
	TraceAndNotify("DisplayReloadSpeed()", True)
	Utility.Wait(0.25)
	TraceAndNotify("" + WeaponDataArray[indexValue].skillNameText + " - ReloadSpeed: " + player.GetValue(WeapReloadSpeedMult)) 
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

Function DisplayValue(string itemName, float value)
	Debug.Trace("DisplayValue()")
	TraceAndNotify("" + itemName + ": " + value, True)
EndFunction

Function DisplayAV(string itemName, ActorValue value )
	Debug.Trace("DisplayAV()")
	TraceAndNotify("" + itemName + ": " + value, True)
EndFunction

Function EnemyKillCounter(Race enemyRace, ActorBase enemyActorBase, bool enemyHitByPlayer) 
	Debug.Trace("EnemyKillCounter()")
	if enemyHitByPlayer ;You have to hit it at least one time to get a kill
		StartTimer(5, killUpdateTimer) ;Give a little time for additional kills so as to concatenate them. Also helps put kills behind level up updates
		Debug.Trace("KillUpdate Timer Started or Reset")
		int RaceIndexValue = RaceToIndex.Find(EnemyRace)
		;TraceAndNotify("IndexValue of Race = " + RaceIndexValue)
		int RaceGroupValue = RaceIndexToRaceDataIndex[RaceIndexValue]
		Debug.Trace("RaceIndexValue: " + RaceIndexValue + "\n RaceGroupValue: " + RaceGroupValue)
		killCounter[RaceGroupValue] += 1
		QueueForKillCheck(RaceGroupValue)
		;/if enemyRace == MirelurkKingRace || enemyRace == MirelurkQueenRace ;Mirelurk king and queen also increases Mirelurk Total by 3
			killCounter[MirelurkAsInt] += 3
			QueueForKillCheck(MirelurkAsInt)
		elseif enemyRace == SupermutantBehemothRace ;Increment SuperMutants by 4 if a Behemoth Killed
			killCounter[SuperMutantAsInt] += 4
			QueueForKillCheck(SuperMutantAsInt)
		EndIf
		/;
		;Needs fixing 
	EndIf
EndFunction

Function QueueForKillCheck(int RaceGroupValue)
	Debug.Trace("QueueForKillCheck()")
	if (killCounterQueue.Find(RaceGroupValue) < 0) ;If you can't find the RaceindexValue in the queue, add it to the queue
		killCounterQueue.Add(RaceGroupValue)
		TraceAndNotify(RaceDataArray[RaceGroupValue].DisplayText + ". Adding it to the queue.", True)
	else
		TraceAndNotify("ERROR: " + RaceDataArray[RaceGroupValue].DisplayText + "But Failed to add to the queue. Reason: Value already in the queue.", True)	
	EndIf
EndFunction
	
Function KillQueueParser()
	Debug.Trace("KillQueueParser()")
	int arrayLength = killCounterQueue.Length
	int RaceGroupValue 
	float currentKillCount
	float totalKillsForObj
	float killsNeeded
	int amountToIncrement
	RaceData RaceKilled
	Debug.Trace("Queue Length = " + arrayLength)
	while arrayLength > 0 
		Debug.Trace("killArrayLength: " + arrayLength)
		RaceGroupValue = killCounterQueue[0]
		RaceKilled = RaceDataArray[RaceGroupValue]
		currentKillCount = RaceKilled.GlobalID.GetValue()
		totalKillsForObj = RaceKilled.Total.GetValue()
		killsNeeded = totalKillsForObj - currentKillCount
		amountToIncrement = Math.Floor(Math.Min(killsNeeded, killCounter[RaceGroupValue]))
		Debug.Trace("RaceGroupValue: " + RaceGroupValue + "\n currentKillCount: " + currentKillCount + "\n totalKillsForObj: " + totalKillsForObj + "\n killsNeeded: " + killsNeeded + "\n amountToIncrement: " + amountToIncrement + "\n killCounter[RaceGroupValue]: " + killCounter[RaceGroupValue])
		killCounter[RaceGroupValue] -= amountToIncrement
		TraceAndNotify("Attempting to increase " + RaceKilled.DisplayText + " via the queue.", True)
		if killCounter[RaceGroupValue] == 0
			Debug.Trace("Removing the first element from the kill queue")
			killCounterQueue.Remove(0) ;Remove the first element once it has exhausted its counter.
		EndIf
		arrayLength = killCounterQueue.Length
		EnemyKillFunction(RaceGroupValue, amountToIncrement)
	EndWhile
EndFunction

;Empty State
Function EnemyKillFunction (int RaceGroupValue, int killCount = 1)
	Debug.Trace("EnemyKillFunction()")
	;Racegroup Value =The numerical value of the group of races bunched together ie: Robot's group includes turrets, automatrons, liberty prime, etc
	RaceData RaceKilled = RaceDataArray[RaceGroupValue] 
	;TraceAndNotify("" + RaceKilled.DisplayText) 
	
	if ModObjectiveGlobal(killCount, RaceKilled.GlobalID, (RaceKilled.ObjectiveID + KillChallengeLevel[RaceGroupValue]), RaceKilled.Total.Value) 
		SetStage(RaceKilled.ObjectiveID + 5) ;Add Perk If Total is Reached.
		Debug.Trace("KillChallengeLevel[RaceGroupValue] = " + KillChallengeLevel[RaceGroupValue])
		KillChallengeLevel[RaceGroupValue] = Math.Floor(Math.Min(KillChallengeLevel[RaceGroupValue] + 1,  4)) ;Clamp Challenge level to 4 (this is important!!!!) 
		;Used to limit Set stage and Objective Ranges ie: Bug Quest Objectives/Stages = 30,31,32,33,34 Bug Perk Stages = 35, 36, 37, 38, 39 . 40 Rolls over into Death Claws
		;Note to self. Change Challenge Increase to a struct similar to RaceData above, and then specify varying amounts for different races. 
		;For example killing 100 Deathclaws is just a ridiculous thing to do. Killing 100 bugs, not so much.
		Debug.Trace("New KillChallengeLevel[RaceGroupValue] = " + KillChallengeLevel[RaceGroupValue])
		float deductCount = RaceKilled.Total.GetValue() * -1
		Debug.Trace("RaceKilled.Total.GetValue() = " + RaceKilled.Total.GetValue())
		Debug.Trace("deductCount = " + deductCount)
		
		UpdateCurrentInstanceGlobal(RaceKilled.Total)
		
		Debug.Trace("RaceKilled.GlobalID = " + RaceKilled.GlobalID.GetValue())
		
		RaceKilled.GlobalID.Mod(deductCount) ;Reset Globals
		UpdateCurrentInstanceGlobal(RaceKilled.Total)
		
		Debug.Trace("New RaceKilled.GlobalID = " + RaceKilled.GlobalID.GetValue())
		
		RaceKilled.Total.Mod(KillChallengeIncrease[KillChallengeLevel[RaceGroupValue]]) ;Increase Globals for next level
		
		Debug.Trace("RaceKilled.Total.GetValue() = " + RaceKilled.Total.GetValue())
		
		UpdateCurrentInstanceGlobal(RaceKilled.Total)
		UpdateCurrentInstanceGlobal(RaceKilled.GlobalID)
		SetObjectiveDisplayed(RaceKilled.ObjectiveID + KillChallengeLevel[RaceGroupValue]) ;Apply new Objectives
		;SetStage(RaceKilled.ObjectiveID + KillChallengeLevel[RaceGroupValue]) ;Apply new Objectives
	EndIf
EndFunction

Function EnemyKillFunctionOld (int RaceIndexValue, int killCount = 1)
	Debug.Trace("EnemyKillFunction()")
	int RaceGroupValue = RaceIndexToRaceDataIndex[RaceIndexValue] ;The numerical value of the group of races bunched together ie: Robot's group includes turrets, automatrons, liberty prime, etc
	RaceData RaceKilled = RaceDataArray[RaceGroupValue] 
	;TraceAndNotify("" + RaceKilled.DisplayText) 
	if ModObjectiveGlobal(killCount, RaceKilled.GlobalID, (RaceKilled.ObjectiveID + KillChallengeLevel[RaceGroupValue]), RaceKilled.Total.Value) 
		SetStage(RaceKilled.ObjectiveID + 5) ;Add Perk If Total is Reached.
		Debug.Trace("KillChallengeLevel[RaceGroupValue] = " + KillChallengeLevel[RaceGroupValue])
		KillChallengeLevel[RaceGroupValue] = Math.Floor(Math.Min(KillChallengeLevel[RaceGroupValue] + 1,  4)) ;Clamp Challenge level to 4 (this is important!!!!) 
		;Used to limit Set stage and Objective Ranges ie: Bug Quest Objectives/Stages = 30,31,32,33,34 Bug Perk Stages = 35, 36, 37, 38, 39 . 40 Rolls over into Death Claws
		;Note to self. Change Challenge Increase to a struct similar to RaceData above, and then specify varying amounts for different races. 
		;For example killing 100 Deathclaws is just a ridiculous thing to do. Killing 100 bugs, not so much.
		Debug.Trace("New KillChallengeLevel[RaceGroupValue] = " + KillChallengeLevel[RaceGroupValue])
		float deductCount = RaceKilled.Total.GetValue() * -1
		Debug.Trace("RaceKilled.Total.GetValue() = " + RaceKilled.Total.GetValue())
		Debug.Trace("deductCount = " + deductCount)
		
		UpdateCurrentInstanceGlobal(RaceKilled.Total)
		
		Debug.Trace("RaceKilled.GlobalID = " + RaceKilled.GlobalID.GetValue())
		
		RaceKilled.GlobalID.Mod(deductCount) ;Reset Globals
		UpdateCurrentInstanceGlobal(RaceKilled.Total)
		
		Debug.Trace("New RaceKilled.GlobalID = " + RaceKilled.GlobalID.GetValue())
		
		RaceKilled.Total.Mod(KillChallengeIncrease[KillChallengeLevel[RaceGroupValue]]) ;Increase Globals for next level
		
		Debug.Trace("RaceKilled.Total.GetValue() = " + RaceKilled.Total.GetValue())
		
		UpdateCurrentInstanceGlobal(RaceKilled.Total)
		UpdateCurrentInstanceGlobal(RaceKilled.GlobalID)
		SetObjectiveDisplayed(RaceKilled.ObjectiveID + KillChallengeLevel[RaceGroupValue]) ;Apply new Objectives
		;SetStage(RaceKilled.ObjectiveID + KillChallengeLevel[RaceGroupValue]) ;Apply new Objectives
	EndIf
EndFunction


Function LevelUpCheckAll()
	TraceAndNotify("LevelUpCheckAll()", True)
	ActorValue skill 
	ActorValue skillExp
	int i = 0
	int weaponArrayLength = WeaponDataArray.Length
	;int ammoArrayLength = AmmoDataArray.Length
	While (i < weaponArrayLength)
		skill = WeaponDataArray[i].skillName1
		skillExp = WeaponDataArray[i].expPrimary
		if player.getvalue(skillExp) >= baseExpToLvUp ;If current exp in this skill is more than the base value then the player is at least level 1
			LevelUpCheck(skill, skillExp, i)
		EndIf
		i+=1
	EndWhile
EndFunction

Function LevelUpCheck (ActorValue skill, ActorValue skillExp, int indexValue, bool isKilled = False, bool isAmmo = False, bool isSecondary = False)
    Debug.Trace("LevelUpCheck()")
    ;UpdateQuestExp(isKilled, indexValue)    
	bool HasLeveled = False
	Debug.Trace("HasLeveled(0) on starting: " + HasLeveled)
	float currSkillLevel = player.GetValue(skill)
	float currSkillExp = player.GetValue(skillExp)
	float expNeededToLevelUp
	expNeededToLevelUp = baseExpToLvUp + (expScale * currSkillLevel)
	TraceAndNotify("\n Skill: " + skill + "\n SkillExp: " + skillExp + "\n indexValue: " + indexValue + "\n isKilled: " + isKilled + "\n isAmmo: " + isAmmo + "\n isSecondary: " + isSecondary + "\n Current Skill Level: " + Math.Floor(currSkillLevel) + "\n Current Skill Exp: " + Math.Floor(currSkillExp) + "\n Exp Needed To LevelUp: " + Math.Floor(expNeededToLevelUp), True )
	Debug.Trace("HasLeveled(1) Before Level Up Check: " + HasLeveled)
	if currSkillExp >= expNeededToLevelUp
        Debug.Trace("HasLeveled(2) After Level UP: " + HasLeveled)
    	HasLeveled = LevelUp(currSkillExp, skill, skillExp, expNeededToLevelUp, indexValue, isAmmo, isSecondary) ;Level Up and Subtract EXP Values but only for the thread that makes it to level up
    	Debug.Trace("Finished Leveling. Displaying Exp, then attempting to level up again.")
        ExpDisplay(skill, skillExp, currSkillExp, expNeededToLevelUp, indexValue, isAmmo, isSecondary) ;Display Exp Amount
        Debug.Trace("HasLeveled(3) After Level UP and setting as True: " + HasLeveled)
	elseif isKilled    
		Debug.Trace("HasLeveled(2) in IsKilled Statement: " + HasLeveled)
    	ExpDisplay(skill, skillExp, currSkillExp, expNeededToLevelUp, indexValue, isAmmo, isSecondary)
    	Debug.Trace("HasLeveled(3) in IsKilled Statement after Exp Display: " + HasLeveled)
	EndIf
	if HasLeveled
		Debug.Trace("Checking for a second level Up.")
		Debug.Trace("HasLeveled(4): Last one" + HasLeveled)
    	LevelUpCheck(skill, skillExp, indexValue, isKilled, isAmmo, isSecondary) ;Check To see if you leveled up more then once
    endif    
    ExpQueueParser()
EndFunction

Float Function difficultyScaler()
	Debug.Trace("difficultyScaler()")
	;TraceAndNotify("Difficulty: " + diffScalerText[Game.GetDifficulty()])
	return diffScaler[Game.GetDifficulty()]
EndFunction

;Empty State
bool Function LevelUp (float currSkillExp, ActorValue skill, ActorValue skillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
	Debug.Trace("LevelUp()")
	TraceAndNotify("Current State: " + GetState(), True)
	GoToState("busyLeveling")
	player.ModValue(skill, 1)
	TraceAndNotify("" + "\n Skill: " + skill + "\n SkillExp: " + skillExp + "\n indexValue: " + indexValue + "\n isAmmo: " + isAmmo + "\n isSecondary: " + isSecondary, True )
	TraceAndNotify("You leveled up! You're now Level " + Math.Floor(player.GetValue(skill))  + " in " + WeaponDataArray[indexValue].skillNameText)
	UpdateStats(skill, indexValue);update quest globals
	SubtractExp(skillExp, expNeededToLevelUp)
	GotoState("")
	return True 
EndFunction

auto State Leveling
	bool Function LevelUp (float currSkillExp, ActorValue skill, ActorValue skillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
		Debug.Trace("LevelUp()")
		TraceAndNotify("Current State: " + GetState(), True)
		GoToState("busyLeveling")
		player.ModValue(skill, 1)
		TraceAndNotify("" + "\n Skill: " + skill + "\n SkillExp: " + skillExp + "\n indexValue: " + indexValue + "\n isAmmo: " + isAmmo + "\n isSecondary: " + isSecondary, True )
		TraceAndNotify("You leveled up! You're now Level " + Math.Floor(player.GetValue(skill))  + " in " + WeaponDataArray[indexValue].skillNameText)
		UpdateStats(skill, indexValue);update quest globals
		SubtractExp(skillExp, expNeededToLevelUp)
		GotoState("Leveling")
		return True 
	EndFunction
EndState

State busyLeveling
	bool Function LevelUp (float currSkillExp, ActorValue skill, ActorValue skillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
		;This is the state when busy leveling
		;Do Nothing, Fam!
		Debug.Trace("LevelUp(): busyLeveling")
		TraceAndNotify("Current State: " + GetState(), True)
		return False
	EndFunction
EndState

Function ExpDisplay(ActorValue skill, ActorValue skillExp, float currSkillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
	Debug.Trace("ExpDisplay()")
	if !(currSkillExp >= expNeededToLevelUp) ;Don't display exp if it's over the value. Just looks weird
           	TraceAndNotify("EXP: " + Math.Floor(currSkillExp) + "/" + Math.Floor(expNeededToLevelUp) + " " + WeaponDataArray[indexValue].skillNameText, True)
    endif
EndFunction

Function SubtractExp(ActorValue skillExp, float expNeededToLevelUp)
	Debug.Trace("SubtractExp()")
	TraceAndNotify("SkillExp: " + skillExp, True)
	TraceAndNotify("expNeededToLevelUp: " + expNeededToLevelUp, True)
	float expToSubtract = 0
	expToSubtract = 0 - expNeededToLevelUp
	Debug.Trace("expToSubtract " + expToSubtract)
	player.ModValue(skillExp, expToSubtract)
EndFunction

Function UpdateQuestValues (int skillLV, int indexValue, int stageToSet, int objectiveID, GlobalVariable globalStat, float amountToIncrement, bool firstTime = False)
	Debug.Trace("UpdateQuestValues()")
	Quest QuestToUpdate = WeaponDataArray[indexValue].QuestSkill
	GlobalVariable skillLevelGlobal = WeaponDataArray[indexValue].Level
	if skillLV >= 5 || skillLV  ;If in the first few Levels, update only that specific stat, otherwise, update all stats
		stageToSet = 0
	EndIf
	QuestToUpdate.ModObjectiveGlobal(amountToIncrement, globalStat, objectiveID) ;Increment the global by it's amount	
	QuestToUpdate.ModObjectiveGlobal(1, skillLevelGlobal , 0) ;increment the Level by 1
	QuestToUpdate.SetStage(stageToSet) ;Update the objectives
EndFunction

Function UpdateStats (ActorValue skill, int indexValue)
	;Figures out what Stat Needs to be updated and then calls functions to update those stats both in their AVs, Quest Values, and Global Values. Also Updates Player Spells.
	Debug.Trace("UpdateStats()")
	int skillLv = Math.Floor(player.GetValue(skill))
	int currentStatAsInt = skillLv % 5 ;Case selection
	int statLV
	float statMult
	ActorValue statAV
	GlobalVariable statGlobal 
	if currentStatAsInt > 0
		statLV = Math.Floor(Math.Min(skillLv / 5 + 1, maxLevelUp))
	else 
		statLV = Math.Floor(Math.Min(skillLv / 5, maxLevelUp))
	EndIf
	if currentStatAsInt == 1 ;Reload Bonus on Level 1, 6, 11, 16, etc
		statMult = WeaponDataArray[indexValue].ReloadMult
		statGlobal = WeaponDataArray[indexValue].Reload
		statAV = WeaponDataArray[indexValue].ReloadAV
		if !(OptedIn[indexValue]) ;Opt the player in to receiving the spell only once
			if WeaponDataArray[indexValue].ReloadSpell ;Check for the existence of a spell first
				player.AddSpell(WeaponDataArray[indexValue].ReloadSpell, false) 
			EndIf
			SetStageQuest(indexValue)
			OptedIn[indexValue] = True ;Opts in even if spell not present. Useful for other things
		EndIf
	elseif currentStatAsInt == 2 ;Accuracy Bonus on Level 2, 7, 12, 17, etc
		statMult = WeaponDataArray[indexValue].AccuracyMult
		statGlobal = WeaponDataArray[indexValue].Accuracy
		statAV = WeaponDataArray[indexValue].AccuracyAV
	elseif currentStatAsInt == 3 ;Damage Bonus on Level 3, 8, 13, 18, etc
		statMult = WeaponDataArray[indexValue].DamageMult
		statGlobal = WeaponDataArray[indexValue].Damage
		statAV = WeaponDataArray[indexValue].DamageAV
	elseif currentStatAsInt == 4 ;Crit Bonus on Level 4, 9, 14, 19, etc		
		statMult = WeaponDataArray[indexValue].CriticalMult
		statGlobal = WeaponDataArray[indexValue].Critical
		statAV = WeaponDataArray[indexValue].CriticalAV
	elseif currentStatAsInt == 0 ;Firing Speed Bonus on Level 5, 10, 15, 20, etc
		;Havent figured out firing speed yet, lol
	EndIf
	AVStatUpdate(currentStatAsInt, statAV, statLV, statMult, indexValue)
	UpdateQuestValues(skillLV, indexValue, StatGroupArray[currentStatAsInt].stageToSet, StatGroupArray[currentStatAsInt].objectiveID, statGlobal, statMult)
	DisplayGlobalsAndAVs(indexValue, currentStatAsInt, statAV, statGlobal) ;Debug Function
	UpdateSpells(indexValue)
EndFunction

Function AVStatUpdate(int currentStatAsInt, ActorValue statToUpdate, float statLV, float statMult, int indexValue)	
	Debug.Trace("AVStatUpdate()")
	if currentStatAsInt == 0
		Debug.Trace("Firing Speed Handled Separately...Escaping")
		;Do Nothing
	elseif currentStatAsInt == 2 ;Accuracy
		Debug.Trace("Attempting to Update Accuracy")
		AccAVStatUpdate(statToUpdate, statLV, statMult, indexValue)
	else ;All other Skills
		Debug.Trace("Attempting to Set AV Value")
		player.SetValue(statToUpdate, statLV * statMult) ;Value of Related Stat will be it's Level * It's Incremental Value per Level. Since this is retroactive it will work for any level and any skill.
	EndIf
	;return GetValue(statToUpdate)
EndFunction

Function AccAVStatUpdate(ActorValue statToUpdate, float statLV, float statMult, int indexValue) ;Acc Done a little differently than the other stats
	Debug.Trace("AVStatUpdate()")
	if WeaponDataArray[indexValue].skillName1 != MFGAWeaponSkillShotgun ;Shotguns don't become 'more accurate' (accuracy/incoming damage reduction is a decrease in value) 
		player.SetValue(statToUpdate, Math.Max(100 - (statLV * statMult), 20)) ;Clamp Damage Reduction/Accuracy
	else 
		player.SetValue(statToUpdate, statMult * statLV)
	EndIf
EndFunction

Function DisplayGlobalsAndAVs(int indexValue, int currentStatAsInt, ActorValue statAV, GlobalVariable statGlobal) 
	Debug.Trace("DisplayGlobalsAndAVs()")
	GlobalVariable skillLevelGlobal = WeaponDataArray[indexValue].Level 
	TraceAndNotify("SkillAV Just Updated: " + statAV, True)
	;TraceAndNotify("IndexValue: " + indexValue)
	TraceAndNotify("Global Value of "  + WeaponDataArray[indexValue].skillnameText + " Skill Level: " + skillLevelGlobal.GetValue(), True)
	TraceAndNotify("Value of "  + WeaponDataArray[indexValue].skillnameText + " " + StatGroupArray[currentStatAsInt].statName1 + " " + "Global: " + statGlobal.GetValue(), True)
	TraceAndNotify("Stat AV Just Updated: " + statAV, True)
	TraceAndNotify("Stat AV Value of "  + WeaponDataArray[indexValue].skillnameText + " " + StatGroupArray[currentStatAsInt].statName1 + ": " + player.GetValue(statAV), True)
EndFunction

Function SetStageQuest(int indexValue)
	TraceAndNotify("SetStageQuest()", True)
	Quest QuestToUpdate = WeaponDataArray[indexValue].QuestSkill
	QuestToUpdate.SetStage(0)
	;Utility.Wait(5)
EndFunction

Function UpdateSpells (int indexValue)
	TraceAndNotify("UpdateSpells()", True)
	if !(HasNoReloadSpell.Find(indexValue) < 0)
		Debug.Trace("" + WeaponDataArray[indexValue].skillNameText + " has no Reload Spell. Escaping...")
	else
		if player.hasspell(WeaponDataArray[indexValue].ReloadSpell) 
			player.RemoveSpell(WeaponDataArray[indexValue].ReloadSpell)	;If the player has the spell, remove it.
		endif
		if player.hasspell(WeaponDataArray[indexValue].ReloadSpell) ;If the spell hasn't been removed yet, wait a while for removal to finish
			Utility.Wait(0.5)
		EndIf
			player.AddSpell(WeaponDataArray[indexValue].ReloadSpell, False) ;Re-Add the spell so it can update its values
		if !player.hasspell(WeaponDataArray[indexValue].ReloadSpell) ;If the spell hasn't been re-added yet, wait a while for it to be added
			Utility.Wait(0.5)
		EndIf
		if player.hasspell(WeaponDataArray[indexValue].ReloadSpell) ;If after waiting, the spell was added. You know it worked.
			;Debug.Notification("Spell for " + WeaponDataArray[indexValue].skillNameText + " has been reset.")
		else 
			;Debug.Notification("Spell for " + WeaponDataArray[indexValue].skillNameText + " wasn't added in time.") ;if spell wasn't added, then there was a waiting issue
		EndIf
		;/if OptedIn[indexValue] ;If Opted in, they have the reload spell as its the first one, but I am paranoid, hence the next line.
		else ;You haven't gotten a level in that weapon yet, so you arent opted in.
			Debug.Notification("You don't have a spell for " + WeaponDataArray[indexValue].skillNameText + " yet.")
		EndIf/;
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
	isUnequip = False
	Debug.Trace("Initializing EXP Values...")
	maxLevel = 30 ;Max Skill Level
	maxLevelUp = 6.0 ;Cyclical Level Ups caps
	expPerHit = 0.25 ;How much exp is gained per hitting an enemy
	baseExpToLvUp = 25 ;Base Exp Needed to Level up
	expScale = 25 ;Exp Increase Per Level
	secondaryExpModifier = 2 ;EXP Gained / SecondaryExpModifier = Secondary Exp Gained. Used for secondary skills: ie Rifle with Assault Rifle.
	ammoExpModifier = 4 ;EXP Gained / AmmoExpModifier = Ammo Exp Gained
	gameDifficulty = Game.GetDifficulty() ;Used for exp multipliers via difficulty (harder = less exp)

	Debug.Trace("Setting Difficulty Multipliers...")
	diffScaler = New float [7] ;EXP Modifiers for difficulty. Multiplies EXP gained by these values ie: ExpGained *= diffScaler[Game.GetDifficulty()]
    diffScaler[0] = 1.50 ;Very Easy
    diffScaler[1] = 1.25 ;Easy
    diffScaler[2] = 1.00 ;Normal
    diffScaler[3] = 0.85 ;Hard
    diffScaler[4] = 0.70 ;V-Hard
    diffScaler[5] = 0.50 ;Survival 1
    diffScaler[6] = 0.50 ;Survival 2

    diffScalerText = New string[7] ;Strings used for difficulty display
    diffScalerText[0] = "Very Easy" 
    diffScalerText[1] = "Easy"
    diffScalerText[2] = "Normal"
    diffScalerText[3] = "Hard"
    diffScalerText[4] = "Very Hard"
    diffScalerText[5] = "Survival (1)"
    diffScalerText[6] = "Survival (2)"
    
    TraceAndNotify("Difficulty: " + diffScalerText[gameDifficulty]) ;Debug display functions
	TraceAndNotify("Difficulty Scaler: " + diffScaler[gameDifficulty]) ;Debug display functions    

    levelUpQueue = New int[0] 
    killCounterQueue = New int[0]

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


	MirelurkAsInt = RaceToIndex.Find(MirelurkRace) ;Used for MirelurkKing/Queen Concatenation
	SuperMutantAsInt = RaceToIndex.Find(SuperMutantRace) ; Used for Behemoth Concatenation, without adding a whole new struct value for it.

	Debug.Trace("Setting Objectives...")
	Debug.Trace("Initializing Global Kill Counter...")
	Debug.Trace("Setting Kill Totals...")



	Debug.Trace("Initializing Weapon Structs...")

	;Used in GetWeaponType()
	;Searches the player's equipped inventory for these keywords in a loop. Then finds the related AV value 
	;Keyword Array used to identify the MFGA type in the parallel array: WeaponKeywordToAV
	WeaponTypeKeywordArray = New Keyword[7] 
	WeaponTypeKeywordArray[0] = WeaponTypeMelee1H 
	WeaponTypeKeywordArray[1] = WeaponTypeMelee2H 
	WeaponTypeKeywordArray[2] = WeaponTypeUnarmed 
	WeaponTypeKeywordArray[3] = WeaponTypePistol 
	WeaponTypeKeywordArray[4] = WeaponTypeShotgun 
	WeaponTypeKeywordArray[5] = WeaponTypeHeavyGun 
	WeaponTypeKeywordArray[6] = WeaponTypeRifle 

	;Used in GetWeaponType()
	;Used alongside the WeaponTypeKeywordArray array  to identify what the related MFGA keyword is
	;Also used to find the integer value of the weapon skill located in the WeaponToIndex Array
	WeaponKeywordToAV = New ActorValue[WeaponTypeKeywordArray.Length] 
	WeaponKeywordToAV[0] = MFGAWeaponSkillMelee
	WeaponKeywordToAV[1] = MFGAWeaponSkillMelee
	WeaponKeywordToAV[2] = MFGAWeaponSkillUnarmed
	WeaponKeywordToAV[3] = MFGAWeaponSkillPistol
	WeaponKeywordToAV[4] = MFGAWeaponSkillShotgun
	WeaponKeywordToAV[5] = MFGAWeaponSkillHeavyGun
	WeaponKeywordToAV[6] = MFGAWeaponSkillRifle

	;Used in GetWeaponType()
	;Used to minimize processing if the weapon is melee. Ie: If it's melee you dont have to check for ammo at all.
	;Also used to find the integer value of the weapon skill located in the WeaponToIndex Array
	meleeAVArray = new ActorValue[2] 
	meleeAVArray[0] = MFGAWeaponSkillMelee
	meleeAVArray[1] = MFGAWeaponSkillUnarmed

	;Used in GetWeaponType()
	;Used to figure out what ammo MFGA AV is used by the weapon in the parallel array: AmmoKeywordToAV
	AmmoTypeKeywordArray = New Keyword[7] 
	AmmoTypeKeywordArray[0] = WeaponTypeBallistic
	AmmoTypeKeywordArray[1] = WeaponTypePlasma
	AmmoTypeKeywordArray[2] = WeaponTypeLaser
	AmmoTypeKeywordArray[3] = WeaponTypeGatlingLaser
	AmmoTypeKeywordArray[4] = WeaponTypeFlamer
	AmmoTypeKeywordArray[5] = WeaponTypeAlienBlaster
	AmmoTypeKeywordArray[6] = WeaponTypeCryolater

	;Used in GetWeaponType()
	;Used as a Parallel Array for AmmoTypeKeywordArray, and also used to find the integer value of ammo located in WeaponToIndex
	AmmoKeywordToAV = New ActorValue[AmmoTypeKeywordArray.Length]
	AmmoKeywordToAV[0] = MFGAWeaponSkillBallistic
	AmmoKeywordToAV[1] = MFGAWeaponSkillPlasma
	AmmoKeywordToAV[2] = MFGAWeaponSkillLaser
	AmmoKeywordToAV[3] = MFGAWeaponSkillLaser 
	AmmoKeywordToAV[4] = MFGAWeaponSkillLaser 
	AmmoKeywordToAV[5] = MFGAWeaponSkillPlasma 
	AmmoKeywordToAV[6] = MFGAWeaponSkillPlasma 
	
	;Used in Many Funtions, but definitely GetWeaponType()
	;Used as an integer value, and also a direct parallel to the weapon struct: WeaponDataArray, used below. Handles many things, very useful.
	;Functions usually find the actor value associated in it, and receieve the parallel integer value in the WeaponDataArray struct, which they can manipulate directly.
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

	;Used by Reload Refresh Function *NEEDS CLARIFICATION*
	;Used to specify which weapons should have their reload spells updated or not.
	;Should be changed so that it instead searches for the value in WeaponToIndex.
	;In reality though, this should be data saved within the struct as a boolean.
	HasNoReloadSpell = New int[6]
	HasNoReloadSpell[0] = 0 ;MFGAWeaponSkillMelee
	HasNoReloadSpell[1] = 1 ;MFGAWeaponSkillUnarmed
	HasNoReloadSpell[2] = 9 ;MFGAWeaponSkillExplosive
	HasNoReloadSpell[3] = 10 ;MFGAWeaponSkillBallistic
	HasNoReloadSpell[4] = 11 ;MFGAWeaponSkillPlasma	 
	HasNoReloadSpell[5] = 12 ;MFGAWeaponSkillLaser

	KillChallengeIncrease = New int [5]
	KillChallengeIncrease[0] = 0
	KillChallengeIncrease[1] = 15
	KillChallengeIncrease[2] = 25
	KillChallengeIncrease[3] = 25
	KillChallengeIncrease[4] = 25

	FSpeedMod = New ObjectMod[6]
	FSpeedMod[0] = None
	FSpeedMod[1] = MFGA_mod_Weapon_Speed_01
	FSpeedMod[2] = MFGA_mod_Weapon_Speed_02
	FSpeedMod[3] = MFGA_mod_Weapon_Speed_03
	FSpeedMod[4] = MFGA_mod_Weapon_Speed_04
	FSpeedMod[5] = MFGA_mod_Weapon_Speed_05

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
	WeaponDataArray[0].Reload = MFGA_MeleeStagger
	WeaponDataArray[0].Critical = MFGA_MeleeCrit
	WeaponDataArray[0].ExpCurr = MFGA_MeleeExpCurr
	WeaponDataArray[0].ExpTotal = MFGA_MeleeExpTotal
	WeaponDataArray[0].AccuracyAV = None
	WeaponDataArray[0].DamageAV = MFGA_MeleeDmgAV
	WeaponDataArray[0].ReloadAV = MFGA_MeleeStaggerAV
	WeaponDataArray[0].CriticalAV = MFGA_MeleeCritAV
	WeaponDataArray[0].ReloadSpell = None
	WeaponDataArray[0].DamagePerk = None
	WeaponDataArray[0].AccuracyMult = 5;Reduce Incoming Damage
	WeaponDataArray[0].CriticalMult = 2;Limb Damage
	WeaponDataArray[0].DamageMult = 10
	WeaponDataArray[0].ReloadMult = 100;Stagger Chance


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
	WeaponDataArray[1].Reload = MFGA_UnarmedStagger
	WeaponDataArray[1].Critical = MFGA_UnarmedCrit
	WeaponDataArray[1].ExpCurr = MFGA_UnarmedExpCurr
	WeaponDataArray[1].ExpTotal = MFGA_UnarmedExpTotal
	WeaponDataArray[1].AccuracyAV = None
	WeaponDataArray[1].DamageAV = MFGA_UnarmedDmgAV
	WeaponDataArray[1].ReloadAV = MFGA_UnarmedStaggerAV
	WeaponDataArray[1].CriticalAV = MFGA_UnarmedCritAV
	WeaponDataArray[1].ReloadSpell = None
	WeaponDataArray[1].DamagePerk = None
	WeaponDataArray[1].AccuracyMult = 5;Reduce Incoming Damage
	WeaponDataArray[1].CriticalMult = 2;Disarm Chance? 
	WeaponDataArray[1].DamageMult = 10
	WeaponDataArray[1].ReloadMult = 10;Stagger Chance


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
	WeaponDataArray[2].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[2].DamagePerk = MFGASkillPerkDmgPistol
	WeaponDataArray[2].AccuracyMult = 5
	WeaponDataArray[2].CriticalMult = 5
	WeaponDataArray[2].DamageMult = 10
	WeaponDataArray[2].ReloadMult = 10


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
	WeaponDataArray[3].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[3].DamagePerk = None
	WeaponDataArray[3].AccuracyMult = 5 
	WeaponDataArray[3].CriticalMult = 5
	WeaponDataArray[3].DamageMult = 10
	WeaponDataArray[3].ReloadMult = 10


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
	WeaponDataArray[4].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[4].DamagePerk = None
	WeaponDataArray[4].AccuracyMult = 5 
	WeaponDataArray[4].CriticalMult = 5
	WeaponDataArray[4].DamageMult = 10
	WeaponDataArray[4].ReloadMult = 10
		

	WeaponDataArray[5] = New WeaponData
	WeaponDataArray[5].expPrimary = MFGAWeaponSkillMissileLauncherExp
	WeaponDataArray[5].expSecondary = MFGAWeaponSkillHeavyGunExp
	WeaponDataArray[5].skillName1 = MFGAWeaponSkillMissileLauncher
	WeaponDataArray[5].skillName2 = MFGAWeaponSkillHeavyGun
	WeaponDataArray[5].skillNameText = "Missile Launcher"
	WeaponDataArray[5].skillNameText2 = "Heavy Guns"
	WeaponDataArray[5].QuestSkill = MFGA_MissileTextReplacementQuest
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
	WeaponDataArray[5].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[5].DamagePerk = None
	WeaponDataArray[5].AccuracyMult = 5
	WeaponDataArray[5].CriticalMult = 5
	WeaponDataArray[5].DamageMult = 10
	WeaponDataArray[5].ReloadMult = 10
	

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
	WeaponDataArray[6].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[6].DamagePerk = None
	WeaponDataArray[6].AccuracyMult = 5 
	WeaponDataArray[6].CriticalMult = 5
	WeaponDataArray[6].DamageMult = 10
	WeaponDataArray[6].ReloadMult = 10

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
	WeaponDataArray[7].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[7].DamagePerk = None
	WeaponDataArray[7].AccuracyMult = 6
	WeaponDataArray[7].CriticalMult = 1 ;Maybe stagger chance instead?
	WeaponDataArray[7].DamageMult = 10
	WeaponDataArray[7].ReloadMult = 10
	

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
	WeaponDataArray[8].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[8].DamagePerk = None
	WeaponDataArray[8].AccuracyMult = 10
	WeaponDataArray[8].CriticalMult = 5
	WeaponDataArray[8].DamageMult = 10 
	WeaponDataArray[8].ReloadMult = 10
	

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
	WeaponDataArray[9].AccuracyMult = 5 
	WeaponDataArray[9].CriticalMult = 5
	WeaponDataArray[9].DamageMult = 6 
	WeaponDataArray[9].ReloadMult = 6

	WeaponDataArray[10] = New WeaponData
	WeaponDataArray[10].expPrimary = MFGAWeaponSkillBallisticExp
	WeaponDataArray[10].expSecondary = None
	WeaponDataArray[10].skillName1 = MFGAWeaponSkillBallistic
	WeaponDataArray[10].skillName2 = None
	WeaponDataArray[10].skillNameText = "Ballistic Ammo"
	WeaponDataArray[10].skillNameText2 = None
	WeaponDataArray[10].QuestSkill = MFGA_BallisticTextReplacementQuest
	WeaponDataArray[10].Level = MFGA_BallisticLv
	WeaponDataArray[10].Accuracy = MFGA_BallisticAcc
	WeaponDataArray[10].Damage = MFGA_BallisticDmg
	WeaponDataArray[10].Reload = MFGA_BallisticReload
	WeaponDataArray[10].Critical = MFGA_BallisticCrit
	WeaponDataArray[10].ExpCurr = MFGA_BallisticExpCurr
	WeaponDataArray[10].ExpTotal = MFGA_BallisticExpTotal
	WeaponDataArray[10].AccuracyAV = MFGA_BallisticAccAV
	WeaponDataArray[10].DamageAV = MFGA_BallisticDmgAV
	WeaponDataArray[10].ReloadAV = MFGA_BallisticReloadAV
	WeaponDataArray[10].CriticalAV = MFGA_BallisticCritAV
	WeaponDataArray[10].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[10].DamagePerk = None
	WeaponDataArray[10].AccuracyMult = 3
	WeaponDataArray[10].CriticalMult = 1
	WeaponDataArray[10].DamageMult = 5
	WeaponDataArray[10].ReloadMult = 8
	

	WeaponDataArray[11] = New WeaponData
	WeaponDataArray[11].expPrimary = MFGAWeaponSkillPlasmaExp
	WeaponDataArray[11].expSecondary = None
	WeaponDataArray[11].skillName1 = MFGAWeaponSkillPlasma
	WeaponDataArray[11].skillName2 = None
	WeaponDataArray[11].skillNameText = "Plasma Ammo"
	WeaponDataArray[11].skillNameText2 = None
	WeaponDataArray[11].QuestSkill = MFGA_PlasmaTextReplacementQuest
	WeaponDataArray[11].Level = MFGA_PlasmaLV
	WeaponDataArray[11].Accuracy = MFGA_PlasmaAcc
	WeaponDataArray[11].Damage = MFGA_PlasmaDmg
	WeaponDataArray[11].Reload = MFGA_PlasmaReload
	WeaponDataArray[11].Critical = MFGA_PlasmaCrit
	WeaponDataArray[11].ExpCurr = MFGA_PlasmaExpCurr
	WeaponDataArray[11].ExpTotal = MFGA_PlasmaExpTotal
	WeaponDataArray[11].AccuracyAV = MFGA_PlasmaAccAV
	WeaponDataArray[11].DamageAV = MFGA_PlasmaDmgAV
	WeaponDataArray[11].ReloadAV = MFGA_PlasmaReloadAV
	WeaponDataArray[11].CriticalAV = MFGA_PlasmaCritAV
	WeaponDataArray[11].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[11].DamagePerk = None
	WeaponDataArray[11].AccuracyMult = 3
	WeaponDataArray[11].CriticalMult = 1
	WeaponDataArray[11].DamageMult = 5
	WeaponDataArray[11].ReloadMult = 8
	

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
	WeaponDataArray[12].AccuracyAV = MFGA_LaserAccAV
	WeaponDataArray[12].DamageAV = MFGA_LaserDmgAV
	WeaponDataArray[12].ReloadAV = MFGA_LaserReloadAV
	WeaponDataArray[12].CriticalAV = MFGA_LaserCritAV
	WeaponDataArray[12].ReloadSpell = MFGAAbPerkReloadSpeed
	WeaponDataArray[12].DamagePerk = None
	WeaponDataArray[12].AccuracyMult = 3 
	WeaponDataArray[12].CriticalMult = 1
	WeaponDataArray[12].DamageMult = 5
	WeaponDataArray[12].ReloadMult = 8

	NonAccuracyArray = New ActorValue[1] ;Weapons Not Affected by accuracy or reduced incoming damage
	NonAccuracyArray[0] = MFGAWeaponSkillShotgun

	StatGroupArray = New StatGroup [5] ;Debug Stat Text Values and Quest Updates

	StatGroupArray[0] = New StatGroup
	StatGroupArray[0].statName1 = "Firing Speed"
	StatGroupArray[0].statName2 = "Stagger Chance"
	StatGroupArray[0].stageToSet = 0
	StatGroupArray[0].objectiveID = 50

	StatGroupArray[1] = New StatGroup
	StatGroupArray[1].statName1 = "Reload Speed"
	StatGroupArray[1].statName2 = "Limb Damage"
	StatGroupArray[1].stageToSet = 10 ;
	StatGroupArray[1].objectiveID = 20
	
	StatGroupArray[2] = New StatGroup
	StatGroupArray[2].statName1 = "Accuracy"
	StatGroupArray[2].statName2 = "Damage Resistance"
	StatGroupArray[2].stageToSet = 20 ;Accuracy
	StatGroupArray[2].objectiveID = 30

	StatGroupArray[3] = New StatGroup
	StatGroupArray[3].statName1 = "Damage"
	StatGroupArray[3].statName2 = "Damage"
	StatGroupArray[3].stageToSet = 30
	StatGroupArray[3].objectiveID = 10

	StatGroupArray[4] = New StatGroup
	StatGroupArray[4].statName1 = "Crit"
	StatGroupArray[4].statName2 = "Crit"
	StatGroupArray[4].stageToSet = 40
	StatGroupArray[4].objectiveID = 40

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
	
	KillCounter = New int [13] ;Monitors number of kills accrued in a short while. Use to minimize flooding of Quest Values, and also to help encourage Kills to appear after Level Up calls and information
	KillCounter[0] = 0
	KillCounter[1] = 0
	KillCounter[2] = 0
	KillCounter[3] = 0
	KillCounter[4] = 0
	KillCounter[5] = 0
	KillCounter[6] = 0
	KillCounter[7] = 0
	KillCounter[8] = 0
	KillCounter[9] = 0
	KillCounter[10] = 0
	KillCounter[11] = 0
	KillCounter[12] = 0

	skillLevelSW = new float [WeaponDataArray.Length] ;Create an array to hold the value of the current level
	oldExpSW = New float [WeaponDataArray.Length] ;Create an array to hold the value of the older exp of each Skill

	UpdateLevelsAndExp()


	Debug.Trace ("Initialization Complete!")
	RunOnce()
	GetWeaponType()
	;ModPlayerEquippedWeapon(MFGA_mod_Weapon_Speed_Test, DavyJonesLocker, true)
EndFunction

Function UpdateLevelsAndExp(int indexValue = -1) ;Run this basically only on reload saves to initialize, else run only on the index values passed to it.
	Debug.Trace("UpdateLevelsAndExp()")
	int i = 0
	string outputText = "Output: \n"
	WeaponData currentSkill
	if indexValue == -1 ;Run this basically only on reload saves to initialize, else run only on the index values passed to it.
		while i < WeaponDataArray.Length
			currentSkill = WeaponDataArray[i]
			outputText += (currentSkill.skillNameText + ":\nOld LV: " + skillLevelSW[i] + " Old Exp: " + oldExpSW[i] + "\n")
			skillLevelSW [i] = currentSkill.Level.GetValue()
			oldExpSW[i] = player.GetValue(currentSkill.expPrimary) 
			outputText += ("New LV: " + skillLevelSW[i] + " New Exp: " + oldExpSW[i] + "\n\n")
			i += 1
		EndWhile
	EndIf
	Debug.Trace(outputText)
EndFunction


int [] Function CreateLevelingQueue()
	Debug.Trace("CreateLevelingQueue()")
	int i = 0
	int[] levelUpCheckQueue = new int[0]
	string outputText = ""
	WeaponData currentSkill
	float currentLevel
	float currentExp
	while i < WeaponDataArray.Length
		bool hasChanged = False 
		currentSkill = WeaponDataArray[i]
		currentLevel = currentSkill.Level.GetValue()
		currentExp = player.GetValue(currentSkill.expPrimary) 
		hasChanged = (skillLevelSW[i] != currentLevel) || (currentExp != oldExpSW[i]) ;If the saved skillLevel or exp values are not the same as current, then it has changed.
		if hasChanged
			levelUpCheckQueue.Add(i)
			outputText += WeaponDataArray[i].skillNameText + "(" + i + ") added to the Queue."
		else
			outputText += WeaponDataArray[i].skillNameText + "(" + i + ") not added to the Queue. Exp Values or level haven't changed"
		EndIf
		i += 1
	EndWhile
	Debug.Trace("" + outputText)
	return levelUpCheckQueue
	;LevelUpCheckQueueParser(CreateLevelingQueue())
EndFunction

Function LevelUpCheckQueueParser(int[] arrayToParse)
	;Function to distribute the jobs to various functions related to this level up check queue
	Debug.Trace("LevelUpCheckQueueParser()")
	int i = 0
	while i < arrayToParse.Length
		;DisplayExp(arrayToParse[i])
		;LevelUpCheck(arrayToParse[i])
	EndWhile
EndFunction

Function RunOnce(bool resetMod = False)
	;These are variables I want to track in the script, but dont want to be reset when the player reloads game.
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

		KillChallengeLevel = New int [13] ;Used to monitor what level each kill enemy group is on. For stage set/objective set purposes. Important that this doesnt get reset, which is why it's in here and not in reinit. 
		;Probably will use globals instead later.
		KillChallengeLevel[0] = 0
		KillChallengeLevel[1] = 0
		KillChallengeLevel[2] = 0
		KillChallengeLevel[3] = 0
		KillChallengeLevel[4] = 0
		KillChallengeLevel[5] = 0
		KillChallengeLevel[6] = 0
		KillChallengeLevel[7] = 0
		KillChallengeLevel[8] = 0
		KillChallengeLevel[9] = 0
		KillChallengeLevel[10] = 0
		KillChallengeLevel[11] = 0
		KillChallengeLevel[12] = 0
				
		ranOnce = True
		Debug.Trace("Booleans Initialized!")
	else
		Debug.Trace("Ran once already or Isnt a Reset Call. Escaping...")
	EndIf
EndFunction

;Attach Point Keywords
Keyword Property MFGA_ap_Gun_FSpeed Auto
Keyword Property MFGA_ObjectMod Auto
Keyword Property MFGA_ObjectMod_Recoil Auto
keyword Property MFGA_ObjectMod_FSpeed Auto

;Testing Items Various/Deprecated
Weapon Property MFGA_PipeRevolver Auto
ObjectMod Property MFGA_mod_Legendary_Weapon_Speed Auto
ObjectMod Property MFGA_mod_Weapon_Speed_Test Auto
ObjectMod Property MFGA_mod_Weapon_Reload_Test Auto

;Reload Nerf Keywords
Keyword Property MFGA_ObjectMod_Reload_Nerf1 Auto


;Object Mods
ObjectMod Property MFGA_mod_Weapon_Speed_01 Auto
ObjectMod Property MFGA_mod_Weapon_Speed_02 Auto
ObjectMod Property MFGA_mod_Weapon_Speed_03 Auto
ObjectMod Property MFGA_mod_Weapon_Speed_04 Auto
ObjectMod Property MFGA_mod_Weapon_Speed_05 Auto


ActorValue Property WeapReloadSpeedMult Auto
ActorValue Property WeapSpeedMult Auto

;Containers
ObjectReference Property DavyJonesLocker Auto

;Booleans
bool Property isMiniGun Auto Hidden
bool Property isAutomatic Auto Hidden

;Perks
Perk Property MFGASkillPerkDmgPistol Auto
Spell Property MFGAAbPerkReloadSpeed  Auto 

;New Actor Values
ActorValue Property MFGA_WeaponType Auto 
ActorValue Property MFGA_AmmoType Auto 

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
Quest Property MFGA_MissileTextReplacementQuest Auto 

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
GlobalVariable Property MFGA_MeleeStagger Auto

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
GlobalVariable Property MFGA_UnarmedStagger Auto

GlobalVariable Property MFGA_BallisticLV Auto
GlobalVariable Property MFGA_BallisticAcc Auto
GlobalVariable Property MFGA_BallisticCrit Auto
GlobalVariable Property MFGA_BallisticDmg Auto
GlobalVariable Property MFGA_BallisticReload Auto
GlobalVariable Property MFGA_BallisticExpCurr Auto
GlobalVariable Property MFGA_BallisticExpTotal Auto

GlobalVariable Property MFGA_PlasmaLV Auto
GlobalVariable Property MFGA_PlasmaAcc Auto
GlobalVariable Property MFGA_PlasmaCrit Auto
GlobalVariable Property MFGA_PlasmaDmg Auto
GlobalVariable Property MFGA_PlasmaReload Auto
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
ActorValue Property MFGA_MeleeStaggerAV Auto

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
ActorValue Property MFGA_UnarmedStaggerAV Auto

ActorValue Property MFGA_BallisticAccAV Auto
ActorValue Property MFGA_BallisticCritAV Auto
ActorValue Property MFGA_BallisticDmgAV Auto
ActorValue Property MFGA_BallisticReloadAV Auto

ActorValue Property MFGA_PlasmaAccAV Auto
ActorValue Property MFGA_PlasmaCritAV Auto
ActorValue Property MFGA_PlasmaDmgAV Auto
ActorValue Property MFGA_PlasmaReloadAV Auto

ActorValue Property MFGA_LaserAccAV Auto
ActorValue Property MFGA_LaserCritAV Auto
ActorValue Property MFGA_LaserDmgAV Auto
ActorValue Property MFGA_LaserReloadAV Auto

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
Keyword Property WeaponTypeFlamer Auto Const
Keyword Property WeaponTypeAlienBlaster Auto Const
Keyword Property WeaponTypeCryolater Auto Const

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
Keyword Property VATSWeaponLongBurst Auto Const

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