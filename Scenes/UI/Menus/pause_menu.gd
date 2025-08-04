extends ColorRect

var paused = false :
	set(value) :
		paused = value
		get_tree().paused = paused
		visible = paused
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = !paused
	

func _on_resume_pressed() -> void:
	paused = false


func _on_quit_pressed() -> void:
	get_tree().quit()
