extends ColorRect






func _on_menu_pressed() -> void:
	Sound.play("click", 1.0, -10.0)
	WorldStash.data = {}
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/Menus/start_menu.tscn")


func _on_load_pressed() -> void:
	Sound.play("click", 1.0, -10.0)
	SaveManager.is_loading = true
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_quit_pressed() -> void:
	Sound.play("click", 1.0, -10.0)
	get_tree().quit()
