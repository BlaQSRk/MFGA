Event OnKill(Actor akVictim)
	if (akVictim.HasKeyword(ActorTypeMolerat))
    	Debug.Notification("We killed a Molerat!")
  	else 
  		Debug.Notification("We killed an unknown enemy!")
  	endIf
endEvent


; Increment Giants killed
kmyQuest.nMoleRatsKilled += 1
Debug.Notification ("You killed " + kmyQuest.nMoleRatsKilled + " Molerats so far.")
if  ( kmyQuest.nMoleRatsKilled == 5 )
  Debug.Notification("You killed 5 Molerats!")
endif

; Increment Molerats Killed
kmyQuest.nMoleRatsKilled += 1
Debug.Notification ("You killed " + kmyQuest.nMoleRatsKilled + " Molerats so far.")

if  ( kmyQuest.nMoleRatsKilled == 5 )
  Debug.Notification("You killed 5 Molerats!")
endif

Scriptname AchievementHarderTheyFallScript extends Actor

Quest Property pAchievements Auto Const Mandatory

Event OnDeath(Actor akKiller)
	if akKiller == Game.GetPlayer()
		pAchievements.SetStage(360)
	endif
EndEvent

Scriptname RegirEnemyWhichEnemyKilledScript extends ObjectReference Const

Quest Property pEnemyKilled Auto Const

ObjectReference rContainer

Event OnInit()
	rContainer = actor.GetContainer()
	if rContainer.HasKeyword(ActorTypeMolerat)
		pEnemyKilled.SetStage(20)
	endif
EndEvent




{Safely increment variable from multiple scripts
The Problem
Say the player needs to kill X of some creature. One common way to do this is put an OnDeath script on all the creatures, increment a quest variable, then do something when the count gets to the right number.
This can cause problems because it isn’t thread safe – meaning if two enemies die at exactly the same moment, one may end up bashing the other, preventing the player from getting credit for one of the kills.
The Solution
Instead of incrementing the variable from the other scripts, it's better to use a function on the quest script (where applicable) which increments the variable and does whatever it needs to when the count gets to the right number. This is thread-safe (because it is a function call). So, for example, instead of doing this:}

 ; WRONG WAY
 Event OnDeath(Actor akKiller)
       ; increment dead count
       myQuestScript = GetOwningQuest() as MS06Script
       myQuestScript.DeadCultists = myQuestScript.DeadCultists + 1
       if myQuestScript.DeadCultists >= myQuestScript.TotalCultists 
             GetOwningQuest().SetStage(100)
       endif
 endEvent
;I changed it to this on the actor script:
 ; RIGHT WAY
 Event OnDeath(Actor akKiller)
       ; increment dead count
       myQuestScript = GetOwningQuest() as MS06Script
       myQuestScript.IncrementDeadCultists()
 endEvent
;And then put this on MS06Script:
 function IncrementDeadCultists()
       DeadCultists = DeadCultists + 1
       if DeadCultists >= TotalCultists
             setStage(100)
       endif
 endFunction

 ScriptObject 

 Scriptname RegirMoleratKilledScript extends ObjectReference

Quest Property pMoleratKill Auto 

Event OnInit()
	pMoleratKill.SetStage(20)
EndEvent