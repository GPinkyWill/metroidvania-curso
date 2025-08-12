extends Panel



func _ready() -> void:
	Events.camera_limits_changed.emit(
		position.x,
		position.x + size.x,
		position.y,
		position.y + size.y
	)
	hide()
