extends Node

var nave_carregada = false
var nave_player = null

var center_point = Vector2.ZERO
var ball_pos = Vector2.ZERO

# faz essa setagem para evitar erros
var direction:Vector2

#faz o direction para o local entre o 1 ponto e o 2
func direction_to_point( point1, point2 ):
	var direction = point1.angle_to_point(point2)
	var direction_normalied = Vector2(cos(direction) * -1, sin(direction))
	return direction_normalied
	
#faz o lerp dos direction do objeto, rotaciona com suavidade
func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

#acha a direção mais curta para se virar e realizar o lerp do angulo
func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
	
func muda_direcao_com_lerp(rotation, position, point, smooth, delta ):
	
	#muda a direcao para o local aonde eu quero
	direction = direction_to_point(position, point)
	
	#faz os requisistos para suaviazar a rotatoria
	var facing:float = atan2(direction.x, direction.y)
	var rota = lerp_angle(rotation, facing, smooth * delta)
	
	# retorna a rotação do objeto, basta atribuir o valor retornado a variavel rotation do Node2D
	return rota
