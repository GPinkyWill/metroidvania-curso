extends Camera2D

var shake = 0

@onready var timer: Timer = $Timer


func _ready() -> void:
	Events.add_screen_shake.connect(start_screen_shake)
	
	

func _process(delta: float) -> void:
	offset.x = randf_range(-shake,shake)
	offset.y = randf_range(-shake,shake)



func start_screen_shake(amount, duration):
	shake = amount
	timer.start(duration)

func _on_timer_timeout() -> void:
	shake = 0
