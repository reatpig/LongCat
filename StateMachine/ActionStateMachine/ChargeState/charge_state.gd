extends Node
@export var wall_collision_mask: int = 1

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

	# player.tilemap.clear() # Это был дубликат, он не нужен

	var alt := 0
	var dir := 1
	var level := 0
	
	var new_form_state
	new_form_state = player.FORM_STATE.WIDE
	if build_direction == BUILD_DIRECTION.LEFT:
		alt = 0 | TileSetAtlasSource.TRANSFORM_FLIP_H
		dir = -1
		
	if build_direction == BUILD_DIRECTION.UP:
		level = 1
		dir = 0
		new_form_state = player.FORM_STATE.LONG
		
	# --- Начало изменений: Настройка проверки коллизий ---
	
	# Получаем доступ к физическому 2D-пространству
	var space_state = get_viewport().get_world_2d().direct_space_state
	
	# Создаем форму для проверки (размером с один тайл)
	var tile_size = tilemap.tile_set.tile_size
	var query_shape = RectangleShape2D.new()
	query_shape.size = tile_size
	
	# Настраиваем параметры запроса
	var query_params = PhysicsShapeQueryParameters2D.new()
	query_params.shape = query_shape
	query_params.collision_mask = wall_collision_mask # Используем нашу маску стен
	# Исключаем самого игрока из проверки, чтобы он не столкнулся сам с собой
	query_params.exclude = [player.get_rid()] 

	var actual_blocks_placed = 0
	var last_placed_cell = Vector2i.ZERO
	# --- Конец изменений: Настройка ---

	# Рисуем линию блоков
	for i in range(block_count):
		var local_cell = Vector2i(dir*i, -i * level)
		
		# --- Начало изменений: Проверка на стену ---
		
		# Находим глобальную позицию центра ячейки, которую хотим поставить
		# Мы используем to_global, чтобы получить мировые координаты
		var global_pos_center = tilemap.to_global(tilemap.map_to_local(local_cell))
		
		# Устанавливаем позицию для нашего физического запроса
		query_params.transform = Transform2D(0, global_pos_center)
		
		# Выполняем запрос: есть ли пересечение?
		var collision_result = space_state.intersect_shape(query_params)
		
		# Если результат НЕ пустой (т.е. мы с чем-то столкнулись)
		if not collision_result.is_empty():
			break # Прекращаем цикл, мы уперлись в стену
			
		# --- Конец изменений: Проверка на стену ---

		# Стены нет, можно ставить тайл
		var tile_id = mid_id
		if i == 0:
			tile_id = start_id
			
		tilemap.set_cell(local_cell, 0, Vector2i(tile_id, level), alt)
		
		actual_blocks_placed += 1
		last_placed_cell = local_cell # Запоминаем последнюю *успешно* поставленную ячейку

	# --- Цикл завершен (либо досрочно, либо полностью) ---

	# Если мы не поставили ни одного блока (стена была прямо перед нами)
	if actual_blocks_placed == 0:
		# player.change_state(player.FORM_STATE.DEFAULT, Vector2i.ZERO) # Опционально: вернуться в состояние по умолчанию
		tilemap.update_internals()
		# Нужно, чтобы и коллизия обновилась до нуля
		player.change_state(player.FORM_STATE.NORMAL, Vector2i.ZERO) 
		return # Выходим

	if actual_blocks_placed == 1:
		player.set_defualt_body()
		return
	# Если мы поставили больше одного блока, 
	# нужно заменить последний (который был 'mid_id') на 'end_id'
	if actual_blocks_placed > 1:
		tilemap.set_cell(last_placed_cell, 0, Vector2i(end_id, level), alt)

	# Меняем состояние игрока, передавая *фактические* координаты последнего блока
	player.change_state(new_form_state, last_placed_cell)
	
	# Обновляем коллизию
	tilemap.update_internals()
