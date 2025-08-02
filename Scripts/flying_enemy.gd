extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@export var acceleration = 100
@export var max_speed = 80
@export var player_path : NodePath

@export var distance_to_fly = 200


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var stats: Stats = $Stats
@onready var way_point_pathfinding: Node2D = $WayPointPathfinding
@onready var chase_timer: Timer = $ChaseTimer
@onready var spawn_marker: Marker2D = $Spawn_Marker

var can_chase = false

func _physics_process(delta: float) -> void:
	var player = MainInstances.player
	if player is CharacterBody2D and can_chase:
		move_toward_position(way_point_pathfinding.pathfinding_next_position, delta)



func move_toward_position(target_position, delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	animated_sprite_2d.flip_h = global_position < target_position
	
	move_and_slide()

func fly_around():
	pass


func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	stats.health -= damage


func _on_stats_no_health() -> void:
	Utils.instantiate_scene_on_world(EnemyDeathEffect, global_position)
	queue_free()



func _on_vision_range_body_entered(body: Node2D) -> void:
	if !body == MainInstances.player: return
	if !way_point_pathfinding.can_see_target: return
	can_chase = true

func _on_vision_range_body_exited(body: Node2D) -> void:
	if !body == MainInstances.player: return
	chase_timer.start()


func _on_chase_timer_timeout() -> void:
	can_chase = false
