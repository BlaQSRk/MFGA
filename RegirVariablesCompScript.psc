Scriptname RegirVariablesCompScript extends ObjectReference Const
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Input: None
;
;This event will be called at the beginning of existence and will perform variable comparison tasks.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Event OnInit()
	;Integer values
	Int ob1 = 1
	Int ob2 = 2
	Int ob3 = 1

	Bool test = True

	if (ob1 == 1)
		Debug.Notification ("ob1 is equal to 1")
	EndIf

	if (ob2 == ob3)
		Debug.Notification("ob2 is equal to ob3")
	Else
		Debug.Notification("ob2 is not equal to ob3")
	EndIf
EndEvent


Event OnInit()
	Debug.Notification("You killed someone with a pistol!")
EndEvent	