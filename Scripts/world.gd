extends Node2D

@onready var level = $Level_One


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
