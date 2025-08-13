extends ColorRect



func _on_start_game_pressed() -> void:
	Sound.play("click", 1.0, -10.0)
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_load_game_pressed() -> void:
	Sound.play("click", 1.0, -10.0)
	SaveManager.is_loading = true
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
