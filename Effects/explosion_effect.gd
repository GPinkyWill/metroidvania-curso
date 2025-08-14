extends "res://Effects/effect.gd"



func _ready() -> void:
	super()
	


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	Sound.play("explosion", randf_range(0.4, 1.2), -10)
