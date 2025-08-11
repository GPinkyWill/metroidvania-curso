extends Node2D

const EnemyDeathEffectScene = preload("res://Effects/enemy_death_effect.tscn")

@onready var floor_cast: RayCast2D = $FloorCast
@onready var wall_cast: RayCast2D = $WallCast
@onready var stats: Stats = $Stats
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var state = crawling_state
var gravity = 100
var max_speed = 100
enum DIRECTION {LEFT = -1, RIGHT = 1}

@export var crawling_direction = DIRECTION.RIGHT
@export var spin_speed = 1200

func _ready() -> void:
	wall_cast.target_position.x *= crawling_direction

func _physics_process(delta: float) -> void:
	state.call(delta)

func crawling_state(delta):
	if wall_cast.is_colliding():
		global_position = wall_cast.get_collision_point()
		var wall_normal = wall_cast.get_collision_normal()
		rotation = wall_normal.rotated(deg_to_rad(90)).angle()
	else:
		floor_cast.rotation_degrees = -max_speed * crawling_direction * delta
		
		var while_limit = 30
		
		while !floor_cast.is_colliding():
			rotation_degrees += crawling_direction
			floor_cast.force_raycast_update()
			while_limit -= 1
			if while_limit <= 0:
				state = falling_state
				break
		
		
		if floor_cast.is_colliding():
			
			global_position = floor_cast.get_collision_point()
			var floor_normal = floor_cast.get_collision_normal()
			rotation = floor_normal.rotated(deg_to_rad(90)).angle()
	
	
	
	
func falling_state(delta):
	animated_sprite_2d.play("fall")
	rotation_degrees += crawling_direction * spin_speed * delta
	position.y += gravity * delta
	if floor_cast.is_colliding() or wall_cast.is_colliding():
		state = crawling_state
		animated_sprite_2d.play("crawl")


func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	stats.health -= damage


func _on_stats_no_health() -> void:
	var displacement = global_position - Vector2(0,8).rotated(rotation)
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, displacement)
	queue_free()
