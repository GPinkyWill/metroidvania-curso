extends Node2D

@onready var path_2d: Path2D = $Path2D
@export var current_path : Curve2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !current_path: return
	path_2d.curve =  current_path
