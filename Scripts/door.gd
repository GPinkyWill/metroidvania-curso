class_name Door
extends Area2D


@export_file("*.tscn") var new_level_path

@onready var right_cast: RayCast2D = $RightCast
@onready var left_cast: RayCast2D = $LeftCast


func _physics_process(delta: float) -> void:
	var player = MainInstances.player as Player
	if !player is Player: return
	if overlaps_body(player):
		var player_direction = sign(player.velocity.x)
		var direction = get_direction()
		if player_direction == direction:
			Events.door_entered.emit(self)

func get_direction():
	if left_cast.is_colliding(): return -1
	if right_cast.is_colliding(): return 1
	return 0
