
Actor player = Game.GetPlayer()
Float xStart
Float yStart
Float zStart
Float xEnd
Float yEnd
Float zEnd


Event OnInit() ; change this to whatever trigger event you want "Event OnTakeDump(Toilet aktarget) or whatever
	LoopWhole()
EndEvent

Function LoopWhole()
	StartTimer(19, 1)
	if afInterval == 1
    	xStart = Game.GetPlayer().GetPositionX()
    	yStart = Game.GetPlayer().GetPositionY()
    	zStart = Game.GetPlayer().GetPositionZ()
	Elseif afInterval == 10
    	xEnd = Game.GetPlayer().GetPositionX()
    	yEnd = Game.GetPlayer().GetPositionY()
    	zEnd = Game.GetPlayer().GetPositionZ()
	EndIf
EndFunction

Event OnTimer(int aiTimerID)
	if aiTimerID == 1
    	LoopWhole()
	EndIf
EndEvent


function LoopWhole()
    Actor player = Game.GetPlayer()
    StartTimer(19, 1)

    if afInterval == 1
        a = player.GetPositionX()
        b = player.GetPositionY()
        c = player.GetPositionZ()
    Elseif afInterval == 10
        player.GetPositionX()
        player.GetPositionY()
        player.GetPositionZ()
    EndIf
EndFunction


Function Sqrt ()

EndFunction

{3:41 AM - Rizhall: and maybe also
3:41 AM - Rizhall: calculate every time a new button is pressed or released?
3:42 AM - Rizhall: that way you won',t have to returning to original position problem}

function MyFunction()
     Math.sqrt(4.0)
endfunction

skillExpForLvUp + (currentSkillLv * skillExpForLvUp)

ExpToNextLevel = (1 + CurrentSkill) * LinearIncrease