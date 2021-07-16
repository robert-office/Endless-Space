extends KinematicBody2D

var speed = Vector2(400, 400)

var delay_timer = 1
var rand = 1;

var modo_descanso = false

var timer_loop_cria_pontos = null
var timer_volta_a_voar = null
var timer_esquecer_player = null
var timer_esquecer_samba_point = null

var point_to_go = Vector2()

var can_loop_timer = true

var pediu_para_locomover = false
var chegou_no_local = false

var player_avistado = false
var perseguindo_player = false

var sambando = false
var local_sambado = Vector2()
var pediu_para_ir_local_sambado = false
var chegou_no_local_sambando = false

var velocity = Vector2()
var parado = true
var soma = null
var target = null


func _ready():
	#cria um temporizador para chamar uma função em intervalos
	timer_loop_cria_pontos = Timer.new()
	timer_loop_cria_pontos.set_one_shot(true)
	timer_loop_cria_pontos.set_wait_time(delay_timer)
	timer_loop_cria_pontos.connect("timeout", self, "on_timeout_complet")
	add_child(timer_loop_cria_pontos)
	
	#cria um temporizidor para chamar uma função para a nave sair do modo de espera e voltar a voar novamente
	timer_volta_a_voar = Timer.new()
	timer_volta_a_voar.set_one_shot(true)
	timer_volta_a_voar.set_wait_time(6)
	timer_volta_a_voar.connect("timeout", self, "on_timeout_complet_volta_a_voar")
	add_child(timer_volta_a_voar)
	
	timer_esquecer_player = Timer.new()
	timer_esquecer_player.set_one_shot(true)
	timer_esquecer_player.set_wait_time(10)
	timer_esquecer_player.connect("timeout", self, "on_timeout_complet_esquecer_player")
	add_child(timer_esquecer_player)
	
	timer_esquecer_samba_point = Timer.new()
	timer_esquecer_samba_point.set_one_shot(true)
	timer_esquecer_samba_point.set_wait_time(5)
	timer_esquecer_samba_point.connect("timeout", self, "on_timeout_esquecer_samba_point")
	add_child(timer_esquecer_samba_point)


func _physics_process(delta):
	
	if velocity != null:
		var v_x = int(velocity.x)
		var v_y = int(velocity.y)
		soma = v_x + v_y
	
	if can_loop_timer:
		timer_loop_cria_pontos.start()
		can_loop_timer = false
	
	# se chegou no local reseta as variaveis
	if chegou_no_local:
		randomize()
		# 1 / 4 para parar a nave e ativar o timer de pausa
		var rand = int( rand_range(1, 5) )
		if rand != 3:
#			print("o rand era: " + str(rand))
			pediu_para_locomover = false
	#		point_to_go = Vector2()
			chegou_no_local = false
		else:
			timer_volta_a_voar.start()
			modo_descanso = true
#			print("bó descançarkkkk gasolina ta cara")
		
	# se pediram para se locomover, move a nave
	if !sambando:
		if !perseguindo_player:
			if !player_avistado:
				if !modo_descanso:
					if pediu_para_locomover:
						
						velocity = mover_nave_at(global_position, point_to_go)
						
						if soma != null:
							if soma <= 60 && soma >= -60:
								pediu_para_locomover = false
								point_to_go = Vector2()
								chegou_no_local = false
								
		else:
			if target != null:
				velocity = mover_nave_at(global_position, target.global_position)
	else:
		if !pediu_para_ir_local_sambado:
			set_local_sambado()
		else:
			if !chegou_no_local_sambando:
				velocity = mover_nave_at(global_position, local_sambado)
				
				if soma != null:
					if soma <= 60 && soma >= -60:
						pediu_para_ir_local_sambado = false
						chegou_no_local_sambando = false
						local_sambado = Vector2()
						set_local_sambado()
			else:
				pediu_para_ir_local_sambado = false
				chegou_no_local_sambando = false
				local_sambado = Vector2()
				set_local_sambado()
	
func _process(delta):
	
	
	
	if modo_descanso:
		if !perseguindo_player:
			parado = true
		else:
			parado = false
	else:
		parado = false
	
	# rotação para o local que esta indo
	if !perseguindo_player:
		if !player_avistado:
			if !modo_descanso:
				if pediu_para_locomover:
					if !chegou_no_local:
						#muda a rotação para o local que esta visando
						rotation = global.muda_direcao_com_lerp(rotation, global_position, point_to_go, 6, delta)
	else:
		if target != null:
			rotation = global.muda_direcao_com_lerp(rotation, global_position, target.global_position , 6, delta)


func on_timeout_esquecer_samba_point():
	if !player_avistado:
		if pediu_para_ir_local_sambado:
			if !chegou_no_local_sambando:
				sambando = false
				pediu_para_ir_local_sambado = false
				chegou_no_local_sambando = false
				local_sambado = Vector2()


func on_timeout_complet_esquecer_player():
	if !player_avistado:
		perseguindo_player = false
		target = null
		
		modo_descanso = false
		pediu_para_locomover = false
		point_to_go = Vector2()
		chegou_no_local = false


func on_timeout_complet_volta_a_voar():
	modo_descanso = false
	pediu_para_locomover = false
	point_to_go = Vector2()
	chegou_no_local = false


func on_timeout_complet():
	can_loop_timer = true
	
	if !modo_descanso:
		if !pediu_para_locomover:
			# seta como true para iniciar a movimentação da nave
			pediu_para_locomover = true
			#pede para criar um ponto no espaço para a nave se locomover
			point_to_go = criar_ponto_at(global_position, -1000, 1000)

func set_local_sambado():
	if target != null:
		local_sambado = criar_ponto_at(target.global_position, -500, 500)
		pediu_para_ir_local_sambado = true
		
func criar_ponto_at(real_position, _min, _max):
	
	var p_to_go = Vector2.ZERO
	
	randomize()
	var pixels_a_decorrer_x = rand_range(_min, _max)
	var pixels_a_decorrer_y = rand_range(_min, _max)
	
	var value_minimo = 200
	var soma_pixels = int(pixels_a_decorrer_x) + int(pixels_a_decorrer_y)
	
	while soma_pixels < value_minimo:
		randomize()
		pixels_a_decorrer_x = rand_range(_min, _max)
		pixels_a_decorrer_y = rand_range(_min, _max)
		soma_pixels = int(pixels_a_decorrer_x) + int(pixels_a_decorrer_y)
	
	p_to_go.x = real_position.x + pixels_a_decorrer_x
	p_to_go.y = real_position.y + pixels_a_decorrer_y
	
	return p_to_go

func mover_nave_at(self_position, point):
	var direction_vector = (point - self_position)
	
	if direction_vector.length() < 10:
		
		if pediu_para_ir_local_sambado:
			chegou_no_local_sambando = true
			pass
		else:
			chegou_no_local = true
			pass
	
	velocity = move_and_slide( direction_vector.normalized() * speed)
	
	return velocity

func _on_collision_area_body_entered(body):
	if body.is_in_group("naves_player"):
		target = body
		player_avistado = true
		
		if !sambando:
			perseguindo_player = true

func _on_collision_area_body_exited(body):
	if body.is_in_group("naves_player"):
		player_avistado = false
		timer_esquecer_player.start()


func _on_collision_area_sambar_body_entered(body):
	if body.is_in_group("naves_player"):
		sambando = true


func _on_collision_area_sambar_body_exited(body):
	if body.is_in_group("naves_player"):
		timer_esquecer_samba_point.start()
		
