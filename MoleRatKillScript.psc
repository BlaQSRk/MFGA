Scriptname MoleRatKillScript extends Actor Const

Event OnKill(Actor akVictim)
	if (akVictim.HasKeyword(ActorTypeMolerat))
    	Debug.Notification("We killed a Molerat!")
  	else 
  		Debug.Notification("We killed an unknown enemy!")
  	endIf
endEvent

