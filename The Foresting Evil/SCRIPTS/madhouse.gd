extends Node3D
@onready var lampiao = $lampiaopegar/Lampiao
@onready var label = $"CharacterBody3D/cabeça/Camera3D/Label3D"
@onready var lampiada = $"CharacterBody3D/cabeça/Camera3D/lampiada"
@onready var player = $CharacterBody3D
@onready var fogo = $Fogueira


var distancia_max := 2.0
var pode_pegar = false
var pegou = false
var pode_ligar = false

#onready
func _ready() -> void:
	label.hide()
	lampiada.hide()
	print("lampiao: ", lampiao, " | player: ", player)

# Entrando na zona que pode pegar
func _on_lampiaopegar_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and not pegou:
		pode_pegar = true
		label.text = "Pressione E para pegar"
		label.show()
		print("entrou")

# Saindo da zona de pegar
func _on_lampiaopegar_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		pode_pegar = false
		label.hide()
		print("saiu")

# Process pra pegar e ascender lampeão
func _process(_delta: float) -> void:
	if pode_pegar and not pegou and Input.is_action_just_pressed("interacao"):
		pegar_lampiao()
		print("pegou")
	
	if pode_ligar == true and Global.luz_ligada == false and Input.is_action_just_pressed("interacao"):
		acender_lampiao()
		Global.luz_ligada = true
		print("ligou")

# Função pra pegar o lampeão
func pegar_lampiao() -> void:
	if player.global_position.distance_to(lampiao.global_position) > distancia_max:
		return
	pegou = true
	pode_pegar= false
	label.hide()
	lampiao.hide()
	lampiada.show()
	print("pegou 2?")
	
# Entrando na zona que pode acender
func _on_ligarlampiao_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("entrou 2")
		if pegou == true and Global.luz_ligada == false:
			pode_ligar = true
			label.text = "Pressione E para alumear"
			label.show()
		elif pegou == true and Global.luz_ligada == true:
			label.text = "Já está aceso"
			label.show()
		else:
			label.text = "Precisa de lampeão"
			label.show()
	
# Saindo da zona de alumear
func _on_ligarlampiao_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		pode_pegar = false
		label.hide()
		print("saiu 2")

# Função de acender
func acender_lampiao() -> void:
	if player.global_position.distance_to(fogo.global_position) > distancia_max:
		return
	Global.luz_ligada = true
	pode_ligar = false
	label.hide()
	print("acendeu")
