extends Area2D
@export var range:int
@export var tower_sprites: Array[Sprite2D] = []
var animationPlayer:AnimationPlayer
func collect_sprites():
	tower_sprites.clear() # Очищаем старый список
	# Проходим по всем дочерним объектам и добавляем те, что являются Sprite2D
	for child in get_children():
		if child is Sprite2D:
			tower_sprites.append(child)
func _ready() -> void:
	collect_sprites()
	animationPlayer = get_node("ANIM01")

func init():
	animationPlayer.play("spin")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
