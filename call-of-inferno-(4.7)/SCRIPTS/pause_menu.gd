extends Control

func _ready():
	visible = false
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
	
func toggle_pause():
	var paused = not get_tree().paused
	get_tree().paused = paused
	visible = paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED


func _on_continuar_pressed():
	toggle_pause()	

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().quit()
