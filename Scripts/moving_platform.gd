extends Node2D

@onready var path_2d: Path2D = $Path2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var current_path : Curve2D
@export var platform_speed = 1.0
@export var generate_random_speed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !current_path: return
	path_2d.curve =  current_path
	animation_player.speed_scale = platform_speed + _random_speed()
	
func _random_speed():
	if !generate_random_speed: return 0
	return randf_range(-0.9, 1.5)
