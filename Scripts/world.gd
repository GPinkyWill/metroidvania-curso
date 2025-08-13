class_name World
extends Node2D

@onready var level = $Level_One

func _enter_tree() -> void:
	MainInstances.world = self

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.door_entered.connect(change_level)
	Events.player_died.connect(game_over)
	Music.play(Music.main_theme)
	if SaveManager.is_loading:
		SaveManager.load_game()
		SaveManager.is_loading = false

func load_level(file_path):
	level.queue_free()
	level.name = level.name + "OLD"
	var LevelScene = load(file_path)
	var new_level = LevelScene.instantiate()
	add_child(new_level)
	level = new_level

func change_level(door : Door):
	var player = MainInstances.player
	if !player is Player: return
	
	level.queue_free()
	
	
	var new_level = load(door.new_level_path).instantiate()
	add_child(new_level)
	level = new_level
	var doors = get_tree().get_nodes_in_group("doors")
	for found_door in doors:
		if found_door == door: continue
		if found_door.connection != door.connection: continue
		var y_offset = player.global_position.y - door.global_position.y
		player.global_position = found_door.global_position + Vector2(0, y_offset)

func game_over():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/UI/Menus/game_over_menu.tscn")

func _exit_tree() -> void:
	MainInstances.world = null
