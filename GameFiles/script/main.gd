extends Node2D

func _on_quit_pressed():
	get_tree().quit()

func _ready():
	Musicplayer.playsong("relaxed")
	for slot in range (1,5):
		if SaveAndLoad.get_save_data(slot) != null:
			var path = "slot" + str(slot)
			if slot == 1:
				get_node(path).text = "Load Autosave: " + str(SaveAndLoad.get_save_data(slot))
			else:
				get_node(path).text = "Load Slot " + str(slot-1) + ": " + str(SaveAndLoad.get_save_data(slot))
		else:
			var path = "slot" + str(slot)
			get_node(path).text = "Load: Empty"
			

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scene/levels/tutorial_area_1.tscn")

func _on_slot_1_pressed():
	var slot = 1
	var path = "slot" + str(slot)
	var slotbtn = get_node(path)
	if SaveAndLoad.loadgame(slot) == null:
		slotbtn.modulate = Color(1,0,0,1)
		await get_tree().create_timer(1.0).timeout
		slotbtn.modulate = Color(1,1,1,1)
	else:
		SaveAndLoad.loadgame(slot)
		get_tree().change_scene_to_packed(SaveAndLoad.loadgame(slot))


func _on_slot_2_pressed():
	var slot = 2
	var path = "slot" + str(slot)
	var slotbtn = get_node(path)
	if SaveAndLoad.loadgame(slot) == null:
		slotbtn.modulate = Color(1,0,0,1)
		await get_tree().create_timer(1.0).timeout
		slotbtn.modulate = Color(1,1,1,1)
	else:
		SaveAndLoad.loadgame(slot)
		get_tree().change_scene_to_packed(SaveAndLoad.loadgame(slot))


func _on_slot_3_pressed():
	var slot = 3
	var path = "slot" + str(slot)
	var slotbtn = get_node(path)
	if SaveAndLoad.loadgame(slot) == null:
		slotbtn.modulate = Color(1,0,0,1)
		await get_tree().create_timer(1.0).timeout
		slotbtn.modulate = Color(1,1,1,1)
	else:
		SaveAndLoad.loadgame(slot)
		get_tree().change_scene_to_packed(SaveAndLoad.loadgame(slot))


func _on_slot_4_pressed():
	var slot = 4
	var path = "slot" + str(slot)
	var slotbtn = get_node(path)
	if SaveAndLoad.loadgame(slot) == null:
		slotbtn.modulate = Color(1,0,0,1)
		await get_tree().create_timer(1.0).timeout
		slotbtn.modulate = Color(1,1,1,1)
	else:
		SaveAndLoad.loadgame(slot)
		get_tree().change_scene_to_packed(SaveAndLoad.loadgame(slot))
