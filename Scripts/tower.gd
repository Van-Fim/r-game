extends Area2D
@export var projectileName:String
@export var turret_sprite:Sprite2D
@export var tower_sprites: Array[Sprite2D] = []
@export var tower_range:Sprite2D
@export var detection_area:Area2D
@export var detection_shape:CollisionShape2D
@export var fire_rate = 1.0 # Выстрел раз в секунду
var fire_timer = 0.0
var target = null
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
	recolor(Color(1,1,1,1))
	animationPlayer.play("spin")

func recolor(newColor:Color):
	for sp:Sprite2D in tower_sprites:
		if sp.name == "tower_range":
			newColor.a = newColor.a * 0.03
		if sp.name == "turret":
			newColor.a = 1
		sp.modulate = newColor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var texture_size = tower_range.texture.get_size()
	var size = texture_size.x/2
	# Предположим, detection_shape — это ваш узел CollisionShape2D
	var shape_res = detection_shape.shape
	shape_res.radius = size
	find_target()
	if target:
		var target_pos = target.global_position
		var direction = (target_pos - turret_sprite.global_position).normalized()
		var target_angle = direction.angle()

		# rotate_toward позволяет избежать резких скачков
		turret_sprite.rotation = rotate_toward(turret_sprite.rotation, target_angle, 5.0 * delta)
	fire_timer += delta
	if target and fire_timer >= fire_rate:
		shoot(target)
		fire_timer = 0.0

func shoot(shotTarget):
	var projectile_scene = load("res://Objects/Projectiles/" + projectileName + ".tscn")
	var projectile = projectile_scene.instantiate()
	projectile.target = target
	# Устанавливаем позицию снаряда в позицию башни
	projectile.global_position = global_position
	
	# Направляем снаряд в сторону цели (куда смотрит ствол)
	var dir = (shotTarget.global_position - global_position).normalized()
	projectile.direction = dir
	
	# Добавляем снаряд в корень сцены, чтобы он не двигался вместе с башней
	BuildManager.sceneNode.add_child(projectile)

func find_target():
	var enemies = detection_area.get_overlapping_areas()
	var closest_enemy = null
	var min_dist = INF

	for enemy in enemies:
		# Проверяем, является ли объект врагом (например, по группе "enemies")
		if enemy.is_in_group("enemies"):
			var dist = global_position.distance_to(enemy.global_position)
			if dist < min_dist:
				min_dist = dist
				closest_enemy = enemy

	target = closest_enemy
