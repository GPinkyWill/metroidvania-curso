extends Projectile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sound.play("bullet",randf_range(1.2, 2), -5)
