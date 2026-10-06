extends Node
var currentLevel = 1
var data
var active_enemies: Array[Node2D] = []

# Предположим, этот код вызывается при старте волны или по нажатию кнопки
func start_wave_countdown(time):
	# Создаем таймер и сохраняем ссылку на него
	var timer = get_tree().create_timer(time)
	
	# Пока таймер работает (его оставшееся время больше 0)
	while timer.time_left > 0:
		# Округляем до целых секунд вверх (ceil) или вниз (int)
		var seconds_left = ceil(timer.time_left)
		GameManager.timer.text = "%02d" % seconds_left
		
		# Ждем ровно 1 секунду перед следующим обновлением текста
		await get_tree().create_timer(1.0).timeout
	
	# Действие по окончании таймера
	GameManager.timer.text = ""
	_on_timer_finished()

func _on_timer_finished():
	print("wave %02d started"% currentLevel)
	
	for st in range(0, data.steps):
		var std = data.step_duration
		for stcfg in data.step_configs:
			if int(stcfg.start_step) > st+1 || int(stcfg.end_step) < st+1:
				std = data.step_duration
				continue
			std = stcfg.step_duration
			break
		await get_tree().create_timer(std).timeout
		for enemy in data.enemies:
			if int(enemy.start_spawn_step) > st+1 || int(enemy.end_spawn_step) < st+1:
				continue
			for v in range(0, enemy.count):
				spawn_enemy(enemy.name)

func _ready():
	GameManager.all_enemies_are_killed.connect(on_all_enemies_are_killed)
	start_level(1)

func on_all_enemies_are_killed():
	currentLevel += 1
	start_level(currentLevel)

func start_level(level):
	currentLevel = level
	data = read_config("res://Configs/Levels/level"+str(currentLevel)+".json")
	if data == null:
		return
	print("wave %02d starts"% currentLevel)
	start_wave_countdown(data.duration)


func read_config(file_path):
	var rdata = null
	if FileAccess.file_exists(file_path):
		var json_text = FileAccess.get_file_as_string(file_path)
		var json = JSON.new()
		var error = json.parse(json_text)
	
		if error == OK:
			rdata = json.data
		else:
			print("JSON Error: ", json.get_error_message())
			print("At line: ", json.get_error_line())
	else:
		print("File does not exist: ", file_path)

	return rdata


func spawn_enemy(enemy_name:String):
	var enemy:Node2D = load("res://Objects/Enemies/"+ enemy_name +".tscn").instantiate()
	add_child(enemy)
	var radius = 15000
	var angle = randf() * 2 * PI
	enemy.position = Vector2(radius * cos(angle), radius * sin(angle))
	enemy.look_at(GameManager.base.global_position)
	active_enemies.append(enemy)

func _process(delta):
	pass
