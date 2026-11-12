extends CharacterBody3D

@export var velocidade_patrulha: float = 2.0
@export var velocidade_perseguicao: float = 4.0
@export var raio_patrulha: float = 15.0
@export var espera_no_ponto: float = 1.5
@export var distancia_para_pegar: float = 1.5

enum Estado { PATRULHANDO, PERSEGUINDO }
var estado := Estado.PATRULHANDO

var jogador: Node3D
var pronto := false
var tempo_espera := 0.0
var origem: Vector3

@onready var agente: NavigationAgent3D = $NavigationAgent3D
@onready var visao: Area3D = $Area3DVision


func _ready() -> void:
	jogador = get_tree().get_first_node_in_group("Jogador")
	origem = global_position

	visao.body_entered.connect(_on_area_3d_vision_body_entered)
	visao.body_exited.connect(_on_area_3d_vision_body_exited)

	await get_tree().physics_frame
	pronto = true
	escolher_novo_ponto()


func _physics_process(delta: float) -> void:
	if not pronto:
		return

	if estado == Estado.PERSEGUINDO:
		if jogador == null:
			return
		agente.target_position = jogador.global_position
		mover(velocidade_perseguicao, delta)

		if global_position.distance_to(jogador.global_position) < distancia_para_pegar:
			print("O monstro pegou o jogador!")
	else:
		if agente.is_navigation_finished():
			
			tempo_espera -= delta
			if tempo_espera <= 0.0:
				escolher_novo_ponto()
				tempo_espera = espera_no_ponto
		else:
			mover(velocidade_patrulha, delta)

func mover(vel: float, delta: float) -> void:
	var proximo_ponto: Vector3 = agente.get_next_path_position()
	global_position = global_position.move_toward(proximo_ponto, vel * delta)


func escolher_novo_ponto() -> void:
	var mapa: RID = agente.get_navigation_map()
	var aleatorio := origem + Vector3(
		randf_range(-raio_patrulha, raio_patrulha),
		0.0,
		randf_range(-raio_patrulha, raio_patrulha)
	)
	# garante que o ponto está em cima da malha azul
	agente.target_position = NavigationServer3D.map_get_closest_point(mapa, aleatorio)


func _on_area_3d_vision_body_entered(body: Node3D) -> void:
	if body.is_in_group("Jogador"):
		estado = Estado.PERSEGUINDO

func _on_area_3d_vision_body_exited(body: Node3D) -> void:
	if body.is_in_group("Jogador"):
		estado = Estado.PATRULHANDO
		escolher_novo_ponto()
