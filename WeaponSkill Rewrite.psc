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

make a global assignment int for each value found

	skillName[0] = "Melee"
	skillName[1] = "Unarmed"
	skillName[2] = "Ballistic Ammo"
	skillName[3] = "Plasma Ammo"
	skillName[4] = "Laser Ammo"
	skillName[5] = "Pistol"
	skillName[6] = "Shotgun"
	skillName[7] = "HeavyGun"
	skillName[8] = "MissileLauncher"
	skillName[9] = "Explosive"
	skillName[10] = "Rifle"
	skillName[11] = "Assault Rifle"
	skillName[12] = "Sniper Rifle"
EndIf

skillIndex: 

0 = Melee
1 = Unarmed
2 = Pistol
3 = Shotgun
4 = HeavyGun
5 = Missile
6 = Rifle
7 = AssaultRifle
8 = Sniper
9 = Explosive

;How To use:
; WeaponDataArray[skillIndex].expPrimary etc etc



expToIncreaseWeapon1 = MFGAWeaponSkillUnarmedExp
relevantSkillWeapon1 = MFGAWeaponSkillUnarmed

WeaponData[] WeaponDataArray

WeaponDataArray[0].expPrimary = MFGAWeaponSkillMeleeExp
WeaponDataArray[0].expSecondary = None
WeaponDataArray[0].skillName1 = MFGAWeaponSkillMelee
WeaponDataArray[0].skillName2 = None
WeaponDataArray[0].skillNameText = "Melee"
WeaponDataArray[0].Accuracy = None
WeaponDataArray[0].Damage = MFGA_MeleeDamage
WeaponDataArray[0].Reload = None
WeaponDataArray[0].Critical = MFGA_MeleeCrit

WeaponDataArray[1].expPrimary = MFGAWeaponSkillUnarmedExp
WeaponDataArray[1].expSecondary = None
WeaponDataArray[1].skillName1 = MFGAWeaponSkillUnarmed
WeaponDataArray[1].skillName2 = None
WeaponDataArray[1].skillNameText = "Unarmed"
WeaponDataArray[1].Accuracy = None
WeaponDataArray[1].Damage = MFGA_UnarmedDamage
WeaponDataArray[1].Reload = None
WeaponDataArray[1].Critical = MFGA_UnarmedCrit

WeaponDataArray[2].expPrimary = MFGAWeaponSkillPistolExp
WeaponDataArray[2].expSecondary = None
WeaponDataArray[2].skillName1 = MFGAWeaponSkillPistol
WeaponDataArray[2].skillName2 = None
WeaponDataArray[2].skillNameText = "Pistol"
WeaponDataArray[2].Accuracy = MFGA_PistolAccuracy
WeaponDataArray[2].Damage = MFGA_PistolDamage
WeaponDataArray[2].Reload = MFGA_PistolReload
WeaponDataArray[2].Critical = MFGA_PistolCrit 

WeaponDataArray[3].expPrimary = MFGAWeaponSkillShotgunExp
WeaponDataArray[3].expSecondary = None
WeaponDataArray[3].skillName1 = MFGAWeaponSkillShotgun
WeaponDataArray[3].skillName2 = None
WeaponDataArray[3].skillNameText = "Shotgun"
WeaponDataArray[3].Accuracy = MFGA_ShotgunAccuracy
WeaponDataArray[3].Damage = MFGA_ShotgunDamage
WeaponDataArray[3].Reload = MFGA_ShotgunReload
WeaponDataArray[3].Critical = MFGA_ShotgunCrit

WeaponDataArray[] = New WeaponData
WeaponDataArray[4].expPrimary = MFGAWeaponSkillHeavyGunExp
WeaponDataArray[4].expSecondary = None
WeaponDataArray[4].skillName1 = MFGAWeaponSkillHeavyGun
WeaponDataArray[4].skillName2 = None
WeaponDataArray[4].skillNameText = "Heavy Guns"
WeaponDataArray[4].Accuracy = MFGA_HeavyAccuracy
WeaponDataArray[4].Damage = MFGA_HeavyDamage
WeaponDataArray[4].Reload = MFGA_HeavyReload
WeaponDataArray[4].Critical = MFGA_HeavyCrit

WeaponDataArray[] = New WeaponData
WeaponDataArray[5].expPrimary = MFGAWeaponSkillMissileLauncherExp
WeaponDataArray[5].expSecondary = MFGAWeaponSkillHeavyGunExp
WeaponDataArray[5].skillName1 = MFGAWeaponSkillMissileLauncher
WeaponDataArray[5].skillName2 = MFGAWeaponSkillHeavyGun
WeaponDataArray[5].skillNameText = "Missile Launcher"
WeaponDataArray[5].Accuracy = None ;MFGA_ have to populate these
WeaponDataArray[5].Damage = None ;MFGA_
WeaponDataArray[5].Reload = None ;MFGA_
WeaponDataArray[5].Critical = None ;MFGA_

WeaponDataArray[] = New WeaponData
WeaponDataArray[6].expPrimary = MFGAWeaponSkillRifleExp
WeaponDataArray[6].expSecondary = None
WeaponDataArray[6].skillName1 = MFGAWeaponSkillRifle
WeaponDataArray[6].skillName2 = None
WeaponDataArray[6].skillNameText = "Rifle"
WeaponDataArray[6].Accuracy = MFGA_RifleAccuracy
WeaponDataArray[6].Damage = MFGA_RifleDamage
WeaponDataArray[6].Reload = MFGA_RifleReload
WeaponDataArray[6].Critical = MFGA_RifleCrit

WeaponDataArray[] = New WeaponData
WeaponDataArray[7].expPrimary = MFGAWeaponSkillAssaultRifleExp
WeaponDataArray[7].expSecondary = MFGAWeaponSkillRifleExp
WeaponDataArray[7].skillName1 = MFGAWeaponSkillAssaultRifle
WeaponDataArray[7].skillName2 = MFGAWeaponSkillRiflerifle
WeaponDataArray[7].skillNameText = "Assault Rifle"
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
WeaponDataArray[8].Accuracy = MFGA_SniperAccuracy
WeaponDataArray[8].Damage = MFGA_SniperDamage
WeaponDataArray[8].Reload = MFGA_SniperReload
WeaponDataArray[8].Critical = MFGA_SniperCrit


AmmoData[0].expAmmo = MFGAWeaponSkillBallisticExp
AmmoData[0].skillName = MFGAWeaponSkillBallistic

AmmoData[1].expAmmo = MFGAWeaponSkillPlasmaExp
AmmoData[1].skillName = MFGAWeaponSkillPlasma

AmmoData[2].expAmmo = MFGAWeaponSkillLaserExp
AmmoData[2].skillName = MFGAWeaponSkillLaser

AmmoData[3].expAmmo = MFGAWeaponSkillExplosiveExp
AmmoData[3].skillName = MFGAWeaponSkillExplosive


{WeaponDataArray[2].expPrimary = MFGAWeaponSkill
WeaponDataArray[2].expSecondary = None
WeaponDataArray[2].skillName1 = MFGAWeaponSkill
WeaponDataArray[2].skillName2 = None
WeaponDataArray[2].skillNameText = ""
WeaponDataArray[2].Accuracy = MFGA_
WeaponDataArray[2].Damage = MFGA_
WeaponDataArray[2].Reload = MFGA_
WeaponDataArray[2].Critical = MFGA_}



		if player.WornHasKeyWord(WeaponTypeBallistic)
			expToIncreaseAmmo =  ; Need to create Ballistic Ammo AV. For future version.
			relevantSkillAmmo = MFGAWeaponSkillBallistic
			skillIndexAmmo = 2
			TraceAndNotify("Weapon uses Ballistic Ammo", True)
		elseif (player.WornHasKeyWord(WeaponTypePlasma))
			expToIncreaseAmmo = MFGAWeaponSkillPlasmaExp
			relevantSkillAmmo = MFGAWeaponSkillPlasma
			skillIndexAmmo = 3
			TraceAndNotify("Weapon uses Plasma Ammo", True)
		elseif player.WornHasKeyWord(WeaponTypeLaser) || player.WornHasKeyword(WeaponTypeGatlingLaser)
			expToIncreaseAmmo = MFGAWeaponSkillLaserExp
			relevantSkillAmmo = MFGAWeaponSkillLaser
			skillIndexAmmo = 4
			TraceAndNotify("Weapon uses Laser Ammo", True)
		EndIf

AmmoIndex:

0 = Ballistic Ammo
1 = Plasma Ammo
2 = Laser Ammo
3 = Explosive




Function GetWeaponType()
	TraceAndNotify("GetWeaponType()", True)
	expToIncreaseWeapon1 = None
	expToIncreaseWeapon2 = None
	expToIncreaseAmmo = None
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
		expToIncreaseWeapon1 = MFGAWeaponSkillMeleeExp
		relevantSkillWeapon1 = MFGAWeaponSkillMelee
		skillIndex1 = 0
		TraceAndNotify("Player equipped a Melee Weapon", True)
	ElseIf (player.WornHasKeyWord(WeaponTypeUnarmed)) || player.GetEquippedWeapon() == None
		expToIncreaseWeapon1 = MFGAWeaponSkillUnarmedExp
		relevantSkillWeapon1 = MFGAWeaponSkillUnarmed
		skillIndex1 = 1
		TraceAndNotify("Player equipped an Unarmed Weapon", True)
	EndIf
	


	;Old Code: (expToIncreaseWeapon1 != MFGAWeaponSkillMelee) || (expToIncreaseWeapon1 = MFGAWeaponSkillUnarmed) 
	if !expToIncreaseWeapon1 ;Don't check for ammo/gun keywords if unarmed/using melee. Save processing
		;Ammotype Check
		if player.WornHasKeyWord(WeaponTypeBallistic)
			expToIncreaseAmmo = MFGAWeaponSkillBallisticExp ; Need to create Ballistic Ammo AV. For future version.
			relevantSkillAmmo = MFGAWeaponSkillBallistic
			skillIndexAmmo = 2
			TraceAndNotify("Weapon uses Ballistic Ammo", True)
		elseif (player.WornHasKeyWord(WeaponTypePlasma))
			expToIncreaseAmmo = MFGAWeaponSkillPlasmaExp
			relevantSkillAmmo = MFGAWeaponSkillPlasma
			skillIndexAmmo = 3
			TraceAndNotify("Weapon uses Plasma Ammo", True)
		elseif player.WornHasKeyWord(WeaponTypeLaser) || player.WornHasKeyword(WeaponTypeGatlingLaser)
			expToIncreaseAmmo = MFGAWeaponSkillLaserExp
			relevantSkillAmmo = MFGAWeaponSkillLaser
			skillIndexAmmo = 4
			TraceAndNotify("Weapon uses Laser Ammo", True)
		EndIf


		;Weapon type check
		If (player.WornHasKeyWord(WeaponTypePistol))
			expToIncreaseWeapon1 = MFGAWeaponSkillPistolExp
			relevantSkillWeapon1 = MFGAWeaponSkillPistol
			skillIndex1 = 5
			TraceAndNotify("Player equipped a Pistol", True)
		elseIf (player.WornHasKeyword(WeaponTypeShotgun))
			expToIncreaseWeapon1 = MFGAWeaponSkillShotgunExp
			relevantSkillWeapon1 = MFGAWeaponSkillShotgun
			skillIndex1 = 6
			TraceAndNotify("Player equipped a Shotgun", True)
		ElseIf (player.WornHasKeyword(WeaponTypeHeavyGun))
			expToIncreaseWeapon1 = MFGAWeaponSkillHeavyGunExp
			relevantSkillWeapon1 = MFGAWeaponSkillHeavyGun
			skillIndex1 = 7
			TraceAndNotify("Player equipped a HeavyGun", True)
		ElseIf (player.WornHasKeyword(WeaponTypeMissileLauncher))
			expToIncreaseWeapon1 = MFGAWeaponSkillMissileLauncherExp
			expToIncreaseWeapon2 = MFGAWeaponSkillHeavyGunExp
			expToIncreaseAmmo = MFGAWeaponSkillExplosiveExp
			relevantSkillWeapon1 = MFGAWeaponSkillMissileLauncher
			relevantSkillWeapon2 = MFGAWeaponSkillHeavyGun
			skillIndex1 = 8
			skillIndex2 = 7
			skillIndexAmmo = 9
			relevantSkillAmmo = MFGAWeaponSkillExplosive
			TraceAndNotify("Player equipped a Missile Launcher", True)
		elseif (player.WornHasKeyWord(WeaponTypeRifle))
			if (player.WornHasKeyWord(WeaponTypeAutomatic))
				expToIncreaseWeapon1 = MFGAWeaponSkillAssaultRifleExp
				expToIncreaseWeapon2 = MFGAWeaponSkillRifleExp
				relevantSkillWeapon1 = MFGAWeaponSkillAssaultRifle
				relevantSkillWeapon2 = MFGAWeaponSkillRifle
				skillIndex1 = 11
				skillIndex2 = 10
				TraceAndNotify("Player equipped an Automatic Rifle", True)
			elseif (player.WornHasKeyWord(HasScope))
				expToIncreaseWeapon1 = MFGAWeaponSkillSniperExp
				expToIncreaseWeapon2 = MFGAWeaponSkillRifleExp
				relevantSkillWeapon1 = MFGAWeaponSkillSniper
				relevantSkillWeapon2 = MFGAWeaponSkillRifle
				skillIndex1 = 12
				skillIndex2 = 10
				TraceAndNotify("Player equipped a Sniper Rifle", True)
			else 
				expToIncreaseWeapon1 = MFGAWeaponSkillRifleExp
				relevantSkillWeapon1 = MFGAWeaponSkillRifle
				skillindex1 = 10
				TraceAndNotify("Player equipped a Normal Rifle", True)
			EndIf 
		else 
			expToIncreaseWeapon1 = MFGAWeaponSkillUnarmedExp ; If 
			relevantSkillWeapon1 = MFGAWeaponSkillUnarmed
			skillIndex1 = 1
			TraceAndNotify("Test fell through the list, so must be 'truly' Unarmed", True) ;Fists don't have a "type" for some reason.
		EndIf

	EndIf
EndFunction
