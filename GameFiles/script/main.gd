extends Node2D

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	#get_tree().change_scene_to_file("res://scene/levels/world.tscn")
	
	get_tree().change_scene_to_file("res://scene/levels/tutorial_area_1.tscn")
	#get_tree().change_scene_to_file("res://scene/levels/infinite.tscn")


func _on_load_pressed():
	if SaveAndLoad.loadgame() == null:
		get_node("Load").text = "No save file found!"
		get_node("Load").size.x = 600
		get_node("Load").position.x -= 200
		get_node("Load").modulate = Color(1,0,0,1)
		
		await get_tree().create_timer(1.0).timeout
		get_node("Load").size.x = 400
		get_node("Load").position.x += 200
		get_node("Load").text = "Load"
		get_node("Load").modulate = Color(1,1,1,1)
	else:
		SaveAndLoad.loadgame()
		get_tree().change_scene_to_packed(SaveAndLoad.loadgame())
		
	
