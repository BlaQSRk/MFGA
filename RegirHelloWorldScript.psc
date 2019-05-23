Scriptname RegirHelloWorldScript extends ObjectReference Const

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Inputs: None
;
;This event runs at the beginning of your save game
;Purpose is to display a message box saying "Hello World!"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Event OnInit()
	;Display Hello World
	Debug.MessageBox("Hello World!")
EndEvent

