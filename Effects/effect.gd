extends AnimatedSprite2D

func _ready() -> void:
	#queue_free está sem parênteses por que se tivesse, ao invés de executar a função
	#iria retornar o valor da função chamada
	animation_finished.connect(queue_free)
	
