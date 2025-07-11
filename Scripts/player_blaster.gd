extends Node2D

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Marker2D = $BlasterSprite/Muzzle
const BulletScene = preload("res://Scenes/bullet.tscn")

func _process(delta: float) -> void:
	blaster_sprite.rotation = get_local_mouse_position().angle()
	
func fire_bullet():
	var bullet = Utils.instantiate_scene_on_world(BulletScene, muzzle.global_position)
	bullet.rotation = blaster_sprite.rotation
	bullet.update_velocity()
