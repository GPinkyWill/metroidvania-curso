class_name Stats
extends Node

@export var max_health = 3.0 : set = set_max_health
#O motivo pra essa variável ser onready é que se ela não for, mesmo max_health
#sendo exportada, ela primeiro vai pegar o valor do código acima (3) e ignorar o valor setado.
@onready var health = max_health : set = set_health

signal no_health
signal health_changed
signal max_health_changed

func set_max_health(value):
	max_health = value
	max_health_changed.emit()

func set_health(value):
	health = clamp(value, 0 , max_health)
	health_changed.emit()
	if health <= 0: no_health.emit()
