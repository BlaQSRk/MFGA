Scriptname RegirEnemyKilledScript extends Quest

Int nMoleRatsKilled
Int nGrenadeKills
Perk Property MoleRatKiller Auto Const

; Increment Molerats Killed

Function IncrementKilled(int numKilled = 1)

	nMoleRatsKilled += numKilled
	Debug.Notification ("You killed " + nMoleRatsKilled + " Molerats so far.")

	if  (nMoleRatsKilled == 5 )
  		Debug.MessageBox("You killed 5 Molerats! You're a Molerat Killer!")
 		Game.GetPlayer().AddPerk(MoleRatKiller) ;Adds Mole Rat Killer to the player after killing 5 Molerats
	endif
EndFunction

Function IncrementGrenadeKills(int numKilled = 1)

	nGrenadeKills += numKilled
	Debug.Notification ("You killed " + nGrenadeKills + " enemies with explosives so far.")

	if  (nMoleRatsKilled == 5 )
  		Debug.MessageBox("You killed exploded 5 enemies! You're an Exploder!")
	endif
EndFunction


