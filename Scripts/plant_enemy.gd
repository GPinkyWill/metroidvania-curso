extends Node2D


const EnemyBulletScene = preload("res://Scenes/Enemies/enemy_bullet.tscn")

@export var bullet_speed = 30
@export var spread = 45

@onready var stats: Stats = $Stats
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var fire_direction: Marker2D = $FireDirection


func fire_bullet():
	var bullet = Utils.instantiate_scene_on_world(EnemyBulletScene, bullet_spawn_point.global_position) as Projectile
	var direction = global_position.direction_to(fire_direction.global_position)
	bullet.rotation = direction.angle()
	bullet.rotate(randf_range(-deg_to_rad(spread/2), deg_to_rad(spread/2)))
	bullet.speed = bullet_speed
	bullet.update_velocity()

func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	stats.health -= damage


func _on_stats_no_health() -> void:
	queue_free()
