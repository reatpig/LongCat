extends AnimatableBody2D

@onready var right_ray := $RightRay
@onready var left_ray := $LeftRay
@onready var sprite := $AnimatedSprite2D
var direction := Vector2(1,0) 
const SPEED := 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if right_ray.is_colliding():
		sprite.flip_h = true
		direction = Vector2(-1,0)
	elif left_ray.is_colliding():
		sprite.flip_h = false
		direction = Vector2(1,0)
		
	move_and_collide(direction * SPEED * delta)
	pass
