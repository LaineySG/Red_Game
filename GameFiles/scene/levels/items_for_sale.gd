extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("item1").makesomenoise.connect(_on_make_noise)
	get_node("item2").makesomenoise.connect(_on_make_noise)
	get_node("item3").makesomenoise.connect(_on_make_noise)
	get_node("healing_station").makesomenoise.connect(_on_make_noise_heal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_make_noise():
	get_node('ping').play()
	get_node("poof").play()
	
func _on_make_noise_heal():
	get_node('ping').play()
	
