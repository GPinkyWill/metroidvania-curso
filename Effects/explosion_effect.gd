extends "res://Effects/effect.gd"



func _ready() -> void:
	super()
	Sound.play("explosion", randf_range(0.4, 1.2), -10)
