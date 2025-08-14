class_name Player
extends CharacterBody2D


const DustEffectScene = preload("res://Effects/dust_effect.tscn")
const JumpEffectScene = preload("res://Effects/jump_effect.tscn")
const WallJumpEffectScene = preload("res://Effects/wall_jump_effect.tscn")


@export var acceleration = 512
@export var max_velocity = 128
@export var friction = 350
@export var gravity = 200
@export var jump_force = 333
@export var max_fall_velocity = 120
@export var wall_slide_speed = 62
@export var max_wall_slide_speed = 300



@onready var wall_slide_cd_timer: Timer = $WallSlideCD_Timer
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var drop_timer: Timer = $DropTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var blinking_animation_player: AnimationPlayer = $BlinkingAnimationPlayer

@onready var player_blaster: Node2D = $PlayerBlaster

@onready var hurt_box: HurtBox = $HurtBox

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_jump_timer: Timer = $Coyote_Jump_Timer
@onready var center: Marker2D = $Center


@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float


var air_jump = false
var state = move_state

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1


func _ready() -> void:
	PlayerStats.no_health.connect(die)
	camera_position_smoothing()
#localização do player pros inimigos que precisarem dessa informação
func _enter_tree() -> void:
	MainInstances.player = self


func _physics_process(delta: float) -> void:
	state.call(delta)
	
	#Checando se deu tiro, independente de qual state está sendo utilizado no momento
	if Input.is_action_pressed("fire") and fire_rate_timer.time_left == 0:
		player_blaster.fire_bullet()
		fire_rate_timer.start()
	
	if (Input.is_action_pressed("fire_missile")
	and fire_rate_timer.time_left == 0
	and PlayerStats.missiles > 0):
		player_blaster.fire_missile()
		fire_rate_timer.start()
		PlayerStats.missiles -= 1

func _exit_tree() -> void:
	MainInstances.player = null

func move_state(delta):
	apply_gravity(delta)
	velocity.y += _get_gravity() * delta
	#Movimentação direita e esquerda
	var input_axis = Input.get_axis("move_left","move_right")
	if is_moving(input_axis):
		apply_acceleration(delta, input_axis)
	else:
		apply_friction(delta)
	
	jump_check()
	
	#Cair da plataforma
	if Input.is_action_just_pressed("crouch"):
		set_collision_mask_value(2, false)
		drop_timer.start()
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		coyote_jump_timer.start()
	wall_check()

func wall_slide_state(delta):
	var wall_normal = get_wall_normal()
	animation_player.play("wall_slide")
	sprite_2d.scale.x = sign(wall_normal.x)
	velocity.y = clampf(velocity.y,-20, max_wall_slide_speed)
	wall_jump_check(wall_normal.x)
	apply_wall_slide_gravity(delta)
	move_and_slide()
	wall_detatch(wall_normal.x, delta)

func wall_check():
	if wall_slide_cd_timer.time_left > 0: return
	if !is_on_floor() and is_on_wall():
		state = wall_slide_state
		air_jump = false
		wall_slide_cd_timer.start()
		create_dust_effect()

func wall_detatch(wall_direction, delta):
	var input_axis = Input.get_axis("move_left","move_right")
	
	if is_on_wall() and input_axis == wall_direction:
		velocity.x = acceleration * delta * sign(input_axis)
		state = move_state
		
	if !is_on_wall() or is_on_floor():
		state = move_state
	
	
	
func wall_jump_check(wall_axis):
	if Input.is_action_just_pressed("jump"):
		Sound.play("jump",randf_range(0.6, 1.1), -5)
		velocity.x = wall_axis * max_velocity
		state = move_state
		jump(-jump_force * 0.75, false)
		var wall_jump_effect_position = global_position + Vector2(wall_axis * 3.5, -2)
		var wall_jump_effect = Utils.instantiate_scene_on_level(WallJumpEffectScene, wall_jump_effect_position)
		wall_jump_effect.scale.x = wall_axis
		

func apply_wall_slide_gravity(delta):
	if wall_slide_cd_timer.time_left > 0: return
	var slide_speed = wall_slide_speed
	if Input.is_action_pressed("crouch"):
		slide_speed = max_wall_slide_speed
	velocity.y = move_toward(velocity.y, slide_speed, gravity * delta)
		

func is_moving(input_axis):
	return input_axis != 0

func _get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func apply_gravity(delta):
	#Aplicação de gravidade para queda do personagem
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)


func apply_acceleration(delta, input_axis):
	if is_moving(input_axis) :
		velocity.x = move_toward(velocity.x,input_axis * max_velocity,acceleration * delta)
	
func apply_friction(delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x,0,friction * delta)
	
	
	
func jump(force, create_effect = true):
	Sound.play("jump",randf_range(0.6, 1.1), -5)
	wall_slide_cd_timer.start()
	velocity.y = force
	if create_effect:
		Utils.instantiate_scene_on_level(JumpEffectScene,global_position)
		
	
func jump_check ():
	if is_on_floor(): air_jump = true
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			jump(-jump_force)
			
	

	if !is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < -jump_force/2:
			velocity.y = -jump_force/2
			
		if Input.is_action_just_pressed("jump") and air_jump:
			jump(-jump_force * 0.75)
			air_jump = false
	
	
	
func update_animations (input_axis):
	sprite_2d.scale.x = sign(get_local_mouse_position().x)
	if abs(sprite_2d.scale.x) != 1: sprite_2d.scale.x = 1
	if is_moving(input_axis):
		animation_player.play("run")
		animation_player.speed_scale = sprite_2d.scale.x * input_axis
		
	else:
		animation_player.play("idle")
	if not is_on_floor():
		animation_player.play("jump")
		

func create_dust_effect():
	Utils.instantiate_scene_on_level(DustEffectScene,global_position)
	Sound.play("step",randf_range(0.7, 1.2), -10)
	


func _on_drop_timer_timeout() -> void:
	set_collision_mask_value(2, true)

func camera_position_smoothing():
	await get_tree().create_timer(1.0).timeout
	camera_2d.position_smoothing_enabled = true

func die():
	camera_2d.position_smoothing_enabled = false
	camera_2d.reparent(get_tree().current_scene)
	Events.player_died.emit()
	queue_free()

func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	Sound.play("hurt", 1.0, -5.0)
	Events.add_screen_shake.emit(2, 0.2)
	PlayerStats.health -= 1
	hurt_box.is_invincible = true
	blinking_animation_player.play("blink")
	await blinking_animation_player.animation_finished
	hurt_box.is_invincible = false
