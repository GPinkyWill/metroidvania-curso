class_name World
extends Node2D

@onready var level = $Level_One


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.door_entered.connect(change_level)
	

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
