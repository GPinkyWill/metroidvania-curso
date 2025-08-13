extends Node


var sounds_path = "res://Metroidvania Assets/music_and_sounds/"

@export var playlist_folder = {}

@onready var sound_players := get_children()

func _ready() -> void:
	var dir = DirAccess.open(sounds_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.get_extension() == "wav":
				var audio_stream = load(sounds_path + file_name)
				playlist_folder[file_name.get_basename()] = audio_stream
			file_name = dir.get_next()
		dir.list_dir_end()
	
	
		
	
	
	
func play(sound_string, pitch_scale = 1.0, volume_db = 0.0):
	for sound_player in sound_players:
		if !sound_player.playing:
			sound_player.pitch_scale = pitch_scale
			sound_player.volume_db = volume_db
			if playlist_folder.has(sound_string):
				sound_player.stream = playlist_folder[sound_string]
				sound_player.play()
			#sound_player.stream = load(sounds_path + sound_string + ".wav")
			else:
				print("Esse som não existe")
			return
	print("muitos sons de uma vez")
