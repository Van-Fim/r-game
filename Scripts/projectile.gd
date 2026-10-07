extends Area2D
class_name TowerProjectile # Это позволяет Godot знать, что это за тип объекта

var target
var speed = 2000.0
var direction = Vector2.ZERO

func _process(delta: float) -> void:
	if !target:
		pass
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta
