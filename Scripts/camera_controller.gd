extends Camera2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var zoom_speed := 0.01
var zoom_value := 0.0
var min_zoom := 0.04
var max_zoom := 0.4

func _ready():
	pass

var shake_duration = 0.5
var shake_intensity = 20.0
var shake_timer = 0.0

func shake():
	shake_timer = shake_duration

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		offset.x = randf_range(-shake_intensity, shake_intensity)
		offset.y = randf_range(-shake_intensity, shake_intensity)
	else:
		offset = Vector2.ZERO
	zoom_value = clamp(zoom_value, min_zoom, max_zoom)
	zoom = Vector2(zoom_value, zoom_value)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom_value += zoom_speed
		zoom_value = clamp(zoom_value, min_zoom, max_zoom)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom_value -= zoom_speed
		zoom_value = clamp(zoom_value, min_zoom, max_zoom)
	zoom = Vector2(zoom_value, zoom_value)
