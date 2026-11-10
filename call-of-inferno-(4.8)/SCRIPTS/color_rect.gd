extends ColorRect

@export var duracao: float = 5.0

func _ready() -> void:
	color = Color(0, 0, 0, 1)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).tween_property(self, "modulate:a", 0.0, duracao)
	tween.tween_callback(queue_free)
