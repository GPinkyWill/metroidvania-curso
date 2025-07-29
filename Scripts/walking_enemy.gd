extends CharacterBody2D

@export var speed = 30.0
@export var turn_at_ledges = true


var gravity = 200.0
var direction = 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var floor_cast: RayCast2D = $FloorCast





func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_wall():
		turn_around()
	if is_at_ledge() and turn_at_ledges:
		turn_around()
	moving()
	
	move_and_slide()


func moving():
	velocity.x = direction * speed
	sprite_2d.scale.x = direction
	
	
func is_at_ledge():
	return is_on_floor() and not floor_cast.is_colliding() 
	
func turn_around():
	direction *= -1.0
	


func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	print(damage)
	queue_free()
