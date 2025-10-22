extends Node

var player
var state_machine

var charge_time := 0.0
var max_charge_time := 3.0
enum BUILD_DIRECTION {UP, LEFT, RIGHT}
var build_direction: BUILD_DIRECTION
var extern_grow := false

const MAX_BLOCKS_COUNT := 7
func enter():
	player.velocity = Vector2(0,0)
	charge_time = 0.0
	player.charge_timer.start()

func exit():
	player.charge_timer.stop()
	var block_count = calc_block_count(charge_time)
	if extern_grow:
		block_count = MAX_BLOCKS_COUNT
		extern_grow = false
	build_block_chain(block_count)

func update(delta):
	charge_time = clamp(charge_time + delta, 0, max_charge_time)

func handle_input(event):
	
	if event.is_action_released("GrowRight"):
		if event.is_action_pressed("GrowMode"):
			extern_grow = true
		build_direction = BUILD_DIRECTION.RIGHT
		state_machine.change_state("IdleState")
	elif event.is_action_released("GrowLeft"):
		if event.is_action_pressed("GrowMode"):
			extern_grow = true
		build_direction = BUILD_DIRECTION.LEFT
		state_machine.change_state("IdleState")
	elif event.is_action_released("GrowUp"):
		if event.is_action_pressed("GrowMode"):
			extern_grow = true
		build_direction = BUILD_DIRECTION.UP
		state_machine.change_state("IdleState")
		

func calc_block_count(t: float) -> int:
	return clamp(int(t * 10) + 2, 2, MAX_BLOCKS_COUNT)

func build_block_chain(block_count: int):
	var tilemap = player.tilemap
	tilemap.clear()

	var start_id = 1
	var mid_id = 2
	var end_id = 3

	player.tilemap.clear()
	
	var alt := 0
	var dir := 1
	var level := 0
	
	
	if build_direction == BUILD_DIRECTION.LEFT:
		alt = 0 | TileSetAtlasSource.TRANSFORM_FLIP_H
		dir = -1;
		
	var new_form_state 
	new_form_state = player.FORM_STATE.WIDE
	if build_direction == BUILD_DIRECTION.UP:
		level = 1
		dir = 0
		new_form_state = player.FORM_STATE.LONG
		
	# Рисуем горизонтальную линию блоков
	for i in range(block_count):
		var tile_id = mid_id
		if i == 0:
			tile_id = start_id
		elif i == block_count - 1:
			tile_id = end_id
		tilemap.set_cell( Vector2i(dir*i, -i * level), 0, Vector2i(tile_id, level), alt)

	var last_i = (block_count-1)
	player.change_state(new_form_state, Vector2i(dir*last_i, -last_i * level) )
	
	# Обновляем коллизию
	tilemap.update_internals()
