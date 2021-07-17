extends Node2D

class NavePlayer:
	
	var speed setget set_velocidade, get_velocidade
	var velocity = Vector2.ZERO
	var ativo = false setget set_nave_ativa, get_nave_ativa
	var parado = true setget set_nave_parada, get_nave_parada
	var t_force = 0
	var analog_relased = true
	
	
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
	
	func set_velocidade(new_value):
		speed = new_value
	
	func get_velocidade():
		return speed


export(int) var speed
var NAVE_ATUAL = NavePlayer.new()

var analog_relased = true
var este_ativo = false
var esta_parada = true

func _ready():
	get_tree().get_nodes_in_group("analogico")[0].connect("analogChange", self, "_on_Player_analogChange")
	get_tree().get_nodes_in_group("analogico")[0].connect("analogPressed", self, "_on_Player_analogPressed")
	get_tree().get_nodes_in_group("analogico")[0].connect("analogRelease", self, "_on_Player_analogRelease")
	
	NAVE_ATUAL.set_nave_ativa(true)
	NAVE_ATUAL.set_velocidade(speed)

#FAZ TODAS AS FUNÇÕES DA NAVE COM O RIDIBODY
func _physics_process(_delta):
	if !analog_relased:
		rotation = global.muda_direcao_com_lerp(rotation, global.center_point, global.ball_pos, 15, _delta)

	if analog_relased:
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
	
	analog_relased = NAVE_ATUAL.analog_relased
	este_ativo = NAVE_ATUAL.get_nave_ativa()
	esta_parada = NAVE_ATUAL.get_nave_parada()


func _on_Player_analogChange(force, pos) -> void:
	NAVE_ATUAL.analog_relased = false
	NAVE_ATUAL.mover_nave(force, pos)

func _on_Player_analogRelease() -> void:
	NAVE_ATUAL.analog_relased = true
	NAVE_ATUAL.zerar_t_force()

func _on_Player_analogPressed():
	pass # Replace with function body.
