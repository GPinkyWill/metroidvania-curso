extends Projectile

func _ready() -> void:
	Sound.play("bullet",randf_range(0.8, 1.2), -5)
	set_process(false)
