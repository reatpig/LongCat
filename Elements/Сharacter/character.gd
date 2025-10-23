extends CharacterBody2D


var SPEED := 100.0

#TODO to another node
enum FORM_STATE {NORMAL, LONG, WIDE}
var current_form_state := FORM_STATE.NORMAL
var end_form_coords := Vector2i(0,0)

@export var end_form_velocity = 250

@onready var current_form = $Form
@onready var state_machine = $ActionStateMachine
@onready var tilemap = $BodyMap
@onready var collision_shape = $CollisionShape2D
#@onready var anim = $AnimationPlayer
@onready var charge_timer = $ChargeTimer

func set_defualt_body() -> void:
	tilemap.clear()
	tilemap.set_cell(Vector2i(0, 0),0, Vector2i(0,0), 0)
	tilemap.update_internals()
	change_state(FORM_STATE.NORMAL, Vector2i(0,0))
	SPEED = 100

func _ready() -> void:
	set_defualt_body()
	state_machine.init(self)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	state_machine.update(delta)
	move_and_slide()
	
func _input(event):
	if event.is_action_released("GrowMode"):
		set_defualt_body()
	state_machine.handle_input(event)

func is_can_grow() -> bool:
	return current_form_state == FORM_STATE.NORMAL
		
func change_state (new_state: FORM_STATE, end_coords := Vector2i(0,0)):
	var tile_size = tilemap.physics_quadrant_size
	#В конце удлинения передвигаем кота в конец
	if new_state == FORM_STATE.NORMAL:
		position += Vector2(end_form_coords) * tile_size
		if current_form_state == FORM_STATE.LONG:
			velocity.y -= end_form_velocity
		#elif current_form_state == FORM_STATE.WIDE:
		#	if end_form_coords.x > 0:
		#		velocity.x += end_form_velocity
		#	else:
		#		velocity.x -= end_form_velocity
	if new_state == FORM_STATE.WIDE:
		SPEED = 200.0
	if new_state == FORM_STATE.LONG:
		SPEED = 50.0
	current_form_state = new_state
	end_form_coords = end_coords
	calculate_collision()
	
func calculate_collision () -> void:
	var tile_size = tilemap.physics_quadrant_size
	
	var y = abs(end_form_coords.y)
	var x = abs(end_form_coords.x)
	
	var new_shape = collision_shape.shape
	new_shape.size = Vector2((x + 1) * tile_size, (y + 1) * tile_size)
	collision_shape.position = Vector2(tile_size, tile_size)/2. + end_form_coords/2. * tile_size
