extends AnimatedSprite2D

var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open():
	play("opening")
	get_node("door_light/Shadow").color = Color.LIGHT_BLUE
	get_node("door_light/TextureLight").color = Color.LIGHT_BLUE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_node("Area2D").open and !opened:
		opened = true
		open()



func _on_transition_screen_transitioned():
	get_tree().change_scene_to_file("res://scene/levels/tutorial_area_2.tscn")
	Game.tutorial_area2count = 1


func _on_area_2d_opendoor():
	pass # Replace with function body.
