extends Node

var player
var state_machine

func enter():
	pass
	#player.anim.play("idle")
   
func handle_input(event):
	if event.is_action_pressed("RightMove") or event.is_action_pressed("LeftMove"):
		state_machine.change_state("WalkState")
		
	if !player.is_can_grow():
		return
		
	if event.is_action_pressed("GrowUp"):
		state_machine.change_state("ChargeState")
	elif event.is_action_pressed("GrowRight"):
		state_machine.change_state("ChargeState")
	elif event.is_action_pressed("GrowLeft"):
		state_machine.change_state("ChargeState")

func update(delta):
	pass

func exit():
	pass
