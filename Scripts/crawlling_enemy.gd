extends Node2D

const EnemyDeathEffectScene = preload("res://Effects/enemy_death_effect.tscn")

@onready var floor_cast: RayCast2D = $FloorCast
@onready var wall_cast: RayCast2D = $WallCast
@onready var stats: Stats = $Stats

var max_speed = 100
enum DIRECTION {LEFT = -1, RIGHT = 1}

@export var crawling_direction = DIRECTION.RIGHT


func _ready() -> void:
	wall_cast.target_position.x *= crawling_direction

func _physics_process(delta: float) -> void:
	if wall_cast.is_colliding():
		global_position = wall_cast.get_collision_point()
		var wall_normal = wall_cast.get_collision_normal()
		rotation = wall_normal.rotated(deg_to_rad(90)).angle()
	else:
		floor_cast.rotation_degrees = -max_speed * crawling_direction * delta
		if floor_cast.is_colliding():
			global_position = floor_cast.get_collision_point()
			var floor_normal = floor_cast.get_collision_normal()
			rotation = floor_normal.rotated(deg_to_rad(90)).angle()
		else:
			rotation_degrees += crawling_direction


func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	stats.health -= damage


func _on_stats_no_health() -> void:
	var displacement = global_position - Vector2(0,8).rotated(rotation)
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, displacement)
	queue_free()
