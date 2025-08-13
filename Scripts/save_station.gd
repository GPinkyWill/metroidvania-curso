extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body is Player: return
	animation_player.play("save")
	SaveManager.save_game()
	Sound.play("powerup", 0.6, -10)
