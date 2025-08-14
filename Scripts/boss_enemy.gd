extends Node2D

const StingerScene = preload("res://Scenes/Enemies/stinger.tscn")
const MissilePowerUpScene = preload("res://Scenes/PowerUps/missile_power_up.tscn")
const EnemyDeathEffectScene = preload("res://Effects/enemy_death_effect.tscn")

@export var acceleration = 200
@export var max_speed = 800
@export var targets : Array[NodePath]

var state = fight_await_state : set = set_state
var state_init = true : get = get_state_init
var velocity = Vector2.ZERO
var fight_started = false

var STATE_OPTIONS = [fire_state, fire_state, rush_state, rush_state]
var state_options_left = []

@onready var stats: Stats = $Stats
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var state_timer: Timer = $StateTimer
@onready var stinger_pivot: Marker2D = $StingerPivot
@onready var muzzle: Marker2D = $StingerPivot/Muzzle

func _ready() -> void:
	var freed = WorldStash.retrieve("firstboss", "freed")
	if freed: queue_free()

func _process(delta):
	if !state: return
	state.call(delta)
	difficulty_check()


func difficulty_check():
	if stats.health < 75:
		acceleration = 400
		max_speed = 1600
		fire_rate_timer.wait_time = 0.025 


func set_state(value):
	state = value
	state_init = true

#Toda vez que acessar state_init ele vai se tornar falso
func get_state_init():
	var was = state_init
	state_init = false
	return was

func fight_await_state(delta):
	if !fight_started: return
	state = recenter_state

func rush_state(delta):
	if state_init:
		state_timer.start(randf_range(4.0, 6.0))
		state_timer.timeout.connect(set_state.bind(decelerate_state), CONNECT_ONE_SHOT)
	var player = MainInstances.player
	if !player is Player: return
	var direction = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	move(delta)
	print("moving")
	

func fire_state(delta):
	if state_init:
		state_timer.start(randf_range(2.0, 6.0))
		state_timer.timeout.connect(set_state.bind(recenter_state), CONNECT_ONE_SHOT)
	if fire_rate_timer.time_left == 0:
		stinger_pivot.rotation_degrees += 17
		fire_rate_timer.start()
		var stinger = Utils.instantiate_scene_on_level(StingerScene, muzzle.global_position)
		stinger.rotation = stinger_pivot.rotation
		stinger.update_velocity()
	print("shooting")

func move(delta):
	translate(velocity * delta)


func recenter_state(delta):
	#Causa um erro e para o programa caso a condição dentro dele seja falsa
	#Bom para confirmar processos dentro do código
	assert(!targets.is_empty())
	if state_init:
		var center_node = get_node(targets.pick_random())
		var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "global_position", center_node.global_position, 2.0)
		await tween.finished
		state_timer.start(1.0)
		await state_timer.timeout
		if state_options_left.is_empty():
			state_options_left = STATE_OPTIONS.duplicate()
			state_options_left.shuffle()
		state = state_options_left.pop_back()

func decelerate_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	move(delta)
	if velocity == Vector2.ZERO:
		state = recenter_state



func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	stats.health -= damage
	print(stats.health)


func _on_stats_no_health() -> void:
	WorldStash.stash("firstboss", "freed", true)
	Utils.instantiate_scene_on_level(MissilePowerUpScene, global_position)
	for i in 6:
		Utils.instantiate_scene_on_level(EnemyDeathEffectScene, global_position + Vector2(randf_range(-16.0,16.0), randf_range(-16.0,16.0)))
		
	queue_free()
