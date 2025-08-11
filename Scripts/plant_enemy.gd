extends Node2D


const EnemyBulletScene = preload("res://Scenes/Enemies/enemy_bullet.tscn")
const EnemyDeathEffectScene = preload("res://Effects/enemy_death_effect.tscn")

@export var bullet_speed = 30
@export var spread = 45

@onready var stats: Stats = $Stats
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var fire_direction: Marker2D = $FireDirection


func fire_bullet():
	#Sem acessar a função update_velocity do projectile não ocorre a rotação do sprite do tiro da planta
	#Isso significa que é possível alterar a velocidade sem entrar na função que também altera a rotação da sprite
	var bullet = Utils.instantiate_scene_on_level(EnemyBulletScene, bullet_spawn_point.global_position) as Projectile
	var direction = global_position.direction_to(fire_direction.global_position)
	var velocity = direction.normalized() * bullet_speed
	velocity = velocity.rotated(randf_range(-deg_to_rad(spread/2), deg_to_rad(spread/2)))
	bullet.velocity = velocity

func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	stats.health -= damage


func _on_stats_no_health() -> void:
	var displacement = global_position - Vector2(0,8).rotated(rotation)
	Utils.instantiate_scene_on_level(EnemyDeathEffectScene, displacement)
	queue_free()
