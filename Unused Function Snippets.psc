;Unused Functions

Function PruneArrayDuplicatesCopy (var[] arrayToPrune, var[] arrayMasterReference)
	Debug.Trace("PruneSkillDuplicates()")
	int maxArrayLength = arrayMasterReference.Length
	int i = 0
	int firstPosition
	int secondPosition
	Debug.Trace("maxWeaponArrayLength: " + maxArrayLength)
	while i < maxArrayLength
		Debug.Trace("i = " + i  "\n Attempting to prune duplicates of " WeaponDataArray[i].skillnameText)
		firstPosition = arrayToPrune.Find(i)
		if firstPosition > -1
			while (arrayToPrune.RFind(i) != firstPosition)
				secondPosition = arrayToPrune.RFind(i)
				Debug.Trace("Found a duplicate of " + WeaponDataArray[i].skillnameText + "at position " + secondPosition ". Removing...")
				arrayToPrune.Remove(secondPosition)
			EndWhile
			Debug.Trace("Finished pruning duplicates of " + WeaponDataArray[i].skillnameText + ". Incrementing the search...")
		else
			Debug.Trace("Couldn't find " + WeaponDataArray[i].skillnameText + " in the queue. Incrementing the search...")
		endif
		i += 1
	EndWhile
EndFunction
