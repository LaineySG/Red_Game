extends AnimatedSprite2D

var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.tutorial_area2count == 1 and self.name == "door1":
		play("closed")
		self.remove_from_group("interact")

func open():
	play("opening")
	get_node("door_light/Shadow").color = Color.LIGHT_BLUE
	get_node("door_light/TextureLight").color = Color.LIGHT_BLUE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_node("Area2D").open and !opened and (Game.tutorial_area2count == 0 or self.name != "door1"):
		opened = true
		open()



func _on_transition_screen_transitioned():
	if get_node("Area2D").door2opened == true:
		get_tree().change_scene_to_file("res://scene/levels/tutorial_area_4.tscn")
