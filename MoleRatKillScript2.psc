Scriptname RegirEnemyKilledScript extends Quest

Int Property nMoleRatsKilled Auto 

Perk MoleratKiller = MoleRatKiller

; Increment Molerats Killed

Function IncrementKilled(int numKilled = 1)

	nMoleRatsKilled += numKilled
	Debug.Notification ("You killed " + nMoleRatsKilled + " Molerats so far.")

	if  (nMoleRatsKilled == 5 )
  		Debug.MessageBox("You killed 5 Molerats! You're a Molerat Killer!")
  		Game.GetPlayer().AddPerk(5rMoleRatKiller) ;Adds Mole Rat Killer to the player after killing 5 Molerats
	endif
EndFunction