extends ColorRect

var paused = false :
	set(value) :
		paused = value
		get_tree().paused = paused
		visible = paused
		if paused:
			Sound.play("pause", 1.0, -10.0)
			Music.fade_out(0.75, true)
		else:
			Sound.play("unpause", 1.0, -10.0)
			Music.play(Music.main_theme, true)
	
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		

	

func _on_resume_pressed() -> void:
	paused = false
	Sound.play("click", 1.0, -10.0)

func _on_quit_pressed() -> void:
	get_tree().quit()
