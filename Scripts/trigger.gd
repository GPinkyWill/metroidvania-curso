extends Area2D

signal trigger_entered

var is_active = true

func _on_body_entered(body: Node2D) -> void:
	if !is_active: return
	if body is Player:
		trigger_entered.emit()
