extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	var slot = self.name.right(1) 
	slot = int(slot) + 1
	if SaveAndLoad.get_save_data(slot) != null:
		text = "Save - Slot " + str(slot - 1) + "\n" + SaveAndLoad.get_save_data(slot)
	else:
		text = "Save - Slot " + str(slot-1) + "\n" + "Empty"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _pressed():
	var slot = self.name.right(1) 
	slot = int(slot) + 1
	SaveAndLoad.savegame(get_tree().current_scene,slot)
	text = "Saved!"
	modulate = Color(0,1,.50,1)
	await get_tree().create_timer(0.50).timeout
	text = "Save - Slot " + str(slot - 1) + "\n" + SaveAndLoad.get_save_data(slot)
	modulate = Color(1,1,1,1)
