extends Node2D

class NavePlayer:
	
	var speed : get = get_velocidade, set = set_velocidade
	var velocity = Vector2.ZERO
	var ativo = false: get = get_nave_ativa, set = set_nave_ativa
	var parado = true: get = get_nave_parada, set = set_nave_parada
	var t_force = 0
	var ultima_direcao = Vector2.ZERO
	var velocidade_atual = 0
	
	func mover_nave(force, pos):
		velocity = (pos * force) * get_velocidade()
		t_force = force

	func zerar_t_force():
		t_force = 0

	func parar_nave():
		velocity = lerp(velocity, Vector2.ZERO, 0.04)

	#SETTER AND GETTERS
	func set_nave_parada(new_value):
		parado = new_value
		
	func get_nave_parada():
		return parado
	
	func set_nave_ativa(new_value):
		ativo = new_value
		
	func get_nave_ativa():
		return ativo
	
	func set_velocidade(new_value: float):
		speed = new_value
	
	func get_velocidade():
		return speed


@export var speed: float
@export var torque: int

var NAVE_ATUAL = NavePlayer.new()

var este_ativo = false
var esta_parada = true

func _ready():
	NAVE_ATUAL.set_nave_ativa(true)
	NAVE_ATUAL.set_velocidade(speed)

#FAZ TODAS AS FUNÇÕES DA NAVE COM O RIDIBODY
func _physics_process(_delta):
	
	var direcao = Vector2.ZERO

	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("w"):
		direcao.y -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("s"):
		direcao.y += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("a"):
		direcao.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("d"):
		direcao.x += 1

	# Normalizar a direção para garantir que a nave não se mova mais rápido nas diagonais
	direcao = direcao.normalized()

	if direcao != Vector2.ZERO:
		NAVE_ATUAL.ultima_direcao = direcao;
		rotation = global.muda_direcao_com_lerp(rotation, Vector2(0, 0), direcao, 15, _delta)
	else:
		rotation = global.muda_direcao_com_lerp(rotation, Vector2(0, 0), NAVE_ATUAL.ultima_direcao, 15, _delta)
	
	# limita a velocidade para a atual, fazendo lerp, e para a nave com lerp
	if direcao != Vector2.ZERO:
		if NAVE_ATUAL.velocidade_atual < NAVE_ATUAL.speed:
			NAVE_ATUAL.velocidade_atual += (NAVE_ATUAL.speed / torque)
		else:
			NAVE_ATUAL.velocidade_atual = NAVE_ATUAL.speed
		
		NAVE_ATUAL.mover_nave(NAVE_ATUAL.velocidade_atual, direcao)
	else:
		if NAVE_ATUAL.velocidade_atual > 0:
			NAVE_ATUAL.velocidade_atual -= (NAVE_ATUAL.speed / torque)
		else:
			NAVE_ATUAL.velocidade_atual = 0;
		
		NAVE_ATUAL.parar_nave()
	
	#mexe a nave de acordo com a velocity
	position += NAVE_ATUAL.velocity


func _process(delta):
	# se a nave estiver ativa ela é mostrada senão é escondida
	if NAVE_ATUAL.ativo:
		show()
	else:
		hide()
	
	if NAVE_ATUAL.t_force >= 0.1:
		NAVE_ATUAL.parado = false
	else:
		NAVE_ATUAL.parado = true
	
	este_ativo = NAVE_ATUAL.get_nave_ativa()
	esta_parada = NAVE_ATUAL.get_nave_parada()
