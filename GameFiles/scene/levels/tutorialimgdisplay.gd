extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name == "bluesboon":
		self_modulate = Color8(255,207,233,255)
	else:
		self_modulate = Color8(255,255,255,255)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
