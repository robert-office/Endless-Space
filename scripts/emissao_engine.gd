extends Particles2D

var parent = null

func _ready():
	parent = get_parent()

func _process(delta):
	
	if parent != null:
		var parent_parado = parent.parado
		if parent_parado:
			emitting = false
		else:
			emitting = true
