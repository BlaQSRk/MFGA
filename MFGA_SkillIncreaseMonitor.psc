Scriptname MFGA_SkillIncreaseMonitor extends activemagiceffect

Actor Player
ActorBase thisActorBase
Int thisActorLevel
Race thisActorRace
MFGA_WeaponSkillQuest Property MyQuestScript Auto Const
Faction Property CurrentCompanionFaction Auto Const
bool enemyHitByPlayer = False
Form deathSource 

Event OnEffectStart (Actor akTarget, Actor akCaster)
	Debug.Trace("OnEffectStart()")
	Player = Game.GetPlayer()
	RegisterForHitEvent(akTarget, Player)
	thisActorBase = akTarget.GetActorBase()
	thisActorRace = akTarget.GetRace()
	thisActorLevel = akTarget.GetLevel()
	MyQuestScript.TraceAndNotify("\n" + thisActorBase + " Registered For Hits" + "\n" + thisActorRace + "\n" + "Level " + thisActorLevel + "\n" , True)
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
    bool abBashAttack, bool abHitBlocked, string asMaterialName)
	MyQuestScript.TraceAndNotify("OnHit()", True)
	deathSource = akSource
	if !enemyHitByPlayer 
		if akAggressor == player ;akAgressor is whoever hit the enemy
			enemyHitByPlayer = True
			Debug.Trace ("Player hit the target.")
		EndIf
	endif
	if MyQuestScript.isAutomatic || MyQuestScript.isMinigun
		Utility.Wait(0.33)
	EndIf
	RegisterForHitEvent(akTarget, Player)
	MyQuestScript.HitInformation(akSource, abSneakAttack, abBashAttack, abHitBlocked)
	MyQuestScript.EnemyHitReward (akSource)
	MyQuestScript.TraceAndNotify(" " + thisActorBase + " is Level " + thisActorLevel, True)
EndEvent

Event OnDying(Actor akKiller)	
    bool CompanionKill = akKiller.IsInFaction(CurrentCompanionFaction)
    if !enemyHitByPlayer && !CompanionKill ;For those weird instances where the killer is the player, but doesn't work. This gets around the weird game event where if the companion kills the enemy the player is also counted as the killer
    	if akKiller == player
    		enemyHitByPlayer = True
    	endif
    EndIf
    if  CompanionKill || enemyHitByPlayer
        bool assist = enemyHitByPlayer && akKiller != Player || CompanionKill && !enemyHitByPlayer ; 
        MyQuestScript.EnemyKillCounter(thisActorRace, thisActorBase, enemyHitByPlayer)
        MyQuestScript.EnemyKillReward(thisActorLevel, thisActorBase, deathsource, assist) ;assist is a bool, true give assist xp within func, false give full xp
        Debug.Trace("" + thisActorBase + " was killed by " + akKiller)
    EndIf
EndEvent

