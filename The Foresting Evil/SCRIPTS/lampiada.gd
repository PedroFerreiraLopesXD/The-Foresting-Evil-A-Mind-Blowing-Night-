extends Node3D

func _process(delta: float) -> void:
	if Global.luz_ligada == false:
		$Lampiao/OmniLight3D.hide()
	elif Global.luz_ligada == true:
		$Lampiao/OmniLight3D.show()
		print("ligou")
