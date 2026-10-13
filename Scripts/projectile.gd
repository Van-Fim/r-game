extends Area2D
class_name TowerProjectile

var target
var speed = 4000.0
var damage = 50
var direction = Vector2.ZERO
var is_ready:bool = false
@onready var trail = $Line2D # Предполагаем, что Line2D добавлен в сцену снаряда

func _ready():
	# Настраиваем линию: убираем ширину, чтобы она была аккуратной, 
	# и ставим антиалиасинг (в инспекторе или тут)
	trail.width = 2.0
	trail.default_color = Color(1, 1, 1, 0.8) # Белый полупрозрачный

func _process(delta: float) -> void:
	if not is_ready:
		pass
	if not is_instance_valid(target):
		queue_free()
		return

	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta
	
	# Обновляем хвост: добавляем текущую позицию в начало линии
	# Чтобы хвост оставался в мире, а не двигался вместе со снарядом,
	# нам нужно переносить точки линии в глобальные координаты
	trail.global_position = Vector2.ZERO # Обнуляем позицию самого узла Line2D
	
	# Добавляем новую точку в конец списка точек Line2D
	trail.add_point(global_position)
	
	# Ограничиваем длину хвоста, чтобы он не рос бесконечно
	if trail.points.size() > 10:
		trail.remove_point(0)


func _on_enemyarea_entered(enemy: Area2D) -> void:
	if enemy.is_in_group("enemies"):
		GameManager.enemy_take_damage_event.emit(enemy, damage)
		queue_free()
		return
