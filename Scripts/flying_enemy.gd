extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@export var acceleration = 100
@export var speed = 25
@export var max_speed = 80
@export var distance_to_fly = 40


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var stats: Stats = $Stats
@onready var way_point_pathfinding: Node2D = $WayPointPathfinding
@onready var chase_timer: Timer = $ChaseTimer
@onready var back_to_spawn_timer: Timer = $BackToSpawnTimer


var time_to_go_back_to_spawn = false

var spawn_marker : Vector2

var can_chase = false
var state = fly_around
var direction = 1

func _ready() -> void:
	spawn_marker = global_position

func _physics_process(delta: float) -> void:
	
	state.call(delta)
	check_chase(delta)
	move_and_slide()
	

func move_toward_position(target_position, delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	animated_sprite_2d.flip_h = global_position < target_position
	
	

func chase_state(delta):
	var player = MainInstances.player
	if player is CharacterBody2D and can_chase:
		move_toward_position(way_point_pathfinding.pathfinding_next_position, delta)
	if !can_chase:
		state = fly_back_to_spawn_state

func fly_around(delta):
	var current_distance = abs(spawn_marker.distance_to(global_position))
	
	if current_distance >= distance_to_fly:
		direction *= -1
	velocity.y = 0
	velocity.x = speed * direction
	animated_sprite_2d.flip_h = direction > 0
	check_chase(delta)
	
func check_chase(delta):
	if can_chase:
		state = chase_state
		
	if state == chase_state and !can_chase:
		state = fly_back_to_spawn_state
		
	

func fly_back_to_spawn_state(delta):
	if way_point_pathfinding.can_see_target and can_chase:
		state = chase_state
		time_to_go_back_to_spawn = false
	if !can_chase:
		if !time_to_go_back_to_spawn:
			back_to_spawn_timer.start()
			time_to_go_back_to_spawn = true
	velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	

func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	stats.health -= damage


func _on_stats_no_health() -> void:
	Utils.instantiate_scene_on_world(EnemyDeathEffect, global_position)
	queue_free()



func _on_vision_range_body_entered(body: Node2D) -> void:
	if body != MainInstances.player: return
	if !way_point_pathfinding.can_see_target: return
	can_chase = true

func _on_vision_range_body_exited(body: Node2D) -> void:
	if !body == MainInstances.player: return
	chase_timer.start()


func _on_chase_timer_timeout() -> void:
	can_chase = false


func _on_back_to_spawn_timer_timeout() -> void:
	state = fly_around
	time_to_go_back_to_spawn = false
	global_position = spawn_marker
