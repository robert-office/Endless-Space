extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# instancia a cena numa variavel, a cena da nava
	var scene_nave = preload("res://cenas/naves/naves_player/nave_player1.tscn").instantiate()
	# modifica a variavel que está nela
	scene_nave.este_ativo = true
	# adiciona a nave na cena atual
	add_child(scene_nave)
	
	var camera_scene = preload("res://cenas/camera/camera_viweport.tscn").instantiate()
	# adiciona a cena da camera como filha da nave
	scene_nave.add_child(camera_scene)
	
	# modifica as vars no global para os outros objs terem acesso a ela, por ex: o joystick
	global.nave_carregada = true
	global.nave_player = scene_nave
