Scriptname MFGA_WeaponSkillQuest extends Quest

Actor Player
ActorValue expToIncreaseAmmo
ActorValue expToIncreaseWeapon1
ActorValue expToIncreaseWeapon2
ActorValue relevantSkillAmmo
ActorValue relevantSkillWeapon1
ActorValue relevantSkillWeapon2

float[] diffScaler 

GlobalVariable[] GlobalSkillToIndex
GlobalVariable[] GlobalToCounter 
GlobalVariable[] GlobalTotalToCounter 
int [] ObjectiveUpdate
string[] diffScalerText
bool Property isMiniGun Auto Hidden
bool Property isAutomatic Auto Hidden
bool isLeveling
float baseExpToLvUp
float expScale
bool isMelee

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

Struct WeaponData
	ActorValue expPrimary
	ActorValue expSecondary
	ActorValue skillName1
	ActorValue skillName2
	String skillNameText
	string skillNameText2
	GlobalVariable Accuracy
	GlobalVariable Damage
	GlobalVariable Reload
	GlobalVariable Critical
EndStruct

Struct AmmoData
	ActorValue expAmmo
	ActorValue skillName
	string skillNameText
EndStruct

WeaponData[] WeaponDataArray
AmmoData[] AmmoDataArray

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
GlobalVariable Property MFGA_ARifleAccuracy Auto
GlobalVariable Property MFGA_ARifleCrit Auto
GlobalVariable Property MFGA_ARifleDamage Auto
GlobalVariable Property MFGA_ARifleReload Auto

GlobalVariable Property MFGA_ExplosionRadius Auto
GlobalVariable Property MFGA_ExplosionDamage Auto

GlobalVariable Property MFGA_HeavyAccuracy Auto
GlobalVariable Property MFGA_HeavyCrit Auto
GlobalVariable Property MFGA_HeavyDamage Auto
GlobalVariable Property MFGA_HeavyReload Auto

GlobalVariable Property MFGA_MeleeDamage Auto
GlobalVariable Property MFGA_MeleeCrit Auto

GlobalVariable Property MFGA_PistolAccuracy Auto
GlobalVariable Property MFGA_PistolCrit Auto
GlobalVariable Property MFGA_PistolDamage Auto
GlobalVariable Property MFGA_PistolReload Auto

GlobalVariable Property MFGA_RifleAccuracy Auto
GlobalVariable Property MFGA_RifleCrit Auto
GlobalVariable Property MFGA_RifleDamage Auto
GlobalVariable Property MFGA_RifleReload Auto

GlobalVariable Property MFGA_ShotgunAccuracy Auto
GlobalVariable Property MFGA_ShotgunCrit Auto
GlobalVariable Property MFGA_ShotgunDamage Auto
GlobalVariable Property MFGA_ShotgunReload Auto

GlobalVariable Property MFGA_SniperAccuracy Auto
GlobalVariable Property MFGA_SniperCrit Auto
GlobalVariable Property MFGA_SniperDamage Auto
GlobalVariable Property MFGA_SniperReload Auto


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

Event OnQuestInit()
	Debug.Trace("OnQuestInit()")
	Player = Game.GetPlayer()
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
	ReInit()
EndEvent

Function ReInit() ;Allows the game to reinitialize things if you need to change. OnQuestInit isn't sufficient. Put changes here.
	Debug.Trace("ReInit()")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
	;TraceAndNotify("" + player.GetEquippedWeapon(0) + "currently equipped in slot 1", True)
	;TraceAndNotify("" + player.GetEquippedWeapon(1) + "currently equipped in slot 2", True)
	;TraceAndNotify("" + player.GetEquippedWeapon(2) + "currently equipped in slot 3", True)
	Debug.Trace("Initializing values...")
	;Initialization values
	Debug.Trace("Setting Difficulty Multipliers...")
	diffScaler = New float [7]
    diffScaler[0] = 0.50
    diffScaler[1] = 0.75
    diffScaler[2] = 1.0
    diffScaler[3] = 1.25
    diffScaler[4] = 1.50
    diffScaler[5] = 1.75
    diffScaler[6] = 1.75

    diffScalerText = New string[7]
    diffScalerText[0] = "Very Easy"
    diffScalerText[1] = "Easy"
    diffScalerText[2] = "Normal"
    diffScalerText[3] = "Hard"
    diffScalerText[4] = "Very Hard"
    diffScalerText[5] = "Survival (1)"
    diffScalerText[6] = "Survival (2)"
    TraceAndNotify("Difficulty: " + diffScalerText[Game.GetDifficulty()])

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
	
	
	WeaponDataArray = New WeaponData[10]

	WeaponDataArray[0] = New WeaponData
	WeaponDataArray[0].expPrimary = MFGAWeaponSkillMeleeExp
	WeaponDataArray[0].expSecondary = None
	WeaponDataArray[0].skillName1 = MFGAWeaponSkillMelee
	WeaponDataArray[0].skillName2 = None
	WeaponDataArray[0].skillNameText = "Melee"
	WeaponDataArray[0].skillNameText2 = None
	WeaponDataArray[0].Accuracy = None
	WeaponDataArray[0].Damage = MFGA_MeleeDamage
	WeaponDataArray[0].Reload = None
	WeaponDataArray[0].Critical = MFGA_MeleeCrit

	WeaponDataArray[1] = New WeaponData
	WeaponDataArray[1].expPrimary = MFGAWeaponSkillUnarmedExp
	WeaponDataArray[1].expSecondary = None
	WeaponDataArray[1].skillName1 = MFGAWeaponSkillUnarmed
	WeaponDataArray[1].skillName2 = None
	WeaponDataArray[1].skillNameText = "Unarmed"
	WeaponDataArray[1].skillNameText2 = None
	WeaponDataArray[1].Accuracy = None
	WeaponDataArray[1].Damage = MFGA_UnarmedDamage
	WeaponDataArray[1].Reload = None
	WeaponDataArray[1].Critical = MFGA_UnarmedCrit

	WeaponDataArray[2] = New WeaponData
	WeaponDataArray[2].expPrimary = MFGAWeaponSkillPistolExp
	WeaponDataArray[2].expSecondary = None
	WeaponDataArray[2].skillName1 = MFGAWeaponSkillPistol
	WeaponDataArray[2].skillName2 = None
	WeaponDataArray[2].skillNameText = "Pistol"
	WeaponDataArray[2].skillNameText2 = None
	WeaponDataArray[2].Accuracy = MFGA_PistolAccuracy
	WeaponDataArray[2].Damage = MFGA_PistolDamage
	WeaponDataArray[2].Reload = MFGA_PistolReload
	WeaponDataArray[2].Critical = MFGA_PistolCrit 

	WeaponDataArray[3] = New WeaponData
	WeaponDataArray[3].expPrimary = MFGAWeaponSkillShotgunExp
	WeaponDataArray[3].expSecondary = None
	WeaponDataArray[3].skillName1 = MFGAWeaponSkillShotgun
	WeaponDataArray[3].skillName2 = None
	WeaponDataArray[3].skillNameText = "Shotgun"
	WeaponDataArray[3].skillNameText2 = None
	WeaponDataArray[3].Accuracy = MFGA_ShotgunAccuracy
	WeaponDataArray[3].Damage = MFGA_ShotgunDamage
	WeaponDataArray[3].Reload = MFGA_ShotgunReload
	WeaponDataArray[3].Critical = MFGA_ShotgunCrit

	WeaponDataArray[4] = New WeaponData
	WeaponDataArray[4].expPrimary = MFGAWeaponSkillHeavyGunExp
	WeaponDataArray[4].expSecondary = None
	WeaponDataArray[4].skillName1 = MFGAWeaponSkillHeavyGun
	WeaponDataArray[4].skillName2 = None
	WeaponDataArray[4].skillNameText = "Heavy Guns"
	WeaponDataArray[4].skillNameText2 = None
	WeaponDataArray[4].Accuracy = MFGA_HeavyAccuracy
	WeaponDataArray[4].Damage = MFGA_HeavyDamage
	WeaponDataArray[4].Reload = MFGA_HeavyReload
	WeaponDataArray[4].Critical = MFGA_HeavyCrit

	WeaponDataArray[5] = New WeaponData
	WeaponDataArray[5].expPrimary = MFGAWeaponSkillMissileLauncherExp
	WeaponDataArray[5].expSecondary = MFGAWeaponSkillHeavyGunExp
	WeaponDataArray[5].skillName1 = MFGAWeaponSkillMissileLauncher
	WeaponDataArray[5].skillName2 = MFGAWeaponSkillHeavyGun
	WeaponDataArray[5].skillNameText = "Missile Launcher"
	WeaponDataArray[5].skillNameText2 = "Heavy Guns"
	WeaponDataArray[5].Accuracy = None ;MFGA_ have to populate these
	WeaponDataArray[5].Damage = None ;MFGA_
	WeaponDataArray[5].Reload = None ;MFGA_
	WeaponDataArray[5].Critical = None ;MFGA_

	WeaponDataArray[6] = New WeaponData
	WeaponDataArray[6].expPrimary = MFGAWeaponSkillRifleExp
	WeaponDataArray[6].expSecondary = None
	WeaponDataArray[6].skillName1 = MFGAWeaponSkillRifle
	WeaponDataArray[6].skillName2 = None
	WeaponDataArray[6].skillNameText = "Rifle"
	WeaponDataArray[6].skillNameText2 = None
	WeaponDataArray[6].Accuracy = MFGA_RifleAccuracy
	WeaponDataArray[6].Damage = MFGA_RifleDamage
	WeaponDataArray[6].Reload = MFGA_RifleReload
	WeaponDataArray[6].Critical = MFGA_RifleCrit

	WeaponDataArray[7] = New WeaponData
	WeaponDataArray[7].expPrimary = MFGAWeaponSkillAssaultRifleExp
	WeaponDataArray[7].expSecondary = MFGAWeaponSkillRifleExp
	WeaponDataArray[7].skillName1 = MFGAWeaponSkillAssaultRifle
	WeaponDataArray[7].skillName2 = MFGAWeaponSkillRiflerifle
	WeaponDataArray[7].skillNameText = "Assault Rifle"
	WeaponDataArray[7].skillNameText2 = "Rifle"
	WeaponDataArray[7].Accuracy = MFGA_ARifleAccuracy
	WeaponDataArray[7].Damage = MFGA_ARifleDamage
	WeaponDataArray[7].Reload = MFGA_ARifleReload
	WeaponDataArray[7].Critical = MFGA_ARifleCrit

	WeaponDataArray[8] = New WeaponData
	WeaponDataArray[8].expPrimary = MFGAWeaponSkillSniperExp
	WeaponDataArray[8].expSecondary = MFGAWeaponSkillRifleExp
	WeaponDataArray[8].skillName1 = MFGAWeaponSkillSniper
	WeaponDataArray[8].skillName2 = MFGAWeaponSkillRifle
	WeaponDataArray[8].skillNameText = "Sniper Rifle"
	WeaponDataArray[8].skillNameText2 = "Rifle"
	WeaponDataArray[8].Accuracy = MFGA_SniperAccuracy
	WeaponDataArray[8].Damage = MFGA_SniperDamage
	WeaponDataArray[8].Reload = MFGA_SniperReload
	WeaponDataArray[8].Critical = MFGA_SniperCrit

	WeaponDataArray[9] = New WeaponData
	WeaponDataArray[9].expPrimary = MFGAWeaponSkillExplosiveExp
	WeaponDataArray[9].expSecondary = None
	WeaponDataArray[9].skillName1 = MFGAWeaponSkillExplosive
	WeaponDataArray[9].skillName2 = None
	WeaponDataArray[9].skillNameText = "Explosives"
	WeaponDataArray[9].skillNameText2 = None
	WeaponDataArray[9].Accuracy = MFGA_ExplosionRadius
	WeaponDataArray[9].Damage = MFGA_ExplosionRadius
	WeaponDataArray[9].Reload = None
	WeaponDataArray[9].Critical = None

	int x = 0
	while x < 10 
		TraceAndNotify("Display Weapon Structs", True)
		TraceAndNotify(" " + WeaponDataArray[x].skillNameText + "\n" + WeaponDataArray[x].expPrimary + "\n" + WeaponDataArray[x].expSecondary + "\n" + WeaponDataArray[x].skillname1 + "\n" + WeaponDataArray[x].skillname2 + "\n" + WeaponDataArray[x].skillnameText "\n" + WeaponDataArray[x].skillnameText2  "\n" + WeaponDataArray[x].Accuracy + "\n" + WeaponDataArray[x].Critical + "\n" + WeaponDataArray[x].Damage + "\n" + WeaponDataArray[x].Reload, True)
		x = x + 1
	EndWhile		
	
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
EndFunction

Function IncreaseSkill(float increaseAmount = 1.0, bool isKilled = False, bool isGrenade = False) ;Default value of 1, Default False for Grenades/Explosives
	TraceAndNotify("IncreaseSkill()", True)
	int skillIndexLocal = skillIndex
	int ammoIndexLocal = ammoIndex
	if skillIndexLocal == 9 ;Grenades/Mines/Throwables are a special case
		player.ModValue(WeaponDataArray[skillIndexLocal].expPrimary, increaseAmount)
		TraceAndNotify("Your EXP in " + WeaponDataArray[skillIndexLocal].skillNameText + " increased by " + increaseAmount, True)
		isGrenade = False ;
		LevelUpCheck(WeaponDataArray[skillIndexLocal].skillName1, WeaponDataArray[skillIndexLocal].expPrimary, skillIndexLocal, isKilled)
	else
		Player.ModValue(WeaponDataArray[skillIndexLocal].expPrimary, increaseAmount)
		TraceAndNotify("Your EXP in " + WeaponDataArray[skillIndexLocal].skillNameText + " increased by " + increaseAmount, True)
		LevelUpCheck(WeaponDataArray[skillIndexLocal].skillName1, WeaponDataArray[skillIndexLocal].expPrimary, skillIndexLocal, isKilled)
		if !isMelee ;if it's not a melee weapon, and not an explosive, then it has ammo. Check for ammo.
			Player.ModValue(AmmoDataArray[ammoIndexLocal].expAmmo, (increaseAmount/2))
			bool isAmmo = True
			TraceAndNotify("Your EXP in " + AmmoDataArray[ammoIndexLocal].skillNameText + " increased by " + (increaseAmount/2), True)
			LevelUpCheck(AmmoDataArray[ammoIndexLocal].skillName,AmmoDataArray[ammoIndexLocal].expAmmo, ammoIndexLocal, isKilled, isAmmo)
		EndIf
		if (WeaponDataArray[skillIndexLocal].skillName2)
			Player.ModValue(WeaponDataArray[ammoIndexLocal].expSecondary, (increaseAmount/4))
			TraceAndNotify("Your EXP in " + WeaponDataArray[ammoIndexLocal].skillNameText2 + " increased by " + (increaseAmount/4), True)
			LevelUpCheck(WeaponDataArray[skillIndexLocal].skillName2, WeaponDataArray[skillIndexLocal].expSecondary, skillIndexLocal, isKilled, False, True)
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
	if akBaseObject.HasKeyword(WeaponTypeExplosive) || akBaseObject.HasKeyword(WeaponTypeGrenade)
		if akBaseObject.HasKeyword(WeaponTypeMissileLauncher)
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
	
EndEvent

Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Debug.Trace ("OnItemUnequipped()")	
	if akBaseObject.HasKeyword(WeaponTypeExplosive) || akBaseObject.HasKeyWord(WeaponTypeGrenade)
		if akBaseObject.HasKeyword(WeaponTypeMissileLauncher)
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


Function DisplaySkills()
	TraceAndNotify("DisplaySkills()", True)
	TraceAndNotify("Ballistic EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillBallisticExp)) + "Laser EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillLaserExp)) + "Plasma EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillPlasmaExp)), True)
	TraceAndNotify("AutoRifle EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillAssaultRifleExp)) + "Explosive EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillExplosiveExp)) + "HeavyGun EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillHeavyGunExp)) + "Melee EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillMeleeExp)) + "Missile EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillMissileLauncherExp)) + "Pistol EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillPistolExp)) + "Rifle EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillRifleExp)) + "Shotgun EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillShotgunExp)) + "Sniper EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillSniperExp)) + "Unarmed EXP " + Math.Floor(player.GetValue(MFGAWeaponSkillUnarmedExp)), True)
	Debug.Trace(" EXP " + "")
EndFunction


Function GetWeaponType()
	TraceAndNotify("GetWeaponType()", True)
	skillIndex = None
	ammoIndex = None
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
			ammoIndex = 0
			TraceAndNotify("Weapon uses Ballistic Ammo", True)
		elseif (player.WornHasKeyWord(WeaponTypePlasma))
			ammoIndex = 1
			TraceAndNotify("Weapon uses Plasma Ammo", True)
		elseif player.WornHasKeyWord(WeaponTypeLaser) || player.WornHasKeyword(WeaponTypeGatlingLaser)
			ammoIndex = 2
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
			skillindex = 4
			TraceAndNotify("Player equipped a HeavyGun", True)
		ElseIf (player.WornHasKeyword(WeaponTypeMissileLauncher))
			skillindex = 5 ; missile launcher
			ammoIndex = 3 ;explosive ammo
			TraceAndNotify("Player equipped a Missile Launcher", True)
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
		if akSource.HasKeyWord(WeaponTypeMissileLauncher)
			TraceAndNotify("Enemy was Hit by a Missile", True)
		else
			TraceAndNotify("Enemy was hit by a grenade", True)
			IncreaseSkill(4.0, isKilled, True)
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
	bool isKilled = True
	expGained = BaseExp + (enemyLevel * 1.15) + bonus
	if !enemyHitByPlayer
		Debug.Trace("Enemy Killed by an Assist")
		expGained = expGained/2
	else
		Debug.Trace("Enemy Killed by the Player")
	EndIf
	if causeOfDeath.HasKeyword(WeaponTypeExplosive) || causeOfDeath.HasKeyword(WeaponTypeGrenade) && !causeOfDeath.HasKeyword(WeaponTypeMissileLauncher) ;if an explosive kills, increase explosive exp. But not if its a missile.
		Debug.Trace("Rewarding Exp For Explosion Kill")
		IncreaseSkill(expGained, isKilled, True)
	else
		Debug.Trace("Rewarding Exp For Kill")
		IncreaseSkill(expGained, isKilled, False)
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
	int RaceIndexValue = RaceToIndex.Find(EnemyRace)
	int testRaceIndex = RaceIndexToRaceDataIndex[RaceIndexValue]
	TraceAndNotify("IndexValue of Race = " + RaceIndexValue)
	EnemyKillFunction(RaceIndexValue, 1)
	if testRaceIndex == 6 || testRaceIndex == 7 ;Mirelurk king and queen also increases Mirelurk Total by 3
		EnemyKillFunction(15, 3)
	elseif testRaceIndex == 12
		EnemyKillFunction(35, 6) ;Increment SuperMutants by 6 if a Behemoth Killed
	EndIf
EndFunction

Function EnemyKillFunction (int RaceIndexValue, int killCount = 1)
	RaceData RaceKilled = RaceDataArray[ RaceIndexToRaceDataIndex[RaceIndexValue] ] 
	TraceAndNotify("" + RaceKilled.DisplayText) 
	if ModObjectiveGlobal(killCount, RaceKilled.GlobalID, RaceKilled.ObjectiveID, RaceKilled.Total.Value) 
		SetStage(RaceKilled.ObjectiveID + 5) ;Add Perk If Total is Reached.
	EndIf
	return
EndFunction
	
Function LevelUpCheck (ActorValue skill, ActorValue skillExp, int indexValue, bool isKilled = False, bool isAmmo = False, bool isSecondary = False)
    Debug.Trace("LevelUpCheck()")
    if isLeveling == True
    	Utility.Wait(0.5) ;Wait a Sec To Let Level Up Finish Doing its stuff
    EndIf
    float currSkillLevel = player.GetValue(skill)
    float currSkillExp = player.GetValue(skillExp)
    float expNeededToLevelUp
    
    expNeededToLevelUp = baseExpToLvUp + (expScale * currSkillLevel)
    if currSkillExp >= expNeededToLevelUp
        LevelUp(skill, skillExp, expNeededToLevelUp, indexValue, bool isAmmo, bool isSecondary)
    else 
        if isKilled    
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
    EndIf
EndFunction

Float Function difficultyScaler()
	Debug.Trace("difficultyScaler()")
	;TraceAndNotify("Difficulty: " + diffScalerText[Game.GetDifficulty()])
	return diffScaler[Game.GetDifficulty()]
EndFunction

Float Function LevelUp (ActorValue skill, ActorValue skillExp, float expNeededToLevelUp, int indexValue, bool isAmmo = False, bool isSecondary = False)
	Debug.Trace("LevelUp()")
	isLeveling = True 
	player.ModValue(skill, 1)
	if isAmmo
		TraceAndNotify("You leveled up! You're now Level " + Math.Floor(player.GetValue(skill))  + " in " + AmmoDataArray[indexValue].skillNameText)
		;update quest globals
	elseif isSecondary
		TraceAndNotify("You leveled up! You're now Level " + Math.Floor(player.GetValue(skill))  + " in " + WeaponDataArray[indexValue].skillNameText2)
		;update quest globals
	else 
		TraceAndNotify("You leveled up! You're now Level " + Math.Floor(player.GetValue(skill))  + " in " + WeaponDataArray[indexValue].skillNameText)
		;update quest globals
	EndIf
	float expToSubtract = (-1 * expNeededToLevelUp)
	player.ModValue(skillExp, expToSubtract)
	isLeveling = False
EndFunction

Function UpdateSkillTextReplacement (ActorValue skill, GlobalVariable statToUpdate)

EndFunction