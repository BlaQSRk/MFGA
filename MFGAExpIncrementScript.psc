Scriptname MFGAExpIncrementScript extends activemagiceffect

Actor player
ActorValue Property MFGAWeaponSkillAssaultRifleExp Auto Const
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
ActorValue Property MFGAWeaponSkillAssaultRifle Auto Const
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
Keyword Property WeaponTypeRifle Auto Const
Keyword Property WeaponTypePistol Auto Const

Event OnEffectStart (Actor akTarget, Actor akCaster)
	player = Game.GetPlayer()
	RegisterForHitEvent(akTarget,  player)
	Debug.Notification("Enemy Registered For Hits.") ;Test For Cloak Activation
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
	bool abBashAttack, bool abHitBlocked, string asMaterialName)
	if akSource.HasKeyword(WeaponTypeRifle)
		IncrementExp(MFGAWeaponSkillRifle, 1)
	ElseIf akSource.HasKeyword(WeaponTypePistol)
		IncrementExp(MFGAWeaponSkillPistol, 1)
	EndIf
		
EndEvent

Function IncrementExp (ActorValue skillToIncrease, Float expGained) 	
	Debug.Notification(skillToIncrease + " will be increased by " + expGained)
EndFunction




