Scriptname RegirAddPerksScript extends Quest

Perk Property aaaRegirMoleratTokenPerk Auto Const

Event OnInit()
	Game.GetPlayer().AddPerk(aaaRegirMoleratTokenPerk)
	Debug.Notification("Perks successfully added to player.") ;Test For Perk Addition
EndEvent