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
var ligou = false

func _ready() -> void:
	label.hide()
	lampiada.hide()

func _on_lampiaopegar_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and not pegou:
		pode_pegar = true
		label.text = "Pressione E para pegar"
		label.show()

func _on_lampiaopegar_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		pode_pegar = false
		label.hide()

func _process(delta: float) -> void:
	if pode_pegar and not pegou and Input.is_action_just_pressed("interacao"):
		pegar_lampiao()
	
	if pode_ligar and not ligou and Input.is_action_just_pressed("interacao"):
		acender_lampiao()

func pegar_lampiao() -> void:
	if player.global_position.distance_to(lampiao.global_position) > distancia_max:
		return
	pegou = true
	pode_pegar= false
	label.hide()
	lampiao.hide()
	lampiada.show()
	
func _on_ligarlampiao_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and not ligou:
		pode_ligar = true
		label.text = "Pressione E para alumiar"
		label.show()
	
func _on_ligarlampiao_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		pode_pegar = false
		label.hide()

func acender_lampiao() -> void:
	if player.global_position.distance_to(fogo.global_position) > distancia_max:
		return
	ligou = true
	pode_ligar = false
	label.hide()
	#$Lampiao/OmniLight3D.show()
