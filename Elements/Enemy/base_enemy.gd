extends CharacterBody2D

@onready var right_ray := $RightRay
@onready var left_ray := $LeftRay
@onready var sprite := $AnimatedSprite2D
var direction := Vector2(1,0) 
const SPEED := 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if right_ray.is_colliding():
		sprite.flip_h = true
		direction = Vector2(-1,0)
	elif left_ray.is_colliding():
		sprite.flip_h = false
		direction = Vector2(1,0)
	velocity.x = direction.x * SPEED ;
	move_and_slide()
