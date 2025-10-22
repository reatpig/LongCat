extends Node

var current_state = null
var states = {}

func init(player):
	for child in get_children():
		if "enter" in child and "exit" in child:
			states[child.name] = child
			child.player = player
			child.state_machine = self
	change_state("IdleState")

func change_state(new_state_name: String):
	if current_state:
		current_state.exit()
	current_state = states.get(new_state_name)
	if current_state:
		current_state.enter()

func handle_input(event):
	if current_state and "handle_input" in current_state:
		current_state.handle_input(event)

func update(delta):
	if current_state and "update" in current_state:
		current_state.update(delta)
