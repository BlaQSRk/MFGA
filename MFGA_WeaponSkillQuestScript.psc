Scriptname MFGAWeaponSkillQuestScript extends Quest

Actor Player
ActorValue skillToIncreaseAmmo
ActorValue skillToIncreaseWeapon1
ActorValue skillToIncreaseWeapon2
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


Event OnQuestInit()
	Debug.Trace("OnQuestInit()")
	Player = Game.GetPlayer()
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
	ReInit()
EndEvent

Function ReInit() ;Allows the game to reinitialize things if you need to change. OnQuestInit isn't sufficient. Put changes here.
	Debug.Trace("ReInit()")
	player.SetValue(MFGAEmptySkill, 0) ; Resets this in case it accidentally was modified added (Prevents possible crashes)
	RegisterForRemoteEvent(Player, "OnItemEquipped")
EndFunction

Function IncreaseSkill(float increaseAmount = 1) ;Default value of 1
	Player.ModValue(skillToIncrease, increaseAmount)
EndFunction

Event Actor.OnPlayerLoadGame(Actor akSender)
	Debug.Trace ("OnPlayerLoadGame()")
	ReInit()
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Debug.Trace("OnItemEquipped()")
	skillToIncreaseWeapon1 = MFGAEmptySkill
	skillToIncreaseWeapon2 = MFGAEmptySkill
	skillToIncreaseAmmo = MFGAEmptySkill
	;Melee Check
	if (player.WornHasKeyWord(WeaponTypeMelee1H) || player.WornHasKeyWord(WeaponTypeMelee2H))
		skillToIncreaseWeapon1 = MFGAWeaponSkillMelee
	ElseIf (player.WornHasKeyWord(WeaponTypeUnarmed))
		skillToIncreaseWeapon1 = MFGAWeaponSkillUnarmed
	EndIf
	
	;AmmoType
	;Old Code: (skillToIncreaseWeapon1 != MFGAWeaponSkillMelee) || (skillToIncreaseWeapon1 = MFGAWeaponSkillUnarmed) 

	if (skillToIncreaseWeapon1 == MFGAEmptySkill);Don't check for ammo/gun keywords if unarmed/using melee. Save processing
		;Ammotype Check
		if player.WornHasKeyWord(WeaponTypeBallistic)
			skillToIncreaseAmmo = MFGAWeaponSkillBallistic ; Need to create Ballistic Ammo AV. For future version.
		elseif (player.WornHasKeyWord(WeaponTypePlasma))
			skillToIncreaseAmmo = MFGAWeaponSkillPlasma
		elseif (player.WornHasKeyWord(WeaponTypeLaser))
			skillToIncreaseAmmo = MFGAWeaponSkillLaser
		EndIf
		;Weapon type check
		If (player.WornHasKeyWord(WeaponTypePistol))
			skillToIncreaseWeapon1 = MFGAWeaponSkillPistol
		elseif (player.WornHasKeyWord(WeaponTypeRifle))
			if (player.WornHasKeyWord(WeaponTypeAutomatic))
				skillToIncreaseWeapon1 = MFGAWeaponSkillAssaultRifle
				skillToIncreaseWeapon2 = MFGAWeaponSkillRifle
			elseif (player.WornHasKeyWord(HasScope))
				skillToIncreaseWeapon1 = MFGAWeaponSkillSniper
				skillToIncreaseWeapon2 = MFGAWeaponSkillRifle
			EndIf
		EndIf
	EndIf
{
	If Player.WornHasKeyWord(WeaponTypePistol)
		skillToIncreaseWeapon1 = 

	If Player.WornHasKeyWord(WeaponTypeRifle)
		skillToIncrease = MFGAWeaponSkillRifle
	ElseIf Player.WornHasKeyWord()
		}
EndEvent