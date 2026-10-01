extends Node2D

var speed = 500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.enemy_killed_event.connect(_on_killed_event)

func _on_killed_event(node):
	if node != self:
		return
	LevelSpawner.active_enemies.erase(self)
	queue_free()
	if LevelSpawner.active_enemies.size() == 0:
		GameManager.all_enemies_are_killed.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameManager.base:
		pass
	var direction = (GameManager.base.global_position - global_position).normalized()
	global_position += direction * speed * delta

func _on_area_entered(body):
	if body.name == "Base":
		GameManager.camera.shake()
		GameManager.enemy_killed_event.emit(self)
