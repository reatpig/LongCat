extends Node

var player 
var state_machine
var lastDirection: float
func enter():
	pass
	#player.anim.play("run")

func update(delta):
	var speed = player.SPEED
	
	if not player.is_on_floor():
		speed /= 2
		
	var direction := Input.get_axis("LeftMove", "RightMove")
	lastDirection = direction
	if direction:
		player.velocity.x = direction * speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
		  
	#if direction == 0:
		#state_machine.change_state("IdleState")w
	  
func handle_input(event):
	if event.is_action_pressed("GrowRight") or event.is_action_pressed("GrowLeft") or (event.is_action_pressed("GrowUp") and player.is_on_floor()):
		if player.current_form_state == player.FORM_STATE.NORMAL:
			state_machine.change_state("ChargeState")
		else:
			player.set_defualt_body()	
	
func exit():
	pass
