extends "res://Elements/Enemy/base_enemy.gd"

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	super._physics_process(delta)
	
