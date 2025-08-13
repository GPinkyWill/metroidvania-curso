extends Node


const TEST_PATH = "res://save.txt"
const PROD_PATH = "user://metroidvania_save.save"

var save_path = TEST_PATH
var is_loading = false

func save_game(save_station_x, save_station_y):
	WorldStash.stash("level", "file_path", MainInstances.level.scene_file_path)
	WorldStash.stash("player", "x", save_station_x)
	WorldStash.stash("player", "y", save_station_y)
	PlayerStats.stash_stats()
	
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	var data_string = JSON.stringify(WorldStash.data)
	save_file.store_string(data_string)
	save_file.close()

func load_game():
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if !save_file is FileAccess: return null
	
	var data = JSON.parse_string(save_file.get_line())
	WorldStash.data = data
	var file_path = WorldStash.retrieve("level", "file_path")
	MainInstances.world.load_level(file_path)
	var player_x = WorldStash.retrieve("player", "x")
	var player_y = WorldStash.retrieve("player", "y")
	MainInstances.player.global_position = Vector2(player_x, player_y)
	PlayerStats.retrieve_stats()
	save_file.close()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
