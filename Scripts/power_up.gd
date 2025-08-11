class_name PowerUp
extends Area2D

func pickup():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	pickup()
