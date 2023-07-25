extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _pressed():
	if SaveAndLoad.loadgame() == null:
		text = "No save file found!"
		modulate = Color(1,0,0,1)
		
		await get_tree().create_timer(1.0).timeout
		text = "Load"
		modulate = Color(1,1,1,1)
	else:
		SaveAndLoad.loadgame()
		get_tree().change_scene_to_packed(SaveAndLoad.loadgame())
