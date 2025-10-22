extends Node

var player
var state_machine

func enter():
	pass
	#player.anim.play("idle")
   
func handle_input(event):
	if event.is_action_pressed("RightMove") or event.is_action_pressed("LeftMove"):
		state_machine.change_state("WalkState")
		
	if event.is_action_pressed("GrowRight") or event.is_action_pressed("GrowLeft") or (event.is_action_pressed("GrowUp") and player.is_on_floor()):
		if player.current_form_state == player.FORM_STATE.NORMAL:
			state_machine.change_state("ChargeState")
		else:
			player.set_defualt_body()	
			
func update(delta):
	pass

func exit():
	pass
