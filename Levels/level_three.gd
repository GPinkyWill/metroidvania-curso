extends Node2D

@onready var bricks: Node2D = $Bricks
@onready var trigger: Area2D = $Trigger
@onready var brick_3: Brick = $Bricks/Brick3
@onready var brick_4: Brick = $Bricks/Brick4
@onready var boss_enemy: Node2D = $BossEnemy


func _on_trigger_trigger_entered() -> void:
	var boss_freed = WorldStash.retrieve("firstboss", "freed")
	if !boss_freed: 
		bricks.show()
		trigger.is_active = false
		boss_enemy.fight_started = true


func _on_boss_enemy_tree_exited() -> void:
	brick_3.queue_free()
	brick_4.queue_free()
