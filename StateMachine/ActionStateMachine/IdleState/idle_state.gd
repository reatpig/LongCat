extends Node

var player
var state_machine

func enter():
	pass

func exit():
	pass

func handle_input(event):
	
	if event.is_action_pressed("special"):
		state_machine.change_state("ChargeState")
