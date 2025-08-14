extends Level

@onready var bricks: Node2D = $Bricks
@onready var trigger: Area2D = $Trigger
@onready var brick_3: Brick = $Bricks/Brick3
@onready var brick_4: Brick = $Bricks/Brick4
@onready var boss_enemy: Node2D = $BossEnemy
@onready var boss_music: AudioStream = preload("res://Metroidvania Assets/music_and_sounds/boss_music.ogg")

func _ready() -> void:
	Music.fade_out(2.0)

func _on_trigger_trigger_entered() -> void:
	var boss_freed = WorldStash.retrieve("firstboss", "freed")
	if !boss_freed: 
		bricks.show()
		trigger.is_active = false
		boss_enemy.fight_started = true
		Music.play(boss_music)


func _on_boss_enemy_tree_exited() -> void:
	brick_3.queue_free()
	brick_4.queue_free()
