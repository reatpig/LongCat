extends Node

var player
var current_state
var states = {}

func init(p):
	player = p
	for child in get_children():
		if "enter" in child:
			child.player = player
			child.state_machine = self
			states[child.name] = child
	change_state("IdleState")

func change_state(name):
	if current_state:
		current_state.exit()
	current_state = states[name]
	if current_state:
		current_state.enter()
