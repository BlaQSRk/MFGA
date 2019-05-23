Scriptname MFGA_WeaponSkillQuest extends Quest

Actor Player
ActorValue expToIncreaseAmmo
ActorValue expToIncreaseWeapon1
ActorValue expToIncreaseWeapon2
ActorValue relevantSkillAmmo
ActorValue relevantSkillWeapon1
ActorValue relevantSkillWeapon2

float[] diffScaler 
Race[] RaceToIndex
GlobalVariable[] GlobalSkillToIndex
string[] diffScalerText


GlobalVariable Property MFGA_numAnimalsKilled Auto
GlobalVariable Property MFGA_numBugsKilled Auto
GlobalVariable Property MFGA_numDeathclawsKilled Auto
GlobalVariable Property MFGA_numDogsKilled Auto
GlobalVariable Property MFGA_numGhoulsKilled Auto
GlobalVariable Property MFGA_numHumansKilled Auto
GlobalVariable Property MFGA_numMirelurksKilled Auto
GlobalVariable Property MFGA_numMirelurkKingsKilled Auto
GlobalVariable Property MFGA_numMirelurkQueensKilled Auto
GlobalVariable Property MFGA_numMoleratsKilled Auto
GlobalVariable Property MFGA_numRobotsKilled Auto
GlobalVariable Property MFGA_numSuperMutantsKilled Auto
GlobalVariable Property MFGA_numSuperMutantBehemothKilled Auto
GlobalVariable Property MFGA_numSynthKilled Auto

GlobalVariable Property MFGA_numAnimalsKilledTotal Auto
GlobalVariable Property MFGA_numBugsKilledTotal Auto
GlobalVariable Property MFGA_numDeathclawsKilledTotal Auto
GlobalVariable Property MFGA_numDogsKilledTotal Auto
GlobalVariable Property MFGA_numGhoulsKilledTotal Auto
GlobalVariable Property MFGA_numHumansKilledTotal Auto
GlobalVariable Property MFGA_numMirelurksKilledTotal Auto
GlobalVariable Property MFGA_numMirelurkKingsKilledTotal Auto
GlobalVariable Property MFGA_numMirelurkQueensKilledTotal Auto
GlobalVariable Property MFGA_numMoleratsKilledTotal Auto
GlobalVariable Property MFGA_numRobotsKilledTotal Auto
GlobalVariable Property MFGA_numSuperMutantsKilledTotal Auto
GlobalVariable Property MFGA_numSuperMutantBehemothKilledTotal Auto
GlobalVariable Property MFGA_numSynthKilledTotal Auto


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


;Ammo Types
Keyword Property WeaponTypeBallistic Auto Const
Keyword Property WeaponTypePlasma Auto Const
Keyword Property WeaponTypeLaser Auto Const
Keyword Property WeaponTypeMelee1H Auto Const
Keyword Property WeaponTypeMelee2H Auto Const
Keyword Property WeaponTypeUnarmed Auto Const

;Weapon Types
Keyword Property WeaponTypeAssaultRifle Auto Const ;Probably will be removed
Keyword Property WeaponTypeExplosive Auto Const
Keyword Property WeaponTypeGrenade Auto Const
Keyword Property WeaponTypeMissileLauncher Auto Const
Keyword Property WeaponTypeHeavyGun Auto Const
Keyword Property WeaponTypePistol Auto Const
Keyword Property WeaponTypeRifle Auto Const
Keyword Property WeaponTypeShotgun Auto Const
Keyword Property WeaponTypeSniper Auto Const
Keyword Property HasScope Auto Const ; Prioritize this. More Reliable than 'WeaponTypeSniper'
Keyword Property WeaponTypeAutomatic Auto Const ; Prioritize this. Generally more reliable for automatic weapons ie: SMG is an Automatic 'Rifle'

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

Event OnQuestInit()
	Debug.Trace("OnQuestInit()")
	Player = Game.GetPlayer()
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
	diffScaler[0] = 0.50
	diffScaler[1] = 0.75
	diffScaler[2] = 1.0
	diffScaler[3] = 1.25
	diffScaler[4] = 1.50
	diffScaler[5] = 1.75
	diffScaler[6] = 1.75
	ReInit()
EndEvent

Function ReInit() ;Allows the game to reinitialize things if you need to change. OnQuestInit isn't sufficient. Put changes here.
	Debug.Trace("ReInit()")
	;player.SetValue(MFGAEmptySkill, 0)  Resets this in case it accidentally was modified (Prevents possible crashes)
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
	Utility.Wait(5)
	TraceAndNotify("" + player.GetEquippedWeapon() + "currently equipped in slot 1")
	Utility.Wait(5)
	TraceAndNotify("" + player.GetEquippedWeapon() + "currently equipped in slot 2")
	Utility.Wait(5)
	TraceAndNotify("" + player.GetEquippedWeapon() + "currently equipped in slot 3")

	float[] diffScaler = New Float[7]
    diffScaler[0] = 0.50
    diffScaler[1] = 0.75
    diffScaler[2] = 1.0
    diffScaler[3] = 1.25
    diffScaler[4] = 1.50
    diffScaler[5] = 1.75
    diffScaler[6] = 1.75

    string [] diffScalerText = New string[7]
    diffScalerText[0] = "The Difficulty Is Very Easy"
    diffScalerText[0] = "The Difficulty Is Easy"
    diffScalerText[0] = "The Difficulty Is Normal"
    diffScalerText[0] = "The Difficulty Is Hard"
    diffScalerText[0] = "The Difficulty Is Very Hard"
    diffScalerText[0] = "The Difficulty Is Survival (1)"
    diffScalerText[0] = "The Difficulty Is Survival (2)"
    TraceAndNotify("" + diffScalerText[Game.GetDifficulty])
    return diffScaler[Game.GetDifficulty()]
	
	GetWeaponType()
EndFunction

Function IncreaseSkill(float increaseAmount = 1.0, bool isGrenade = False) ;Default value of 1, Default False for Grenades/Explosives
	TraceAndNotify("IncreaseSkill()", True)
	if isGrenade == True ;Grenades/Mines/Throwables are a special case
		player.ModValue(MFGAWeaponSkillExplosiveExp, increaseAmount)
		TraceAndNotify("Your EXP in " + MFGAWeaponSkillExplosiveExp + " increased by " + increaseAmount, True)
		isGrenade = False ;
		LevelUpCheck(MFGAWeaponSkillExplosive, MFGAWeaponSkillExplosiveExp)
	else
		Player.ModValue(expToIncreaseWeapon1, increaseAmount)
		TraceAndNotify("Your EXP in " + expToIncreaseWeapon1 + " increased by " + increaseAmount, True)
		LevelUpCheck(relevantSkillWeapon1, expToIncreaseWeapon1)
		if expToIncreaseAmmo
			Player.ModValue(expToIncreaseAmmo, (increaseAmount/2))
			TraceAndNotify("Your EXP in " + expToIncreaseAmmo + " increased by " + (increaseAmount/2), True)
			LevelUpCheck(relevantSkillAmmo, expToIncreaseAmmo)
		EndIf
		if expToIncreaseWeapon2
			Player.ModValue(expToIncreaseWeapon2, (increaseAmount/4))
			LevelUpCheck(expToIncreaseWeapon2, relevantSkillWeapon2)
			TraceAndNotify("Your EXP in " + expToIncreaseWeapon2 + " increased by " + (increaseAmount/4), True)
			LevelUpCheck(relevantSkillWeapon2, expToIncreaseWeapon2)
		EndIf
	EndIf
	;DisplaySkills()
EndFunction

Event Actor.OnPlayerLoadGame(Actor akSender)
	Debug.Trace ("OnPlayerLoadGame()")
	ReInit()
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Debug.Trace("OnItemEquipped()")
	TraceAndNotify("" + player.GetEquippedWeapon(0) + "currently equipped in slot 1")
	TraceAndNotify("" + player.GetEquippedWeapon(1) + "currently equipped in slot 2")
	TraceAndNotify("" + player.GetEquippedWeapon(2) + "currently equipped in slot 3")
	if akBaseObject.HasKeyword(WeaponTypeExplosive) || akBaseObject.HasKeyword(WeaponTypeGrenade)
		if akBaseObject.HasKeyword(WeaponTypeMissileLauncher)
			expToIncreaseWeapon1 = MFGAWeaponSkillMissileLauncherExp
			expToIncreaseWeapon2 = MFGAWeaponSkillExplosiveExp
			expToIncreaseAmmo = MFGAWeaponSkillHeavyGunExp
			TraceAndNotify("The player equipped a Missile Launcher", True)
			TraceAndNotify("", True)
		else 
			TraceAndNotify("A grenade or mine was equipped", True)
			;Set Grenade Equip (Though this is probably not even necessary)
		EndIf
	else
		TraceAndNotify("No explosives found, checking for weapon type...", True)
		GetWeaponType()
	EndIf
	
EndEvent

Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Debug.Trace ("OnItemUnequipped()")	
	TraceAndNotify("" + player.GetEquippedWeapon(0) + "currently equipped in slot 1")
	TraceAndNotify("" + player.GetEquippedWeapon(1) + "currently equipped in slot 2")
	TraceAndNotify("" + player.GetEquippedWeapon(2) + "currently equipped in slot 3")
	Utility.Wait(5)
	if akBaseObject.HasKeyword(WeaponTypeExplosive) || akBaseObject.HasKeyWord(WeaponTypeGrenade)
		if akBaseObject.HasKeyword(WeaponTypeMissileLauncher)
			GetWeaponType()
		else 
			TraceAndNotify("A grenade or mine was unequipped", True)
			;Set Grenade Equip (Though this is probably not even necessary). Do nothing
		EndIf
	EndIf
	if player.GetEquippedWeapon() == None
			expToIncreaseWeapon1 = MFGAWeaponSkillUnarmedExp
			expToIncreaseWeapon2 = None
			expToIncreaseAmmo = None
			relevantSkillWeapon1 = MFGAWeaponSkillUnarmed
			TraceAndNotify("Player equipped an Unarmed Weapon", True)	
	EndIf
EndEvent


Function DisplaySkills()
	TraceAndNotify("DisplaySkills()", True)
    TraceAndNotify("AutoRifle EXP " + player.GetValue(MFGAWeaponSkillAssaultRifleExp), True)
	TraceAndNotify("Ballistic EXP " + player.GetValue(MFGAWeaponSkillBallisticExp), True)
	TraceAndNotify("Explosive EXP " + player.GetValue(MFGAWeaponSkillExplosiveExp), True)
	TraceAndNotify("HeavyGun EXP " + player.GetValue(MFGAWeaponSkillHeavyGunExp), True)
	TraceAndNotify("Laser EXP " + player.GetValue(MFGAWeaponSkillLaserExp), True)
	TraceAndNotify("Melee EXP " + player.GetValue(MFGAWeaponSkillMeleeExp), True)
	TraceAndNotify("Missile EXP " + player.GetValue(MFGAWeaponSkillMissileLauncherExp), True)
	TraceAndNotify("Pistol EXP " + player.GetValue(MFGAWeaponSkillPistolExp), True)
	TraceAndNotify("Plasma EXP " + player.GetValue(MFGAWeaponSkillPlasmaExp), True)
	TraceAndNotify("Rifle EXP " + player.GetValue(MFGAWeaponSkillRifleExp), True)
	TraceAndNotify("Shotgun EXP " + player.GetValue(MFGAWeaponSkillShotgunExp), True)
	TraceAndNotify("Sniper EXP " + player.GetValue(MFGAWeaponSkillSniperExp), True)
	TraceAndNotify("Unarmed EXP " + player.GetValue(MFGAWeaponSkillUnarmedExp), True)
	Debug.Trace(" EXP " + "")
EndFunction


Function GetWeaponType()
	TraceAndNotify("GetWeaponType()", True)
	expToIncreaseWeapon1 = None
	expToIncreaseWeapon2 = None
	expToIncreaseAmmo = None
	;Melee Check
	if (player.WornHasKeyWord(WeaponTypeMelee1H) || player.WornHasKeyWord(WeaponTypeMelee2H))
		expToIncreaseWeapon1 = MFGAWeaponSkillMeleeExp
		relevantSkillWeapon1 = MFGAWeaponSkillMelee
		TraceAndNotify("Player equipped a Melee Weapon", True)
	ElseIf (player.WornHasKeyWord(WeaponTypeUnarmed)) || player.GetEquippedWeapon() == None
		expToIncreaseWeapon1 = MFGAWeaponSkillUnarmedExp
		relevantSkillWeapon1 = MFGAWeaponSkillUnarmed
		TraceAndNotify("Player equipped an Unarmed Weapon", True)
	EndIf
	
	;Old Code: (expToIncreaseWeapon1 != MFGAWeaponSkillMelee) || (expToIncreaseWeapon1 = MFGAWeaponSkillUnarmed) 
	if !expToIncreaseWeapon1 ;Don't check for ammo/gun keywords if unarmed/using melee. Save processing
		;Ammotype Check
		if player.WornHasKeyWord(WeaponTypeBallistic)
			expToIncreaseAmmo = MFGAWeaponSkillBallisticExp ; Need to create Ballistic Ammo AV. For future version.
			relevantSkillAmmo = MFGAWeaponSkillBallistic
			TraceAndNotify("Weapon uses Ballistic Ammo", True)
		elseif (player.WornHasKeyWord(WeaponTypePlasma))
			expToIncreaseAmmo = MFGAWeaponSkillPlasmaExp
			relevantSkillAmmo = MFGAWeaponSkillPlasma
			TraceAndNotify("Weapon uses Plasma Ammo", True)
		elseif (player.WornHasKeyWord(WeaponTypeLaser))
			expToIncreaseAmmo = MFGAWeaponSkillLaserExp
			relevantSkillAmmo = MFGAWeaponSkillLaser
			TraceAndNotify("Weapon uses Laser Ammo", True)
		EndIf

		;Weapon type check
		If (player.WornHasKeyWord(WeaponTypePistol))
			expToIncreaseWeapon1 = MFGAWeaponSkillPistolExp
			relevantSkillWeapon1 = MFGAWeaponSkillPistol
			TraceAndNotify("Player equipped a Pistol", True)
		elseIf (player.WornHasKeyword(WeaponTypeShotgun))
			expToIncreaseWeapon1 = MFGAWeaponSkillShotgunExp
			relevantSkillWeapon1 = MFGAWeaponSkillShotgun
			TraceAndNotify("Player equipped a Shotgun", True)
		ElseIf (player.WornHasKeyword(WeaponTypeHeavyGun))
			expToIncreaseWeapon1 = MFGAWeaponSkillHeavyGunExp
			relevantSkillWeapon1 = MFGAWeaponSkillHeavyGun
			TraceAndNotify("Player equipped a HeavyGun", True)
		ElseIf (player.WornHasKeyword(WeaponTypeMissileLauncher))
			expToIncreaseWeapon1 = MFGAWeaponSkillMissileLauncherExp
			expToIncreaseWeapon2 = MFGAWeaponSkillHeavyGunExp
			expToIncreaseAmmo = MFGAWeaponSkillExplosiveExp
			relevantSkillWeapon1 = MFGAWeaponSkillMissileLauncher
			relevantSkillWeapon2 = MFGAWeaponSkillHeavyGun
			relevantSkillAmmo = MFGAWeaponSkillExplosive
			TraceAndNotify("Player equipped a Missile Launcher", True)
		elseif (player.WornHasKeyWord(WeaponTypeRifle))
			if (player.WornHasKeyWord(WeaponTypeAutomatic))
				expToIncreaseWeapon1 = MFGAWeaponSkillAssaultRifleExp
				expToIncreaseWeapon2 = MFGAWeaponSkillRifleExp
				relevantSkillWeapon1 = MFGAWeaponSkillAssaultRifle
				relevantSkillWeapon2 = MFGAWeaponSkillRifle
				TraceAndNotify("Player equipped an Automatic Rifle", True)
			elseif (player.WornHasKeyWord(HasScope))
				expToIncreaseWeapon1 = MFGAWeaponSkillSniperExp
				expToIncreaseWeapon2 = MFGAWeaponSkillRifleExp
				relevantSkillWeapon1 = MFGAWeaponSkillSniper
				relevantSkillWeapon2 = MFGAWeaponSkillRifle
				TraceAndNotify("Player equipped a Sniper Rifle", True)
			else 
				expToIncreaseWeapon1 = MFGAWeaponSkillRifleExp
				relevantSkillWeapon1 = MFGAWeaponSkillRifle
				TraceAndNotify("Player equipped a Normal Rifle", True)
			EndIf 
		else 
			expToIncreaseWeapon1 = MFGAWeaponSkillUnarmed ; If 
			TraceAndNotify("Test fell through the list, so must be 'truly' Unarmed", True) ;Fists don't have a "type" for some reason.
		EndIf

	EndIf
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
	if akSource.HasKeyword(WeaponTypeExplosive) || akSource.haskeyword(WeaponTypeGrenade)
		if akSource.HasKeyWord(WeaponTypeMissileLauncher)
			TraceAndNotify("Enemy was Hit by a Missile", True)
		else
			TraceAndNotify("Enemy was hit by a grenade", True)
			IncreaseSkill(1.0, True)
		EndIf
	else
		IncreaseSkill(1.0)
	endif
EndFunction

Function EnemyKillReward(int enemyLevel, ActorBase enemyActorBase, form causeOfDeath, bool enemyHitByPlayer = True)
	TraceAndNotify("EnemyKillReward()", True)
	Debug.Trace("Enemy ActorBase " + enemyActorBase)
	Int baseExp = 4
	float expGained
	int playerLevel = player.GetLevel()
	float bonus = Math.Max((Math.Min(EnemyLevel - playerLevel, 6)),-3)  * 0.2 * Math.Min(enemyLevel, 25) 
	expGained = BaseExp + (enemyLevel * 1.15) + bonus
	if !enemyHitByPlayer
		Debug.Trace("Enemy Killed by an Assist")
		expGained = expGained/2
	else
		Debug.Trace("Enemy Killed by the Player")
	EndIf
	if causeOfDeath.HasKeyword(WeaponTypeExplosive) || causeOfDeath.HasKeyword(WeaponTypeGrenade) && !causeOfDeath.HasKeyword(WeaponTypeMissileLauncher) ;if an explosive kills, increase explosive exp. But not if its a missile.
		Debug.Trace("Rewarding Exp For Explosion Kill")
		IncreaseSkill(expGained, True)
	else
		Debug.Trace("Rewarding Exp For Kill")
		IncreaseSkill(expGained)
	EndIf
EndFunction
	
Function TraceAndNotify(string msg, bool TraceOnly = false)
    Debug.Trace(msg)
    if !TraceOnly
        Debug.Notification(msg)
    EndIf
EndFunction

Function EnemyKillCounter(Race enemyRace, ActorBase enemyActorBase) 
	Debug.Trace("EnemyKillCounter()")
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

	GlobalVariable[] GlobalToCounter = New Int[14]

	GlobalToCounter[0] = MFGA_numAnimalsKilled
	GlobalToCounter[1] = MFGA_numBugsKilled
	GlobalToCounter[2] = MFGA_numDeathclawsKilled
	GlobalToCounter[3] = MFGA_numDogsKilled
	GlobalToCounter[4] = MFGA_numGhoulsKilled
	GlobalToCounter[5] = MFGA_numHumansKilled
	GlobalToCounter[6] = MFGA_numMirelurksKilled
	GlobalToCounter[7] = MFGA_numMirelurkKingsKilled
	GlobalToCounter[8] = MFGA_numMirelurkQueensKilled
	GlobalToCounter[9] = MFGA_numMoleratsKilled
	GlobalToCounter[10] = MFGA_numRobotsKilled
	GlobalToCounter[11] = MFGA_numSuperMutantsKilled
	GlobalToCounter[12] = MFGA_numSuperMutantBehemothKilled
	GlobalToCounter[13] = MFGA_numSynthKilled

	GlobalToCounter[RaceToIndex.Find(EnemyRace)]

	
	
	{if enemyRace == HumanRace || enemyRace == GhoulRace
		numHumansKilled +=1
		if ModObjectiveGlobal(1, MFGA_numHumansKilled, 10, MFGA_numHumansKilledTotal.Value)
			SetStage(20)
		endif
		TraceAndNotify("You Killed a Human. " + numHumansKilled + " killed so far.")
	elseif enemyRace == MoleRatRace || enemyRace == YaoGuaiRace || enemyRace == RadStagRace || enemyRace == BrahminRace || enemyRace == CatRace
		numAnimalsKilled += 1
		TraceAndNotify("You Killed an Animal. " + numAnimalsKilled + " killed so far.")
	elseif enemyRace == BloatflyRace || enemyRace == BloodbugRace || enemyRace == RadRoachRace || enemyRace == RadScorpionRace || enemyRace == StingwingRace
		numBugsKilled += 1
		TraceAndNotify("You Killed a Bug. " + numBugsKilled + " killed so far.")
	elseif enemyRace == DeathclawRace
		numDeathclawsKilled += 1
		TraceAndNotify("You Killed a Deathclaw. " + numDeathclawsKilled + " killed so far.")
	elseif enemyRace == FeralGhoulRace || enemyRace == FeralGhoulGlowingRace
		numGhoulsKilled += 1
		TraceAndNotify("You Killed a Ghoul. " + numGhoulsKilled + " killed so far.")
	elseif enemyRace == MirelurkHunterRace || enemyRace == MirelurkRace
		if enemyRace == MirelurkKingRace
			numMirelurksKilled += 1
			numMirelurkKingsKilled += 1
			TraceAndNotify("You Killed a Mirelurk King "  + numMirelurkKingsKilled + " killed so far.")
			TraceAndNotify(""  + numMirelurksKilled + " Mirelurks killed so far.")
		elseif enemyRace == MirelurkQueenRace
			numMirelurksKilled += 1
			numMirelurkQueensKilled += 1
			TraceAndNotify("You Killed a Mirelurk Queen. "  + numMirelurkQueensKilled + " killed so far.")
			TraceAndNotify(""  + numMirelurksKilled + " Mirelurks killed so far.")
		else 
			numMirelurksKilled += 1
			TraceAndNotify("You Killed a Mirelurk"  + numMirelurksKilled + " killed so far.")
		EndIf
	elseif enemyRace == FEVHoundRace || enemyRace == RaiderDogRace || enemyRace == ViciousDogRace
		numDogsKilled += 1
		TraceAndNotify("You Killed a Dog... You asshole. " + numDogsKilled + " killed so far.")
	elseif enemyRace == AssaultronRace || enemyRace == EyeBotRace || enemyRace == HandyRace || enemyRace == LibertyPrimeRace || enemyRace == ProtectronRace || enemyRace == SentryBotRace || enemyRace == TurretBubbleRace || enemyRace == TurretWorkshopRace || enemyRace == TurretTripodRace || enemyRace == VertibirdRace
		numRobotsKilled +=1
		TraceAndNotify("You Killed a Robot. "  + numRobotsKilled + " killed so far.")
	elseif enemyRace == SupermutantRace
		numSuperMutantsKilled += 1
		TraceAndNotify ("You killed " + numSuperMutantsKilled + " Super Mutants so far")
	elseif enemyRace == SupermutantBehemothRace
		numSuperMutantsKilled += 1
		numSuperMutantBehemothKilled +=1
		TraceAndNotify("You Killed a Behemoth"  + numSuperMutantBehemothKilled + " killed so far.")
		TraceAndNotify("You also killed " + numSuperMutantsKilled + " Super Mutant so far")
	elseif enemyRace == SynthGen1Race || enemyRace == SynthGen2Race || enemyRace == GorillaRace
		numSynthKilled +=1
		TraceAndNotify("You Killed a Synth"  + numSynthKilled + " killed so far.")
	else
		TraceAndNotify ("Enemy classification failed")
	Endif}
EndFunction

enemyRace = 

Function LevelUpCheck (ActorValue skill, ActorValue skillExp)
	Debug.Trace("LevelUpCheck()")
	float currSkillLevel = player.GetValue(skill)
	float currSkillExp = player.GetValue(skillExp)
	float expNeededToLevelUp
	float baseExpToLvUp = 200
	float extraExp = 75
	float currentExp
	expNeededToLevelUp = (currSkillLevel + 1) * (baseExpToLvUp * difficultyScaler()) + (extraExp * currSkillLevel)
	TraceAndNotify ("You need "+ expNeededToLevelUp + " EXP to level up")
	Utility.Wait(3)
	TraceAndNotify ("Your current level in "+ skill + " is " + currSkillLevel)
	Utility.Wait(3)
	TraceAndNotify ("Your current EXP in "+ skillExp + " is " + currSkillExp)
EndFunction

Float Function difficultyScaler()
	Debug.Trace("difficultyScaler()")
	diffScaler = New Float[7]
	diffScaler[0] = 0.50
	diffScaler[1] = 0.75
	diffScaler[2] = 1.0
	diffScaler[3] = 1.25
	diffScaler[4] = 1.50
	diffScaler[5] = 1.75
	diffScaler[6] = 1.75

	string [] diffScalerText = New string[7]
	diffScalerText[0] = "The Difficulty Is Very Easy"
	diffScalerText[1] = "The Difficulty Is Easy"
	diffScalerText[2] = "The Difficulty Is Normal"
	diffScalerText[3] = "The Difficulty Is Hard"
	diffScalerText[4] = "The Difficulty Is Very Hard"
	diffScalerText[5] = "The Difficulty Is Survival (1)"
	diffScalerText[6] = "The Difficulty Is Survival (2)"
	TraceAndNotify("" + diffScalerText[Game.GetDifficulty])

	return diffScaler[Game.GetDifficulty()]
EndFunction
