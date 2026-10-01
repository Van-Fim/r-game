extends Node
var base:Node2D
var camera:Camera2D
var timer:Label
signal enemy_killed_event(node)
signal all_enemies_are_killed()
func _ready():
	var main_node = get_tree().current_scene
	camera = main_node.get_node("/root/MAIN/Camera")
	timer = main_node.get_node("/root/MAIN/CanvasLayer2/Timer")
	spawn_base()

func spawn_base():
	base = preload("res://Objects/base.tscn").instantiate()
	add_child(base)
	base.position = Vector2.ZERO
