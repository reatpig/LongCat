extends Node

var player
var state_machine

var charge_time := 0.0
var max_charge_time := 3.0

func enter():
	charge_time = 0.0
	player.tilemap.clear()
	player.charge_timer.start()
	player.is_charging = true

func exit():
	player.is_charging = false
	player.charge_timer.stop()
	var block_count = calc_block_count(charge_time)
	build_block_chain(block_count)

func update(delta):
	charge_time = clamp(charge_time + delta, 0, max_charge_time)

func handle_input(event):
	if event.is_action_released("special"):
		state_machine.change_state("IdleState")

func calc_block_count(t: float) -> int:
	return clamp(int(t * 4) + 2, 2, 10)

func build_block_chain(block_count: int):
	var tilemap = player.tilemap
	tilemap.clear()

	var start_id = 0
	var mid_id = 1
	var end_id = 2

	# Рисуем горизонтальную линию блоков
	for i in range(block_count):
		var tile_id = mid_id
		if i == 0:
			tile_id = start_id
		elif i == block_count - 1:
			tile_id = end_id
		tilemap.set_cell(0, Vector2i(i, 0), 0, Vector2i(tile_id, 0))

	# Обновляем коллизию
	tilemap.update_internals()
