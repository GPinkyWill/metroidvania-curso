extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sound.play("enemy_die", 1.0, -10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
