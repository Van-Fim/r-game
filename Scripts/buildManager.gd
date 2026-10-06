extends Node2D

var current_ghost_tower = null
var tower_scene = null
var current_tower_path: String
var sceneNode:Node2D

func _ready() -> void:
	var main_node = get_tree().current_scene
	sceneNode = main_node.get_node("/root/MAIN")

func start_building(tower_name: String):
	# Загружаем сцену башни
	current_tower_path = "res://Objects/Towers/" + tower_name + ".tscn"
	tower_scene = load(current_tower_path).instantiate()
	
	# Отключаем коллизии у призрака, чтобы он не мешал кликам
	# Например, через set_collision_layer или просто удалив CollisionShape
	
	add_child(tower_scene)
	current_ghost_tower = tower_scene

func _process(delta):
	if current_ghost_tower:
		var mouse_pos = get_viewport().get_mouse_position()
		var world_pos = get_canvas_transform().affine_inverse() * mouse_pos
		
		# Привязка к сетке 64x64
		var snapped_x = round(world_pos.x / 64.0) * 64.0
		var snapped_y = round(world_pos.y / 64.0) * 64.0
		# Если игра 2D, конвертируем экранные координаты в мировые
		current_ghost_tower.global_position = Vector2(snapped_x, snapped_y)
		var overlapping_areas = current_ghost_tower.get_overlapping_areas()
		if overlapping_areas.size() > 0:
			current_ghost_tower.recolor(Color(1,0,0,0.35))
		else:
			current_ghost_tower.recolor(Color(1,1,1,0.35))

func place_tower():
	if current_ghost_tower:
		var overlapping_areas = current_ghost_tower.get_overlapping_areas()

		if overlapping_areas.size() > 0:
			print("Здесь уже что-то построено!")
			return # Прерываем функцию, башня не создается

		# Здесь логика финальной установки (например, проверка на препятствия)
		# Создаем полноценную башню в этой позиции
		var pos = current_ghost_tower.global_position
		var tower_scene = load(current_tower_path) 
		var real_tower = tower_scene.instantiate()
		real_tower.global_position = pos
		sceneNode.add_child(real_tower)
		real_tower.init()
		# ... логика добавления на карту ...
		
		# Удаляем призрака
		current_ghost_tower.queue_free()
		current_ghost_tower = null

func _input(event):
	# Проверяем, был ли клик левой кнопкой мыши
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if current_ghost_tower:
				place_tower()
