extends ColorRect



func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_load_game_pressed() -> void:
	print("load saved game")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
