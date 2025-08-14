extends Node

@export var main_theme : AudioStream

var volume_fade : Tween = null
var last_volume_db 
var previous_music_position := 0.0

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	last_volume_db = audio_stream_player.volume_db


func play(song, pausable = false):
	if volume_fade and volume_fade.is_valid():
		volume_fade.kill()
	if audio_stream_player.volume_db < 0.0:
		audio_stream_player.volume_db = last_volume_db
	audio_stream_player.stream = song
	if !pausable:
		audio_stream_player.play()
	else:
		audio_stream_player.play(previous_music_position)


func fade_out(duration = 0.25, pausable = false):
	if volume_fade and volume_fade.is_valid():
		volume_fade.kill()
	
	volume_fade = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	volume_fade.tween_property(audio_stream_player, "volume_db", -50.0, duration).from_current()
	volume_fade.tween_callback(Callable(self, "stop_music").bind(pausable))
	
	
func stop_music(pausable):
	if !pausable:
		audio_stream_player.stop()
	else:
		previous_music_position = audio_stream_player.get_playback_position()
		audio_stream_player.stop()
	#audio_stream_player.volume_db = previous_volume_db
