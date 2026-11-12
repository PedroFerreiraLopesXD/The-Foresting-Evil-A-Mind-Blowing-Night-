
extends Node3D
@onready var lampiao = $lampiaopegar/Lampiao
@onready var label = $"CharacterBody3D/cabeça/Camera3D/Label3D"
@onready var lampiada = $"CharacterBody3D/cabeça/Camera3D/lampiada"
@onready var player = $CharacterBody3D
@onready var fogo = $Fogueira
@onready var vela = $Itens/Itenspegar/Vela
@onready var contador_velas = $"CharacterBody3D/cabeça/Camera3D/ContadorVelas"
@onready var bike = $BikeDoJaiden

var distancia_max := 2.0
var pode_pegar = false
var pode_pegar_vela = false
var pegou = false
var pegou_vela = false
var pode_ligar = false

func _ready() -> void:
	label.hide()
	lampiada.hide()
	vela.show()
	contador_velas.hide()
	bike.hide()

func _process(_delta: float) -> void:
	if pode_pegar and not pegou and Input.is_action_just_pressed("interacao"):
		pegar_lampiao()

	if pode_pegar_vela and not pegou_vela and Input.is_action_just_pressed("interacao"):
		pegar_vela()

	if pode_ligar == true and Global.luz_ligada == false and Input.is_action_just_pressed("interacao"):
		acender_lampiao()
		Global.luz_ligada = true

func pegar_lampiao() -> void:
	if player.global_position.distance_to(lampiao.global_position) > distancia_max:
		return

	pegou = true
	pode_pegar = false
	label.hide()
	lampiao.hide()
	lampiada.show()
	contador_velas.show()
	atualizar_contador()

func _on_lampiaopegar_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and not pegou:
		pode_pegar = true
		label.text = "Pressione E para pegar"
		label.show()

func _on_lampiaopegar_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		pode_pegar = false
		label.hide()

func _on_ligarlampiao_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
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

func _on_ligarlampiao_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		pode_pegar = false
		label.hide()

func acender_lampiao() -> void:
	if player.global_position.distance_to(fogo.global_position) > distancia_max:
		return

	Global.luz_ligada = true
	pode_ligar = false
	label.hide()

func _on_itenspegar_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and not pegou_vela:
		pode_pegar_vela = true
		label.text = "Pressione E para pegar"
		label.show()

func _on_itenspegar_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		pode_pegar_vela = false
		label.hide()

func pegar_vela() -> void:
	if player.global_position.distance_to(vela.global_position) > distancia_max:
		return

	pegou_vela = true
	pode_pegar_vela = false
	label.hide()
	vela.hide()

	print("pegou vela")

	Global.itens += 1
	atualizar_contador()

	print("Velas coletadas: ", Global.itens)

	if Global.itens >= 1:
		bike.show()

func atualizar_contador() -> void:
	contador_velas.text = "Velas: " + str(Global.itens) + "/7"
