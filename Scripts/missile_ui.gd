extends HBoxContainer

@onready var label: Label = $Label


func _ready() -> void:
	update_missile_label()
	PlayerStats.missiles_changed.connect(update_missile_label)
	
	

func update_missile_label():
	label.text = str(PlayerStats.missiles)
