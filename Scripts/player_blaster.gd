extends Node2D

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Marker2D = $BlasterSprite/Muzzle
const BulletScene = preload("res://Scenes/bullet.tscn")

func _process(delta: float) -> void:
	blaster_sprite.rotation = get_local_mouse_position().angle()
	print(rad_to_deg(blaster_sprite.rotation))
	
func fire_bullet():
	var bullet = BulletScene.instantiate()
	var world = get_tree().current_scene
	world.add_child(bullet)
	bullet.rotation = blaster_sprite.rotation
	bullet.global_position = muzzle.global_position
