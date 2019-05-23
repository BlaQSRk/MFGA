
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
		skillIndexLocal = 9
		IncrementAndDisplayExpValues(skillIndexLocal, increaseAmount, isKilled)
	else
		IncrementAndDisplayExpValues(skillIndexLocal, increaseAmount, isKilled)
		if !isMelee ;if it's not a melee weapon, and not an explosive, then it has ammo. Check for ammo.
			IncrementAndDisplayExpValues(ammoIndex, (increaseAmount/ammoExpModifier), isKilled)

		EndIf
		if (WeaponDataArray[skillIndexLocal].skillName2) ;Check Secondary Skills
			skill2 = WeaponDataArray[skillIndexLocal].skillName2
			skillIndexLocal = WeaponToIndex.Find(skill2)
			Player.ModValue(WeaponDataArray[skillIndexLocal].expSecondary, (increaseAmount / secondaryExpModifier))
			TraceAndNotify("Your EXP in " + WeaponDataArray[skillIndexLocal].skillNameText2 + " increased by " + (increaseAmount / secondaryExpModifier), True)
			TraceAndNotify("Your Total EXP in " + WeaponDataArray[skillIndexLocal].skillNameText2 + " is " + player.getvalue(WeaponDataArray[skillIndexLocal].expSecondary), True)
			LevelUpCheck(WeaponDataArray[skillIndexLocal].skillName2, WeaponDataArray[skillIndexLocal].expSecondary, WeaponToIndex.Find(skill2), isKilled, False, True)
		EndIf
	EndIf
	;DisplaySkills()
EndFunction

Function IncrementAndDisplayExpValues(int indexValue, float increaseAmount, bool isKilled)
		ActorValue skill = WeaponDataArray[indexValue].skillName1
		ActorValue skillExp = WeaponDataArray[indexValue].expPrimary
		string skillText = WeaponDataArray[indexValue].skillNameText 
		Player.ModValue(skillExp, increaseAmount)
		TraceAndNotify("Your EXP in " + skillText + " increased by " + increaseAmount, True)
		TraceAndNotify("Your Total EXP in " + skillText + " is " + player.getvalue(skillExp), True)
		LevelUpCheck(skill, skillexp, indexValue, isKilled)
EndFunction