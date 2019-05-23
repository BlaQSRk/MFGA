Struct WeaponData 
	ActorValue expPrimary
	ActorValue expPrimary
	ActorValue expSecondary
	ActorValue skillLevel1
	ActorValue skillLevel2
	String skillLabel1
	string skillLabel2
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
	int SkillType
	Spell ReloadSpell
	Perk DamagePerk
	float AccuracyMult
	float CriticalMult
	float DamageMult
	float ReloadMult
EndStruct

;Ammo Type Identifiers
Keyword Property WeaponTypeBallistic Auto Const
Keyword Property WeaponTypePlasma Auto Const
Keyword Property WeaponTypeLaser Auto Const
Keyword Property WeaponTypeExplosive Auto Const

;WeaponType Keyword Identifiers
Keyword Property WeaponTypeMelee1H Auto Const
Keyword Property WeaponTypeMelee2H Auto Const
Keyword Property WeaponTypeUnarmed Auto Const
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

WeaponDataArray

Keyword[] meleeArray

WeaponKeyword = New Keyword[]
WeaponKeyword[0] = WeaponTypeMelee1H
WeaponKeyword[1] = WeaponTypeMelee2H
WeaponKeyword[2] = WeaponTypeUnarmed
WeaponKeyword[3] = 
WeaponKeyword[4] = 
WeaponKeyword[5] = 
WeaponKeyword[6] = 
WeaponKeyword[7] = 
WeaponKeyword[8] = 

WeaponKeywordToIndex = New Int[WeaponKeyword.Length]

i = 0 
while i < WeaponKeywordToIndex.Length
	WeaponKeyword[i]
	WeaponKeywordToIndex[i] 

Function GetWeaponInfo()
	;Checks for what weapon and ammo type are equipped and stores that as a Script-wide Int
	;
	skillIndex = -1
	ammoIndex = -1
	ActorValue MFGAWeaponSkillAV
	if player.GetEquippedWeapon() == None ;If no weapon equipped, skip all other processing
		skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillUnarmed) 
	else 
		bool isScoped = player.WornHasKeyword(HasScope) ;Scope is necessary to check for sniper rifles and such
		bool isAuto = player.WornHasKeyword(WeaponTypeAutomatic) || player.WornHasKeyword(VATSWeaponLongBurst) ;Automatic Weapons only give EXP once per .35seconds, so they dont level faster than others
		isAutomatic = isAuto ;Global Variant
		int skillIndexLocal = -1 ;
		int ammoIndexLocal = -1
		int i = 0
		bool weaponTypeFound = False
		bool ammoTypeFound = False
		;skillIndexLocal = FindSkillIndex(WeaponTypeKeywordArray[], WeaponKeywordToAV[])
		while ((i < WeaponTypeKeywordArray.length) && !weaponTypeFound) 
			weaponTypeFound = player.WornHasKeyword(WeaponTypeKeywordArray[i]) ;Check for Primary Weapon Type First
			if weaponTypeFound 
				MFGAWeaponSkillAV = WeaponKeywordToAV[i]
				skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAV) ;store SkillIndexLocal for later
			else
				i += 1
			EndIf
		EndWhile
		if (meleeAVArray.Find(MFGAWeaponSkillAV) > -1);If it's melee no futher processing needed
			skillIndex = skillIndexLocal ;set the local as a global
		else ;Weapon Specifier
			if MFGAWeaponSkillAV == MFGAWeaponSkillPistol
				;if isAuto
					;skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAutoPistol) ;Not Implemented yet, but later on maybe
				;EndIf
			elseif MFGAWeaponSkillAV == MFGAWeaponSkillHeavyGun ;Find the specific heavy gun equipped 
				i = 0
				weaponTypeFound = player.WornHasKeyword(WeaponTypeMissileLauncher) || player.WornHasKeyword(WeaponTypeFatman) 
				if weaponTypeFound ;If not a missile, then it sets itself as just 'Heavy Gun' when it falls through this if loop
					skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillMissileLauncher) ;Only store if it's a missile
				endif
			elseif MFGAWeaponSkillAV == MFGAWeaponSkillRifle
				if isAuto
					skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAssaultRifle)
				elseif isScoped
					skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillSniper)
				EndIf
			EndIf
			;Find Ammo
			i = 0
			while ((i < AmmoTypeKeywordArray.length) && !ammoTypeFound) 
				ammoTypeFound = player.WornHasKeyword(AmmoTypeKeywordArray[i]) ;Check for Primary Weapon Type First
				if weaponTypeFound 
					MFGAWeaponSkillAV = WeaponKeywordToAV[i]
					skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAV) ;store SkillIndexLocal for later
				else
					i += 1
				EndIf
			EndWhile
		skillIndex = skillIndexLocal ;set the local as global value	
EndFunction

Function GetWeaponInfoNew()
	;Checks for what weapon and ammo type are equipped and stores that as a Script-wide Int
	skillIndex = -1 ;Script Wide Variant
	ammoIndex = -1 ;Script Wide Variant
	ActorValue MFGAWeaponSkillAV = None
	ActorValue MFGAWeaponAmmoAV = None 
	if player.GetEquippedWeapon() == None ;If no weapon equipped, skip all other processing
		skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillUnarmed) 
	else 
		int skillIndexLocal
		int ammoIndexLocal
		bool weaponTypeFound = False
		bool isScoped = player.WornHasKeyword(HasScope) ;Scope is necessary to check for sniper rifles and such
		bool isAuto = player.WornHasKeyword(WeaponTypeAutomatic) || player.WornHasKeyword(VATSWeaponLongBurst) ;Automatic Weapons only give EXP once per .35seconds, so they dont level faster than others
		isAutomatic = isAuto ;Script Wide Variant
		MFGAWeaponSkillAV = FindMFGAAV(WeaponTypeKeywordArray[], WeaponKeywordToAV[])
		skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAV)w
		if MFGAWeaponSkillAV != None
			if (meleeAVArray.Find(MFGAWeaponSkillAV) > -1);If it's melee no futher processing needed
				;skillIndex = skillIndexLocal ;set the local as a global
			else ;Weapon Specifier
				if MFGAWeaponSkillAV == MFGAWeaponSkillPistol
					;if isAuto
						;skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAutoPistol) ;Not Implemented yet, but later on maybe
					;EndIf
				elseif MFGAWeaponSkillAV == MFGAWeaponSkillHeavyGun ;Find the specific heavy gun equipped 
					int i = 0
					weaponTypeFound = player.WornHasKeyword(WeaponTypeMissileLauncher) || player.WornHasKeyword(WeaponTypeFatman) 
					if weaponTypeFound ;If not a missile, then it sets itself as just 'Heavy Gun' when it falls through this if loop
						skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillMissileLauncher) ;Only store if it's a missile
						ammoIndexLocal = WeaponToIndex.RFind(MFGAWeaponSkillExplosive) ;Set Explosive as the ammo type
					endif
				elseif MFGAWeaponSkillAV == MFGAWeaponSkillRifle
					if isAuto
						skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillAssaultRifle)
					elseif isScoped
						skillIndexLocal = WeaponToIndex.Find(MFGAWeaponSkillSniper)
					EndIf
				EndIf
				;Find Ammo
				if !(ammoIndexLocal > -1) ;Special case for explosives/missile launchers
					MFGAWeaponAmmoAV = FindMFGAAV(AmmoTypeKeywordArray[], AmmoKeywordToAV[])
					ammoIndexLocal = WeaponToIndex.RFind(MFGAWeaponAmmoAV)
				EndIf
				ammoIndex = ammoIndexLocal ;set the local as global value	
			EndIf
		EndIf
	Endif
	skillIndex = skillIndexLocal ;set the local as global value	
EndFunction


ActorValue Function FindMFGAAV(Keyword[] ArrayToSearch, ActorValue[] ParralelArray)
	;Searches for a Keyword on the Player from an array, and if Found, searches for a related MFGAActorValue from its Parallel Array inside of 'WeaponToIndex'
	;WeaponToIndex holds the true int values for the specific skill.
	int i = 0 
	int iValue = -1
	bool itemTypeFound = False ;for verifying whether was found already
	ActorValue MFGAWeaponSkillAV = None ;Actor Value to Test. Returns None if it can't find it.
	while ((i < ArrayToSearch.length) && !itemTypeFound) 
		itemTypeFound = player.WornHasKeyword(ArrayToSearch[i]) 
		if itemTypeFound 
			MFGAWeaponSkillAV = ParralelArray[i] ;Set the actor value from the Parallel array.
		EndIf
		i += 1 ;increment counter
	EndWhile
		return MFGAWeaponSkillAV ;If it wasn't found, return None, otherwise return the skillIndexValue
	EndIf
EndFunction

WeaponTypeKeywordArray = New Keyword[7]
WeaponTypeKeywordArray[0] = WeaponTypeMelee1H 
WeaponTypeKeywordArray[1] = WeaponTypeMelee2H 
WeaponTypeKeywordArray[2] = WeaponTypeUnarmed 
WeaponTypeKeywordArray[3] = WeaponTypePistol 
WeaponTypeKeywordArray[4] = WeaponTypeShotgun 
WeaponTypeKeywordArray[5] = WeaponTypeHeavyGun 
WeaponTypeKeywordArray[6] = WeaponTypeRifle 

WeaponKeywordToAV = New ActorValue[WeaponTypeKeywordArray.Length]
WeaponKeywordToAV[0] = MFGAWeaponSkillMelee
WeaponKeywordToAV[1] = MFGAWeaponSkillMelee
WeaponKeywordToAV[2] = MFGAWeaponSkillUnarmed
WeaponKeywordToAV[3] = MFGAWeaponSkillPistol
WeaponKeywordToAV[4] = MFGAWeaponSkillShotgun
WeaponKeywordToAV[5] = MFGAWeaponSkillHeavyGun
WeaponKeywordToAV[6] = MFGAWeaponSkillRifle

meleeAVArray = new ActorValue[2]
meleeAVArray[0] = MFGAWeaponSkillMelee
meleeAVArray[1] = MFGAWeaponSkillUnarmed

AmmoTypeKeywordArray = New Keyword[7]
AmmoTypeKeywordArray[0] = WeaponTypeBallistic
AmmoTypeKeywordArray[1] = WeaponTypePlasma
AmmoTypeKeywordArray[2] = WeaponTypeLaser
AmmoTypeKeywordArray[3] = WeaponTypeGatlingLaser
AmmoTypeKeywordArray[4] = WeaponTypeFlamer
AmmoTypeKeywordArray[5] = WeaponTypeAlienBlaster
AmmoTypeKeywordArray[6] = WeaponTypeCryolater

AmmoKeywordToAV = New ActorValue[AmmoTypeKeywordArray.Length]
AmmoKeywordToAV[0] = MFGAWeaponSkillBallistic
AmmoKeywordToAV[1] = MFGAWeaponSkillPlasma
AmmoKeywordToAV[2] = MFGAWeaponSkillLaser
AmmoKeywordToAV[3] = MFGAWeaponSkillLaser 
AmmoKeywordToAV[4] = MFGAWeaponSkillLaser 
AmmoKeywordToAV[5] = MFGAWeaponSkillPlasma 
AmmoKeywordToAV[6] = MFGAWeaponSkillPlasma 


Keyword Property VATSWeaponLongBurst Auto Const

;(WeaponTypeKeyword[i] == WeaponTypeMelee1H) || (WeaponTypeKeyword[i] == WeaponTypeMelee2H || WeaponTypeKeyword[i] == WeaponTypeUnarmed

;/HeavyGunKeywordArray  = new Keyword[3]
HeavyGunKeywordArray[0] = WeaponTypeMissileLauncher
HeavyGunKeywordArray[1] = WeaponTypeFatman

HeavyGunKeywordToAV = new ActorValue[HeavyGunKeywordArray.Length]
HeavyGunKeywordArray[0] = MFGAWeaponSkillMissileLauncher
HeavyGunKeywordArray[1] = MFGAWeaponSkillMissileLauncher
/;


WeaponTypeKeywordArray = New Keyword[7]
WeaponTypeKeywordArray[0] = WeaponTypeMelee1H 
WeaponTypeKeywordArray[1] = WeaponTypeMelee2H 
WeaponTypeKeywordArray[2] = WeaponTypeUnarmed 
WeaponTypeKeywordArray[3] = WeaponTypePistol 
WeaponTypeKeywordArray[4] = WeaponTypeShotgun 
WeaponTypeKeywordArray[5] = WeaponTypeHeavyGun 
WeaponTypeKeywordArray[6] = WeaponTypeRifle 

WeaponKeywordToAV = New ActorValue[WeaponTypeKeywordArray.Length]
WeaponKeywordToAV[0] = MFGAWeaponSkillMelee
WeaponKeywordToAV[1] = MFGAWeaponSkillMelee
WeaponKeywordToAV[2] = MFGAWeaponSkillUnarmed
WeaponKeywordToAV[3] = MFGAWeaponSkillPistol
WeaponKeywordToAV[4] = MFGAWeaponSkillShotgun
WeaponKeywordToAV[5] = MFGAWeaponSkillHeavyGun
WeaponKeywordToAV[6] = MFGAWeaponSkillRifle


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


Function GetWeaponType(bool isMelee)

EndFunction

;=====================;
;ActorValues
;=====================;


;=====================;
;KEYWORDS
;=====================;

;Ammo Type Identifiers
Keyword Property WeaponTypeBallistic Auto Const
Keyword Property WeaponTypePlasma Auto Const
Keyword Property WeaponTypeLaser Auto Const
Keyword Property WeaponTypeExplosive Auto Const

;WeaponType Keyword Identifiers
Keyword Property WeaponTypeMelee1H Auto Const
Keyword Property WeaponTypeMelee2H Auto Const
Keyword Property WeaponTypeUnarmed Auto Const
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