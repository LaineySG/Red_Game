extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _pressed():
	SaveAndLoad.savegame(get_tree().current_scene)
	text = "Saved!"
	modulate = Color(0,1,.50,1)
	await get_tree().create_timer(0.50).timeout
	text = "Save"
	modulate = Color(1,1,1,1)
