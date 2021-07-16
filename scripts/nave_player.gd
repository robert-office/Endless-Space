extends Node2D

var velocity = Vector2.ZERO
var speed = 15
var analog_relased = false
var ativo = false
var parado = true
var t_force = 0

func mover_nave(force, pos):
	velocity = (pos * force) * speed
	t_force = force

func zerar_t_force():
	t_force = 0

func parar_nave():
	velocity = lerp(velocity, Vector2.ZERO, 0.04)

func _process(delta):
	if t_force >= 0.1:
		parado = false
	else:
		parado = true

func _physics_process(_delta):
	# se a nave estiver ativa ela é mostrada senão é escondida
	if ativo:
		show()
	else:
		hide()
	
	if !analog_relased:
		rotation = global.muda_direcao_com_lerp(rotation, global.center_point, global.ball_pos, 15, _delta)
	
	if analog_relased:
		parar_nave()
	
	#mexe a nave de acordo com a velocity
	position += velocity
