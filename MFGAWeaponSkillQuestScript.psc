Scriptname MFGAWeaponSkillQuestScript extends Quest

Actor Player
ActorValue expToIncreaseAmmo
ActorValue expToIncreaseWeapon1
ActorValue expToIncreaseWeapon2
ActorValue Property MFGAEmptySkill Auto Const ; Used to create a 'Null' for testing purposes

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
	ReInit()
EndEvent

Function ReInit() ;Allows the game to reinitialize things if you need to change. OnQuestInit isn't sufficient. Put changes here.
	Debug.Trace("ReInit()")
	;player.SetValue(MFGAEmptySkill, 0)  Resets this in case it accidentally was modified (Prevents possible crashes)
	RegisterForRemoteEvent(Player, "OnItemEquipped")
EndFunction

Function IncreaseSkill(float increaseAmount = 1.0) ;Default value of 1
	Player.ModValue(expToIncreaseWeapon1, increaseAmount)
	DisplaySkills()
EndFunction

Event Actor.OnPlayerLoadGame(Actor akSender)
	Debug.Trace ("OnPlayerLoadGame()")
	ReInit()
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Debug.Trace("OnItemEquipped()")
	expToIncreaseWeapon1 = MFGAEmptySkill
	expToIncreaseWeapon2 = MFGAEmptySkill
	expToIncreaseAmmo = MFGAEmptySkill
	;Melee Check
	if (player.WornHasKeyWord(WeaponTypeMelee1H) || player.WornHasKeyWord(WeaponTypeMelee2H))
		expToIncreaseWeapon1 = MFGAWeaponSkillMeleeExp
	ElseIf (player.WornHasKeyWord(WeaponTypeUnarmed))
		expToIncreaseWeapon1 = MFGAWeaponSkillUnarmedExp
	EndIf
	
	;Old Code: (expToIncreaseWeapon1 != MFGAWeaponSkillMelee) || (expToIncreaseWeapon1 = MFGAWeaponSkillUnarmed) 
	if (expToIncreaseWeapon1 == MFGAEmptySkill) ;Don't check for ammo/gun keywords if unarmed/using melee. Save processing
		;Ammotype Check
		if player.WornHasKeyWord(WeaponTypeBallistic)
			expToIncreaseAmmo = MFGAWeaponSkillBallisticExp ; Need to create Ballistic Ammo AV. For future version.
		elseif (player.WornHasKeyWord(WeaponTypePlasma))
			expToIncreaseAmmo = MFGAWeaponSkillPlasmaExp
		elseif (player.WornHasKeyWord(WeaponTypeLaser))
			expToIncreaseAmmo = MFGAWeaponSkillLaserExp
		EndIf
		;Weapon type check
		If (player.WornHasKeyWord(WeaponTypePistol))
			expToIncreaseWeapon1 = MFGAWeaponSkillPistolExp
		elseIf (player.WornHasKeyword(WeaponTypeShotgun))
			expToIncreaseWeapon1 = MFGAWeaponSkillShotgun
		elseif (player.WornHasKeyWord(WeaponTypeRifle))
			if (player.WornHasKeyWord(WeaponTypeAutomatic))
				expToIncreaseWeapon1 = MFGAWeaponSkillAssaultRifleExp
				expToIncreaseWeapon2 = MFGAWeaponSkillRifleExp
			elseif (player.WornHasKeyWord(HasScope))
				expToIncreaseWeapon1 = MFGAWeaponSkillSniperExp
				expToIncreaseWeapon2 = MFGAWeaponSkillRifleExp
			else 
				expToIncreaseWeapon1 = MFGAWeaponSkillRifleExp
			EndIf
		EndIf
	EndIf
EndEvent

Function DisplaySkills()
	Debug.Trace("AutoRifle EXP " + MFGAWeaponSkillAssaultRifleExp)
	Debug.Trace("Ballistic EXP " + MFGAWeaponSkillBallisticExp)
	Debug.Trace("Explosive EXP " + MFGAWeaponSkillExplosiveExp)
	Debug.Trace("HeavyGun EXP " + MFGAWeaponSkillHeavyGunExp)
	Debug.Trace("Laser EXP " + MFGAWeaponSkillLaserExp)
	Debug.Trace("Melee EXP " + MFGAWeaponSkillMeleeExp)
	Debug.Trace("Missile EXP " + MFGAWeaponSkillMissileLauncherExp)
	Debug.Trace("Pistol EXP " + MFGAWeaponSkillPistolExp)
	Debug.Trace("Plasma EXP " + MFGAWeaponSkillPlasmaExp)
	Debug.Trace("Rifle EXP " + MFGAWeaponSkillRifleExp)
	Debug.Trace("Shotgun EXP " + MFGAWeaponSkillShotgunExp)
	Debug.Trace("Sniper EXP " + MFGAWeaponSkillSniperExp)
	Debug.Trace("Unarmed EXP " + MFGAWeaponSkillUnarmedExp)
	;Debug.Trace(" EXP " + )
EndFunction









