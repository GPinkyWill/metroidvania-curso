class_name PowerUp
extends Area2D

func _ready() -> void:
	var id = WorldStash.get_id(self)
	var freed = WorldStash.retrieve(id, "freed")
	if freed: queue_free()

func pickup():
	Sound.play("powerup", 1.0, -10.0)
	var id = WorldStash.get_id(self)
	WorldStash.stash(id, "freed", true)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	pickup()
