extends CharacterBody2D

const SPEED = 300.0
const SECOND_FOR_ONE_SEGMENT = 1

enum CHARACTER_STATE {}
@onready var GrowTimer = $GrowTimer

@export var sprite: Sprite2D
@export var collision: CollisionShape2D

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("GrowLeft"):
		GrowTimer.start()
	
	if Input.is_action_just_released():
		var segment_count = GrowTimer.time_left / SECOND_FOR_ONE_SEGMENT
		
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("LeftMove", "RightMove")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
