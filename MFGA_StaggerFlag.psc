Scriptname MFGA_StaggerFlag extends activemagiceffect
MFGA_WeaponSkillQuest Property MyQuestScript Auto Const

Event OnEffectStart(Actor akTarget, Actor akCaster)
    MyQuestScript.TraceAndNotify("Stagger!")
EndEvent