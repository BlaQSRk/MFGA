Scriptname RegirGrenadeTokenEffectScript extends activemagiceffect

Quest Property pGrenadeQuest Auto Const

Event OnEffectStart()
	pGrenadeQuest.SetStage(20)
EndEvent