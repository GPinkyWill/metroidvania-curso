extends CharacterBody2D


const DustEffectScene = preload("res://Effects/dust_effect.tscn")

@export var acceleration = 512
@export var max_velocity = 128
@export var friction = 350
@export var gravity = 200
@export var jump_force = 128
@export var max_fall_velocity = 120

@onready var player_blaster: Node2D = $PlayerBlaster


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_jump_timer: Timer = $Coyote_Jump_Timer


@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	velocity.y += _get_gravity() * delta
	#Movimentação direita e esquerda
	var input_axis = Input.get_axis("move_left","move_right")
	if is_moving(input_axis):
		apply_acceleration(delta, input_axis)
	else:
		apply_friction(delta)
	
	jump_check()
	
	#Checando se deu tiro
	if Input.is_action_just_pressed("fire"):
		player_blaster.fire_bullet()
	
	
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		coyote_jump_timer.start()
func is_moving(input_axis):
	return input_axis != 0

func _get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	velocity.y = jump_velocity

func apply_gravity(delta):
	#Aplicação de gravidade para queda do personagem
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)


func apply_acceleration(delta, input_axis):
	if is_moving(input_axis) :
		velocity.x = move_toward(velocity.x,input_axis * max_velocity,acceleration * delta)
	
func apply_friction(delta):
	velocity.x = move_toward(velocity.x,0,friction * delta)
		
func jump_check ():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			jump()
	if !is_on_floor() and Input.is_action_just_released("jump") and velocity.y < -jump_force/2:
		velocity.y = -jump_force/2

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
	Utils.instantiate_scene_on_world(DustEffectScene,global_position)
	
