extends Node

var player
var state_machine
var lastDirection: float
func enter():
	pass
	#player.anim.play("run")

func update(delta):
	var direction := Input.get_axis("LeftMove", "RightMove")
	lastDirection = direction
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		
	#if direction == 0:
		#state_machine.change_state("IdleState")
	  
func handle_input(event):
	
	if event.is_action_pressed("GrowUp"):
		state_machine.change_state("ChargeState")
		

	if !player.is_can_grow():
		return
		
	elif event.is_action_pressed("GrowRight"):
		state_machine.change_state("ChargeState")
	elif event.is_action_pressed("GrowLeft"):
		state_machine.change_state("ChargeState")
		
func exit():
	pass
