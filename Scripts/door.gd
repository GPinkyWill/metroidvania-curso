class_name Door
extends Area2D



@export_file("*.tscn") var new_level_path
@export var connection : DoorConnection


@onready var timer: Timer = $Timer
@onready var right_cast: RayCast2D = $RightCast
@onready var left_cast: RayCast2D = $LeftCast

var active = false

func _physics_process(delta: float) -> void:
	var player = MainInstances.player as Player
	if !player is Player: return
	if !active: return
	if overlaps_body(player) and new_level_path:
		var player_direction = sign(player.velocity.x)
		var direction = get_direction()
		if player_direction == direction:
			Events.door_entered.emit(self)

func get_direction():
	if left_cast.is_colliding(): return -1
	if right_cast.is_colliding(): return 1
	return 0


func _on_timer_timeout() -> void:
	active = true
