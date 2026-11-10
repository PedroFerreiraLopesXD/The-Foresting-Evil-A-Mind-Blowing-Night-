extends CanvasLayer

@onready var stamina_bar = $stamina
@export var player: Node

func _process(delta):
	if player:
		stamina_bar.max_value = player.max_stamina
		stamina_bar.value = player.stamina
