extends Projectile


func _ready():
	Sound.play("explosion")

func _on_hit_box_body_entered(body: Node2D) -> void:
	super(body)
	if !body is Brick: return
	body.queue_free()
